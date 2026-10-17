/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include <iostream>

extern "C" {
#include "foo.h"
}

int main() {
  if( foo() == 42)
    std::cout << "ok" << std::endl;
  else
    std::cout << "failed" << std::endl;
}
