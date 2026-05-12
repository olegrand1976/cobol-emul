      *>****************************************************************
      *> Lecon 9 (complement) - STRING (concatenation controlee)
      *> Construire un libelle de mouvement bancaire a partir de morceaux
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L09STR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-TYPE-MVT        PIC X(1) VALUE "D".
       01 WS-MONT-BRUT      PIC S9(9)V99 VALUE 1250.50.
       01 WS-MONT-AFF       PIC ZZZZZZZ9.99.
       01 WS-DEVISE         PIC X(3) VALUE "EUR".
       01 WS-LIBELLE        PIC X(48).

       PROCEDURE DIVISION.
           DISPLAY "Lecon 09 complement - STRING".
           MOVE WS-MONT-BRUT TO WS-MONT-AFF.
           STRING "Mouvement " DELIMITED BY SIZE
                  WS-TYPE-MVT DELIMITED BY SIZE
                  " montant " DELIMITED BY SIZE
                  WS-MONT-AFF DELIMITED BY SIZE
                  " " DELIMITED BY SIZE
                  WS-DEVISE DELIMITED BY SIZE
             INTO WS-LIBELLE
           END-STRING.
           DISPLAY "[" WS-LIBELLE "]".
           STOP RUN.
       END PROGRAM L09STR.
