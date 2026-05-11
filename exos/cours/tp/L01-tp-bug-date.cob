      *>****************************************************************
      *> TP L1 - MAINTENANCE : affichage date agence (BUG intentionnel)
      *> Contexte metier : pied de page releve avec date du jour AAAAMMJJ.
      *> Bug technique : mauvaise sous-chaine sur FUNCTION CURRENT-DATE.
      *> Corrige pour afficher la vraie date du jour (8 premiers caracteres).
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L01TPBUG.

       PROCEDURE DIVISION.
           DISPLAY "Agence COBOL-EMUL - Releve du ".
           DISPLAY "Date (AAAAMMJJ) : " FUNCTION CURRENT-DATE(9:8).
           STOP RUN.
       END PROGRAM L01TPBUG.
