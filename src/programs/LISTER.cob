      *>****************************************************************
      *> Programme : LISTER
      *> Role      : Parcourt sequentiellement le fichier indexe COMPTES
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. LISTER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY COMPTE.
       COPY CODES-ERR.
       COPY OPS.

       01 WS-FIN                PIC X(1) VALUE 'N'.
          88 FIN-PARCOURS       VALUE 'O'.
       01 WS-NB                 PIC 9(5) VALUE 0.
       01 WS-SOLDE-AFF          PIC -Z(10)9.99.

       PROCEDURE DIVISION.

       DISPLAY " ".
       DISPLAY "--- Liste des comptes ---".
       DISPLAY "------------------------------------------------------".
       DISPLAY "NUMERO    TITULAIRE                                "
               "      SOLDE        ST".
       DISPLAY "------------------------------------------------------".

       MOVE "OPEN-IO" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Erreur d'ouverture (code: " W-CODE-RETOUR ")."
           EXIT PROGRAM
       END-IF.

       MOVE "START-FIRST" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Aucun compte enregistre."
           MOVE "CLOSE" TO WS-OP
           CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR
           EXIT PROGRAM
       END-IF.

       PERFORM UNTIL FIN-PARCOURS
           MOVE "READ-NEXT" TO WS-OP
           CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR
           IF RC-OK
               MOVE W-CPT-SOLDE TO WS-SOLDE-AFF
               DISPLAY W-CPT-NUMERO "  "
                       W-CPT-TITULAIRE
                       WS-SOLDE-AFF "  "
                       W-CPT-STATUT
               ADD 1 TO WS-NB
           ELSE
               SET FIN-PARCOURS TO TRUE
           END-IF
       END-PERFORM.

       MOVE "CLOSE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.

       DISPLAY "------------------------------------------------------".
       DISPLAY "Total : " WS-NB " compte(s).".

       EXIT PROGRAM.

       END PROGRAM LISTER.
