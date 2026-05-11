      *>****************************************************************
      *> TP L7 - MAINTENANCE : inventaire produits (BUG intentionnel)
      *> Meme fichier data/COURS-PROD.dat que la lecon 7.
      *> Bug technique : READ NEXT sans START => ordre de parcours
      *>   non garanti / erreur selon implementation.
      *> Corrige : apres OPEN, faire START KEY >= cle minimale puis READ NEXT.
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L07TPBUG.

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
               DISPLAY "Ouvrir d'abord avec lecon 7 ou creer le fichier."
               STOP RUN
           END-IF.

      *> BUG : pas de START avant le premier READ NEXT
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
       END PROGRAM L07TPBUG.
