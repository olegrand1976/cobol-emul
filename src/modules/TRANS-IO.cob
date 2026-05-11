      *>****************************************************************
      *> Module : TRANS-IO
      *> Role   : Acces au fichier sequentiel TRANS.dat (historique)
      *> Appel  : CALL "TRANS-IO" USING LK-OP, W-TRANS, LK-CODE-RETOUR.
      *> Operations (LK-OP):
      *>   "OPEN-OUT"   -> ouvre en sortie (append-style via EXTEND)
      *>   "OPEN-IN"    -> ouvre en lecture
      *>   "CLOSE"      -> ferme
      *>   "WRITE"      -> ajoute W-TRANS en fin de fichier
      *>   "READ-NEXT"  -> lit la transaction suivante
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TRANS-IO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F-TRANS ASSIGN TO "data/TRANS.dat"
               ORGANIZATION IS LINE SEQUENTIAL
               FILE STATUS IS WS-FS.

       DATA DIVISION.
       FILE SECTION.
       FD F-TRANS.
       01 F-TRANS-REC           PIC X(80).

       WORKING-STORAGE SECTION.
       01 WS-FS                 PIC X(2) VALUE '00'.
       01 WS-OUVERT             PIC X(1) VALUE 'N'.
          88 OUVERT-LECTURE     VALUE 'L'.
          88 OUVERT-ECRITURE    VALUE 'E'.
          88 FICHIER-FERME      VALUE 'N'.

      *> Tampon en clair pour ecriture/lecture en LINE SEQUENTIAL
       01 WS-LIGNE.
          05 WS-L-ID            PIC 9(10).
          05 FILLER             PIC X(1) VALUE ';'.
          05 WS-L-CPT           PIC 9(8).
          05 FILLER             PIC X(1) VALUE ';'.
          05 WS-L-TYPE          PIC X(1).
          05 FILLER             PIC X(1) VALUE ';'.
          05 WS-L-MONTANT       PIC -Z(10)9.99.
          05 FILLER             PIC X(1) VALUE ';'.
          05 WS-L-DATE          PIC 9(8).
          05 FILLER             PIC X(1) VALUE ';'.
          05 WS-L-HEURE         PIC 9(6).
          05 FILLER             PIC X(1) VALUE ';'.
          05 WS-L-LIBELLE       PIC X(40).

       LINKAGE SECTION.
       01 LK-OP                 PIC X(12).
       COPY TRANSACT.
       01 LK-CODE-RETOUR        PIC X(2).

       PROCEDURE DIVISION USING LK-OP, W-TRANS, LK-CODE-RETOUR.

       MOVE '00' TO LK-CODE-RETOUR.

       EVALUATE LK-OP

           WHEN "OPEN-OUT"
               IF NOT OUVERT-ECRITURE
                   IF OUVERT-LECTURE
                       CLOSE F-TRANS
                   END-IF
                   OPEN EXTEND F-TRANS
                   IF WS-FS = '35'
                       OPEN OUTPUT F-TRANS
                   END-IF
                   IF WS-FS NOT = '00'
                       MOVE '29' TO LK-CODE-RETOUR
                   ELSE
                       SET OUVERT-ECRITURE TO TRUE
                   END-IF
               END-IF

           WHEN "OPEN-IN"
               IF NOT OUVERT-LECTURE
                   IF OUVERT-ECRITURE
                       CLOSE F-TRANS
                   END-IF
                   OPEN INPUT F-TRANS
                   IF WS-FS NOT = '00'
                       MOVE '29' TO LK-CODE-RETOUR
                   ELSE
                       SET OUVERT-LECTURE TO TRUE
                   END-IF
               END-IF

           WHEN "CLOSE"
               IF NOT FICHIER-FERME
                   CLOSE F-TRANS
                   SET FICHIER-FERME TO TRUE
               END-IF

           WHEN "WRITE"
               IF NOT OUVERT-ECRITURE
                   MOVE '29' TO LK-CODE-RETOUR
               ELSE
                   MOVE W-TRN-ID      TO WS-L-ID
                   MOVE W-TRN-CPT     TO WS-L-CPT
                   MOVE W-TRN-TYPE    TO WS-L-TYPE
                   MOVE W-TRN-MONTANT TO WS-L-MONTANT
                   MOVE W-TRN-DATE    TO WS-L-DATE
                   MOVE W-TRN-HEURE   TO WS-L-HEURE
                   MOVE W-TRN-LIBELLE TO WS-L-LIBELLE
                   MOVE WS-LIGNE      TO F-TRANS-REC
                   WRITE F-TRANS-REC
                   IF WS-FS NOT = '00'
                       MOVE '29' TO LK-CODE-RETOUR
                   END-IF
               END-IF

           WHEN "READ-NEXT"
               IF NOT OUVERT-LECTURE
                   MOVE '29' TO LK-CODE-RETOUR
               ELSE
                   READ F-TRANS
                       AT END
                           MOVE '21' TO LK-CODE-RETOUR
                       NOT AT END
                           MOVE F-TRANS-REC TO WS-LIGNE
                           MOVE WS-L-ID      TO W-TRN-ID
                           MOVE WS-L-CPT     TO W-TRN-CPT
                           MOVE WS-L-TYPE    TO W-TRN-TYPE
                           MOVE WS-L-MONTANT TO W-TRN-MONTANT
                           MOVE WS-L-DATE    TO W-TRN-DATE
                           MOVE WS-L-HEURE   TO W-TRN-HEURE
                           MOVE WS-L-LIBELLE TO W-TRN-LIBELLE
                   END-READ
               END-IF

           WHEN OTHER
               MOVE '99' TO LK-CODE-RETOUR
       END-EVALUATE.

       GOBACK.

       END PROGRAM TRANS-IO.
