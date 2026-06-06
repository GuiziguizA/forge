---
description: Implémente la feature décrite dans .forge/spec/SPEC.md (code + tests)
argument-hint: [feature ou ticket optionnel à cibler]
---

# /forge:build

## Pré-requis

Lis `.forge/spec/SPEC.md`. S'il n'existe pas, demande à l'utilisateur de lancer `/forge:spec` d'abord — ne devine pas la spec.

Cible : $ARGUMENTS (si vide, implémente l'ensemble des critères d'acceptation non encore couverts).

## Procédure

1. Délègue à l'agent **implementer**.
2. Respecte le skill `engineering-standards` (les 5 piliers) — il est non négociable.
3. Pour chaque critère d'acceptation : écris le code **et** le test correspondant. Pas de code sans test.
4. Le hook `post-edit` lance lint + tests à chaque écriture de fichier de code : si rouge, **corrige avant de continuer**, ne contourne pas.
5. Journalise chaque décision d'architecture non triviale dans `.forge/decisions/` au format imposé (le hook `decision-logger` le valide).

## Sortie

Termine par un récapitulatif : critères couverts, fichiers créés/modifiés, tests ajoutés, décisions logguées. Ne déploie rien (le deploy est hors MVP).
