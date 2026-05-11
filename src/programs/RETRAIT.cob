      *>****************************************************************
      *> Programme : RETRAIT
      *> Role      : Debiter un compte avec controle de decouvert
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. RETRAIT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY COMPTE.
       COPY TRANSACT.
       COPY CODES-ERR.
       COPY OPS.

       01 WS-MONTANT            PIC S9(11)V99 COMP-3.
       01 WS-LIB-VIDE           PIC X(40) VALUE SPACES.
       01 WS-NUM-VIDE           PIC 9(8) VALUE 0.

       01 WS-DATE-COMPLETE      PIC X(21).
       01 WS-COMPTEUR           PIC 9(10) VALUE 0.

       PROCEDURE DIVISION.

       DISPLAY " ".
       DISPLAY "--- Retrait ---".

       DISPLAY "Numero de compte : " WITH NO ADVANCING.
       ACCEPT W-CPT-NUMERO.

       MOVE "READ" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Compte introuvable."
           EXIT PROGRAM
       END-IF.

       IF NOT CPT-ACTIF
           DISPLAY "Compte non actif (statut: " W-CPT-STATUT ")."
           EXIT PROGRAM
       END-IF.

       DISPLAY "Solde actuel : " W-CPT-SOLDE.
       DISPLAY "Montant a retirer : " WITH NO ADVANCING.
       ACCEPT WS-MONTANT.

       MOVE "MONTANT" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUM-VIDE WS-MONTANT WS-LIB-VIDE
                          W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Montant invalide."
           EXIT PROGRAM
       END-IF.

       IF WS-MONTANT > W-CPT-SOLDE
           DISPLAY "Refuse : decouvert non autorise."
           MOVE '30' TO W-CODE-RETOUR
           EXIT PROGRAM
       END-IF.

       SUBTRACT WS-MONTANT FROM W-CPT-SOLDE.

       MOVE "REWRITE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Echec mise a jour solde."
           EXIT PROGRAM
       END-IF.

      *> Journalisation
       MOVE FUNCTION CURRENT-DATE TO WS-DATE-COMPLETE.
       COMPUTE WS-COMPTEUR = FUNCTION RANDOM(1) * 9999999999.

       MOVE WS-COMPTEUR        TO W-TRN-ID.
       MOVE W-CPT-NUMERO       TO W-TRN-CPT.
       MOVE 'R'                TO W-TRN-TYPE.
       MOVE WS-MONTANT         TO W-TRN-MONTANT.
       MOVE WS-DATE-COMPLETE(1:8) TO W-TRN-DATE.
       MOVE WS-DATE-COMPLETE(9:6) TO W-TRN-HEURE.
       MOVE "RETRAIT GUICHET"  TO W-TRN-LIBELLE.

       MOVE "OPEN-OUT" TO WS-OP.
       CALL "TRANS-IO" USING WS-OP W-TRANS W-CODE-RETOUR.
       MOVE "WRITE" TO WS-OP.
       CALL "TRANS-IO" USING WS-OP W-TRANS W-CODE-RETOUR.
       MOVE "CLOSE" TO WS-OP.
       CALL "TRANS-IO" USING WS-OP W-TRANS W-CODE-RETOUR.

       DISPLAY "Retrait effectue.".
       DISPLAY "Nouveau solde : " W-CPT-SOLDE.

       EXIT PROGRAM.

       END PROGRAM RETRAIT.
