        SUBROUTINE ir2(N,M)
        M=N*N
        RETURN
        END

        INTEGER FUNCTION if3(N)
        if3=N*N*N
        RETURN
        END

        SUBROUTINE dr2(N,M)
        REAL*8, INTENT(IN)  :: N
        REAL*8, INTENT(OUT) :: M
        M=N*N
        RETURN
        END

        REAL*8 FUNCTION df3(N)
        REAL*8, INTENT(IN)  :: N
        df3=N*N*N
        RETURN
        END
