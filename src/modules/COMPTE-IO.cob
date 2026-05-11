      *>****************************************************************
      *> Module : COMPTE-IO
      *> Role   : Acces (CRUD) au fichier indexe COMPTES.dat
      *>          Cle primaire = W-CPT-NUMERO
      *> Appel  : CALL "COMPTE-IO" USING LK-OP, W-COMPTE, LK-CODE-RETOUR.
      *> Operations (LK-OP):
      *>   "OPEN-IO"    -> ouvre le fichier en lecture/ecriture (cree si absent)
      *>   "CLOSE"      -> ferme le fichier
      *>   "READ"       -> lit le compte dont le numero est dans W-COMPTE
      *>   "WRITE"      -> insere W-COMPTE
      *>   "REWRITE"    -> met a jour W-COMPTE existant
      *>   "DELETE"     -> supprime le compte
      *>   "START-FIRST"-> positionne sur le premier compte (parcours)
      *>   "READ-NEXT"  -> lit le compte suivant en sequentiel
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. COMPTE-IO.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT F-COMPTES ASSIGN TO "data/COMPTES.dat"
               ORGANIZATION IS INDEXED
               ACCESS MODE IS DYNAMIC
               RECORD KEY IS F-CPT-NUMERO
               FILE STATUS IS WS-FS.

       DATA DIVISION.
       FILE SECTION.
       FD F-COMPTES.
       01 F-COMPTE.
          05 F-CPT-NUMERO       PIC 9(8).
          05 F-CPT-RESTE        PIC X(63).

       WORKING-STORAGE SECTION.
       01 WS-FS                 PIC X(2) VALUE '00'.
       01 WS-OUVERT             PIC X(1) VALUE 'N'.
          88 FICHIER-OUVERT     VALUE 'O'.
          88 FICHIER-FERME      VALUE 'N'.

       LINKAGE SECTION.
       01 LK-OP                 PIC X(12).
       COPY COMPTE.
       01 LK-CODE-RETOUR        PIC X(2).

       PROCEDURE DIVISION USING LK-OP, W-COMPTE, LK-CODE-RETOUR.

       MOVE '00' TO LK-CODE-RETOUR.

       EVALUATE LK-OP

           WHEN "OPEN-IO"
               PERFORM OUVRIR-FICHIER

           WHEN "CLOSE"
               IF FICHIER-OUVERT
                   CLOSE F-COMPTES
                   SET FICHIER-FERME TO TRUE
               END-IF

           WHEN "READ"
               PERFORM ASSURER-OUVERT
               MOVE W-CPT-NUMERO TO F-CPT-NUMERO
               READ F-COMPTES
                   INVALID KEY
                       MOVE '21' TO LK-CODE-RETOUR
                   NOT INVALID KEY
                       MOVE F-COMPTE TO W-COMPTE
               END-READ

           WHEN "WRITE"
               PERFORM ASSURER-OUVERT
               MOVE W-COMPTE TO F-COMPTE
               WRITE F-COMPTE
                   INVALID KEY
                       MOVE '22' TO LK-CODE-RETOUR
               END-WRITE

           WHEN "REWRITE"
               PERFORM ASSURER-OUVERT
               MOVE W-CPT-NUMERO TO F-CPT-NUMERO
               READ F-COMPTES
                   INVALID KEY
                       MOVE '21' TO LK-CODE-RETOUR
               END-READ
               IF LK-CODE-RETOUR = '00'
                   MOVE W-COMPTE TO F-COMPTE
                   REWRITE F-COMPTE
                       INVALID KEY
                           MOVE '29' TO LK-CODE-RETOUR
                   END-REWRITE
               END-IF

           WHEN "DELETE"
               PERFORM ASSURER-OUVERT
               MOVE W-CPT-NUMERO TO F-CPT-NUMERO
               DELETE F-COMPTES
                   INVALID KEY
                       MOVE '21' TO LK-CODE-RETOUR
               END-DELETE

           WHEN "START-FIRST"
               PERFORM ASSURER-OUVERT
               MOVE ZERO TO F-CPT-NUMERO
               START F-COMPTES KEY >= F-CPT-NUMERO
                   INVALID KEY
                       MOVE '21' TO LK-CODE-RETOUR
               END-START

           WHEN "READ-NEXT"
               PERFORM ASSURER-OUVERT
               READ F-COMPTES NEXT
                   AT END
                       MOVE '21' TO LK-CODE-RETOUR
                   NOT AT END
                       MOVE F-COMPTE TO W-COMPTE
               END-READ

           WHEN OTHER
               MOVE '99' TO LK-CODE-RETOUR
       END-EVALUATE.

       GOBACK.

      *>----------------------------------------------------------------
       OUVRIR-FICHIER.
           IF FICHIER-OUVERT
               EXIT PARAGRAPH
           END-IF.
           OPEN I-O F-COMPTES.
           IF WS-FS = '35'
               OPEN OUTPUT F-COMPTES
               CLOSE F-COMPTES
               OPEN I-O F-COMPTES
           END-IF.
           IF WS-FS NOT = '00'
               MOVE '29' TO LK-CODE-RETOUR
           ELSE
               SET FICHIER-OUVERT TO TRUE
           END-IF.

       ASSURER-OUVERT.
           IF FICHIER-FERME
               PERFORM OUVRIR-FICHIER
           END-IF.

       END PROGRAM COMPTE-IO.
