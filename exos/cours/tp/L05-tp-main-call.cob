      *>****************************************************************
      *> TP L5 - Appelant (meme que lecon 5, compile avec module TP)
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L05TPCALL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-HT                PIC S9(7)V99 COMP-3.
       01 WS-TAUX              PIC 9(3)V99 COMP-3.
       01 WS-TTC               PIC S9(7)V99 COMP-3.
       01 WS-TTC-AFF           PIC -ZZZZZZ9.99.

       PROCEDURE DIVISION.
           DISPLAY "TP L5 - Test TVA (HT=100, taux=20 => TTC attendu 120)".
           MOVE 100.00 TO WS-HT.
           MOVE 20.00 TO WS-TAUX.
           CALL "TVA-CALC" USING WS-HT WS-TAUX WS-TTC.
           MOVE WS-TTC TO WS-TTC-AFF.
           DISPLAY "TTC calcule : " WS-TTC-AFF.
           STOP RUN.
       END PROGRAM L05TPCALL.
