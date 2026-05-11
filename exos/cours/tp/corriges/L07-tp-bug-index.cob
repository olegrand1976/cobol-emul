      *>****************************************************************
      *> TP L7 - CORRIGE : START puis READ NEXT jusqu'a fin
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L07TPCORR.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F-PR ASSIGN TO "data/COURS-PROD.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS F-P-CODE
               FILE STATUS IS WS-FS.

       DATA DIVISION.
       FILE SECTION.
       FD F-PR.
       01 F-P-REC.
          05 F-P-CODE            PIC 9(5).
          05 F-P-LIB             PIC X(27).

       WORKING-STORAGE SECTION.
       01 WS-FS                   PIC X(2).
       01 WS-FIN                  PIC X(1) VALUE 'N'.
          88 FIN-PARCOURS         VALUE 'O'.

       PROCEDURE DIVISION.
           OPEN INPUT F-PR.
           IF WS-FS NOT = '00'
               DISPLAY "Fichier absent - lancer lecon 7 une fois."
               STOP RUN
           END-IF.

           MOVE ZERO TO F-P-CODE.
           START F-PR KEY >= F-P-CODE
               INVALID KEY
                   DISPLAY "START invalide"
                   CLOSE F-PR
                   STOP RUN
           END-START.

           PERFORM UNTIL FIN-PARCOURS
               READ F-PR NEXT
                   AT END
                       SET FIN-PARCOURS TO TRUE
                   NOT AT END
                       DISPLAY "CODE=" F-P-CODE " " F-P-LIB
               END-READ
           END-PERFORM.

           CLOSE F-PR.
           STOP RUN.
       END PROGRAM L07TPCORR.
