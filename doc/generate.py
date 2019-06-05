#!/usr/bin/env python

"""Generate sphinx documentation tree for ecBuild CMake macros."""

from glob import glob
from os import makedirs, path
import sys

TOC = [('macros', 'ecbuild*.cmake'),
       ('find', 'Find*.cmake'),
       ('contrib', 'contrib/*.cmake')]

CWD = path.abspath(path.dirname(__file__))


def generate(basedir):
    for section, pattern in TOC:
        section = path.join(CWD, section)
        if not path.exists(section):
            makedirs(section)
        for m in sorted(glob(path.join(basedir, pattern))):
            base = path.splitext(path.basename(m))[0]
            with open(path.join(section, base) + '.rst', 'w') as c:
                c.write('.. cmake-module :: %s\n' % path.relpath(m, section))

if __name__ == '__main__':
    generate(sys.argv[1])
