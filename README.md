# cobol-emul — Environnement d'apprentissage COBOL

Conteneur Docker prêt à l'emploi (Debian + **GnuCOBOL** en mode **Micro Focus / IBM**) accompagné d'un **mini-projet bancaire** complet pour reprendre la main sur COBOL : fichiers indexés ISAM, copybooks, sous-programmes (CALL), Makefile, debugger gdb, tests unitaires.

Une **stack étendue** (IDE web, émulateur **Hercules** / perspective **JCL**+**TK4-**, **IBM Db2**, notes **CICS** / **OpenCobolIDE**) est décrite **section 5** et dans le dossier [`stack/`](stack/README.md).

**Cursor / agent** : règles projet dans [`.cursor/rules/`](.cursor/rules/), contexte agent [`AGENTS.md`](AGENTS.md). **Nouvelles fonctionnalités** : [`docs/GUIDE-EXTENSION.md`](docs/GUIDE-EXTENSION.md). **Backlog métier** banque + assurance : [`docs/BACKLOG-METIER.md`](docs/BACKLOG-METIER.md). **Cours guidé COBOL** : [`docs/COURS-COBOL.md`](docs/COURS-COBOL.md) + exemples [`exos/cours/`](exos/cours/).

---

## 1. Prérequis

- Docker + Docker Compose v2 (`docker compose ...`)
- Un éditeur (Cursor / VS Code)

Aucun outil COBOL à installer sur l'hôte : tout vit dans le conteneur, le code source est édité depuis l'hôte via un volume bind.

### Environnement Cursor / VS Code

Le dépôt inclut une config **éditeur** alignée sur la toolchain Docker :

| Élément | Rôle |
|---------|------|
| [`AGENTS.md`](AGENTS.md) | Instructions pour l’agent IA (validation, cartographie, règles). |
| [`.cursor/rules/*.mdc`](.cursor/rules/) | Règles **COBOL**, **copybooks**, **Docker/Make**, **tests**, **métier** banque/assurance. |
| [`.cursorignore`](.cursorignore) | Exclut `build/`, binaires et `data/*.dat` de l’index (moins de bruit). |
| [`.vscode/tasks.json`](.vscode/tasks.json) | **COBOL: make (Docker)** = `clean && make` ; **COBOL: make incrémental (Docker)** = `make` seul (plus rapide au quotidien) ; **test**, **make+test** ; raccourci build (**Ctrl+Shift+B** = tâche de build par défaut = clean+make). |
| [`.vscode/extensions.json`](.vscode/extensions.json) | Extensions suggérées : COBOL (Bitlang), Makefile Tools. |
| [`.vscode/settings.json`](.vscode/settings.json) | Associations `.cob`/`.cpy`, tabulation 7, règles colonne utiles COBOL. |

---

## 2. Démarrage rapide

```bash
docker compose build           # construit l'image (~1 min, une seule fois)
docker compose run --rm cobol  # ouvre un shell dans le conteneur
```

Une fois dans le conteneur (`root@.../workspace#`) :

```bash
make           # compile tout (modules + programmes + main)
make run       # lance le menu bancaire interactif
make test      # exécute les tests unitaires
make debug     # lance MAIN sous gdb
make clean     # nettoie build/
make reset     # supprime les fichiers de données data/*.dat
```

> Astuce : `make help` affiche la liste des cibles.

---

## 3. Arborescence

