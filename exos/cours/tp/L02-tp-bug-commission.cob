      *>****************************************************************
      *> TP L2 - MAINTENANCE : calcul commission conseiller (BUG intentionnel)
      *> Contexte metier : sur un montant place WS-MONTANT, la banque
      *>   prend une commission de 1,50% pour le conseiller.
      *> Resultat attendu : WS-COM = arrondi metier a 2 decimales.
      *> Bug metier/technique : formule utilise /1000 au lieu de /100
      *>   (commission 10 fois trop faible).
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L02TPBUG.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-MONTANT           PIC S9(9)V99 VALUE 10000.00.
       01 WS-TAUX-PCT          PIC 9(3)V99 VALUE 1.50.
       01 WS-COM               PIC S9(9)V99.

       PROCEDURE DIVISION.
           DISPLAY "TP L2 - Commission sur placement".
           DISPLAY "Montant : " WS-MONTANT "  Taux % : " WS-TAUX-PCT.
      *> BUG : diviser par 1000 au lieu de 100 pour un pourcentage
           COMPUTE WS-COM ROUNDED = WS-MONTANT * WS-TAUX-PCT / 1000.
           DISPLAY "Commission (incorrecte si bug present) : " WS-COM.
           STOP RUN.
       END PROGRAM L02TPBUG.
