# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

set( ec511_res clean.sh )

configure_file( run-test.sh.in run-test.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-511
  TYPE       SCRIPT
  COMMAND    run-test.sh
  RESOURCES  ${ec511_res}
)

