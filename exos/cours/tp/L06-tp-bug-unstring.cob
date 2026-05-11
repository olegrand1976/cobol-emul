      *>****************************************************************
      *> TP L6 - MAINTENANCE : import fichier prospects (BUG intentionnel)
      *> Fichier : exos/cours/personnes.txt (separateur ';')
      *> Bug technique : UNSTRING avec mauvais delimiteur (',' au lieu de ';')
      *>   => ligne entiere dans le 1er champ (suffixe ";age" visible), age vide.
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L06TPBUG.

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
       01 WS-FIN                  PIC X(1) VALUE 'N'.
          88 FIN-FICHIER          VALUE 'O'.
       01 WS-NOM                  PIC X(30).
       01 WS-AGE                  PIC 9(3).

       PROCEDURE DIVISION.
           OPEN INPUT F-IN.
           PERFORM UNTIL FIN-FICHIER
               READ F-IN
                   AT END
                       SET FIN-FICHIER TO TRUE
                   NOT AT END
      *> BUG : delimiteur incompatible avec le fichier
                       UNSTRING F-LIGNE DELIMITED BY ','
                           INTO WS-NOM WS-AGE
                       END-UNSTRING
                       DISPLAY "LU : [" WS-NOM "] age=" WS-AGE
               END-READ
           END-PERFORM.
           CLOSE F-IN.
           STOP RUN.
       END PROGRAM L06TPBUG.
