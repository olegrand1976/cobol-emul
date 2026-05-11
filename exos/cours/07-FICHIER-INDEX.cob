      *>****************************************************************
      *> Lecon 7 - Fichier INDEXED (ISAM) miniature
      *> Cree data/COURS-PROD.dat : cle 5 chiffres + libelle 27 caracteres
      *> Avant une 2e execution : rm -f data/COURS-PROD.dat
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L07INDEX.

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
       01 WS-FIN-PARCOURS         PIC X(1) VALUE 'N'.
          88 FIN-PARCOURS          VALUE 'O'.

       PROCEDURE DIVISION.
           DISPLAY "Lecon 7 - Fichier indexe (cle + libelle)".

           OPEN I-O F-PR.
           IF WS-FS = '35'
               OPEN OUTPUT F-PR
               CLOSE F-PR
               OPEN I-O F-PR
           END-IF.
           IF WS-FS NOT = '00'
               DISPLAY "Erreur ouverture FS=" WS-FS
               STOP RUN
           END-IF.

           MOVE 30003 TO F-P-CODE.
           MOVE "VIS AUTO BASE" TO F-P-LIB.
           WRITE F-P-REC
               INVALID KEY
                   DISPLAY "WRITE 30003 INVALID (fichier deja rempli ? rm data/COURS-PROD.dat)"
           END-WRITE.

           MOVE 10001 TO F-P-CODE.
           MOVE "HABITATION STD" TO F-P-LIB.
           WRITE F-P-REC
               INVALID KEY
                   DISPLAY "WRITE 10001 INVALID"
           END-WRITE.

           MOVE 20002 TO F-P-CODE.
           MOVE "SANTE PLUS" TO F-P-LIB.
           WRITE F-P-REC
               INVALID KEY
                   DISPLAY "WRITE 20002 INVALID"
           END-WRITE.

           DISPLAY "Lecture par cle 20002 :".
           MOVE 20002 TO F-P-CODE.
           READ F-PR
               INVALID KEY
                   DISPLAY "  introuvable"
               NOT INVALID KEY
                   DISPLAY "  " F-P-CODE " " F-P-LIB
           END-READ.

           DISPLAY "Parcours sequentiel (cle croissante) :".
           MOVE ZERO TO F-P-CODE.
           START F-PR KEY >= F-P-CODE
               INVALID KEY
                   DISPLAY "  START invalide"
           END-START.

           PERFORM UNTIL FIN-PARCOURS
               READ F-PR NEXT
                   AT END
                       SET FIN-PARCOURS TO TRUE
                   NOT AT END
                       DISPLAY "  " F-P-CODE " " F-P-LIB
               END-READ
           END-PERFORM.

           CLOSE F-PR.
           DISPLAY "Fichier : data/COURS-PROD.dat".
           STOP RUN.
       END PROGRAM L07INDEX.
