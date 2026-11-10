# SPDX-FileCopyrightText: 2026- European Centre for Medium-Range Weather Forecasts (ECMWF)
# SPDX-License-Identifier: Apache-2.0

add_library(example_sub INTERFACE)
ecbuild_pkgconfig(NAME example_sub LIBRARIES example_sub)
