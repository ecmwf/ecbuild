/* Stand-in for mkl_core: defines this symbol returning 0 (false), as the
 * real MKL does on non-Intel CPUs. */
int mkl_serv_intel_cpu_true(void) { return 0; }
