# EXERCICES — Reprise en main de COBOL

16 exercices progressifs, du « Hello World » à des scénarios proches du **batch** bancaire. Tous se compilent dans le conteneur (`docker compose run --rm cobol`).

Pour un **cours structuré** avec explications détaillées leçon par leçon et exemples associés : [`docs/COURS-COBOL.md`](docs/COURS-COBOL.md) (programmes dans `exos/cours/`).

Convention :
- **Compilation** : `cobc -free -std=mf -Wall -x -o build/<nom> <chemin>.cob`
- Pose ton code dans un dossier `exos/<nom>/` (à toi de créer) pour ne pas polluer `src/`.
- À la fin de chaque exo, vérifie le **résultat attendu** avant de passer au suivant.

---

## Exercice 1 — Hello World

**Objectif** : retrouver les 4 DIVISIONS obligatoires.

**Concepts** : `IDENTIFICATION/ENVIRONMENT/DATA/PROCEDURE DIVISION`, `DISPLAY`, `STOP RUN`.

```cobol
       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       PROCEDURE DIVISION.
       DISPLAY "Bonjour COBOL".
       STOP RUN.
```

**Compilation** : `cobc -free -std=mf -x -o build/HELLO exos/01/HELLO.cob`
**Résultat** : `Bonjour COBOL`

---

## Exercice 2 — ACCEPT + arithmétique

**Objectif** : lire deux nombres au clavier, afficher leur somme, leur produit, leur moyenne (arrondie).

**Concepts** : `ACCEPT`, `COMPUTE`, `ROUNDED`, `PIC 9V99`.

Indice :
```cobol
       01 WS-A         PIC 9(4).
       01 WS-B         PIC 9(4).
       01 WS-MOY       PIC 9(4)V99.
       ...
       COMPUTE WS-MOY ROUNDED = (WS-A + WS-B) / 2.
       DISPLAY "Moyenne = " WS-MOY.
```

**Résultat** : pour `10` puis `3` → `Somme=13 Produit=30 Moyenne=00006.50`.

---

## Exercice 3 — PIC, niveaux, COMP-3, REDEFINES

**Objectif** : déclarer une fiche client en `COMP-3` et la projeter en zoned-decimal pour comprendre la différence.

**Concepts** : niveaux `01/05`, `COMP-3` (packed-decimal), `REDEFINES`, `LENGTH OF`.

```cobol
       01 W-CLIENT.
          05 W-NOM     PIC X(20).
          05 W-AGE     PIC 9(3).
          05 W-SOLDE   PIC S9(7)V99 COMP-3.
       01 W-CLIENT-RAW REDEFINES W-CLIENT PIC X(LENGTH OF W-CLIENT).
       ...
       DISPLAY "Taille structuree : " LENGTH OF W-CLIENT.
       DISPLAY "Hex solde : " FUNCTION DISPLAY-OF(W-CLIENT-RAW(24:5)).
```

**Résultat attendu** : on observe que `COMP-3` occupe 5 octets pour 9 chiffres significatifs (n/2+1).

---

## Exercice 4 — Niveaux 88 + EVALUATE

**Objectif** : classifier l'âge (`MINEUR`, `ADULTE`, `SENIOR`) à l'aide de niveaux 88, puis afficher une catégorie via `EVALUATE`.

```cobol
       01 W-AGE        PIC 9(3).
          88 MINEUR    VALUES 0 THRU 17.
          88 ADULTE    VALUES 18 THRU 64.
          88 SENIOR    VALUES 65 THRU 999.
       ...
       EVALUATE TRUE
           WHEN MINEUR DISPLAY "mineur"
           WHEN ADULTE DISPLAY "adulte"
           WHEN SENIOR DISPLAY "senior"
       END-EVALUATE.
```

**Résultat** : pour `17` → `mineur`, `30` → `adulte`, `70` → `senior`.

---

## Exercice 5 — PERFORM VARYING

**Objectif** : afficher la table de multiplication de 7, puis remplir un tableau `01 T-CARRES PIC 9(4) OCCURS 10` avec les carrés de 1 à 10.

