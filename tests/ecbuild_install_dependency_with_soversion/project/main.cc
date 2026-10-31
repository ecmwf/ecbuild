/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include "foo/foo.h"

#include <iostream>

int main() {
  std::cout << foo::true_random_int() << std::endl;
  return 0;
}
