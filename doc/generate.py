#!/usr/bin/env python

"""Generate sphinx documentation tree for ecBuild CMake macros."""

from glob import glob
from os import makedirs, path
import sys

TOC = [('macros', 'ecBuild macros', 'ecbuild*.cmake'),
       ('find', 'ecBuild find package helpers', 'Find*.cmake'),
       ('contrib', 'ecBuild third party scripts', 'contrib/*.cmake')]

CWD = path.abspath(path.join(path.dirname(__file__), 'src'))


def generate(basedir):
    for section, title, pattern in TOC:
        section = path.join(CWD, section)
        if not path.exists(section):
            makedirs(section)
        with open(path.join(section, 'index.rst'), 'w') as f:
            f.write("""
%(title)s
%(bar)s

.. toctree::
   :maxdepth: 1

""" % {'title': title, 'bar': '#' * len(title)})
            for m in sorted(glob(path.join(basedir, pattern))):
                base = path.splitext(path.basename(m))[0]
                with open(path.join(section, base) + '.rst', 'w') as c:
                    c.write('.. cmake-module :: %s\n' % path.relpath(m, section))
                f.write('   %s\n' % base)

if __name__ == '__main__':
    generate(sys.argv[1])
