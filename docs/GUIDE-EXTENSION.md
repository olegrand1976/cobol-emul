# Guide — ajouter une fonctionnalité

## 1. Classifier la fonctionnalité

| Type | Où agir |
|------|---------|
| Nouveau champ sur un enregistrement existant | `src/copybooks/*.cpy` puis `COMPTE-IO.cob` (taille enregistrement) ou équivalent |
| Nouveau fichier métier | Nouveau copybook + module `src/modules/*-IO.cob` + `data/xxx.dat` |
| Nouvel écran / use case | `src/programs/MONPRG.cob` + entrée dans `MAIN.cob` |
| Règle de validation transverse | `VALID.cob` + `CODES-ERR.cpy` si nouveaux codes |

## 2. Ordre de mise en œuvre recommandé

1. **Copybook** (structures `01`, montants `COMP-3`, `88` pour statuts).
2. **Accès données** : soit étendre un module existant, soit créer `FOO-IO.cob` avec les mêmes patterns que `COMPTE-IO` (`OPEN-IO`, `READ`, `WRITE`… + `OPS` pour les appels).
3. **Programme** : `PROGRAM-ID` = nom du fichier (sans extension) = nom du `.so` produit.
4. **Menu** : dans `MAIN.cob`, nouveau `DISPLAY`, nouveau `WHEN` dans `EVALUATE`, `CALL "MONPRG"`.
5. **Makefile** : aucun changement si le fichier est sous `src/programs/*.cob` ou `src/modules/*.cob` (déjà couverts).
6. **Tests** : `tests/TEST-*.cob` pour la logique nouvelle ; étendre `run-tests.sh` seulement si besoin de données spéciales.
7. **Validation** : `make clean && make && make test` puis `make run`.

## 3. Rappels techniques

- **`CALL "XYZ" USING ...`** : tailles des paramètres **identiques** côté appelant et `LINKAGE` du sous-programme ; utiliser **`COPY OPS`** pour l’opération texte.
- **`COB_LIBRARY_PATH`** : exporté par le `Makefile` vers `build/` — lancer les binaires via `make run` ou préfixer manuellement.
- Données persistantes : répertoire `data/` (volume Docker) ; `make reset` pour effacer banque uniquement — ajouter d’autres `rm` dans `reset` si nouveaux fichiers.

## 4. Périmètre métier

Pour des idées de fonctions banque/assurance priorisées, voir [`BACKLOG-METIER.md`](BACKLOG-METIER.md).
