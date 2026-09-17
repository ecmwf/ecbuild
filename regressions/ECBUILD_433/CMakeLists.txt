# SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

configure_file( run.sh.in run.sh @ONLY )

ecbuild_add_test(
  TARGET     ECBUILD-433
  TYPE       SCRIPT
  COMMAND    run.sh
)

