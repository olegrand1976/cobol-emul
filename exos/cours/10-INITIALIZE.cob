      *>****************************************************************
      *> Lecon 10 (complement) - INITIALIZE (remise a zero / blanc)
      *> Utile avant reutilisation d'une zone groupe en batch
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L10INIT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MVT.
          05 WS-MVT-CPT      PIC 9(8)  VALUE 11111111.
          05 WS-MVT-MONT    PIC S9(9)V99 VALUE -99.99.
          05 WS-MVT-LIB     PIC X(20) VALUE "ANCIEN LIBELLE".

       PROCEDURE DIVISION.
           DISPLAY "Lecon 10 complement - INITIALIZE".
           DISPLAY "Avant : " WS-MVT-CPT " " WS-MVT-MONT " [" WS-MVT-LIB "]".
           INITIALIZE WS-MVT.
           DISPLAY "Apres INITIALIZE WS-MVT : "
                   WS-MVT-CPT " " WS-MVT-MONT " [" WS-MVT-LIB "]".
           STOP RUN.
       END PROGRAM L10INIT.
