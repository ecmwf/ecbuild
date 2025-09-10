#=============================================================================
# CMake - Cross Platform Makefile Generator
# Copyright 2000-2013 Kitware, Inc., Insight Software Consortium
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
import sys
import os
import re


def parse_version(ver_str):
    return re.sub("^((([0-9]+)\\.)+([0-9]+)).*", "\\1", ver_str)


here = os.path.abspath(os.path.dirname(__file__))
sys.path.insert(0, here)

source_suffix = '.rst'
master_doc = 'index'

project = 'ecBuild'
copyright = 'ECMWF'

with open(os.path.join(here, '..', 'VERSION'), 'r') as f:
    release = f.readline().strip() # full version string
version = parse_version(release) # feature version

primary_domain = 'cmake'

exclude_patterns = []

extensions = ['cmake']
templates_path = [os.path.join(here, 'templates')]

nitpicky = True

html_show_sourcelink = True
html_static_path = [os.path.join(here, 'static')]
html_theme = 'sphinx_rtd_theme'
html_title = 'ecBuild %s Documentation' % release
html_short_title = '%s Documentation' % release
html_favicon = os.path.join(here, 'static', 'ecbuild.ico')


# Extract the docs from the .cmake files
from generate import generate
generate(os.path.join(here, '..', 'cmake'))
