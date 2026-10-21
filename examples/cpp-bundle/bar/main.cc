/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include <iostream>

extern "C" {
#include "bar.h"
#include "baz.h"
#include "zingo.h"
}

int main()
{
  std::cout << "bar is " << bar() << std::endl;
  std::cout << "baz is " << baz() << std::endl;
  std::cout << "zingo is " << zingo() << std::endl;
}
