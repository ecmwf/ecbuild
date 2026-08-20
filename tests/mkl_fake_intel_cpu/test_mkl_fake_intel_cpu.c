#include <stdio.h>
#include <stdlib.h>

#ifdef HAVE_MKL
#include <mkl.h>
#endif

extern int mkl_serv_intel_cpu_true(void);

int main(void)
{
    int result;

#ifdef HAVE_MKL
    /* When linked against the real MKL, call a real MKL service routine so
     * the test genuinely exercises the MKL libraries, not just the override
     * object. */
    {
        MKLVersion version;
        MKL_Get_Version( &version );
        printf( "Using Intel MKL %d.%d update %d\n",
                version.MajorVersion, version.MinorVersion,
                version.UpdateVersion );
    }
#endif

    const int N = 4;

    double A[N * N];
    double B[N * N];
    double C[N * N];

    for (int i = 0; i < N; i++) {
        for (int j = 0; j < N; j++) {
            A[i * N + j] = i + 1;
            B[i * N + j] = (i == j) ? 2.0 : 0.0;
            C[i * N + j] = 0.0;
        }
    }

    cblas_dgemm (CblasRowMajor,
                 CblasNoTrans, CblasNoTrans,
                 N, N, N,
                 1.0,
                 A, N,
                 B, N,
                 0.0,
                 C, N);

    result = mkl_serv_intel_cpu_true();
    if( result != 1 )
    {
        fprintf( stderr,
                 "mkl_serv_intel_cpu_true() returned %d, expected 1 "
                 "(override object did not take precedence over mkl_core)\n",
                 result );
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
