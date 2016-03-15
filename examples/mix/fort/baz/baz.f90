        SUBROUTINE lir2(N,M)
        M=N*N
        RETURN
        END

        INTEGER FUNCTION lif3(N)
        lif3=N*N*N
        RETURN
        END

        SUBROUTINE ldr2(N,M)
        REAL*8, INTENT(IN)  :: N
        REAL*8, INTENT(OUT) :: M
        M=N*N
        RETURN
        END

        REAL*8 FUNCTION ldf3(N)
        REAL*8, INTENT(IN)  :: N
        ldf3=N*N*N
        RETURN
        END
