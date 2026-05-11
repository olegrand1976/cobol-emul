      *>****************************************************************
      *> Test : TEST-VALID
      *> Role : Verifie le module VALID sur ses 3 operations
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TEST-VALID.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY OPS.
       01 WS-NB-OK              PIC 9(3) VALUE 0.
       01 WS-NB-KO              PIC 9(3) VALUE 0.

       01 WS-NUMERO             PIC 9(8).
       01 WS-MONTANT            PIC S9(11)V99 COMP-3.
       01 WS-LIBELLE            PIC X(40).
       01 WS-RC                 PIC X(2).

       01 WS-ATTENDU            PIC X(2).
       01 WS-LIB-CAS            PIC X(40).

       PROCEDURE DIVISION.

       DISPLAY "=== TEST-VALID ===".

      *> Cas 1 : numero valide
       MOVE 12345678 TO WS-NUMERO.
       MOVE 0 TO WS-MONTANT.
       MOVE SPACES TO WS-LIBELLE.
       MOVE "NUMERO" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "numero valide" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 2 : numero zero -> KO
       MOVE 0 TO WS-NUMERO.
       MOVE "NUMERO" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "10" TO WS-ATTENDU.
       MOVE "numero zero" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 3 : montant positif -> OK
       MOVE 100.50 TO WS-MONTANT.
       MOVE "MONTANT" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "montant positif" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 4 : montant zero -> KO
       MOVE 0 TO WS-MONTANT.
       MOVE "MONTANT" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "11" TO WS-ATTENDU.
       MOVE "montant zero" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 5 : montant negatif -> KO
       MOVE -42.00 TO WS-MONTANT.
       MOVE "MONTANT" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "11" TO WS-ATTENDU.
       MOVE "montant negatif" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 6 : libelle non vide -> OK
       MOVE "Dupont" TO WS-LIBELLE.
       MOVE "LIBELLE" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "00" TO WS-ATTENDU.
       MOVE "libelle rempli" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 7 : libelle vide -> KO
       MOVE SPACES TO WS-LIBELLE.
       MOVE "LIBELLE" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "12" TO WS-ATTENDU.
       MOVE "libelle vide" TO WS-LIB-CAS.
       PERFORM ASSERT-EGAL.

      *> Cas 8 : operation inconnue -> 99
       MOVE "BIDON" TO WS-OP.
       CALL "VALID" USING WS-OP WS-NUMERO WS-MONTANT WS-LIBELLE WS-RC.
       MOVE "99" TO WS-ATTENDU.
       MOVE "operation inconnue" TO WS-LIB-CAS.
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

       END PROGRAM TEST-VALID.
