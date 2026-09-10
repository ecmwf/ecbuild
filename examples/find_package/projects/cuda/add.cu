/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include "add.h"
#include "kernel_add.h"

void add(int n, float* x, float* y) {
    kernel_add<<<1, 1>>>(n, x, y);
}