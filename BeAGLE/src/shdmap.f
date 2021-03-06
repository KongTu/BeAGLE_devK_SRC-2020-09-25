      DOUBLE PRECISION FUNCTION SHDMAP(RA)
      DOUBLE PRECISION RA
C...
C... Mark Baker 08-Aug-2016
C...
C... Input RA and output "dipole" cross-section 
C... Based on TSpline5 coefficients

C...Pythia eA shadowing common block from Mark 2017-06-30
      COMMON /PYSHAD/ NKNOTS,RDUMMY,RAVAL,XKNOT(100),YKNOT(100),
     &BKNOT(100),CKNOT(100),DKNOT(100),EKNOT(100),FKNOT(100),SHDFAC
      SAVE /PYSHAD/
      DOUBLE PRECISION XKNOT,YKNOT,BKNOT,CKNOT,DKNOT,EKNOT,FKNOT,RAVAL,
     &SHDFAC
      INTEGER NKNOTS,RDUMMY

C... Locals by Mark 7/15/16
      INTEGER LKNOT,RKNOT,TKNOT
      DOUBLE PRECISION DX
C
      INTEGER IKNOT
C      WRITE(*,*) "Inside shdmap. RA= ", RA
C      DO IKNOT=1,NKNOTS
C         WRITE(*,'(7(1X,D13.6))')XKNOT(IKNOT),YKNOT(IKNOT),
C     &        BKNOT(IKNOT),CKNOT(IKNOT),DKNOT(IKNOT),EKNOT(IKNOT),
C     &        FKNOT(IKNOT)
C      ENDDO
C
C... Find the knot with the highest X value less than RA.
      IF (RA.LT.XKNOT(1)) THEN
         LKNOT = 1
         RKNOT = 1
      ELSE IF (RA.GT.XKNOT(NKNOTS)) THEN
         LKNOT = NKNOTS
         RKNOT = NKNOTS
      ELSE
         LKNOT = 1
         RKNOT = NKNOTS
         DO WHILE (LKNOT.LT.RKNOT-1) 
            TKNOT = (LKNOT+RKNOT)/2
            IF (XKNOT(TKNOT).LE.RA) THEN
               LKNOT=TKNOT
            ELSE
               RKNOT=TKNOT
            ENDIF
         ENDDO
      ENDIF
C
      IF (LKNOT.EQ.1 .AND. RKNOT.EQ.1) THEN
         WRITE(*,*) 'ERROR in SHDMAP: RA= ',RA,' < RAmin= ',XKNOT(1)
         WRITE(*,*) 'Using RA=RAmin'
         SHDMAP = YKNOT(1)
      ELSE
         DX=RA-XKNOT(LKNOT)
         SHDMAP=YKNOT(LKNOT)+BKNOT(LKNOT)*DX+CKNOT(LKNOT)*DX*DX+
     &        DKNOT(LKNOT)*DX**3+EKNOT(LKNOT)*DX**4+FKNOT(LKNOT)*DX**5
      ENDIF
      IF (SHDMAP.LT.0.0) SHDMAP=0.0D0

      RETURN
      END

