      *>****************************************************************
      *> TP L3 - MAINTENANCE : categorie client assurance (BUG intentionnel)
      *> Contexte metier : tarification depend de l'age (mineur / adulte / senior).
      *>   - mineur : < 18 ans
      *>   - adulte : 18 a 64 ans inclus
      *>   - senior : >= 65 ans
      *> Bug metier : plage ADULTE commence a 19 au lieu de 18 : un client
      *>   de 18 ans tombe dans SENIOR (erreur de prime).
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L03TPBUG.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-AGE                PIC 9(3).

       PROCEDURE DIVISION.
           DISPLAY "TP L3 - Categorie (saisir age, ex. 18) : " WITH NO ADVANCING.
           ACCEPT WS-AGE.

           EVALUATE WS-AGE
      *> BUG : 18 ans n'est ni mineur ni adulte selon ces plages
               WHEN 0 THRU 17
                   DISPLAY "Categorie : MINEUR"
               WHEN 19 THRU 64
                   DISPLAY "Categorie : ADULTE"
               WHEN OTHER
                   DISPLAY "Categorie : SENIOR"
           END-EVALUATE.

           STOP RUN.
       END PROGRAM L03TPBUG.
