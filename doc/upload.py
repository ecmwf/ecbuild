"""Uplodad documentation for a given list of ecBuild macros to Confluence.

The Confluence password needs be be export as environment variable
``CONFLUENCE_PASSWORD``.
"""

from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
import json
import logging
from os import environ, path

import requests

API_URL = 'https://software.ecmwf.int/wiki/rest/api/content'
if 'USER' in environ and 'CONFLUENCE_PASSWORD' in environ:
    AUTH = (environ['USER'], environ['CONFLUENCE_PASSWORD'])
else:
    AUTH = None

log = logging.getLogger('upload')
log.setLevel(logging.DEBUG)


def pp(res):
    "Pretty-print JSON response"
    return '{} {}\n'.format(json.dumps(res.json(), sort_keys=True, indent=2,
                            separators=(',', ': ')), res)


def upload(fname, space, parent_id):
    """Upload documentation for CMake module ``fname`` as child of page with
    id ``parent_id``."""
    pagename = path.splitext(path.basename(fname))[0]
    with open(fname) as f:
        data = f.read()
    log.debug('=' * 79)
    log.info('Uploading %s', pagename)
    log.debug('=' * 79)
    log.debug(data)
    log.debug('-' * 79)
    page = {'type': 'page',
            'title': pagename,
            'space': {'key': space},
            'body': {'storage': {'value': data, 'representation': 'storage'}},
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
    parser.add_argument('--space', default='ATLAS',
                        help='Confluence space to upload to')
    parser.add_argument('--page', default='Documentation',
                        help='Page to attach documentation to')
    parser.add_argument('--logfile', default='upload.log',
                        help='Path to log file')
    parser.add_argument('file', nargs='+',
                        help='list of paths to html files to upload')
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
    for f in args.file:
        upload(f, args.space, parent_id)
    log.info('====== Finished uploading documentation ======')

if __name__ == '__main__':
    main()