**Concepts** : `PERFORM VARYING UNTIL`, `OCCURS`, `INDEXED BY`.

```cobol
       01 T-CARRES.
          05 T-VAL    OCCURS 10 PIC 9(4).
       01 I           PIC 9(2).
       ...
       PERFORM VARYING I FROM 1 BY 1 UNTIL I > 10
           COMPUTE T-VAL(I) = I * I
       END-PERFORM.
```

**Résultat attendu** : `T-VAL(7) = 49`.

---

## Exercice 6 — Fichier séquentiel

**Objectif** : lire un fichier texte `personnes.csv` (`nom;age` par ligne), afficher chaque ligne et compter le total.

**Concepts** : `SELECT`, `ASSIGN TO`, `ORGANIZATION LINE SEQUENTIAL`, `READ ... AT END`, `UNSTRING`.

```cobol
       SELECT F-IN ASSIGN TO "exos/06/personnes.csv"
           ORGANIZATION IS LINE SEQUENTIAL
           FILE STATUS IS WS-FS.
       ...
       OPEN INPUT F-IN.
       PERFORM UNTIL WS-FS NOT = '00'
           READ F-IN INTO WS-LIGNE AT END EXIT PERFORM END-READ
           UNSTRING WS-LIGNE DELIMITED BY ';' INTO WS-NOM, WS-AGE
           DISPLAY WS-NOM " a " WS-AGE " ans"
       END-PERFORM.
```

---

## Exercice 7 — Fichier indexé (ISAM)

**Objectif** : créer un programme qui ajoute 3 produits dans `data/PRODUITS.dat` (clé = code 5 chiffres) puis les relit dans l'ordre.

**Concepts** : `ORGANIZATION INDEXED`, `ACCESS DYNAMIC`, `RECORD KEY`, `WRITE INVALID KEY`, `START`, `READ NEXT AT END`.

Inspire-toi directement de `src/modules/COMPTE-IO.cob` et fais une version "produits". C'est l'exercice **clé** pour le COBOL bancaire.

**Résultat** : trois produits affichés triés par code, même s'ils sont insérés dans le désordre.

---

## Exercice 8 — COPY + CALL (sous-programme)

**Objectif** : extraire le calcul de TVA dans un module `TVA-CALC.cob` avec :
- `LK-MONTANT-HT` (entrée), `LK-TAUX` (entrée), `LK-MONTANT-TTC` (sortie).
- Un **copybook** `TVA.cpy` partagé entre l'appelant et l'appelé.

**Concepts** : `LINKAGE SECTION`, `PROCEDURE DIVISION USING`, `CALL`, `COPY`.

Compilation :
```bash
cobc -free -std=mf -m -o build/TVA-CALC.so exos/08/TVA-CALC.cob
cobc -free -std=mf -x -o build/MAIN08      exos/08/MAIN08.cob
COB_LIBRARY_PATH=build ./build/MAIN08
```

---

## Exercice 9 — DEPOT/RETRAIT avec contrôle découvert

**Objectif** : modifier `src/programs/RETRAIT.cob` pour autoriser un découvert paramétrable (lu dans une variable `WS-PLAFOND-DECOUVERT`). Refuser au-delà.

**Concepts** : règles métier, `EVALUATE TRUE`, journalisation.

À tester manuellement : créer un compte avec 100 €, plafond -50 €, retirer 130 → doit refuser ; retirer 140 ne doit pas refuser… puis comparer les deux comportements.

---

## Exercice 10 — Test unitaire personnel

**Objectif** : écrire `tests/TEST-MIEN.cob` qui :
1. crée 5 comptes via `COMPTE-IO`,
2. fait 3 dépôts et 2 retraits,
3. vérifie que la somme des soldes = solde initial + crédits − débits.

**Concepts** : pattern d'assertion, `RETURN-CODE`, intégration dans `make test`.

Le run-tests.sh prendra automatiquement ton fichier puisqu'il s'appuie sur `build/TEST-*`.

---

## Exercice 11 — INSPECT TALLYING (contrôle de saisie)

