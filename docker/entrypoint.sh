#!/usr/bin/env bash
set -e

cat <<'BANNER'
============================================================
  Environnement d'apprentissage COBOL (GnuCOBOL / dialecte MF)
============================================================
  Compilateur :  cobc -free -std=mf -Wall
  Workspace   :  /workspace
  Commandes   :  make all | make run | make test | make debug
  Aide        :  cat README.md  ou  cat EXERCICES.md
============================================================
BANNER

cobc --version | head -n 1 || true
echo

exec "$@"
