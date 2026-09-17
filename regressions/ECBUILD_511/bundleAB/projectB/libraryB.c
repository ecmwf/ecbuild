/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include "libraryB.h"
#include "libraryA.h"

int libraryB() {
  return libraryA() + 1;
}

