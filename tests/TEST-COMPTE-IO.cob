      *>****************************************************************
      *> Test : TEST-COMPTE-IO
      *> Role : CRUD complet sur le fichier indexe COMPTES.dat
      *> Note : Le fichier de test est efface avant le run par run-tests.sh
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-COMPTE-IO.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY COMPTE.
       COPY OPS.

       01 WS-NB-OK              PIC 9(3) VALUE 0.
       01 WS-NB-KO              PIC 9(3) VALUE 0.

       01 WS-RC                 PIC X(2).
       01 WS-ATTENDU            PIC X(2).
       01 WS-LIB-CAS            PIC X(40).

       PROCEDURE DIVISION.

       DISPLAY "=== TEST-COMPTE-IO ===".

      *> 1) Ouverture (le fichier sera cree)
       MOVE "OPEN-IO" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "ouverture/creation" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> 2) Insertion d'un compte
       MOVE 11111111 TO W-CPT-NUMERO.
       MOVE "MARTIN PAUL" TO W-CPT-TITULAIRE.
       MOVE 1000.00 TO W-CPT-SOLDE.
       MOVE 20240101 TO W-CPT-DATE-OUV.
       MOVE 'A' TO W-CPT-STATUT.
       MOVE "WRITE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "insertion compte 11111111" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> 3) Doublon refuse
       MOVE "WRITE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "22" TO WS-ATTENDU.
       MOVE "rejet doublon" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> 4) Lecture par cle
       INITIALIZE W-COMPTE.
       MOVE 11111111 TO W-CPT-NUMERO.
       MOVE "READ" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "lecture compte" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

       IF W-CPT-SOLDE = 1000.00
           ADD 1 TO WS-NB-OK
           DISPLAY "  [OK] solde lu correctement"
       ELSE
           ADD 1 TO WS-NB-KO
           DISPLAY "  [KO] solde inattendu : " W-CPT-SOLDE
       END-IF.

      *> 5) Mise a jour
       MOVE 1500.00 TO W-CPT-SOLDE.
       MOVE "REWRITE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "rewrite" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

       INITIALIZE W-COMPTE.
       MOVE 11111111 TO W-CPT-NUMERO.
       MOVE "READ" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       IF W-CPT-SOLDE = 1500.00
           ADD 1 TO WS-NB-OK
           DISPLAY "  [OK] solde mis a jour"
       ELSE
           ADD 1 TO WS-NB-KO
           DISPLAY "  [KO] solde non mis a jour : " W-CPT-SOLDE
       END-IF.

      *> 6) Lecture compte inexistant
       MOVE 99999999 TO W-CPT-NUMERO.
       MOVE "READ" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "21" TO WS-ATTENDU.
       MOVE "lecture compte inexistant" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> 7) Suppression
       MOVE 11111111 TO W-CPT-NUMERO.
       MOVE "DELETE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "suppression" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> 8) Lecture apres suppression -> 21
       MOVE "READ" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "21" TO WS-ATTENDU.
       MOVE "lecture apres suppression" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> 9) Fermeture
       MOVE "CLOSE" TO WS-OP.
       CALL "COMPTE-IO" USING WS-OP W-COMPTE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "fermeture" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

       DISPLAY "=== Resultat : " WS-NB-OK " OK / " WS-NB-KO " KO ===".

       IF WS-NB-KO > 0
           MOVE 1 TO RETURN-CODE
       ELSE
           MOVE 0 TO RETURN-CODE
       END-IF.

       STOP RUN.

      *>----------------------------------------------------------------
       ASSERT-EGAL.
           IF WS-RC = WS-ATTENDU
               ADD 1 TO WS-NB-OK
               DISPLAY "  [OK] " WS-LIB-CAS
           ELSE
               ADD 1 TO WS-NB-KO
               DISPLAY "  [KO] " WS-LIB-CAS
                       " attendu=" WS-ATTENDU " obtenu=" WS-RC
           END-IF.

       END PROGRAM TEST-COMPTE-IO.
