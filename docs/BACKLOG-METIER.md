# Backlog métier — suppléments au programme actuel

Banque (existant) + **assurance** (à ajouter). Chaque item est indépendant ; ordre suggéré = complexité croissante.

---

## Banque (enrichissement du périmètre actuel)

| ID | Fonctionnalité | Description | Fichiers / notes |
|----|----------------|-------------|------------------|
| B1 | **Virement** entre deux comptes | Débit compte source, crédit cible, 2 lignes dans `TRANS.dat` ou équivalent ; atomicité « best effort » (les deux ou message d’erreur). | Nouveau `VIREMENT.cob`, `VALID`, `COMPTE-IO` |
| B2 | **Découvert autorisé** | Paramètre par compte (`W-CPT-PLAFOND-DEC`) ; `RETRAIT` autorise solde négatif jusqu’au plafond. | Étendre `COMPTE.cpy`, `CREER`, `RETRAIT` |
| B3 | **Clôture de compte** | Passage statut `C`, solde doit être 0 (ou virement de solde résiduel). | `CLOTURE.cob` ou option dans menu |
| B4 | **Relevé / export** | Extraire mouvements d’un compte sur période (date début/fin) vers fichier séquentiel `data/RELEVE-YYYYMMDD.txt`. | Lecture `TRANS.dat` filtrée, nouveau petit module |
| B5 | **Commission / frais** | Prélèvement fixe ou % sur opération (depuis param `data/PARAM.dat` séquentiel simple). | `PARAM-IO` minimal, appel depuis `DEPOT`/`RETRAIT` |
| B6 | **Opposition / gel** | Statut compte `G` ; refuse mouvements sauf déblocage admin (mot de passe fictif en `WS`). | `COMPTE.cpy` + contrôles dans I/O |

---

## Assurance (nouveau module métier — bancassurance légère)

| ID | Fonctionnalité | Description | Fichiers suggérés |
|----|----------------|-------------|-------------------|
| A1 | **Souscription police** | Créer police auto/habitation : id police, id assuré (lien optionnel `W-CPT-NUMERO`), prime annuelle, franchise, statut. | `POLICE.cpy`, `POLICE-IO.cob`, `SOUSCRIT.cob`, `data/POLICES.dat` indexé |
| A2 | **Encaissement prime depuis compte** | Débit compte bancaire + écriture ligne transaction assurance ; refuse si solde insuffisant. | `EMIT-PRIME.cob`, réutilise `COMPTE-IO`, `TRANS-IO` |
| A3 | **Déclaration sinistre** | Enregistrement sinistre (date, montant estimé, police) ; statut `D` déclaré / `I` indemnisé. | `SINISTRE.cpy`, `SIN-IO.cob`, `DECLAR-SIN.cob` |
| A4 | **Indemnisation** | Crédit du compte lié (si présent) + mise à jour sinistre ; sinon solde « reste à payer » fictif. | `INDEMNIS.cob` |
| A5 | **Liste polices / sinistres** | Menus consultation comme `LISTER` / `HISTO`. | `LIST-POL.cob`, `LIST-SIN.cob` |
| A6 | **Résiliation** | Clôture police ; plus de prélèvement automatique. | `RESILIE.cob` |

---

## Priorisation recommandée

1. **B1** (virement) — touche la logique métier centrale sans nouveau fichier métier assurance.  
2. **A1 + A2** — introduit `POLICES.dat` et le lien compte ↔ police.  
3. **A3 + A4** — cycle sinistre complet pédagogique.  
4. **B2, B3** — affiner la banque.  
5. Le reste selon besoin.

---

## Jeux de tests suggérés

- **B1** : virement avec compte inexistant ; virement montant > solde ; OK.  
- **A2** : prime avec compte insuffisant ; OK avec bon solde.  
- **A4** : indemnisation double = rejet ou idempotence simple.

Document vivant : coche les ID dans ton suivi perso (issues / notes) au fur et à mesure des implémentations.
