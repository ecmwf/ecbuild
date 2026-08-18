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
