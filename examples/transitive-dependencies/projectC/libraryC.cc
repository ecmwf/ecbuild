/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef A_EXPORT
#error A_EXPORT should be exported by projectA via projectB
#endif

extern int libraryB();

int libraryC() {
  return libraryB();
}