**Objectif** : dans une `PIC X(30)` saisie au clavier, compter combien de **lettres** `A` à `Z` (majuscules) apparaissent ; afficher le total (zéro si aucune).

**Concepts** : `INSPECT ... TALLYING ... FOR ALL 'A'` enchaîné ou boucle `PERFORM` avec inspection d’un seul caractère à la fois via `WS-LIGNE(IX:1)`.

**Résultat attendu** : pour `BANQUE-ABC` → au moins 3 majuscules détectées selon ta méthode.

---

## Exercice 12 — STRING pour construire une référence

**Objectif** : concaténer **préfixe** `REF-`, un numéro sur 8 chiffres (avec zéros à gauche via `MOVE` vers `PIC ZZZZZZZ9` ou `9(8)`), tiret, **suffixe** `EUR`, dans une zone `PIC X(24)`.

**Concepts** : `STRING ... DELIMITED BY SIZE`, `INTO` avec gestion du débordement (`OVERFLOW` si tu ajoutes la phrase).

**Résultat attendu** : une seule ligne `DISPLAY` du type `[REF-00001234-EUR]` pour le compteur 1234.

---

## Exercice 13 — INITIALIZE puis réutilisation d’un buffer

**Objectif** : déclarer une zone groupe `01 WS-BUFFER` avec un compte `PIC 9(8)`, un montant `PIC S9(7)V99`, un libellé `PIC X(20)`. Remplis-les, affiche, puis `INITIALIZE WS-BUFFER`, affiche à nouveau (tout à zéro / blanc).

**Concepts** : `INITIALIZE`, distinction **NUMERIC** / **ALPHANUMERIC** (option `REPLACING` avancée en bonus).

---

## Exercice 14 — PERFORM THRU (factorisation)

**Objectif** : écrire trois paragraphes `A-`, `B-`, `C-` qui affichent chacun une ligne ; enchaîne-les avec **`PERFORM A-THRU C-`** depuis `MAIN-LOGIC`.

**Concepts** : étendue de `PERFORM`, nommage des sections (style maintenance).

**Résultat attendu** : trois lignes dans l’ordre, sans dupliquer trois `PERFORM` séparés.

---

## Exercice 15 — REDEFINES (même octets, deux lectures)

**Objectif** : une zone `PIC X(8)` contient `12345678` (caractères). Déclare un `01` groupe avec `REDEFINES` : une vue `PIC X(8)` et une vue `PIC 9(8)` ; `MOVE` la chaîne dans la vue caractère puis `DISPLAY` la vue numérique (comportement selon compilateur : note la conversion implicite ou les espaces).

**Concepts** : `REDEFINES`, alignement mémoire, pièges de **superposition** (ne jamais activer les deux vues en écriture concurrente sans discipline).

---

## Exercice 16 — Date « système » (AAAAMMJJ)

**Objectif** : récupérer la date du jour en `PIC 9(8)` au format **AAAAMMJJ** avec `MOVE FUNCTION CURRENT-DATE (1:8) TO WS-DATE-J` puis l’afficher avec un libellé du type « Reprise batch du » immédiatement suivi de la date (sans espace superflu si tu veux coller au format ISO).

**Concepts** : `FUNCTION CURRENT-DATE` (chaîne longue ; extraire les 8 premiers caractères pour la date calendaire).

**Résultat attendu** : une ligne du type `Reprise batch du 20260511` (la valeur jour dépend de l’exécution).

---

## Pour aller plus loin

- Ajouter un programme `VIREMENT.cob` qui débite un compte et crédite un autre **dans la même unité d'œuvre** (rollback si la 2e opération échoue).
- Remplacer `LINE SEQUENTIAL` de `TRANS-IO` par un fichier indexé sur `(W-TRN-CPT, W-TRN-DATE, W-TRN-ID)` (clé composée + clés alternatives).
- Brancher un test de performance avec 100 000 comptes générés.
- **Stack « mainframe »** : IDE web (`code-server`), **Hercules** + **JCL** / **TK4-**, **Db2**, CICS — voir [README](README.md) section 5 et le dossier [stack/](stack/README.md).
