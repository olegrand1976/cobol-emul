       IDENTIFICATION DIVISION.
       PROGRAM-ID. L05MAINCALL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-HT                PIC S9(7)V99 COMP-3.
       01 WS-TAUX              PIC 9(3)V99 COMP-3.
       01 WS-TTC               PIC S9(7)V99 COMP-3.
       01 WS-TTC-AFF           PIC -ZZZZZZ9.99.

       PROCEDURE DIVISION.
           DISPLAY "Lecon 5 - CALL d'un sous-programme".

           DISPLAY "Montant HT : " WITH NO ADVANCING.
           ACCEPT WS-HT.

           DISPLAY "Taux TVA (%): " WITH NO ADVANCING.
           ACCEPT WS-TAUX.

           CALL "TVA-CALC" USING WS-HT WS-TAUX WS-TTC.

           MOVE WS-TTC TO WS-TTC-AFF.
           DISPLAY "Montant TTC : " WS-TTC-AFF.

           STOP RUN.
       END PROGRAM L05MAINCALL.
