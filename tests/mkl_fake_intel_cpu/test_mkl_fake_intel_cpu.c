#include <stdio.h>
#include <stdlib.h>

extern int mkl_serv_intel_cpu_true(void);

int main(void)
{
    int result = mkl_serv_intel_cpu_true();
    if( result != 1 )
    {
        fprintf( stderr,
                 "mkl_serv_intel_cpu_true() returned %d, expected 1 "
                 "(override object did not take precedence over fakemkl_core)\n",
                 result );
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
