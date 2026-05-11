       IDENTIFICATION DIVISION.
       PROGRAM-ID. L02CALCUL.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-A                PIC S9(5)V99.
       01 WS-B                PIC S9(5)V99.
       01 WS-SOMME            PIC S9(6)V99.
       01 WS-PRODUIT          PIC S9(8)V99.
       01 WS-MOYENNE          PIC S9(6)V99.

       PROCEDURE DIVISION.
           DISPLAY "Lecon 2 - Calculs".

           DISPLAY "Valeur A : " WITH NO ADVANCING.
           ACCEPT WS-A.

           DISPLAY "Valeur B : " WITH NO ADVANCING.
           ACCEPT WS-B.

           COMPUTE WS-SOMME   = WS-A + WS-B.
           COMPUTE WS-PRODUIT = WS-A * WS-B.
           COMPUTE WS-MOYENNE ROUNDED = (WS-A + WS-B) / 2.

           DISPLAY "Somme   = " WS-SOMME.
           DISPLAY "Produit = " WS-PRODUIT.
           DISPLAY "Moyenne = " WS-MOYENNE.

           STOP RUN.
       END PROGRAM L02CALCUL.
