/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include <iostream>

extern "C" {
#include "foo.h"
#include "bar.h"
}

int main()
{
  std::cout << "foo is " << foo() << std::endl;
  std::cout << "bar is " << bar() << std::endl;
}
