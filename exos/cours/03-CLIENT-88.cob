       IDENTIFICATION DIVISION.
       PROGRAM-ID. L03CLIENT.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 W-CLIENT.
          05 W-CLI-NOM        PIC X(30).
          05 W-CLI-AGE        PIC 9(3).
             88 W-CLI-MINEUR  VALUES 0 THRU 17.
             88 W-CLI-ADULTE  VALUES 18 THRU 64.
             88 W-CLI-SENIOR  VALUES 65 THRU 999.
          05 W-CLI-SOLDE      PIC S9(7)V99 COMP-3.

       01 W-AGE-AFF           PIC ZZZ.
       01 W-SOLDE-AFF         PIC -ZZZZZZ9.99.

       PROCEDURE DIVISION.
           DISPLAY "Lecon 3 - PIC / COMP-3 / niveaux 88".

           DISPLAY "Nom client : " WITH NO ADVANCING.
           ACCEPT W-CLI-NOM.

           DISPLAY "Age : " WITH NO ADVANCING.
           ACCEPT W-CLI-AGE.

           DISPLAY "Solde : " WITH NO ADVANCING.
           ACCEPT W-CLI-SOLDE.

           MOVE W-CLI-AGE TO W-AGE-AFF.
           MOVE W-CLI-SOLDE TO W-SOLDE-AFF.

           DISPLAY "Client : " W-CLI-NOM.
           DISPLAY "Age    : " W-AGE-AFF.

           EVALUATE TRUE
               WHEN W-CLI-MINEUR
                   DISPLAY "Categorie : MINEUR"
               WHEN W-CLI-ADULTE
                   DISPLAY "Categorie : ADULTE"
               WHEN W-CLI-SENIOR
                   DISPLAY "Categorie : SENIOR"
               WHEN OTHER
                   DISPLAY "Categorie : INCONNUE"
           END-EVALUATE.

           DISPLAY "Solde  : " W-SOLDE-AFF.
           STOP RUN.
       END PROGRAM L03CLIENT.
