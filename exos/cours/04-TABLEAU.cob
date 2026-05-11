       IDENTIFICATION DIVISION.
       PROGRAM-ID. L04TABLEAU.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 T-CARRES.
          05 T-VALEUR          OCCURS 10 TIMES PIC 9(5).

       01 WS-I                 PIC 9(2).
       01 WS-SOMME             PIC 9(6) VALUE 0.

       PROCEDURE DIVISION.
           DISPLAY "Lecon 4 - OCCURS + PERFORM VARYING".

           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
               COMPUTE T-VALEUR(WS-I) = WS-I * WS-I
               ADD T-VALEUR(WS-I) TO WS-SOMME
           END-PERFORM.

           DISPLAY "Carres de 1 a 10 :".
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 10
               DISPLAY "  " WS-I "^2 = " T-VALEUR(WS-I)
           END-PERFORM.

           DISPLAY "Somme des carres = " WS-SOMME.
           STOP RUN.
       END PROGRAM L04TABLEAU.
