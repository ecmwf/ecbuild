"""Offline checks for ecbuild's composed CD pipeline (requires PyYAML)."""
import importlib.util
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

import yaml

ROOT = Path(__file__).resolve().parents[2]
SCRIPT = ROOT / '.github/scripts/plan-cd.py'
SPEC = importlib.util.spec_from_file_location('plan_cd', SCRIPT)
planner = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(planner)


class PlanTests(unittest.TestCase):
    def test_split_preserves_resolved_configuration(self):
        conda = {'type': 'conda', 'name': 'conda-linux', 'runner': 'linux', 'channels': 'custom'}
        hpc = {'type': 'hpc', 'name': 'hpc', 'modules': 'python3', 'platform': 'gnu-14.2.0'}
        config = {'release': {'enabled': True, 'config': {'draft': True}}}
        result = planner.plan({'include': [conda, hpc]}, config, True)
        self.assertEqual(result['conda'], {'include': [conda]})
        self.assertEqual(result['hpc'], {'include': [hpc]})
        self.assertEqual(result['release_config']['release']['config'], {'draft': True, 'prerelease': True})
        self.assertNotIn('prerelease', config['release']['config'])

    def test_disabled_builds_have_empty_matrices(self):
        result = planner.plan({'include': []}, {}, False)
        self.assertEqual(result['conda'], {'include': []})
        self.assertEqual(result['hpc'], {'include': []})
        self.assertFalse(result['release_config']['release']['config']['prerelease'])

    def test_unknown_build_kind_fails_instead_of_silently_skipping(self):
        with self.assertRaisesRegex(ValueError, 'explicit CD jobs'):
            planner.plan({'include': [{'type': 'tarball'}]}, {}, False)

    def test_cli_outputs_are_single_line_json(self):
        with tempfile.TemporaryDirectory() as tmp:
            output = Path(tmp) / 'outputs'
            subprocess.run([sys.executable, str(SCRIPT)], check=True, env={
                **os.environ, 'GITHUB_OUTPUT': str(output), 'BUILD_MATRIX': '{"include": []}',
                'CD_CONFIG': 'release:\n  config:\n    body: |\n      Line one\n      Line two\n',
                'IS_PRERELEASE': 'true',
            })
            outputs = dict(line.split('=', 1) for line in output.read_text().splitlines())
            self.assertEqual(set(outputs), {'conda', 'hpc', 'release_config'})
            self.assertIn('Line two', json.loads(outputs['release_config'])['release']['config']['body'])


class WorkflowTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.workflow = yaml.load((ROOT / '.github/workflows/cd.yml').read_text(), Loader=yaml.BaseLoader)
        cls.jobs = cls.workflow['jobs']

    def action(self, job, name):
        return next(step for step in self.jobs[job]['steps']
                    if step.get('uses', '').startswith(f'ecmwf/reusable-workflows/cd-actions/{name}@'))

    def test_direct_actions_not_main_cd(self):
        self.assertEqual(set(self.jobs), {'prepare', 'conda', 'hpc', 'hpc-sync-tag', 'release'})
        self.assertTrue(all('uses' not in job for job in self.jobs.values()))
        for job in ('conda', 'hpc', 'hpc-sync-tag', 'release'):
            self.action(job, job)

    def test_builds_use_prepared_sha(self):
        for name in ('conda', 'hpc'):
            job = self.jobs[name]
            self.assertEqual(job['needs'], 'prepare')
            checkout = next(step for step in job['steps'] if step.get('uses', '').startswith('actions/checkout@'))
            self.assertEqual(checkout['with']['ref'], '${{ needs.prepare.outputs.source_sha }}')
            self.assertEqual(self.action(name, name)['with']['dry_run'], '${{ needs.prepare.outputs.dry_run }}')
        self.assertEqual(self.action('hpc', 'hpc')['with']['sha'], '${{ needs.prepare.outputs.source_sha }}')

    def test_manual_runs_cannot_publish(self):
        detect = self.action('prepare', 'detect-release-type')
        self.assertEqual(detect['with']['dry_run'], "${{ github.event_name != 'push' || !startsWith(github.ref, 'refs/tags/') }}")
        for name in ('release', 'hpc-sync-tag'):
            self.assertIn("needs.prepare.outputs.dry_run == 'false'", self.jobs[name]['if'])
        self.assertEqual(self.action('hpc', 'hpc')['with']['dry_run_install'], 'false')
        for key in ('nexus_token', 'nexus_test_token'):
            self.assertIn("needs.prepare.outputs.dry_run == 'false'", self.action('conda', 'conda')['with'][key])

    def test_only_release_job_has_contents_write(self):
        self.assertEqual(self.workflow['permissions']['contents'], 'read')
        for name, job in self.jobs.items():
            if job.get('permissions', {}).get('contents') == 'write':
                self.assertEqual(name, 'release')

    def test_release_requires_successful_prepare_and_no_build_failure(self):
        release = self.jobs['release']
        self.assertEqual(set(release['needs']), {'prepare', 'conda', 'hpc', 'hpc-sync-tag'})
        self.assertIn('!cancelled()', release['if'])
        self.assertIn("needs.prepare.result == 'success'", release['if'])
        for name in ('conda', 'hpc', 'hpc-sync-tag'):
            self.assertIn(f"(needs.{name}.result == 'success' || needs.{name}.result == 'skipped')", release['if'])


if __name__ == '__main__':
    unittest.main()
