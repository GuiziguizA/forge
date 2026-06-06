---
name: spec-conventions
description: Format et conventions d'une spécification produit (SPEC.md) avec critères d'acceptation testables. S'active dès qu'on rédige, structure ou relit une spec, un cahier des charges, des exigences ou des critères d'acceptation.
---

# Conventions de spécification Forge

Une spec n'est valable que si elle est **testable** et **délimitée**. Format imposé pour `.forge/spec/SPEC.md` :

```markdown
# SPEC — <titre>

## 1. Problème
Le besoin métier en 2-4 phrases. Pourquoi maintenant, pour qui.

## 2. Objectif & résultat attendu
Ce qui doit être vrai une fois la feature livrée (mesurable si possible).

## 3. Règles métier
Liste numérotée des règles (RG1, RG2…). Une règle = une affirmation vérifiable.

## 4. Critères d'acceptation
Format Given/When/Then, numérotés (CA1, CA2…). Chacun doit pouvoir devenir un test automatisé.
- CA1 — Étant donné <contexte>, quand <action>, alors <résultat observable>.

## 5. Intégrations & dépendances
Systèmes, API, données, droits requis.

## 6. Hors-scope
Ce que cette feature ne fait PAS (explicite, pour borner le périmètre).

## 7. Hypothèses & questions ouvertes
Toute ambiguïté non levée. Ne jamais combler une ambiguïté en silence.
```

Principes :
- Chaque critère d'acceptation (CA) trace vers au moins un test à la phase build.
- Pas de solution technique dans la spec (le « comment » appartient à l'archi/build).
- Si une règle métier dépend d'une hypothèse, elle va en §7, pas en §3.
