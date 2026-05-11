      *>****************************************************************
      *> COPYBOOK : COMPTE.cpy
      *> Description : Structure d'un compte bancaire
      *> Cle primaire : W-CPT-NUMERO (8 chiffres)
      *>****************************************************************
       01 W-COMPTE.
          05 W-CPT-NUMERO       PIC 9(8).
          05 W-CPT-TITULAIRE    PIC X(40).
          05 W-CPT-SOLDE        PIC S9(11)V99 COMP-3.
          05 W-CPT-DATE-OUV     PIC 9(8).
          05 W-CPT-STATUT       PIC X(1).
             88 CPT-ACTIF       VALUE 'A'.
             88 CPT-CLOTURE     VALUE 'C'.
             88 CPT-SUSPENDU    VALUE 'S'.
