#!/bin/bash

[[ $(uname) == "Darwin" ]] && return # no module environment on the Mac

# initialise module environment if it is not
if [[ ! $(command -v module > /dev/null 2>&1) ]]; then
  . /usr/local/apps/module/init/bash
fi

module load cmake/new
