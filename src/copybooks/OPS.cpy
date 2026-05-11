      *>****************************************************************
      *> COPYBOOK : OPS.cpy
      *> Description : Variable de transport pour les noms d'operations
      *>               passes aux modules VALID / COMPTE-IO / TRANS-IO.
      *>               Ils attendent tous LK-OP de taille PIC X(12).
      *>               On MOVE "WRITE", "READ", "NUMERO" etc. dans
      *>               WS-OP avant chaque CALL.
      *>****************************************************************
       01 WS-OP                 PIC X(12) VALUE SPACES.
