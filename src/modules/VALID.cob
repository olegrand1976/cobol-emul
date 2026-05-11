      *>****************************************************************
      *> Module : VALID
      *> Role   : Validations metier reutilisables
      *> Appel  : CALL "VALID" USING LK-OP, LK-NUMERO, LK-MONTANT,
      *>                            LK-LIBELLE, LK-CODE-RETOUR.
      *> Operations supportees (LK-OP):
      *>   "NUMERO"   -> verifie LK-NUMERO numerique > 0
      *>   "MONTANT"  -> verifie LK-MONTANT > 0
      *>   "LIBELLE"  -> verifie LK-LIBELLE non vide
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. VALID.

       DATA DIVISION.
       LINKAGE SECTION.
       01 LK-OP             PIC X(12).
       01 LK-NUMERO         PIC 9(8).
       01 LK-MONTANT        PIC S9(11)V99 COMP-3.
       01 LK-LIBELLE        PIC X(40).
       01 LK-CODE-RETOUR    PIC X(2).

       PROCEDURE DIVISION USING LK-OP
                                LK-NUMERO
                                LK-MONTANT
                                LK-LIBELLE
                                LK-CODE-RETOUR.

       MOVE '00' TO LK-CODE-RETOUR.

       EVALUATE LK-OP
           WHEN "NUMERO"
               IF LK-NUMERO = 0
                   MOVE '10' TO LK-CODE-RETOUR
               END-IF
           WHEN "MONTANT"
               IF LK-MONTANT <= 0
                   MOVE '11' TO LK-CODE-RETOUR
               END-IF
           WHEN "LIBELLE"
               IF LK-LIBELLE = SPACES
                   MOVE '12' TO LK-CODE-RETOUR
               END-IF
           WHEN OTHER
               MOVE '99' TO LK-CODE-RETOUR
       END-EVALUATE.

       GOBACK.

       END PROGRAM VALID.
