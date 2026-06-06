---
description: Conçoit l'architecture et les ADRs à partir d'une SPEC.md validée (gate humain ensuite)
argument-hint: [contrainte ou orientation optionnelle]
---

# /forge:design

## Pré-requis
Lis `.forge/spec/SPEC.md`. S'il n'existe pas ou n'est pas validé, demande `/forge:spec` d'abord.

Orientation : $ARGUMENTS

## Procédure
1. Délègue à l'agent **solution-architect**.
2. Avant de concevoir, lance un **recall** de la mémoire de fabrique (cf. `/forge:recall`) : réutilise un pattern/ADR existant plutôt que réinventer.
3. Respecte le skill `stack-defaults` (stack et conventions par défaut) sauf justification explicite.
4. Produis :
   - `.forge/design/ARCHITECTURE.md` : composants, flux, données, frontières, intégrations.
   - `.forge/design/ADR-00x.md` : une décision d'architecture = un ADR (format Décision / Justification / Alternatives écartées / Impact — validé par le hook `decision-logger`).
5. Mappe chaque critère d'acceptation de la spec à un composant.

## Gate humain (obligatoire)
Arrête-toi après écriture. Résume les choix structurants (≤ 5 lignes) et les ADRs ouverts, demande validation avant `/forge:build`. Ne génère aucun code.
