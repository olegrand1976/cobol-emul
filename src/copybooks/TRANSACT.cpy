      *>****************************************************************
      *> COPYBOOK : TRANSACT.cpy
      *> Description : Enregistrement d'une transaction (historique)
      *> Fichier sequentiel TRANS.dat
      *>****************************************************************
       01 W-TRANS.
          05 W-TRN-ID           PIC 9(10).
          05 W-TRN-CPT          PIC 9(8).
          05 W-TRN-TYPE         PIC X(1).
             88 TRN-DEPOT       VALUE 'D'.
             88 TRN-RETRAIT     VALUE 'R'.
             88 TRN-VIREMENT    VALUE 'V'.
          05 W-TRN-MONTANT      PIC S9(11)V99 COMP-3.
          05 W-TRN-DATE         PIC 9(8).
          05 W-TRN-HEURE        PIC 9(6).
          05 W-TRN-LIBELLE      PIC X(40).
