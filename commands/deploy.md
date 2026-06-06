---
description: Déploie l'application sur l'infra cible (dev → staging → prod), avec gate bloquant en prod
argument-hint: <dev|staging|prod>
---

# /forge:deploy

Environnement cible : **$ARGUMENTS** (défaut `dev` si vide).

## Pré-requis impératifs
- `/forge:review` doit avoir rendu un verdict `GO`.
- Le hook `pre-deploy-gate` bloque tout déploiement si les tests/sécurité ne sont pas verts, ou si l'environnement est `prod` sans fichier d'approbation `.forge/.deploy-approved`.

## Procédure
1. Délègue à l'agent **sre-deployer**.
2. `dev` / `staging` : déploiement direct via le pipeline configuré (GitLab CI / Coolify selon le projet).
3. `prod` : action **irréversible** → l'agent NE déploie PAS de lui-même. Il prépare le déploiement, affiche le diff/plan, et **demande une confirmation humaine explicite**. La confirmation matérialise le fichier `.forge/.deploy-approved` que le gate exige.
4. Après déploiement : vérifie la santé (health checks), consigne la version déployée.

## Interdits
Aucune saisie de secrets/identifiants, aucune modification de droits, aucune suppression de données. Si l'infra le requiert, l'agent décrit l'étape et la délègue à l'utilisateur.