```
cobol-emul/
├── docker/                Dockerfile + entrypoint (+ docker/hercules pour profile hercules)
├── docker-compose.yml     Service principal cobol (GnuCOBOL + make)
├── docker-compose.stack.yml   Profiles optionnels : ide, hercules, db2
├── .env.stack.example     Variables pour la stack étendue (copier en .env.stack)
├── stack/                 Guides + hercules.cnf (JCL / TK4- / Hercules)
├── Makefile
├── src/
│   ├── copybooks/         Structures partagées (.cpy)
│   ├── modules/           Sous-programmes "techniques" : VALID, COMPTE-IO, TRANS-IO
│   └── programs/          Programmes applicatifs : MAIN + CREER/DEPOT/...
├── tests/                 TEST-*.cob + run-tests.sh
├── data/                  Fichiers indexés/séquentiels au runtime (auto-créé)
├── build/                 Binaires compilés (.so + executables) (auto-créé)
├── EXERCICES.md           10 exercices progressifs guidés
├── docs/
│   ├── COURS-COBOL.md       Cours complet (leçons 1–9 + exemples exos/cours/)
│   ├── GUIDE-EXTENSION.md Comment ajouter une fonctionnalité
│   └── BACKLOG-METIER.md  Idées banque + assurance à implémenter
├── exos/cours/              Programmes du cours + personnes.txt
│   └── tp/                  TP maintenance (bugs) + corriges/
├── .cursor/rules/         Règles Cursor (COBOL, Docker, tests, métier)
├── .cursorignore          Fichiers exclus de l’index Cursor
├── .vscode/               tasks, settings, extensions (COBOL + Makefile)
├── AGENTS.md              Instructions pour l’agent IA
└── README.md
```

---

## 4. Architecture du projet bancaire

```
              MAIN (menu)
                 │
       ┌─────────┼─────────┬─────────┬─────────┐
       ▼         ▼         ▼         ▼         ▼
     CREER    DEPOT    RETRAIT    SOLDE    LISTER  ...
       │         │         │         │         │
       └─────────┴─────────┼─────────┴─────────┘
                           ▼
              VALID    COMPTE-IO    TRANS-IO
                           │              │
                           ▼              ▼
                   data/COMPTES.dat   data/TRANS.dat
                   (indexed ISAM)     (line sequential)
```

- **Programmes applicatifs** = orchestrent l'IHM (DISPLAY/ACCEPT) et appellent les modules.
- **Modules techniques** = isolent les I/O et les règles transversales. C'est le pattern "data-access layer" en COBOL classique.
- **CALL "NOMPROG"** est dynamique : chaque module est compilé en `.so` et chargé via `COB_LIBRARY_PATH` (configuré par le Makefile).

---

## 5. Stack étendue (IDE web, Hercules/JCL, Db2, CICS)

Ces briques complètent l'environnement GnuCOBOL pour coller à un parcours **mainframe** ou **SQL embarqué**. Elles sont **optionnelles** : fichier compose dédié + profiles.

Vue d'ensemble : [`stack/README.md`](stack/README.md).

### 5.1 IDE web — code-server

Équivalent conteneurisé d'un VS Code dans le navigateur (édition du même dépôt que le service `cobol`).

```bash
cp .env.stack.example .env.stack
# Édite .env.stack : COBOL_EMUL_VSCODE_PASSWORD, etc.

docker compose -f docker-compose.yml -f docker-compose.stack.yml \
  --env-file .env.stack --profile ide up -d code-server
```

Ouvre `http://localhost:8443` (port modifiable via `COBOL_EMUL_CODE_PORT`). Installe une extension COBOL depuis le marketplace (ex. **COBOL Bitlang** / **Zowe** selon tes besoins).

### 5.2 OpenCobolIDE (poste de travail, hors Docker)

Éditeur graphique historique pour COBOL (GTK). Il vit **sur la machine hôte** : installe-le via le gestionnaire de paquets / Flatpak / [OpenCobolIDE sur Launchpad](https://launchpad.net/open-cobol-ide), et pointe le répertoire du projet monté depuis l'hôte (`cobol-emul/`). Il complète Cursor ou code-server ; ce n'est pas un service dans `docker-compose` car dépendant d'un affichage graphique local.

### 5.3 Hercules, JCL, distributions type TK4-

Le profile **`hercules`** fournit une image avec l'émulateur **S/390 Hercules** et le dossier monté `stack/hercules/` (`hercules.cnf` minimal avec device 3270 pour que l'émulateur démarre).

```bash
docker compose -f docker-compose.yml -f docker-compose.stack.yml \
  --profile hercules run --rm hercules
# Dans le shell :
hercules -f /config/hercules.cnf
```

Pour pratiquer le **JCL** et un **OS MVS**, ajoute les fichiers DASD d'une distribution (souvent **TK4- Turnkey**) et complète `hercules.cnf` selon la doc du pack. Détail : [`stack/hercules/README.md`](stack/hercules/README.md).

