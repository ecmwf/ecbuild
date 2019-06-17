#!/usr/bin/env python

"""
Extract rst documentation for a given list of ecBuild macros for use with Sphinx.
"""

from __future__ import print_function
from argparse import ArgumentParser, ArgumentDefaultsHelpFormatter
from os import environ, path, makedirs


def writeRST(rst, directory):
    "Write rST documentation to ``fname``.rst"

    if not path.exists(directory):
        makedirs(directory)

    for key, value in rst.items():
        fh = open('%s/%s.rst' % (directory, key), 'w')
        fh.write(value)
        fh.close()

    return


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


def indexRST():

    strings = []

    strings.append('#####################\n')
    strings.append('ecBuild Documentation\n')
    strings.append('#####################\n')
    strings.append('\n')
    strings.append('.. toctree::\n')
    strings.append('\t:maxdepth: 2\n')
    strings.append('\n')
    strings.append('\tmacros/index.rst\n')
    strings.append('\n')
    strings.append('##################\n')
    strings.append('Indices and tables\n')
    strings.append('##################\n')
    strings.append('\n')
    #strings.append('* :ref:`genindex`\n')
    strings.append('* :ref:`search`\n')

    return ''.join(strings)


def macrosRST(macros):

    strings = []

    strings.append('##############\n')
    strings.append('ecBuild macros\n')
    strings.append('##############\n')
    strings.append('.. toctree::\n')
    strings.append('\t:maxdepth: 1\n')
    strings.append('\n')

    for m in sorted(macros):
        mname, _ = path.splitext(m)
        strings.append('\t'+mname+'.rst\n')

    return ''.join(strings)


def main():
    parser = ArgumentParser(description=__doc__,
                            formatter_class=ArgumentDefaultsHelpFormatter)
    parser.add_argument('--source', default='./_source',
                        help='Path to stage Sphinx .rst files')
    parser.add_argument('macro', nargs='+',
                        help='list of paths to ecBuild macros')
    args = parser.parse_args()

    print('====== Start creating rst for Sphinx documentation ======')

    rst = {}
    for m in args.macro:
        mname, _ = path.splitext(m)
        mname = path.basename(mname)
        rst[mname] = '\n'.join(extract(m))

    writeRST(rst, path.join(args.source, 'macros'))

    writeRST({'index': indexRST()}, args.source)
    writeRST({'index': macrosRST(rst.keys())}, path.join(args.source, 'macros'))

    print('====== Finished creating rst for Sphinx documentation ======')

if __name__ == '__main__':
    main()
