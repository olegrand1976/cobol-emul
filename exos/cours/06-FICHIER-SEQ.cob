      *>****************************************************************
      *> Lecon 6 - Lecture fichier LINE SEQUENTIAL (CSV simple)
      *> Fichier : exos/cours/personnes.txt (lignes NOM;AGE)
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L06SEQ.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F-IN ASSIGN TO "exos/cours/personnes.txt"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS.

       DATA DIVISION.
       FILE SECTION.
       FD F-IN.
       01 F-LIGNE                PIC X(80).

       WORKING-STORAGE SECTION.
       01 WS-FS                   PIC X(2).
       01 WS-FIN-LECTURE          PIC X(1) VALUE 'N'.
          88 FIN-FICHIER          VALUE 'O'.
       01 WS-NOM                  PIC X(30).
       01 WS-AGE                  PIC 9(3).
       01 WS-NB                   PIC 9(3) VALUE 0.

       PROCEDURE DIVISION.
           DISPLAY "Lecon 6 - Fichier sequentiel (lecture ligne par ligne)".

           OPEN INPUT F-IN.
           IF WS-FS NOT = '00'
               DISPLAY "Erreur OPEN INPUT FS=" WS-FS
               STOP RUN
           END-IF.

           PERFORM UNTIL FIN-FICHIER
               READ F-IN
                   AT END
                       SET FIN-FICHIER TO TRUE
                   NOT AT END
                       UNSTRING F-LIGNE DELIMITED BY ';'
                           INTO WS-NOM WS-AGE
                       END-UNSTRING
                       ADD 1 TO WS-NB
                       DISPLAY "  " WS-NB " - " WS-NOM " (" WS-AGE " ans)"
               END-READ
           END-PERFORM.

           CLOSE F-IN.

           DISPLAY "Total lignes lues : " WS-NB.
           STOP RUN.
       END PROGRAM L06SEQ.
