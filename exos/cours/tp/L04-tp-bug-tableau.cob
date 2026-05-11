      *>****************************************************************
      *> TP L4 - MAINTENANCE : total cotisations mensuelles (BUG intentionnel)
      *> Contexte metier : 12 primes mensuelles dans un tableau ; afficher
      *>   la somme des 12 montants.
      *> Bug technique : boucle PERFORM s'arrete a 11 au lieu de 12.
      *> Resultat attendu : somme des 12 valeurs saisies (ou fixees).
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L04TPBUG.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 T-PRIMES.
          05 T-MONT              OCCURS 12 TIMES PIC S9(5)V99.
       01 WS-M                   PIC S9(5)V99.
       01 WS-I                   PIC 9(2).
       01 WS-TOTAL               PIC S9(7)V99 VALUE 0.

       PROCEDURE DIVISION.
           DISPLAY "TP L4 - Saisir 12 primes (une par ligne)".
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 12
               DISPLAY "Prime " WS-I " : " WITH NO ADVANCING
               ACCEPT WS-M
               MOVE WS-M TO T-MONT(WS-I)
           END-PERFORM.

      *> BUG : dernier indice 11 seulement
           PERFORM VARYING WS-I FROM 1 BY 1 UNTIL WS-I > 11
               ADD T-MONT(WS-I) TO WS-TOTAL
           END-PERFORM.

           DISPLAY "Total (incorrect si bug) : " WS-TOTAL.
           STOP RUN.
       END PROGRAM L04TPBUG.
