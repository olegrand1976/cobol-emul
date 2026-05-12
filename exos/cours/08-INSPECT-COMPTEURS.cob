      *>****************************************************************
      *> Lecon 8 (complement) - INSPECT TALLYING / CONVERTING
      *> Denombrer des caracteres ; REPLACING (meme longueur des operandes)
      *>****************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. L08INSP.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01 WS-TEXTE           PIC X(50) VALUE "  REF-OP  20260511  EUR  ".
       01 WS-NB-ESPACES      PIC 9(4).
       01 WS-NB-ZERO        PIC 9(4).

       PROCEDURE DIVISION.
           DISPLAY "Lecon 08 complement - INSPECT".
           MOVE ZERO TO WS-NB-ESPACES
           INSPECT WS-TEXTE TALLYING WS-NB-ESPACES FOR ALL SPACE
           DISPLAY "Nombre d'espaces : " WS-NB-ESPACES.

           *> Remplacer un marqueur fixe (operandes meme longueur en COBOL)
           INSPECT WS-TEXTE REPLACING ALL "REF-OP" BY "REF_OP".
           DISPLAY "Apres remplacement etiquette : [" WS-TEXTE "]".

           MOVE ZERO TO WS-NB-ZERO
           INSPECT WS-TEXTE TALLYING WS-NB-ZERO FOR ALL "0"
           DISPLAY "Nombre de chiffres 0 dans la zone : " WS-NB-ZERO.

           STOP RUN.
       END PROGRAM L08INSP.
