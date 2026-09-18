"""Split the shared CD matrix into ecbuild's explicit delivery jobs."""
import json
import os

import yaml


def plan(matrix, config, prerelease):
    entries = matrix['include']
    unsupported = {entry['type'] for entry in entries} - {'conda', 'hpc'}
    if unsupported:
        raise ValueError(f'Add explicit CD jobs before enabling: {sorted(unsupported)}')
    # Work on a copy: preserve all release settings except the derived flag.
    config = json.loads(json.dumps(config))
    config.setdefault('release', {}).setdefault('config', {})['prerelease'] = prerelease
    return {
        'conda': {'include': [entry for entry in entries if entry['type'] == 'conda']},
        'hpc': {'include': [entry for entry in entries if entry['type'] == 'hpc']},
        'release_config': config,
    }


def main():
    outputs = plan(
        json.loads(os.environ['BUILD_MATRIX']),
        yaml.safe_load(os.environ['CD_CONFIG']),
        os.environ['IS_PRERELEASE'] == 'true',
    )
    with open(os.environ['GITHUB_OUTPUT'], 'a') as output:
        for name, value in outputs.items():
            output.write(f'{name}={json.dumps(value)}\n')


if __name__ == '__main__':
    main()
