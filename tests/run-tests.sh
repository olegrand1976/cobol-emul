#!/usr/bin/env bash
# Lance tous les programmes TEST-*.cob compiles dans build/
# Sortie : exit 0 si tous verts, 1 sinon.

set -u

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
BUILD="$ROOT/build"
DATA="$ROOT/data"

export COB_LIBRARY_PATH="$BUILD"
export COB_RUNTIME_CONFIG=""
cd "$ROOT"

TOTAL=0
FAILED=0

# Fichier de test isole pour COMPTE-IO
mkdir -p "$DATA"
rm -f "$DATA/COMPTES.dat"

echo "------------------------------------------------------------"
echo " Lancement des tests unitaires COBOL"
echo "------------------------------------------------------------"

for bin in "$BUILD"/TEST-*; do
    [ -x "$bin" ] || continue
    name="$(basename "$bin")"
    echo
    echo ">>> $name"
    if "$bin"; then
        :
    else
        FAILED=$((FAILED + 1))
        echo "<<< $name : ECHEC"
    fi
    TOTAL=$((TOTAL + 1))
done

echo
echo "------------------------------------------------------------"
echo " Bilan : $((TOTAL - FAILED))/$TOTAL programmes verts"
echo "------------------------------------------------------------"

if [ "$FAILED" -ne 0 ]; then
    exit 1
fi
exit 0
