#!/bin/bash

# (C) Copyright 2011- ECMWF.
#
# This software is licensed under the terms of the Apache Licence Version 2.0
# which can be obtained at http://www.apache.org/licenses/LICENSE-2.0.
# In applying this licence, ECMWF does not waive the privileges and immunities
# granted to it by virtue of its status as an intergovernmental organisation
# nor does it submit to any jurisdiction.

chksm="md5sum"
manifest_file="manifest.txt"
install_proc="echo_install"

#------------------------------------------------------------------------------

function abspath {
    if [[ -d "$1" ]]
    then
        pushd "$1" >/dev/null
        pwd
        popd >/dev/null
    elif [[ -e $1 ]]
    then
        pushd $(dirname $1) >/dev/null
        echo $(pwd)/$(basename $1)
        popd >/dev/null
    else
        echo "error: path $1 does not exist!" >&2
        return 127
    fi
}

function echo_install {
  echo "$1 -> $2"
}

#------------------------------------------------------------------------------

if [ -z $2 ]
then
    echo "usage: $0 <src_dir> <target_dir>"
    exit 1
fi

[[ ! -z $3 ]] && install_proc="$3"

SRC=$(abspath $1)
TGT=$(abspath $2)

manifest="$SRC/$manifest_file"

#------------------------------------------------------------------------------

[[ ! -f $manifest ]] && echo "error: cannot find manifest.txt in dir $SRC" && exit 1

cd $SRC

for f in $(cat $manifest )
do

  [[ ! -f "$SRC/$f" ]] && echo "error: $SRC/$f does not exist" && exit 1

  install="no"

  if [[ ! -f "$TGT/$f" ]]
  then
    install="yes"
  else
    srcsum=$( $chksm "$SRC/$f" | cut -d" " -f1 )
    tgtsum=$( $chksm "$TGT/$f" | cut -d" " -f1 )

    if [ $srcsum != "$tgtsum" ]
    then
      install="yes"
    fi
  fi

   if [ $install == "yes" ]
   then
     $install_proc $SRC/$f $TGT/$f
   fi

done