### 5.4 IBM Db2 Community (SQL embarqué COBOL)

Le profile **`db2`** lance `ibmcom/db2` (conteneur **privilégié**, ~4 Go RAM, premier démarrage long, **licence** IBM à accepter).

```bash
docker compose -f docker-compose.yml -f docker-compose.stack.yml \
  --env-file .env.stack --profile db2 up -d db2
```

Port SQL par défaut : **50000** (variable `COBOL_EMUL_DB2_PORT`). Pour du **COBOL + EXEC SQL**, il faut en général un **précompilateur Db2** et une chaîne de build adaptée : ce dépôt reste centré sur GnuCOBOL **sans** précompileur IBM ; le conteneur sert surtout à **disposer d'un Db2** pour tests JDBC/CLI ou pour une chaîne séparée (host ou IDE) si tu branches un compilateur compatible.

### 5.5 CICS

**CICS** (transactions 3270, linkage convention `CALL`, etc.) n'a pas d'équivalent léger en conteneur Docker prêt à l'emploi comme pour GnuCOBOL. Parcours typiques : environnement **IBM Z** (essai éducatif), **Micro Focus Enterprise Developer**, ou cours sur **IBM Z Xplore**. Ce dépôt documente l'emplacement dans la stack pour que tu saches où chercher après les fichiers indexés locaux.

---

## 6. Glossaire COBOL minimal

| Terme | Sens |
|---|---|
| `IDENTIFICATION DIVISION` | Métadonnées du programme (PROGRAM-ID...) |
| `ENVIRONMENT DIVISION` | Configuration : association de fichiers logiques à des chemins |
| `DATA DIVISION` | Déclaration des données (FILE/WORKING-STORAGE/LINKAGE) |
| `PROCEDURE DIVISION` | Le code exécutable |
| `PIC 9(8)` | Champ numérique 8 chiffres |
| `PIC X(40)` | Chaîne de 40 caractères |
| `PIC S9(11)V99 COMP-3` | Décimal signé packé (11 entiers + 2 décimales), format mainframe efficient |
| `01` / `05` | Niveaux : `01` racine, `05` enfant |
| `88` | Condition nommée (énumération) |
| `COPY xxx` | Inclusion d'un copybook (équivalent `#include`) |
| `CALL "NOMPROG" USING ...` | Appel de sous-programme |
| `EVALUATE` | Switch/case |
| `PERFORM ... UNTIL` | Boucle |
| `ORGANIZATION INDEXED` / `RECORD KEY` | Fichier ISAM avec clé primaire |
| `FILE STATUS` | Code retour standardisé des opérations I/O |

---

## 7. Workflow recommandé pour apprendre

1. Lis `EXERCICES.md` et fais les **10 exercices progressifs** dans l'ordre.
2. Reprends ensuite `src/programs/CREER.cob` et expérimente : ajoute un champ "email" au compte, propage-le dans le copybook, dans `COMPTE-IO`, dans `LISTER`.
3. Active la verbosité du compilateur : `make COBFLAGS='-free -std=mf -Wall -Wextra -debug'`.
4. Pour debugger un crash en runtime : `make debug` ou `cobc -free -std=mf -x -g -fdebugging-line src/programs/MAIN.cob -o build/MAIN && gdb build/MAIN`.

---

## 8. Conseil ergonomie / UX (apprentissage)

- **Garde un terminal côté hôte ouvert sur le conteneur** (`docker compose run --rm cobol`) et **un autre côté Cursor** pour éditer : tu reproduis le cycle `vim → cobc → run` sans rebuild d'image.
- Les fichiers `data/*.dat` sont **persistés sur l'hôte** grâce au volume bind : tu peux `make reset` pour repartir à zéro.

---

## 9. Validation après installation

- [ ] `docker compose build` se termine sans erreur.
- [ ] `docker compose run --rm cobol` affiche la bannière et un prompt bash.
- [ ] `make` produit `build/MAIN` et plusieurs `build/*.so`.
- [ ] `make test` affiche `Bilan : 2/2 programmes verts`.
- [ ] `make run` affiche le menu, l'option `1` permet de créer un compte, `4` de le consulter.
