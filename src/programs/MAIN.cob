      *>****************************************************************
      *> Programme : MAIN
      *> Role      : Menu principal de l'application bancaire
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. MAIN.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-CHOIX              PIC 9(1) VALUE 0.
       01 WS-FIN                PIC X(1) VALUE 'N'.
          88 FIN-PROGRAMME      VALUE 'O'.

       PROCEDURE DIVISION.

       PERFORM UNTIL FIN-PROGRAMME
           PERFORM AFFICHER-MENU
           ACCEPT WS-CHOIX
           EVALUATE WS-CHOIX
               WHEN 1 CALL "CREER"
               WHEN 2 CALL "DEPOT"
               WHEN 3 CALL "RETRAIT"
               WHEN 4 CALL "SOLDE"
               WHEN 5 CALL "LISTER"
               WHEN 6 CALL "HISTO"
               WHEN 9 SET FIN-PROGRAMME TO TRUE
               WHEN OTHER DISPLAY "Choix invalide."
           END-EVALUATE
       END-PERFORM.

       DISPLAY " ".
       DISPLAY "A bientot !".
       STOP RUN.

      *>----------------------------------------------------------------
       AFFICHER-MENU.
           DISPLAY " ".
           DISPLAY "==================================================".
           DISPLAY "             BANQUE COBOL - MENU                  ".
           DISPLAY "==================================================".
           DISPLAY "  1. Creer un compte".
           DISPLAY "  2. Effectuer un depot".
           DISPLAY "  3. Effectuer un retrait".
           DISPLAY "  4. Consulter un solde".
           DISPLAY "  5. Lister tous les comptes".
           DISPLAY "  6. Historique des transactions".
           DISPLAY "  9. Quitter".
           DISPLAY "==================================================".
           DISPLAY "Votre choix : " WITH NO ADVANCING.

       END PROGRAM MAIN.
