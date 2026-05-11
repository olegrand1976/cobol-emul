      *>****************************************************************
      *> TP L1 - CORRIGE : date = positions 1 a 8 de CURRENT-DATE (AAAAMMJJ)
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L01TPCORR.

       PROCEDURE DIVISION.
           DISPLAY "Agence COBOL-EMUL - Releve du ".
           DISPLAY "Date (AAAAMMJJ) : " FUNCTION CURRENT-DATE(1:8).
           STOP RUN.
       END PROGRAM L01TPCORR.
