      *>****************************************************************
      *> TP L3 - CORRIGE : adulte 18 THRU 64, senior 65 et +
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L03TPCORR.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-AGE                PIC 9(3).

       PROCEDURE DIVISION.
           DISPLAY "TP L3 - Categorie (saisir age) : " WITH NO ADVANCING.
           ACCEPT WS-AGE.

           EVALUATE WS-AGE
               WHEN 0 THRU 17
                   DISPLAY "Categorie : MINEUR"
               WHEN 18 THRU 64
                   DISPLAY "Categorie : ADULTE"
               WHEN OTHER
                   DISPLAY "Categorie : SENIOR"
           END-EVALUATE.

           STOP RUN.
       END PROGRAM L03TPCORR.
