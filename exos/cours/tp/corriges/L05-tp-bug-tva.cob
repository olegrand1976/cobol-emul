      *>****************************************************************
      *> TP L5 - CORRIGE : une seule fois la part TVA
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. TVA-CALC.

       DATA DIVISION.
       LINKAGE SECTION.
       01 LK-MONTANT-HT        PIC S9(7)V99 COMP-3.
       01 LK-TAUX              PIC 9(3)V99 COMP-3.
       01 LK-MONTANT-TTC       PIC S9(7)V99 COMP-3.

       PROCEDURE DIVISION USING LK-MONTANT-HT
                                LK-TAUX
                                LK-MONTANT-TTC.
           COMPUTE LK-MONTANT-TTC ROUNDED = LK-MONTANT-HT
                                        + (LK-MONTANT-HT * LK-TAUX / 100).
           GOBACK.
       END PROGRAM TVA-CALC.
