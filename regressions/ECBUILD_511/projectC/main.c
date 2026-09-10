/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

#include <stdio.h>

#include "libraryA.h"
#include "libraryB.h"

int main(int argc, char* argv[]) {
    printf("libraryA = %d\n", libraryA());
    printf("libraryB = %d\n", libraryB());
    return 0;
}

