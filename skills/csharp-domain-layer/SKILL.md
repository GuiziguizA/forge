---
name: csharp-domain-layer
description: Conventions de la couche Domain/Entités .NET — entités sans dépendance d'infrastructure, alias de type pour résoudre les collisions namespace↔entité, enums et bitmask flags, invariants portés par l'entité. S'active dès qu'on écrit ou modifie une entité du domaine, un enum métier, un objet-valeur, ou qu'on structure un namespace du domaine.
---

# Couche Domain / Entités (.NET)

Le domaine est le cœur stable : entités, objets-valeurs, enums métier. Il ne dépend de rien (ni EF, ni ASP.NET, ni package externe).

## Non-négociables

- **Zéro dépendance d'infrastructure** : pas d'attribut EF, pas de référence à un client HTTP ou à un package d'API externe dans l'entité. Le domaine ne connaît ni la DB ni le transport.
- **Alias de type sur collision namespace↔entité** : quand un même nom sert de namespace **et** d'entité (ex. `InternalVenue`), lever l'ambiguïté par un alias en tête de fichier (`using DomainInternalVenue = …Entities.InternalVenue;`) plutôt que par des chemins pleinement qualifiés disséminés.
- **Enums & bitmask** : un enum de flags est `[Flags]` avec des valeurs en puissances de 2 ; documenter quand le bitmask est partagé avec un système externe (le cast devient alors intentionnel côté mapping — voir [[csharp-mapping-layer]]).
- **Invariants dans l'entité** : une entité valide à la construction ; éviter les setters publics qui permettent un état incohérent quand c'est possible.
- **Nommage explicite** : noms métier, pas techniques ; pas d'abréviation obscure.

## Ancrage Aparte

- Entités `EventSeries`, `Event`, `InternalVenue`, `InternalOrganizer`, `Tour`. Collision `InternalVenue`/`InternalOrganizer` (namespace **et** entité) résolue par alias `DomainInternalVenue` / `DomainInternalOrganizer`. `StatusFlags` est un bitmask aligné sur l'enum IAS (cast intentionnel côté mapper).

## Checklist

- [ ] Aucune dépendance EF/HTTP/package externe dans l'entité
- [ ] Collision namespace↔entité levée par alias en tête de fichier
- [ ] Enums de flags `[Flags]` + valeurs puissances de 2
- [ ] Invariants garantis ; nommage métier explicite
