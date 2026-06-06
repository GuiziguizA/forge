---
description: Revue QA indépendante du code produit contre la spec et les 5 piliers
argument-hint: [périmètre optionnel : fichiers, dossier, feature]
---

# /forge:review

## Procédure

1. Délègue à l'agent **qa-reviewer** (lecture seule — il ne corrige rien lui-même).
2. Confronte le code à `.forge/spec/SPEC.md` : chaque critère d'acceptation est-il couvert et testé ?
3. Vérifie les 5 piliers du skill `engineering-standards` : sécurité, performance, maintenabilité, observabilité, transparence.
4. Vérifie la traçabilité : chaque feature ↔ spec ↔ code ↔ test (mets à jour `.forge/traceability.md`).

Périmètre : $ARGUMENTS (si vide : tout le diff depuis la dernière review).

## Sortie

Produis un **rapport de revue** structuré :
- ✅ Conforme / ⚠️ À corriger / ❌ Bloquant, par critère et par pilier.
- Liste priorisée des corrections.
- Verdict : `GO` (prêt pour gate deploy) ou `NO-GO` (corrections requises).

Ne modifie aucun fichier de code. Si des corrections sont nécessaires, recommande un nouveau `/forge:build` ciblé.
