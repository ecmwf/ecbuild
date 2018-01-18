# (C) Copyright 1996 ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

"""Uplodad documentation for a given list of ecBuild macros to Confluence.

The Confluence password needs be be export as environment variable
``CONFLUENCE_PASSWORD``.
"""

from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
import json
import logging
from os import environ, path

from docutils.core import publish_string

import requests

from rst2confluence import confluence

API_URL = 'https://software.ecmwf.int/wiki/rest/api/content'
if 'USER' in environ and 'CONFLUENCE_PASSWORD' in environ:
    AUTH = (environ['USER'], environ['CONFLUENCE_PASSWORD'])
else:
    AUTH = None

log = logging.getLogger('upload')
log.setLevel(logging.DEBUG)


def extract(fname):
    "Extract rST documentation from CMake module ``fname``."
    with open(fname) as f:
        rst = False
        lines = []
        for line in f:
            line = line.strip()
            # Only consider comments
            if not line.startswith('#'):
                rst = False
                continue
            # Lines with the magic cooke '.rst:' start an rST block
            if line.endswith('.rst:'):
                rst = True
                continue
            # Only add lines in an rST block
            if rst:
                line = line.lstrip('#')
                # Blank lines are syntactically relevant
                lines.append(line[1:] if line else line)
        return lines


def pp(res):
    "Pretty-print JSON response"
    return '{} {}\n'.format(json.dumps(res.json(), sort_keys=True, indent=2,
                            separators=(',', ': ')), res)


def upload(fname, space, parent_id):
    """Upload documentation for CMake module ``fname`` as child of page with
    id ``parent_id``."""
    pagename = path.splitext(path.basename(fname))[0]
    rst = '\n'.join(extract(fname))
    if not rst:
        return
    log.debug('=' * 79)
    log.info('Uploading %s', pagename)
    log.debug('=' * 79)
    log.debug('rST')
    log.debug('-' * 79)
    log.debug(rst)
    log.debug('-' * 79)
    log.debug('Confluence')
    log.debug('-' * 79)
    cwiki = publish_string(rst, writer=confluence.Writer())
    log.debug(cwiki)
    page = {'type': 'page',
            'title': pagename,
            'space': {'key': space},
            'body': {'storage': {'value': cwiki, 'representation': 'wiki'}},
            'ancestors': [{'type': 'page', 'id': parent_id}]}
    create_or_update(page, space)


def create_or_update(page, space):
    "Update Confluence ``page`` if it exists, otherwise create it."
    # Check if page exists
    r = requests.get(API_URL,
                     params={'spaceKey': space,
                             'title': page['title'],
                             'expand': 'version'},
                     auth=AUTH,
                     headers=({'Content-Type': 'application/json'}))
    if len(r.json()['results']):
        p = r.json()['results'][0]
        page['version'] = {'number': p['version']['number'] + 1}
        r = requests.put('/'.join([API_URL, p['id']]),
                         data=json.dumps(page),
                         auth=AUTH,
                         headers=({'Content-Type': 'application/json'}))
    else:
        r = requests.post(API_URL,
                          data=json.dumps(page),
                          auth=AUTH,
                          headers=({'Content-Type': 'application/json'}))
    log.debug(pp(r))
    if not r.ok:
        log.warn('  Uploading to space %s failed: %d (%s)\n    %s',
                 space, r.status_code, r.reason, r.json()['message'])


def main():
    parser = ArgumentParser(description=__doc__,
                            formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument('--space', default='ECBUILD',
                        help='Confluence space to upload to')
    parser.add_argument('--page', default='ecBuild Macros',
                        help='Page to attach documentation to')
    parser.add_argument('--logfile', default='upload.log',
                        help='Path to log file')
    parser.add_argument('macro', nargs='+',
                        help='list of paths to ecBuild macros')
    args = parser.parse_args()

    # Log to file with level DEBUG
    fh = logging.FileHandler(args.logfile)
    fh.setLevel(logging.DEBUG)
    fmt = logging.Formatter('%(asctime)s %(name)s %(levelname)-5s - %(message)s')
    fh.setFormatter(fmt)
    log.addHandler(fh)
    # Log to console with level INFO
    ch = logging.StreamHandler()
    ch.setLevel(logging.INFO)
    log.addHandler(ch)
    # Also log requests at debug level to file
    logging.getLogger('requests').addHandler(fh)
    logging.getLogger('requests').setLevel(logging.DEBUG)

    # Get id of parent page
    r = requests.get(API_URL,
                     params={'spaceKey': args.space, 'title': args.page},
                     auth=AUTH,
                     headers=({'Content-Type': 'application/json'}))
    parent_id = r.json()['results'][0]['id']
    log.info('====== Start uploading documentation to "%s" in space %s ======',
             args.page, args.space)
    log.info('Logging to file %s', args.logfile)
    for f in args.macro:
        upload(f, args.space, parent_id)
    log.info('====== Finished uploading documentation ======')

if __name__ == '__main__':
    main()
