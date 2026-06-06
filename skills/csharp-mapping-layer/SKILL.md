---
name: csharp-mapping-layer
description: Conventions de la couche Mapping .NET — traduction entité domaine ↔ modèle de contrat, fallback override (X ?? Y), casts intentionnels documentés (bitmask/enum), signalement explicite des valeurs hardcodées, sourcing parent↔enfant, mapping null-safe. S'active dès qu'on écrit ou modifie un Mapper, une méthode To/From, une projection entité vers DTO ou vers un modèle d'API externe.
---

# Couche Mapping (.NET)

Le mapper traduit l'**entité du domaine** vers le **modèle de contrat** (DTO, modèle d'API externe) et inversement. C'est ici, et nulle part ailleurs, qu'on absorbe les écarts de forme entre les deux mondes.

## Non-négociables

- **Fallback override** : pour une valeur surchargeable, `Override ?? Base` (ex. `NameOverride ?? Name`). Toujours dans cet ordre, l'override gagne.
- **Casts intentionnels documentés** : un cast non évident (`(StatusEnum)(int)x` quand deux enums partagent le même bitmask) doit porter un commentaire « pourquoi », pas « quoi ». Un cast silencieux est un bug en attente.
- **Valeurs hardcodées signalées** : toute valeur sans source de données (ex. `GenreId = 1`, `SalesLogo = "default"`) est marquée d'un `// TODO/HACK: hardcodé, pas de source DB` explicite — jamais cachée. Un raccourci assumé > un raccourci invisible.
- **Sourcing parent↔enfant explicite** : si un champ exposé sur l'enfant provient en réalité du parent (ex. textes sur `Event` mais stockés sur `EventSeries`), le commenter pour que la provenance soit traçable.
- **Mapping null-safe** : tout accès à une relation potentiellement absente est gardé (`?.`, `is not null`). Un mapper ne lève pas de `NullReferenceException`.
- **Pas d'accès DB ni d'I/O dans le mapper** : il reçoit des objets déjà chargés. Les requêtes appartiennent au service ([[csharp-application-layer]]).

## Ancrage Aparte

- `Catalog/Mappers/IasMapper.cs` : mappe Tour / EventSeries / Event / Venue / Promoter / SettlementPartner vers le modèle IAS. Patterns : `NameOverride ?? Name`, cast bitmask intentionnel `(StatusEnum)(int)event.StatusFlags`, textes `shortText/longText/infoText` sourcés depuis le parent `EventSeries` (ShortComment/LongComment/Description), valeurs encore hardcodées (`GenreId=1`, `Genres`) signalées dans la doc de mapping `_inventory-update-mapping.adoc`.

## Checklist

- [ ] Fallback override dans le bon ordre (`Override ?? Base`)
- [ ] Casts non triviaux commentés (le « pourquoi »)
- [ ] Valeurs hardcodées explicitement marquées
- [ ] Provenance parent↔enfant tracée
- [ ] Accès aux relations null-safe ; aucune I/O dans le mapper
