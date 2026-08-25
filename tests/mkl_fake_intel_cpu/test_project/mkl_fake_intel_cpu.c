/* Stand-in for the override object that FindMKL.cmake generates when
 * MKL_FAKE_INTEL_CPU is ON: forces MKL onto its Intel codepath. */
int mkl_serv_intel_cpu_true(void) { return 1; }