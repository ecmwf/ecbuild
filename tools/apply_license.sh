#!/bin/bash

# (C) Copyright 1996-2017 ECMWF.
# 
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0. 
# In applying this licence, ECMWF does not waive the privileges and immunities 
# granted to it by virtue of its status as an intergovernmental organisation nor
# does it submit to any jurisdiction.

if [ -z $1 ]
then
    echo "apply_license.sh"
    echo "usage: $0 [dir] [dir] ... "
    echo "dir - directory where to search"
    exit 1
fi

for f in $( find $DIRS $* \(   \
            -iname "*.java" \
        -or -iname "*.xml" \
        -or -iname "*.sh"  \
        -or -iname "*.pl"  \
        -or -iname "*.pm"  \
        -or -iname "*.py"  \
        -or -iname "*.js"  \
        -or -iname "*.c"   \
        -or -iname "*.cpp" \
        -or -iname "*.cxx" \
        -or -iname "*.cc"  \
        -or -iname "*.h"   \
        -or -iname "*.hh"  \
        -or -iname "*.hpp" \
        -or -iname "*.l"   \
        -or -iname "*.y"   \
        -or -iname "*.f"   \
        -or -iname "*.F"   \
        -or -iname "*.for" \
        -or -iname "*.f77" \
        -or -iname "*.f90" \
        -or -iname "*.cmake" \
        -or -iname "*.css"   \
        -or -iname "*.sql"   \
        -or -iname "*.properties"  \
        -or -iname "*.def" \
 \) -print -follow | grep -v "\.git/" | grep -v "\.svn/" )
do
#  echo $f
  license.pl -u $f
done

#|  sed "s/ /\\\ /g" | \
#xargs echo

exit
