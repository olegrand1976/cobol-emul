# Instructions agent — cobol-emul

Projet **COBOL** (GnuCOBOL, **`-free -std=mf`**) dans **Docker**. Application **banque** ; extensions **assurance** prévues dans [`docs/BACKLOG-METIER.md`](docs/BACKLOG-METIER.md).

## Périmètre assistant

| Priorité | Action |
|----------|--------|
| 1 | Respecter [`.cursor/rules/`](.cursor/rules/) : COBOL, copybooks, **docker-toolchain**, domaine banque/assurance, tests, Makefile. |
| 2 | Modifications **localisées** : `copybook → module I/O → programme → MAIN → tests`. |
| 3 | Valider avec **`docker compose run --rm cobol`** + `make` / `make test` (ne pas supposer `cobc` sur l’hôte). |

## Validation obligatoire après changement COBOL

```bash
docker compose run --rm cobol bash -lc 'make clean && make && make test'
```

## Cartographie des fichiers

| Sujet | Chemins |
|-------|---------|
| Menu & flux | `src/programs/MAIN.cob` |
| Comptes ISAM | `src/modules/COMPTE-IO.cob`, `src/copybooks/COMPTE.cpy`, `data/COMPTES.dat` |
| Journal TX | `src/modules/TRANS-IO.cob`, `src/copybooks/TRANSACT.cpy`, `data/TRANS.dat` |
| Retours / erreurs | `src/copybooks/CODES-ERR.cpy`, `src/modules/VALID.cob` |
| Opérations `CALL` | `src/copybooks/OPS.cpy` |
| Tests | `tests/TEST-*.cob`, `tests/run-tests.sh` |
| Infra | `Makefile`, `docker-compose.yml`, `docker/` |
| Cours COBOL | `docs/COURS-COBOL.md`, `exos/cours/*.cob` |
| Backlog & guide | `docs/BACKLOG-METIER.md`, `docs/GUIDE-EXTENSION.md` |
| Stack optionnelle | `docker-compose.stack.yml`, `stack/` |

## Règles Cursor (aperçu)

| Fichier | Portée |
|---------|--------|
| `cobol-gnucobol.mdc` | `*.cob` — CALL, `.so`, flags |
| `cobol-copybooks.mdc` | `*.cpy` |
| `domaine-banque-assurance.mdc` | Toujours — vocabulaire métier |
| `docker-toolchain.mdc` | Toujours — Docker / Make |
| `tests-cobol.mdc` | `tests/**/*.cob` |
| `makefile-ci.mdc` | `Makefile` |

L’index IA exclut les artefacts via [`.cursorignore`](.cursorignore) (`build/`, `*.so`, `data/*.dat`, …).

## VS Code / Cursor intégré

- **Tâches** : `Ctrl+Shift+B` → **COBOL: make (Docker)** (`clean && make`). Pour itérer vite : *Run Task* → **COBOL: make incrémental (Docker)** (`make` seul). Voir aussi **test** et **make + test** dans `.vscode/tasks.json`.
- **Extensions suggérées** : `.vscode/extensions.json` (COBOL Bitlang + outils Makefile).
- **Réglages** : `.vscode/settings.json` (association `.cob`/`.cpy`, tabulation 7).

## Métier

Règle **domaine-banque-assurance** : identifiants stables, montants `COMP-3`, liaisons banque↔assurance via `COMPTE-IO`/`VALID`. Pas d’UI type 5250 ; terminal uniquement.

## Ce que l’agent ne fait pas sans demande

- Ajouter des paquets non-Debian au `Dockerfile`.
- Refactor global hors besoin exprimé.
- Commiter `build/` ou secrets (`.env.stack`).
