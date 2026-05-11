#!/usr/bin/env bash
# =============================================================================
# Vérifie les exemples du cours (exos/cours/) et les TP + corrigés (exos/cours/tp/).
#
# Usage (recommandé, depuis la racine du dépôt) :
#   docker compose run --rm -T cobol bash scripts/verify-cours-tp.sh
#
# Si GnuCOBOL est installé localement :
#   bash scripts/verify-cours-tp.sh
#
# Exit : 0 si tout est vert, 1 dès qu'une étape échoue.
# =============================================================================

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

COB=(cobc -free -std=mf -Wall)
mkdir -p build data

# Douze lignes "100" pour les TP tableau (L4)
PRIMES_12="$(for _ in $(seq 1 12); do echo 100; done)"

TMPLOG=""
cleanup() { [[ -n "${TMPLOG}" && -f "${TMPLOG}" ]] && rm -f "${TMPLOG}"; }
trap cleanup EXIT

run_cob() { "${COB[@]}" "$@"; }

echo "=== Cours L01-L04 ==="
run_cob -x -o build/L01 exos/cours/01-HELLO.cob
./build/L01 | grep -q "Bonjour" && echo "  L01_OK"

run_cob -x -o build/L02 exos/cours/02-CALCUL.cob
printf '10\n3\n' | ./build/L02 | grep -q "Somme" && echo "  L02_OK"

run_cob -x -o build/L03 exos/cours/03-CLIENT-88.cob
printf 'TEST\n25\n1234.56\n' | ./build/L03 | grep -q "ADULTE" && echo "  L03_OK"

run_cob -x -o build/L04 exos/cours/04-TABLEAU.cob
./build/L04 | grep -q "Somme des carres" && echo "  L04_OK"

echo "=== Cours L05 (CALL dynamique) ==="
run_cob -m -o build/TVA-COURS.so exos/cours/05-TVA-CALC.cob
run_cob -x -o build/L05 exos/cours/05-MAIN-CALL.cob
printf '100\n20\n' | COB_LIBRARY_PATH=build ./build/L05 | grep -q "120.00" && echo "  L05_OK"

echo "=== Cours L06-L07 ==="
run_cob -x -o build/L06 exos/cours/06-FICHIER-SEQ.cob
./build/L06 | grep -q "Total lignes" && echo "  L06_OK"

rm -f data/COURS-PROD.dat
run_cob -x -o build/L07 exos/cours/07-FICHIER-INDEX.cob
TMPLOG="$(mktemp)"
./build/L07 >"${TMPLOG}" 2>&1
grep -q "30003" "${TMPLOG}" && echo "  L07_OK"

echo "=== Projet : make test ==="
make clean >/dev/null
make >/dev/null
make test

echo "=== TP corrigés L01-L04 ==="
run_cob -x -o build/T1c exos/cours/tp/corriges/L01-tp-bug-date.cob
./build/T1c | grep -qE 'Date \(AAAAMMJJ\) : [0-9]{8}' && echo "  TP1_CORR_OK"

run_cob -x -o build/T2c exos/cours/tp/corriges/L02-tp-bug-commission.cob
./build/T2c | grep -q "150.00" && echo "  TP2_CORR_OK"

run_cob -x -o build/T3c exos/cours/tp/corriges/L03-tp-bug-categorie.cob
printf '18\n' | ./build/T3c | grep -q "ADULTE" && echo "  TP3_CORR_OK"

run_cob -x -o build/T4c exos/cours/tp/corriges/L04-tp-bug-tableau.cob
echo "${PRIMES_12}" | ./build/T4c | grep -q "1200.00" && echo "  TP4_CORR_OK"

echo "=== TP versions bugguées (comportement attendu) ==="
run_cob -x -o build/T1b exos/cours/tp/L01-tp-bug-date.cob
./build/T1b >/dev/null && echo "  TP1_BUG_RUNS"

run_cob -x -o build/T2b exos/cours/tp/L02-tp-bug-commission.cob
./build/T2b | grep -q "15.00" && echo "  TP2_BUG_COMMISSION"

run_cob -x -o build/T3b exos/cours/tp/L03-tp-bug-categorie.cob
printf '18\n' | ./build/T3b | grep -q "SENIOR" && echo "  TP3_BUG_CATEGORIE"

run_cob -x -o build/T4b exos/cours/tp/L04-tp-bug-tableau.cob
echo "${PRIMES_12}" | ./build/T4b | grep -q "1100.00" && echo "  TP4_BUG_ONZE_PRIMES"

echo "=== TP L05 TVA ==="
run_cob -m -o build/TVA-CALC.so exos/cours/tp/L05-tp-bug-tva.cob
run_cob -x -o build/T5main exos/cours/tp/L05-tp-main-call.cob
out_bug="$(COB_LIBRARY_PATH=build ./build/T5main)"
echo "${out_bug}" | grep -q "140.00" && echo "  TP5_BUG_140"

run_cob -m -o build/TVA-CALC.so exos/cours/tp/corriges/L05-tp-bug-tva.cob
out_ok="$(COB_LIBRARY_PATH=build ./build/T5main)"
echo "${out_ok}" | grep -q "120.00" && echo "  TP5_CORR_120"

echo "=== TP L06 UNSTRING ==="
run_cob -x -o build/T6b exos/cours/tp/L06-tp-bug-unstring.cob
out6b="$(./build/T6b)"
echo "${out6b}" | grep -q ";42" && echo "  TP6_BUG_SYMPTOME"

run_cob -x -o build/T6c exos/cours/tp/corriges/L06-tp-bug-unstring.cob
./build/T6c | grep -q "DUPONT" && echo "  TP6_CORR_OK"

echo "=== TP L07 index (fichier data/COURS-PROD.dat) ==="
run_cob -x -o build/T7b exos/cours/tp/L07-tp-bug-index.cob
./build/T7b | grep -q "CODE=" && echo "  TP7_BUG_RUNS"

run_cob -x -o build/T7c exos/cours/tp/corriges/L07-tp-bug-index.cob
./build/T7c | grep -q "10001" && echo "  TP7_CORR_OK"

echo "=== Tous les contrôles cours + TP sont passés ==="
