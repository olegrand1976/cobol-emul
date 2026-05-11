# Cours COBOL — Parcours complet avec explications détaillées

Ce document accompagne le dépôt **cobol-emul** (GnuCOBOL en **format libre**, dialecte `**-std=mf`**, exécution dans **Docker**).

À la fin de **chaque leçon**, une section **« Travaux pratiques »** propose des **TP** avec **contexte métier** (banque / assurance), **résultat attendu** et **corrigé** (code ou fichiers dans `[exos/cours/tp/](../exos/cours/tp/)` et `[exos/cours/tp/corriges/](../exos/cours/tp/corriges/)`. Plusieurs TP sont des **maintenances** sur un programme **déjà faux** (bug **technique** ou **métier**) à diagnostiquer et corriger.

---

## Table des matières

1. [Contexte et environnement](#0-contexte-et-environnement)
2. [Anatomie d’un programme COBOL](#1-anatomie-dun-programme-cobol)
3. [Leçon 1 — Premier programme](#2-leçon-1--premier-programme-01-hellocob)
4. [Leçon 2 — Données et calculs](#3-leçon-2--données-et-calculs-02-calculcob)
5. [Leçon 3 — Structures, COMP-3 et niveaux 88](#4-leçon-3--structures-comp-3-et-niveaux-88-03-client-88cob)
6. [Leçon 4 — Tableaux et boucles](#5-leçon-4--tableaux-et-boucles-04-tableaucob)
7. [Leçon 5 — Sous-programme et CALL (partie A et B)](#6-leçon-5--sous-programme-et-call-partie-a-et-b)
8. [Leçon 6 — Fichier séquentiel](#7-leçon-6--fichier-séquentiel-06-fichier-seqcob)
9. [Leçon 7 — Fichier indexé (ISAM)](#8-leçon-7--fichier-indexé-isam-07-fichier-indexcob)
10. [Leçon 8 — Lire le projet bancaire du dépôt](#9-leçon-8--lire-le-projet-bancaire-du-dépôt)
11. [Leçon 9 — Vers la bancassurance (assurance)](#10-leçon-9--vers-la-bancassurance-assurance)
12. [Synthèse et poursuite](#11-synthèse-et-poursuite)
13. [Fichiers TP et corrigés (`exos/cours/tp/`)](#12-fichiers-tp-et-corrigés-exoscourstp)

---

## 0) Contexte et environnement

### Pourquoi COBOL ici ?

COBOL est un langage **orienté données** et **orienté fichiers**, historiquement utilisé en **banque** et **assurance**. Ce dépôt te donne :

- un **compilateur** moderne (**GnuCOBOL**) avec une option de dialecte proche **Micro Focus / IBM** (`-std=mf`) ;
- un **mini-projet** (`src/`) qui illustre **fichiers indexés**, **journal séquentiel**, **sous-programmes** (`CALL`) et **copybooks**.

### Où compiler et exécuter ?

Sur ta machine, la voie recommandée est le conteneur :

```bash
cd /chemin/vers/cobol-emul
docker compose run --rm cobol
```

Tu arrives dans `/workspace` : c’est le dossier du projet monté par Docker.

### Commandes de compilation (rappel)

- **Programme autonome** (un seul `.cob` → un exécutable) :
  ```bash
  cobc -free -std=mf -Wall -x -o build/NOM exos/cours/FICHIER.cob
  ./build/NOM
  ```
- **Sous-programme dynamique** (`.so` chargé au `CALL`) :
  ```bash
  cobc -free -std=mf -Wall -m -o build/MODULE.so exos/cours/MODULE.cob
  cobc -free -std=mf -Wall -x -o build/MAIN exos/cours/MAIN.cob
  COB_LIBRARY_PATH=build ./build/MAIN
  ```

`-free` : format **libre** (pas de marges « carte perforée »).  
`-Wall` : active des avertissements utiles.  
`-x` : produit un **exécutable**.  
`-m` : produit un **module** (`.so`) pour `CALL "..."`.

---

## 1) Anatomie d’un programme COBOL

Un programme COBOL classique comporte jusqu’à **quatre divisions** :


| Division           | Rôle                                                                                                           |
| ------------------ | -------------------------------------------------------------------------------------------------------------- |
| **IDENTIFICATION** | Identité du programme (`PROGRAM-ID`).                                                                          |
| **ENVIRONMENT**    | Fichiers physiques, associations (`SELECT ... ASSIGN TO`).                                                     |
| **DATA**           | Données : fichiers (`FILE SECTION`), mémoire (`WORKING-STORAGE`), paramètres (`LINKAGE` pour sous-programmes). |
| **PROCEDURE**      | Code exécutable : paragraphes, `PERFORM`, `IF`, `READ`, etc.                                                   |


**Remarque** : dans les petits exemples, certaines divisions peuvent être absentes si inutiles (ex. pas de fichier → pas d’`ENVIRONMENT`).

### Notions de données indispensables

- `**PIC`** (*Picture*) : décrit le **type** et la **taille** d’une donnée.
  - `PIC 9(n)` : numérique **décimal zoné** (souvent appelé *display*).
  - `PIC X(n)` : **caractères** (texte).
  - `PIC S9(n)V99` : numérique **signé** avec **partie décimale** (`V` = virgule **implicite**).
- `**COMP-3*`* (*packed decimal*) : nombre **compacté** en demi-octets ; très courant en mainframe pour les montants.
- **Niveaux** :
  - `01` : groupe racine (souvent une ligne de données ou un enregistrement logique).
  - `05`, `10`, … : sous-éléments.
- **Niveau `88*`* : condition nommée sur le niveau parent (équivalent pratique d’une énumération / jeu de valeurs).

### Entrées / sorties terminal

- `**DISPLAY**` : affiche sur la sortie standard (console).
- `**ACCEPT**` : lit depuis l’entrée standard (clavier dans un terminal interactif).
- `**WITH NO ADVANCING**` sur `DISPLAY` : évite le saut de ligne automatique après l’affichage (utile pour une invite).

### Fin de programme

- `**STOP RUN**` : termine **l’exécutable** (programme principal).
- `**GOBACK`** : termine un **sous-programme** et rend la main à l’appelant (usage courant avec `CALL`).

---

## 2) Leçon 1 — Premier programme (`01-HELLO.cob`)

### Objectif pédagogique

Montrer la **structure minimale** : un programme qui affiche du texte et se termine proprement.

### Fichier

`exos/cours/01-HELLO.cob`

### Explication ligne à ligne (idée)

- `**PROGRAM-ID. L01HELLO.`** : nom interne du programme. Avec GnuCOBOL, ce nom sert aussi souvent de nom de fichier exécutable logique.
- `**PROCEDURE DIVISION.**` : début du code.
- `**DISPLAY**` : écrit une ligne sur la console.
- `**STOP RUN.**` : arrête l’exécution du programme **principal**.

### Pourquoi il n’y a pas de `DATA DIVISION` ici ?

Parce qu’aucune donnée nommée n’est nécessaire : on affiche uniquement des **littéraux** (`"..."`).

### Compiler et exécuter

```bash
cobc -free -std=mf -Wall -x -o build/L01 exos/cours/01-HELLO.cob
./build/L01
```

### Exercice (extension libre)

Affiche aussi la date du jour avec :

```cobol
DISPLAY "Date AAAAMMJJ : " FUNCTION CURRENT-DATE(1:8).
```

### Travaux pratiques (fin de leçon 1)

#### TP L1.1 — Pied de page « relevé » avec date (maintenance + bug technique)

**Contexte métier** : en banque, un programme d’édition de **relevé** ou de **avis** affiche en pied de page la **date du jour** au format **AAAAMMJJ** (standard COBOL / fichiers plats).

**Mission** : corriger le programme de maintenance `exos/cours/tp/L01-tp-bug-date.cob` : la date affichée est **fausse** (sous-chaîne incorrecte sur `FUNCTION CURRENT-DATE`).

**Résultat attendu après correction** : une ligne du type (la valeur change chaque jour) :

```text
Date (AAAAMMJJ) : 20260511
```

(8 chiffres = date du jour réelle.)

**Corrigé** : fichier `exos/cours/tp/corriges/L01-tp-bug-date.cob` — remplacer `(9:8)` par `(1:8)` pour prendre les 8 premiers caractères de `CURRENT-DATE` (format `AAAAMMJJ` + heure + …).

```cobol
DISPLAY "Date (AAAAMMJJ) : " FUNCTION CURRENT-DATE(1:8).
```

**Compilation**

```bash
cobc -free -std=mf -Wall -x -o build/TP-L1-BUG exos/cours/tp/L01-tp-bug-date.cob && ./build/TP-L1-BUG
cobc -free -std=mf -Wall -x -o build/TP-L1-OK  exos/cours/tp/corriges/L01-tp-bug-date.cob && ./build/TP-L1-OK
```

#### TP L1.2 — Mini habillage « agence » (sans bug)

**Contexte métier** : afficher **nom d’agence** + **code pays** (fictif) sur deux lignes.

**Résultat attendu** : texte stable + date correcte (réutilise la règle du TP L1.1).

---

## 3) Leçon 2 — Données et calculs (`02-CALCUL.cob`)

### Objectif pédagogique

Introduire la `**DATA DIVISION` / `WORKING-STORAGE SECTION`**, la saisie `**ACCEPT**`, et les calculs avec `**COMPUTE**`.

### Fichier

`exos/cours/02-CALCUL.cob`

### Explication des zones mémoire

Les variables `WS-*` sont en `**WORKING-STORAGE**` : elles existent pendant toute l’exécution du programme.

- `PIC S9(5)V99` : jusqu’à 5 chiffres entiers + 2 décimales, avec signe.
- `PIC S9(6)V99` : résultat un peu plus large pour éviter un débordement sur la somme.

### `COMPUTE` et `ROUNDED`

`COMPUTE` exprime une formule mathématique lisible.  
`ROUNDED` applique une **règle d’arrondi** sur le résultat (important pour les moyennes et les montants).

### Piège fréquent

Si les `PIC` sont trop petits pour le résultat, tu peux avoir des **troncatures** ou des comportements inattendus : augmente la taille des cibles (`WS-SOMME`, etc.).

### Compiler et exécuter

```bash
cobc -free -std=mf -Wall -x -o build/L02 exos/cours/02-CALCUL.cob
./build/L02
```

### Exercice (extension libre)

Ajoute une remise de **12,5%** sur `WS-A` et affiche le montant remisé.

### Travaux pratiques (fin de leçon 2)

#### TP L2.1 — Commission conseiller (maintenance + bug métier)

**Contexte métier** : sur un **montant placé**, la banque prélève une **commission** pour le conseiller : **1,50 %** du montant (`WS-MONTANT = 10000`, `WS-TAUX-PCT = 1,50`).

**Formule correcte** : `commission = montant * (taux_pourcent / 100)`.

**Résultat attendu** : `150,00` (et non `15,00`).

**Fichier bugué** : `exos/cours/tp/L02-tp-bug-commission.cob` (division par **1000** au lieu de **100**).

**Corrigé** : `exos/cours/tp/corriges/L02-tp-bug-commission.cob`.

```bash
cobc -free -std=mf -Wall -x -o build/TP-L2-BUG exos/cours/tp/L02-tp-bug-commission.cob && ./build/TP-L2-BUG
cobc -free -std=mf -Wall -x -o build/TP-L2-OK  exos/cours/tp/corriges/L02-tp-bug-commission.cob && ./build/TP-L2-OK
```

#### TP L2.2 — Remise commerciale (évolution fonctionnelle)

**Contexte métier** : appliquer une **remise de 12,5 %** sur `WS-A` du programme `02-CALCUL.cob`, afficher **montant remisé** et **montant net**.

**Résultat attendu** (exemple `A=100`, `B=50`) : remise `12,50`, net sur A `87,50` (les autres résultats inchangés sauf si tu factorises l’affichage).

**Corrigé (principe)** : variables `WS-REMISE`, `WS-A-NET` en `PIC S9(5)V99`, puis :

```cobol
COMPUTE WS-REMISE ROUNDED = WS-A * 12.5 / 100
COMPUTE WS-A-NET  ROUNDED = WS-A - WS-REMISE
```

---

## 4) Leçon 3 — Structures, COMP-3 et niveaux 88 (`03-CLIENT-88.cob`)

### Objectif pédagogique

Comprendre :

- la **hiérarchie** (`01` → `05`) ;
- le stockage **COMP-3** pour un montant ;
- les **conditions nommées** (`88`) et un branchement `**EVALUATE`**.

### Fichier

`exos/cours/03-CLIENT-88.cob`

### Structure `01 W-CLIENT`

`W-CLIENT` est un **groupe** : une zone composée de sous-zones contiguës.

- `W-CLI-NOM` : texte.
- `W-CLI-AGE` : entier 3 chiffres.
- `W-CLI-SOLDE` : montant signé en `COMP-3`.

### Niveaux `88`

Sous `W-CLI-AGE`, les `88` définissent des **conditions** sur la valeur de l’âge :

- `W-CLI-MINEUR` est vrai si l’âge est entre 0 et 17.

**Intérêt** : le code métier devient lisible (`WHEN W-CLI-MINEUR`) au lieu de comparer explicitement des plages.

### `EVALUATE TRUE`

`EVALUATE TRUE` évalue des conditions booléennes dans l’ordre.  
Ici, on teste les `88` liées à l’âge.

### Zones d’affichage séparées (`W-AGE-AFF`, `W-SOLDE-AFF`)

On ne fait pas toujours `DISPLAY` direct d’un `COMP-3` brut : on **déplace** (`MOVE`) vers une zone avec `PIC` d’édition (ex. `Z` pour supprimer les zéros non significatifs, `-` pour le signe).

### Compiler et exécuter

```bash
cobc -free -std=mf -Wall -x -o build/L03 exos/cours/03-CLIENT-88.cob
./build/L03
```

### Exercice (extension libre)

Ajoute une catégorie `VIP` (ex. solde > 10000) avec un `88` ou une règle `IF` après l’`EVALUATE`.

### Travaux pratiques (fin de leçon 3)

#### TP L3.1 — Tarification assurance par âge (maintenance + bug métier)

**Contexte métier** : pour une **souscription**, l’âge détermine la **catégorie tarifaire** :

- **MINEUR** : moins de 18 ans ;
- **ADULTE** : de 18 à 64 ans inclus ;
- **SENIOR** : 65 ans et plus.

**Bug** : dans `exos/cours/tp/L03-tp-bug-categorie.cob`, la plage **adulte** commence à **19** ans : un assuré de **18 ans** est classé **SENIOR** → **prime fausse** (risque réglementaire / plainte client en vrai système).

**Résultat attendu** : saisie `18` → `ADULTE` ; `17` → `MINEUR` ; `65` → `SENIOR`.

**Corrigé** : `exos/cours/tp/corriges/L03-tp-bug-categorie.cob` (`WHEN 18 THRU 64`).

```bash
cobc -free -std=mf -Wall -x -o build/TP-L3-BUG exos/cours/tp/L03-tp-bug-categorie.cob
printf "18\n" | ./build/TP-L3-BUG
cobc -free -std=mf -Wall -x -o build/TP-L3-OK  exos/cours/tp/corriges/L03-tp-bug-categorie.cob
printf "18\n" | ./build/TP-L3-OK
```

#### TP L3.2 — Statut VIP patrimoine (évolution)

**Contexte métier** : afficher **VIP** si le solde `W-CLI-SOLDE` est **strictement supérieur à 10000**.

**Résultat attendu** : après l’`EVALUATE` sur l’âge, une ligne supplémentaire `Statut patrimoine : VIP` ou `STANDARD`.

---

## 5) Leçon 4 — Tableaux et boucles (`04-TABLEAU.cob`)

### Objectif pédagogique

Introduire :

- un **tableau COBOL** (`OCCURS`) ;
- une boucle `**PERFORM VARYING`**.

### Fichier

`exos/cours/04-TABLEAU.cob`

### `OCCURS`

`05 T-VALEUR OCCURS 10 TIMES` crée **10 cases** : `T-VALEUR(1)` … `T-VALEUR(10)`.

### `PERFORM VARYING`

Cette structure remplace une boucle `for` :

- `WS-I` varie de 1 à 10 ;
- à chaque itération, on calcule un carré et on l’accumule dans `WS-SOMME`.

### Compiler et exécuter

```bash
cobc -free -std=mf -Wall -x -o build/L04 exos/cours/04-TABLEAU.cob
./build/L04
```

### Exercice (extension libre)

Affiche aussi la **moyenne** des carrés (attention au `PIC` du résultat).

### Travaux pratiques (fin de leçon 4)

#### TP L4.1 — Total des 12 primes mensuelles (maintenance + bug technique)

**Contexte métier** : en **assurance vie**, les **cotisations mensuelles** sont enregistrées dans un tableau de **12** montants ; le batch doit afficher la **somme annuelle** exacte.

**Bug** : `exos/cours/tp/L04-tp-bug-tableau.cob` cumule seulement les indices **1 à 11** (`UNTIL WS-I > 11`).

**Résultat attendu** : si tu saisis douze fois `100`, le total affiché doit être `**1200,00`** (et non `1100,00`).

**Corrigé** : `exos/cours/tp/corriges/L04-tp-bug-tableau.cob` — boucle `UNTIL WS-I > 12`.

```bash
cobc -free -std=mf -Wall -x -o build/TP-L4-BUG exos/cours/tp/L04-tp-bug-tableau.cob
# puis saisir 12 fois 100...
cobc -free -std=mf -Wall -x -o build/TP-L4-OK  exos/cours/tp/corriges/L04-tp-bug-tableau.cob
```

#### TP L4.2 — Moyenne des carrés (sans fichier bug)

**Contexte métier** : indicateur statistique sur une série (carrés 1..10).

**Résultat attendu** : à partir du programme `04-TABLEAU.cob`, afficher la moyenne des `T-VALEUR(i)` avec **2 décimales** (`ROUNDED`).

**Corrigé (principe)** : après la boucle de cumul, `COMPUTE WS-MOY ROUNDED = WS-SOMME / 10` avec `WS-MOY PIC S9(6)V99` adapté.

---

## 6) Leçon 5 — Sous-programme et CALL (partie A et B)

Cette leçon est en **deux fichiers** : un **module** appelé et un **programme principal** appelant.

### Objectif pédagogique

Comprendre :

- la `**LINKAGE SECTION`** (contrat de paramètres) ;
- le `**PROCEDURE DIVISION USING ...**` ;
- le `**CALL "NAME"**` et le chargement dynamique `**.so**` (`-m`).

### Fichiers

- `exos/cours/05-TVA-CALC.cob` — sous-programme `TVA-CALC`
- `exos/cours/05-MAIN-CALL.cob` — programme `L05MAINCALL`

### Partie A — `TVA-CALC` (le sous-programme)

Points clés :

- `**PROGRAM-ID. TVA-CALC.**` : le nom utilisé par `CALL "TVA-CALC"` doit être cohérent avec le fichier module généré (`TVA-CALC.so`).
- `**LINKAGE SECTION**` : décrit les **paramètres** attendus exactement dans l’ordre du `USING`.
- `**GOBACK.`** : retourne à l’appelant après le calcul.

Formule utilisée :


TTC = HT + HT \times \frac{taux}{100}


### Partie B — `L05MAINCALL` (l’appelant)

- Déclare des zones locales (`WS-HT`, `WS-TAUX`, `WS-TTC`).
- `CALL "TVA-CALC" USING WS-HT WS-TAUX WS-TTC` : passe **adresses** de zones ; le sous-programme **écrit** dans `WS-TTC`.

### Chaîne de compilation

```bash
cobc -free -std=mf -Wall -m -o build/TVA-CALC.so exos/cours/05-TVA-CALC.cob
cobc -free -std=mf -Wall -x -o build/L05 exos/cours/05-MAIN-CALL.cob
COB_LIBRARY_PATH=build ./build/L05
```

### Piège fréquent (déjà vu dans le projet réel)

Avec GnuCOBOL, les tailles des paramètres `USING` doivent **correspondre** à celles du `LINKAGE` : ne pas passer un littéral trop court à la place d’une zone `PIC X(12)` (d’où le copybook `OPS.cpy` dans `src/`).

### Exercice (extension libre)

Ajoute un second calcul (ex. taux **5,5%**) en relançant `CALL` avec un autre `WS-TAUX`.

### Travaux pratiques (fin de leçon 5)

#### TP L5.1 — Module TVA en double (maintenance + bug métier)

**Contexte métier** : le **TTC** doit être `HT + TVA` une seule fois (`TVA = HT * taux/100`).

**Bug** : `exos/cours/tp/L05-tp-bug-tva.cob` ajoute **deux fois** la part TVA dans `COMPUTE`.

**Résultat attendu** : avec `WS-HT = 100` et `WS-TAUX = 20`, le TTC doit être `**120,00`** (et non `140,00`).

**Procédure** :

```bash
cobc -free -std=mf -Wall -m -o build/TVA-CALC.so exos/cours/tp/L05-tp-bug-tva.cob
cobc -free -std=mf -Wall -x -o build/TP-L5-MAIN exos/cours/tp/L05-tp-main-call.cob
COB_LIBRARY_PATH=build ./build/TP-L5-MAIN
```

Puis recompiler le **corrigé** `exos/cours/tp/corriges/L05-tp-bug-tva.cob` **en écrasant** `build/TVA-CALC.so` et relancer le même main.

#### TP L5.2 — Deux taux sur un même dossier (évolution)

**Contexte métier** : afficher TTC pour **20 %** puis pour **5,5 %** sur le même HT (deux `CALL` successifs).

**Résultat attendu** : pour `HT=200` → `240,00` puis `211,00` (selon arrondis `ROUNDED`).

---

## 7) Leçon 6 — Fichier séquentiel (`06-FICHIER-SEQ.cob`)

### Objectif pédagogique

Comprendre la lecture **ligne à ligne** d’un fichier texte (**LINE SEQUENTIAL**), la boucle `READ ... AT END`, et le découpage simple avec `**UNSTRING`**.

### Fichier données

`exos/cours/personnes.txt` : chaque ligne `NOM;AGE`.

### Fichier programme

`exos/cours/06-FICHIER-SEQ.cob`

### Explication du flux

1. `SELECT ... ASSIGN TO "exos/cours/personnes.txt"` : lie le fichier logique au chemin dans le workspace Docker.
2. `OPEN INPUT` : ouvre en lecture.
3. Boucle `PERFORM UNTIL FIN-FICHIER` :
  - `READ F-IN` lit une ligne dans `F-LIGNE` ;
  - `AT END` : fin de fichier → on lève un indicateur `FIN-FICHIER` ;
  - sinon : `UNSTRING ... DELIMITED BY ';'` remplit `WS-NOM` et `WS-AGE`.
4. `CLOSE F-IN`.

### Pourquoi un indicateur `FIN-FICHIER` ?

Parce que `FILE STATUS` reste souvent à `'00'` sur une lecture réussie : **on ne peut pas** se baser uniquement sur `WS-FS != '00'` pour détecter la fin de fichier après une lecture OK.

### Compiler et exécuter

```bash
cobc -free -std=mf -Wall -x -o build/L06 exos/cours/06-FICHIER-SEQ.cob
./build/L06
```

### Exercice (extension libre)

Ajoute une validation : si `WS-AGE` est `0`, n’affiche pas la ligne (ou affiche un avertissement).

### Travaux pratiques (fin de leçon 6)

#### TP L6.1 — Import prospects : mauvais séparateur (maintenance + bug technique)

**Contexte métier** : import d’un fichier **prospects** banque (`NOM;AGE`) comme `personnes.txt`.

**Bug** : `exos/cours/tp/L06-tp-bug-unstring.cob` utilise `DELIMITED BY ','` alors que le fichier utilise **`;`**.

**Symptôme avant correction** : sans virgule dans la ligne, l’`UNSTRING` déverse souvent **toute la chaîne** dans le premier champ (on voit encore le nom mais avec le suffixe `;42`, etc.) et l’**âge reste vide** (le second champ ne reçoit rien d’exploitable).

**Résultat attendu après correction** : trois lignes lisibles du type :

```text
LU : [DUPONT JEAN                    ] age=042
```

**Corrigé** : `exos/cours/tp/corriges/L06-tp-bug-unstring.cob`.

```bash
cobc -free -std=mf -Wall -x -o build/TP-L6-BUG exos/cours/tp/L06-tp-bug-unstring.cob && ./build/TP-L6-BUG
cobc -free -std=mf -Wall -x -o build/TP-L6-OK  exos/cours/tp/corriges/L06-tp-bug-unstring.cob && ./build/TP-L6-OK
```

#### TP L6.2 — Contrôle métier « âge zéro » (évolution)

**Contexte métier** : une ligne avec **âge = 0** est **invalide** (donnée manquante).

**Résultat attendu** : message `AGE INVALIDE - ligne ignoree` et **pas** d’affichage `LU :` pour cette ligne.

**Corrigé (principe)** : après `UNSTRING`, `IF WS-AGE = 0 THEN` … `ELSE DISPLAY …`.

---

## 8) Leçon 7 — Fichier indexé (ISAM) (`07-FICHIER-INDEX.cob`)

### Objectif pédagogique

Introduire le fichier **INDEXED** :

- une **clé primaire** (`RECORD KEY`) ;
- `WRITE` pour insérer ;
- `READ` pour lire par clé ;
- `START` + `READ NEXT` pour un **parcours ordonné** par clé.

### Fichier programme

`exos/cours/07-FICHIER-INDEX.cob`

### Fichier physique

`data/COURS-PROD.dat` (créé au runtime ; le dossier `data/` est ignoré par git dans ce dépôt).

### Création du fichier si absent

Le programme fait :

1. `OPEN I-O` ;
2. si `FILE STATUS = '35'` (fichier inexistant), `OPEN OUTPUT` puis `CLOSE` puis `OPEN I-O` : c’est le même principe que `COMPTE-IO` dans `src/modules/COMPTE-IO.cob`.

### Insertion « hors ordre »

Les codes `30003`, `10001`, `20002` sont insérés volontairement dans un ordre quelconque : le parcours séquentiel montre que le **moteur d’index** restitue les enregistrements **triés par clé**.

### Compiler et exécuter

```bash
mkdir -p data
rm -f data/COURS-PROD.dat
cobc -free -std=mf -Wall -x -o build/L07 exos/cours/07-FICHIER-INDEX.cob
./build/L07
```

**Astuce scripts** : évite `./build/L07 | grep -q "30003"` pour des tests automatisés. `grep -q` peut **fermer le tube** dès la première occurrence alors que le programme continue d’écrire → message `broken pipe` côté COBOL (comportement normal du shell, pas une erreur métier). Préfère par exemple `./build/L07 > /tmp/l07.txt && grep -q "30003" /tmp/l07.txt`.

### Exercice (extension libre)

Ajoute un `READ` sur une clé inexistante et affiche un message propre (`INVALID KEY`).

### Travaux pratiques (fin de leçon 7)

#### TP L7.1 — Inventaire sans `START` (maintenance + bug technique)

**Contexte métier** : **édition d’inventaire** des produits assurance enregistrés dans `data/COURS-PROD.dat` (créé par la leçon 7).

**Bug** : `exos/cours/tp/L07-tp-bug-index.cob` enchaîne des `READ NEXT` **sans** `START` positionné → parcours **incorrect** ou **imprévisible** selon l’état du fichier.

**Prérequis** : avoir généré le fichier une fois :

```bash
mkdir -p data && rm -f data/COURS-PROD.dat
cobc -free -std=mf -Wall -x -o build/L07 exos/cours/07-FICHIER-INDEX.cob && ./build/L07
```

**Résultat attendu après correction** : liste **triée par code** `10001`, `20002`, `30003` (comme la leçon 7).

**Corrigé** : `exos/cours/tp/corriges/L07-tp-bug-index.cob` (`START F-PR KEY >= F-P-CODE` avec `F-P-CODE` à zéro avant la boucle).

```bash
cobc -free -std=mf -Wall -x -o build/TP-L7-BUG exos/cours/tp/L07-tp-bug-index.cob && ./build/TP-L7-BUG
cobc -free -std=mf -Wall -x -o build/TP-L7-OK  exos/cours/tp/corriges/L07-tp-bug-index.cob && ./build/TP-L7-OK
```

#### TP L7.2 — Clé produit inexistante (évolution)

**Contexte métier** : recherche d’un produit **99999** absent du fichier.

**Résultat attendu** : message clair `Produit introuvable` via branche `INVALID KEY` sur `READ`.

**Corrigé (principe)** :

```cobol
MOVE 99999 TO F-P-CODE
READ F-PR
    INVALID KEY
        DISPLAY "Produit introuvable"
    NOT INVALID KEY
        DISPLAY F-P-CODE " " F-P-LIB
END-READ
```

---

## 9) Leçon 8 — Lire le projet bancaire du dépôt

### Objectif pédagogique

Passer du **petit exemple** au **projet réel** : voir comment les notions précédentes se combinent.

### Ordre de lecture recommandé

1. `**src/programs/MAIN.cob`** : menu, `EVALUATE`, `CALL` dynamique des traitements.
2. `**src/programs/CREER.cob**` : saisie + validations + insertion.
3. `**src/modules/VALID.cob**` : validations factorisées (sous-programme).
4. `**src/modules/COMPTE-IO.cob**` : fichier **indexé** `data/COMPTES.dat`.
5. `**src/modules/TRANS-IO.cob`** : fichier **séquentiel** `data/TRANS.dat`.
6. **Copybooks** dans `src/copybooks/` (`COMPTE`, `TRANSACT`, `CODES-ERR`, `OPS`).

### Compiler tout le projet

Dans le conteneur :

```bash
make clean && make
make test
make run
```

### Ce que tu dois observer

- Les **montants** sont en `**COMP-3`** dans `COMPTE.cpy` / `TRANSACT.cpy`.
- Les **codes retour** `W-CODE-RETOUR` standardisent les erreurs (`CODES-ERR.cpy`).
- Les `CALL` utilisent `**WS-OP`** (`OPS.cpy`) pour respecter la taille `PIC X(12)` attendue par les modules.

### Travaux pratiques (fin de leçon 8)

#### TP L8.1 — Maintenance « découvert » sur retrait (bug métier dans le vrai projet)

**Contexte métier** : dans `src/programs/RETRAIT.cob`, la règle actuelle **interdit tout solde négatif** (`WS-MONTANT > W-CPT-SOLDE`). Une évolution produit autorise un **découvert autorisé** de **50 €** pour les comptes **actifs** uniquement.

**Mission** : introduire une variable `WS-DECOUVERT-AUTORISE` avec valeur **50,00** (`COMP-3`) et remplacer le test par :

- refus si `W-CPT-SOLDE - WS-MONTANT < (0 - WS-DECOUVERT-AUTORISE)` pour un compte actif ;
- conserver le refus total si compte non actif.

**Résultat attendu** (jeux de test manuels après `make run`) :


| Solde | Retrait | Avant correctif | Après correctif                |
| ----- | ------- | --------------- | ------------------------------ |
| 100   | 120     | refus           | **autorisé** (solde -20 ≥ -50) |
| 100   | 160     | refus           | **refus** (solde -60 < -50)    |


**Corrigé (extrait à intégrer)** :

```cobol
       01 WS-DECOUVERT-AUTORISE PIC S9(11)V99 COMP-3 VALUE 50.00.
      *> ...
           IF (W-CPT-SOLDE - WS-MONTANT) < (0 - WS-DECOUVERT-AUTORISE)
               DISPLAY "Refuse : decouvert max depasse."
               EXIT PROGRAM
           END-IF
```

*(Tu remplaces l’ancien test `WS-MONTANT > W-CPT-SOLDE` pour les comptes actifs.)*

#### TP L8.2 — Bug technique `CALL "VALID"` (paramètres trop courts)

**Contexte métier** : un développeur écrit `CALL "VALID" USING "NUMERO" ...` avec un littéral `"NUMERO"` (7 caractères) au lieu de `WS-OP` (`PIC X(12)`).

**Symptôme** : plantage runtime GnuCOBOL (`LINKAGE item ... too small in the caller`).

**Corrigé** : toujours `MOVE "NUMERO" TO WS-OP` puis `CALL "VALID" USING WS-OP ...` (comme dans `CREER.cob` / `DEPOT.cob`).

---

## 10) Leçon 9 — Vers la bancassurance (assurance)

### Objectif pédagogique

Comprendre **comment prolonger** le même style d’architecture pour l’**assurance**, sans tout réécrire.

### Rappels métier (simples)

- Une **police** a un identifiant stable, un statut (`88`), une prime, etc.
- Un **sinistre** référence une police et un montant.
- Un **lien banque → assurance** (prélèvement / indemnisation) doit **valider le compte** via `VALID` + `COMPTE-IO` avant mouvement.

### Piste d’implémentation (alignée sur ce dépôt)

1. Ajouter `POLICE.cpy` puis `POLICE-IO.cob` (fichier indexé `data/POLICES.dat`).
2. Ajouter `SOUSCRIT.cob` + entrée de menu dans `MAIN.cob`.
3. Récupérer un **numéro de compte** optionnel et vérifier son existence (`COMPTE-IO` + `READ`).

Le backlog d’idées est déjà listé dans `docs/BACKLOG-METIER.md`.

### Travaux pratiques (fin de leçon 9)

#### TP L9.1 — Modèle police + prélèvement (conception, sans tout coder)

**Contexte métier** : une **police d’assurance** a un **numéro stable** (`PIC 9(10)`), une **prime annuelle** (`COMP-3`), un **statut** (`A` active, `R` résiliée) et un **compte bancaire optionnel** (`PIC 9(8)`) pour le prélèvement.

**Mission** : rédiger sur papier ou en commentaires COBOL :

1. le `01 W-POLICE` (copybook fictif) ;
2. la séquence **valider compte** (`VALID` + `COMPTE-IO` `READ`) si le numéro de compte est **non zéro** ;
3. le message d’erreur si compte **inexistant** ou **non actif**.

**Résultat attendu** : un schéma texte (pseudo-code) sans erreur de logique ; implémentation réelle = entrée `A1` du backlog.

#### TP L9.2 — Bug métier « prime sur police résiliée » (maintenance à détecter)

**Scénario** : un batch `EMIT-PRIME` (futur) prélève une prime même si `POL-STATUT = 'R'`.

**Résultat attendu** : refus avec code retour métier dédié (ex. `RC-ERR-CLOTURE` ou nouveau `88`).

**Corrigé (principe)** :

```cobol
       IF POL-RESILIEE
           MOVE '31' TO W-CODE-RETOUR
           EXIT PROGRAM
       END-IF
```

*(À relier à ton futur copybook `POLICE.cpy`.)*

---

## 11) Synthèse et poursuite

### Ce que tu maîtrises après ce parcours

- Divisions et structure d’un programme.
- Données : `PIC`, groupes, `88`, `COMP-3`.
- Contrôle de flux : `EVALUATE`, `PERFORM`.
- Modularisation : `CALL`, `LINKAGE`, `GOBACK`.
- Fichiers : **séquentiel** et **indexé** (bases).

### Poursuite recommandée

- `EXERCICES.md` : exercices guidés plus poussés.
- `docs/GUIDE-EXTENSION.md` : méthode pour ajouter une fonctionnalité proprement.
- `docs/BACKLOG-METIER.md` : scénarios banque + assurance à coder.

### Aide-mémoire compilation (toutes les leçons avec binaires)

```bash
cobc -free -std=mf -Wall -x -o build/L01 exos/cours/01-HELLO.cob
cobc -free -std=mf -Wall -x -o build/L02 exos/cours/02-CALCUL.cob
cobc -free -std=mf -Wall -x -o build/L03 exos/cours/03-CLIENT-88.cob
cobc -free -std=mf -Wall -x -o build/L04 exos/cours/04-TABLEAU.cob
cobc -free -std=mf -Wall -m -o build/TVA-CALC.so exos/cours/05-TVA-CALC.cob
cobc -free -std=mf -Wall -x -o build/L05 exos/cours/05-MAIN-CALL.cob
cobc -free -std=mf -Wall -x -o build/L06 exos/cours/06-FICHIER-SEQ.cob
mkdir -p data && rm -f data/COURS-PROD.dat
cobc -free -std=mf -Wall -x -o build/L07 exos/cours/07-FICHIER-INDEX.cob
```

Puis :

```bash
./build/L01
COB_LIBRARY_PATH=build ./build/L05
./build/L06
./build/L07
```

---

## 12) Fichiers TP et corrigés (`exos/cours/tp/`)


| Fichier bug                                         | Corrigé                                 | Leçon |
| --------------------------------------------------- | --------------------------------------- | ----- |
| `tp/L01-tp-bug-date.cob`                            | `tp/corriges/L01-tp-bug-date.cob`       | 1     |
| `tp/L02-tp-bug-commission.cob`                      | `tp/corriges/L02-tp-bug-commission.cob` | 2     |
| `tp/L03-tp-bug-categorie.cob`                       | `tp/corriges/L03-tp-bug-categorie.cob`  | 3     |
| `tp/L04-tp-bug-tableau.cob`                         | `tp/corriges/L04-tp-bug-tableau.cob`    | 4     |
| `tp/L05-tp-bug-tva.cob` + `tp/L05-tp-main-call.cob` | `tp/corriges/L05-tp-bug-tva.cob`        | 5     |
| `tp/L06-tp-bug-unstring.cob`                        | `tp/corriges/L06-tp-bug-unstring.cob`   | 6     |
| `tp/L07-tp-bug-index.cob`                           | `tp/corriges/L07-tp-bug-index.cob`      | 7     |


Index local : `[exos/cours/tp/README.md](../exos/cours/tp/README.md)`.

---

## Annexe — Erreurs fréquentes GnuCOBOL (débutant)

- **Oubli de `-free`** alors que le source est en format libre : erreurs de compilation.
- `**CALL` introuvable** : oublier `COB_LIBRARY_PATH=build` ou oublier de compiler le `.so` avec `-m`.
- **Mauvais ordre `USING`** : les paramètres doivent correspondre exactement au `LINKAGE`.
- **Fichier indexé déjà rempli** : un second `WRITE` sur la même clé peut déclencher `INVALID KEY` ; supprime le fichier de test avant de rejouer un script de démo.

