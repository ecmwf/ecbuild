import json
from os import environ, path

from docutils.core import publish_string

import requests

from rst2confluence import confluence

API_URL = 'https://software-test.ecmwf.int/wiki/rest/api/content'
AUTH = (environ['USER'], environ['CONFLUENCE_PASSWORD'])


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
    print '{} {}\n'.format(json.dumps(res.json(), sort_keys=True, indent=2,
                           separators=(',', ': ')), res)


def upload(fname):
    "Upload documentation for CMake module ``fname``."
    pagename = path.splitext(path.basename(fname))[0]
    rst = '\n'.join(extract(fname))
    if not rst:
        return
    print '=' * 79
    print pagename
    print '=' * 79
    print 'rST'
    print '-' * 79
    print rst
    print '-' * 79
    print 'Confluence'
    print '-' * 79
    cwiki = publish_string(rst, writer=confluence.Writer())
    print cwiki
    # Get id of parent page
    r = requests.get(API_URL,
                     params={'spaceKey': 'ECSDK', 'title': 'ecBuild macros'},
                     auth=AUTH,
                     headers=({'Content-Type': 'application/json'}))
    parent_id = r.json()['results'][0]['id']
    page = {'type': 'page',
            'title': pagename,
            'space': {'key': 'ECSDK'},
            'body': {'storage': {'value': cwiki, 'representation': 'wiki'}},
            'ancestors': [{'type': 'page', 'id': parent_id}]}
    create_or_update(page)


def create_or_update(page):
    "Update Confluence ``page`` if it exists, otherwise create it."
    # Check if page exists
    r = requests.get(API_URL,
                     params={'spaceKey': 'ECSDK',
                             'title': page['title'],
                             'expand': 'version'},
                     auth=AUTH,
                     headers=({'Content-Type': 'application/json'}))
    if len(r.json()['results']):
        p = r.json()['results'][0]
        page['version'] = {'number': p['version']['number'] + 1}
        pp(requests.put('/'.join([API_URL, p['id']]),
                        data=json.dumps(page),
                        auth=AUTH,
                        headers=({'Content-Type': 'application/json'})))
    else:
        pp(requests.post(API_URL,
                         data=json.dumps(page),
                         auth=AUTH,
                         headers=({'Content-Type': 'application/json'})))


def main():
    import sys
    for f in sys.argv[1:]:
        upload(f)

if __name__ == '__main__':
    main()
