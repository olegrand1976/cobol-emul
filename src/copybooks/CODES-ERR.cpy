      *>****************************************************************
      *> COPYBOOK : CODES-ERR.cpy
      *> Description : Codes retour standardises pour les sous-programmes
      *> Convention :
      *>   '00' = OK
      *>   '1x' = Donnees invalides
      *>   '2x' = Acces fichier
      *>   '3x' = Regle metier
      *>****************************************************************
       01 W-CODE-RETOUR          PIC X(2).
          88 RC-OK                VALUE '00'.
          88 RC-ERR-NUM-INVALIDE  VALUE '10'.
          88 RC-ERR-MONTANT-NEG   VALUE '11'.
          88 RC-ERR-LIB-VIDE      VALUE '12'.
          88 RC-ERR-INTROUVABLE   VALUE '21'.
          88 RC-ERR-DEJA-EXISTE   VALUE '22'.
          88 RC-ERR-IO            VALUE '29'.
          88 RC-ERR-DECOUVERT     VALUE '30'.
          88 RC-ERR-CLOTURE       VALUE '31'.
