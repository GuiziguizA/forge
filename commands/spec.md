---
description: Transforme un besoin en langage naturel en SPEC.md structurée (gate humain ensuite)
argument-hint: <description du besoin>
---

# /forge:spec

Tu vas produire la **spécification** du besoin suivant, sans écrire de code :

> $ARGUMENTS

## Procédure

1. Délègue à l'agent **product-analyst** la rédaction de la spec.
2. La spec DOIT suivre le format du skill `spec-conventions` (objectif, règles métier, intégrations, critères d'acceptation testables, hors-scope).
3. Écris le résultat dans `.forge/spec/SPEC.md` (crée les dossiers si besoin).
4. Si des règles métier sont ambiguës, liste explicitement les **hypothèses** prises et les **questions ouvertes** en fin de spec — ne les invente pas silencieusement.

## Gate humain (obligatoire)

Après écriture, **arrête-toi**. Affiche un résumé en 5 lignes max et demande validation explicite avant tout passage à `/forge:build`. Ne commence aucune implémentation tant que l'utilisateur n'a pas validé la spec.
