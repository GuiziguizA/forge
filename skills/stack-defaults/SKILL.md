---
name: stack-defaults
description: Stack technique et conventions de repo par défaut (architecture, tests, CI/CD, observabilité) à appliquer quand on conçoit une architecture, scaffolde un projet, choisit une techno, structure des dossiers/namespaces, ou met en place un pipeline. S'active sur les tâches de design et de mise en place projet.
---

# Conventions de stack par défaut

Stack opinionnée appliquée sauf déviation justifiée par un ADR. Adapter aux contraintes du projet.

## Backend (défaut)
- **.NET 8**, Clean Architecture (Domain / Application / Infrastructure / API).
- **CQRS** via MediatR ; commandes et requêtes séparées.
- **EF Core** ; migrations versionnées ; pas de migration sur branche de feature partagée sans coordination.
- Tests : **xUnit** ; tests unitaires sur le domaine/application, tests d'intégration sur l'infra.

## Observabilité (imposée, pilier du même nom)
- Logs structurés (**Serilog** ou équivalent), enrichis (correlation id).
- Traçage **OpenTelemetry** sur les frontières I/O et opérations critiques.
- Codes d'erreur stables et catégorisés.

## CI/CD & livraison
- **GitLab CI** : étapes build → test → (lint/sécu) → package.
- Conteneurisation **Docker** ; images taguées (semver + sha), registry **Harbor**.
- Déploiement applicatif via **Coolify** (cible auto-hébergée) selon le projet.

## Conventions de repo
- Branches : `feature/*`, rebase + push `--force-with-lease` sur sa propre branche.
- Commits clairs, atomiques.
- Arborescence et namespaces cohérents avec la solution existante (lire avant d'écrire).

## Front (si applicable)
- Composants typés, état maîtrisé, pas de re-render inutile ; le front passe les mêmes gates qualité que le back.

## Savoir-faire C# par couche
Pour le détail des conventions par couche (déclenché just-in-time selon le fichier édité), voir les skills dédiés :
`csharp-api-layer`, `csharp-application-layer`, `csharp-mapping-layer`, `csharp-persistence-layer`, `csharp-domain-layer`, `csharp-testing-layer`, `csharp-contracts-integration`.

> Toute déviation à ces défauts doit être tracée en ADR (`.forge/design/ADR-00x.md`).
