# Sécurité — cobol-emul

## Secrets et configuration

- Le fichier **`.env.stack`** est listé dans **`.gitignore`** : il peut contenir mots de passe et paramètres locaux. **Ne le commite jamais** (ni aucune variante `.env` avec secrets).
- **`.env.stack.example`** ne doit contenir **aucun mot de passe** ni valeur ressemblant à un secret réel : il sert uniquement de modèle pour les variables non sensibles (ports, tags d’image).
- Les valeurs par défaut dans **`docker-compose.stack.yml`** (`changeme`, `db2changeme`) sont **explicitement réservées au développement local**. Avant toute exposition sur un réseau (LAN, Internet, VM partagée), définis **`COBOL_EMUL_VSCODE_PASSWORD`** et **`COBOL_EMUL_DB2_PASSWORD`** dans `.env.stack` avec des secrets forts et uniques.

## Signalement de vulnérabilité

Si tu identifies une faille de sécurité liée à ce dépôt (fuite de credentials, configuration dangereuse par défaut, etc.), ouvre une issue **privée** sur le dépôt GitHub du projet ou contacte les mainteneurs selon la politique du compte organisation.

## Surface d’attaque volontaire (stack optionnelle)

Le profile **Db2** utilise un conteneur **privilégié** ; le profile **IDE** expose un serveur web. Réserve ces services à des environnements de confiance (machine locale, réseau isolé) et mets à jour les images régulièrement.
