/*
 * SPDX-FileCopyrightText: 2011- European Centre for Medium-Range Weather Forecasts (ECMWF)
 * SPDX-License-Identifier: Apache-2.0
 */

/* Stand-in for the override object that FindMKL.cmake generates when
 * MKL_FAKE_INTEL_CPU is ON: forces MKL onto its Intel codepath. */
int mkl_serv_intel_cpu_true(void) { return 1; }