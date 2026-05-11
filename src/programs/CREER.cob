      *>****************************************************************
      *> Programme : CREER
      *> Role      : Saisir un nouveau compte et l'inserer dans COMPTES.dat
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. CREER.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY COMPTE.
       COPY CODES-ERR.
       COPY OPS.
       01 WS-NUM-LIB            PIC 9(8) VALUE 0.
       01 WS-MNT-VIDE           PIC S9(11)V99 COMP-3 VALUE 0.
       01 WS-LIB-VIDE           PIC X(40) VALUE SPACES.

       PROCEDURE DIVISION.

       DISPLAY " ".
       DISPLAY "--- Creation d'un compte ---".

       DISPLAY "Numero (8 chiffres) : " WITH NO ADVANCING.
       ACCEPT W-CPT-NUMERO.

       MOVE "NUMERO" TO WS-OP.
       CALL "VALID" USING WS-OP W-CPT-NUMERO
                          WS-MNT-VIDE WS-LIB-VIDE
                          W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Numero invalide."
           EXIT PROGRAM
       END-IF.

       DISPLAY "Titulaire           : " WITH NO ADVANCING.
       ACCEPT W-CPT-TITULAIRE.

       MOVE "LIBELLE" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUM-LIB
                          WS-MNT-VIDE W-CPT-TITULAIRE
                          W-CODE-RETOUR.
       IF NOT RC-OK
           DISPLAY "Titulaire vide."
           EXIT PROGRAM
       END-IF.

       MOVE 0 TO W-CPT-SOLDE.
       MOVE FUNCTION CURRENT-DATE(1:8) TO W-CPT-DATE-OUV.
       MOVE 'A' TO W-CPT-STATUT.

       MOVE "WRITE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE W-CODE-RETOUR.

       EVALUATE TRUE
           WHEN RC-OK
               DISPLAY "Compte cree avec succes."
           WHEN RC-ERR-DEJA-EXISTE
               DISPLAY "Erreur : ce numero existe deja."
           WHEN OTHER
               DISPLAY "Erreur d'ecriture (code: " W-CODE-RETOUR ")."
       END-EVALUATE.

       EXIT PROGRAM.

       END PROGRAM CREER.
