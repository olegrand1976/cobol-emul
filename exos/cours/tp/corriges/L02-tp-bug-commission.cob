      *>****************************************************************
      *> TP L2 - CORRIGE : commission = montant * (taux_pct / 100)
      *> 10000 * 1,50% = 150,00
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L02TPCORR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MONTANT           PIC S9(9)V99 VALUE 10000.00.
       01 WS-TAUX-PCT          PIC 9(3)V99 VALUE 1.50.
       01 WS-COM               PIC S9(9)V99.

       PROCEDURE DIVISION.
           DISPLAY "TP L2 - Commission sur placement".
           DISPLAY "Montant : " WS-MONTANT "  Taux % : " WS-TAUX-PCT.
           COMPUTE WS-COM ROUNDED = WS-MONTANT * WS-TAUX-PCT / 100.
           DISPLAY "Commission : " WS-COM.
           STOP RUN.
       END PROGRAM L02TPCORR.
