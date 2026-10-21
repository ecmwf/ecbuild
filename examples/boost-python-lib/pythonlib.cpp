/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include "pythonlib.hpp"

BOOST_PYTHON_MODULE(libmypython)
{
  boost::python::scope().attr("__doc__") = "Python API for my python project";
}
