# Hercules — mainframe S/390 et JCL

Ce dossier est monté dans le conteneur `hercules` (`/config`) défini dans `docker-compose.stack.yml`.

## Démarrage

```bash
docker compose -f docker-compose.yml -f docker-compose.stack.yml --profile hercules run --rm hercules
hercules -f /config/hercules.cnf
```

Le fichier `hercules.cnf` fourni démarre Hercules avec un **device 3270** (console). Pour un **OS MVS** et du **JCL** réels, il faut ajouter des volumes **DASD** et une distribution prête à l’emploi.

## TK4- / MVS Turnkey

- Projet **TK4-** (« Turn Key ») : distribution MVS sous Hercules très utilisée en auto-formation (soumissions JCL, TSO, etc.).
- Télécharge l’archive officielle, extrais les fichiers `.ckd` / `.dasd`, puis référence-les dans `hercules.cnf` (adresses 3390 comme dans la doc du pack).

## JCL

- Sur z/OS ou MVS émulé, les jobs sont soumis via **JCL** (`//JOB`, `//EXEC`, `//DD`).
- Le projet **GnuCOBOL** du répertoire racine n’utilise pas JCL : il compile avec `cobc`. Le lien se fait **par l’émulation** une fois l’OS chargé.

## Ressources

- [Hercules — installation](https://hercules-390.github.io/)
- Recherche web : `TK4 Turnkey MVS Hercules` pour guides pas à pas à jour.
