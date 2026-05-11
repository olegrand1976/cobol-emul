      *>****************************************************************
      *> Programme : HISTO
      *> Role      : Afficher l'historique des transactions, optionnellement
      *>             filtre sur un numero de compte
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HISTO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY TRANSACT.
       COPY CODES-ERR.
       COPY OPS.

       01 WS-FILTRE-NUM         PIC 9(8) VALUE 0.
       01 WS-CHOIX              PIC X(1) VALUE 'N'.
          88 AVEC-FILTRE        VALUE 'O'.

       01 WS-FIN                PIC X(1) VALUE 'N'.
          88 FIN-LECTURE        VALUE 'O'.

       01 WS-NB                 PIC 9(5) VALUE 0.
       01 WS-MNT-AFF            PIC -Z(10)9.99.

       PROCEDURE DIVISION.

       DISPLAY " ".
       DISPLAY "--- Historique des transactions ---".

       DISPLAY "Filtrer sur un compte ? (O/N) : " WITH NO ADVANCING.
       ACCEPT WS-CHOIX.
       IF AVEC-FILTRE
           DISPLAY "Numero de compte : " WITH NO ADVANCING
           ACCEPT WS-FILTRE-NUM
       END-IF.

       DISPLAY "------------------------------------------------------".
       DISPLAY "DATE      HEURE  TYPE  CPT       MONTANT"
               "        LIBELLE".
       DISPLAY "------------------------------------------------------".

       MOVE "OPEN-IN" TO WS-OP.
       CALL "TRANS-IO" USING WS-OP W-TRANS W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Aucune transaction enregistree."
           EXIT PROGRAM
       END-IF.

       PERFORM UNTIL FIN-LECTURE
           MOVE "READ-NEXT" TO WS-OP
           CALL "TRANS-IO" USING WS-OP W-TRANS W-CODE-RETOUR
           EVALUATE TRUE
               WHEN RC-OK
                   IF (NOT AVEC-FILTRE)
                       OR (W-TRN-CPT = WS-FILTRE-NUM)
                       MOVE W-TRN-MONTANT TO WS-MNT-AFF
                       DISPLAY W-TRN-DATE "  "
                               W-TRN-HEURE "  "
                               W-TRN-TYPE "    "
                               W-TRN-CPT "  "
                               WS-MNT-AFF "  "
                               W-TRN-LIBELLE
                       ADD 1 TO WS-NB
                   END-IF
               WHEN OTHER
                   SET FIN-LECTURE TO TRUE
           END-EVALUATE
       END-PERFORM.

       MOVE "CLOSE" TO WS-OP.
       CALL "TRANS-IO" USING WS-OP W-TRANS W-CODE-RETOUR.

       DISPLAY "------------------------------------------------------".
       DISPLAY "Total : " WS-NB " transaction(s).".

       EXIT PROGRAM.

       END PROGRAM HISTO.
