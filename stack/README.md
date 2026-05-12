# Stack étendue — hors scope du cœur GnuCOBOL

Le dépôt se centre sur **GnuCOBOL** + fichiers **ISAM** dans Docker (`docker-compose.yml`). Les briques ci-dessous étaient « hors scope » du plan initial : elles sont **optionnelles**, activables par **profiles** (`docker-compose.stack.yml`).

| Brique | Rôle | Activation |
|--------|------|------------|
| **code-server** | IDE web (VS Code dans le navigateur), édition du même volume que le conteneur `cobol` | `--profile ide` |
| **OpenCobolIDE** (hôte) | IDE graphique dédié COBOL (GTK) — pas dans Docker | Voir README principal |
| **Hercules** | Émulateur S/390 : base pour **JCL**, **MVS**, distributions type **TK4-** | `--profile hercules` |
| **IBM Db2** | SGBD pour **SQL embarqué** en COBOL (EXEC SQL), tests JDBC/CLI | `--profile db2` |
| **CICS** | Transactionnel mainframe | Documenté seulement (pas de conteneur turnkey) |

Fichiers utiles :

- [`docker-compose.stack.yml`](../docker-compose.stack.yml) — services optionnels.
- [`.env.stack.example`](../.env.stack.example) — variables non sensibles (copier en `.env.stack` ; mots de passe uniquement en local, voir [SECURITY.md](../SECURITY.md)).
- [`hercules/`](hercules/) — `hercules.cnf` + guide TK4-/JCL.
