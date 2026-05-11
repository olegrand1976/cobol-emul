# Travaux pratiques (TP) — maintenance avec bugs

Chaque fichier `L*-tp-bug*.cob` contient un **bug intentionnel** (commentaire `*> BUG` ou description en tête).

Les **corrigés** sont dans `corriges/` (même base de noms).

Compilation (dans le conteneur `docker compose run --rm cobol`) :

```bash
# Exemple L1
cobc -free -std=mf -Wall -x -o build/TP1 exos/cours/tp/L01-tp-bug-date.cob && ./build/TP1
cobc -free -std=mf -Wall -x -o build/TP1C exos/cours/tp/corriges/L01-tp-bug-date.cob && ./build/TP1C
```

Le détail des énoncés, résultats attendus et interprétation métier est dans [`docs/COURS-COBOL.md`](../../docs/COURS-COBOL.md) (section TP de chaque leçon).
