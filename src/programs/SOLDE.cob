      *>****************************************************************
      *> Programme : SOLDE
      *> Role      : Afficher les informations d'un compte
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SOLDE.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY COMPTE.
       COPY CODES-ERR.
       COPY OPS.

       01 WS-SOLDE-AFF          PIC -Z(10)9.99.

       PROCEDURE DIVISION.

       DISPLAY " ".
       DISPLAY "--- Consultation de solde ---".

       DISPLAY "Numero de compte : " WITH NO ADVANCING.
       ACCEPT W-CPT-NUMERO.

       MOVE "READ" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.

       IF NOT RC-OK
           DISPLAY "Compte introuvable."
           EXIT PROGRAM
       END-IF.

       MOVE W-CPT-SOLDE TO WS-SOLDE-AFF.

       DISPLAY "+--------------------------------------------------+".
       DISPLAY "| Numero    : " W-CPT-NUMERO
               "                            |".
       DISPLAY "| Titulaire : " W-CPT-TITULAIRE " |".
       DISPLAY "| Solde     : " WS-SOLDE-AFF " EUR             |".
       DISPLAY "| Statut    : " W-CPT-STATUT
               "                                   |".
       DISPLAY "+--------------------------------------------------+".

       EXIT PROGRAM.

       END PROGRAM SOLDE.
