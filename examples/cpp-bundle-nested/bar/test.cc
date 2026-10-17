/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include <iostream>

extern "C" {
#include "bar.h"
}

int main() {
  if( bar() == 42*42 )
    std::cout << "ok" << std::endl;
  else
    std::cout << "failed" << std::endl;
}
