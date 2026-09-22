---
description: Déploie l'application sur l'infra cible (dev → staging → prod), avec gate bloquant en prod
argument-hint: <dev|staging|prod>
---

# /forge:deploy

Environnement cible : **$ARGUMENTS** (défaut `dev` si vide).

## Pré-requis impératifs
- `/forge:review` doit avoir rendu un verdict `GO`.
- Le hook `pre-deploy-gate` bloque tout déploiement si les tests/sécurité ne sont pas verts, ou si l'environnement est `prod` sans fichier d'approbation `.forge/.deploy-approved`.

## Connecteurs (optionnels)
Si `.mcp.json` expose un serveur **GitLab** (voir `.mcp.json.example`), l'agent l'utilise pour déclencher/suivre le pipeline et lire l'état des jobs au lieu de commandes shell ad hoc. Sinon, repli sur le pipeline shell du projet. Le choix des serveurs MCP est tracé en ADR (`.forge/design/`).

## Procédure
1. Délègue à l'agent **sre-deployer**.
2. `dev` / `staging` : déclenche le pipeline GitLab CI (via le connecteur MCP `gitlab` si présent, sinon `git push` sur la branche d'env / Coolify selon le projet). Pipeline attendu : build → test → lint/sécu → package (cf. skill `stack-defaults`).
3. `prod` : action **irréversible** → l'agent NE déploie PAS de lui-même. Il prépare le déploiement, affiche le diff/plan, et **demande une confirmation humaine explicite**. La confirmation matérialise le fichier `.forge/.deploy-approved` que le gate exige.
4. Après déploiement : vérifie la santé (health checks), consigne la version déployée.

## Interdits
Aucune saisie de secrets/identifiants, aucune modification de droits, aucune suppression de données. Si l'infra le requiert, l'agent décrit l'étape et la délègue à l'utilisateur.
