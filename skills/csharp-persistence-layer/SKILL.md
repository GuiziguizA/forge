---
name: csharp-persistence-layer
description: Conventions de la couche Persistence/EF Core .NET — pattern repository derrière interface, batch GetByIdsAsync (anti N+1), early-return sur liste d'IDs vide, AsNoTracking en lecture, requêtes paramétrées, index sur colonnes de jointure/filtre, migrations versionnées. S'active dès qu'on écrit ou modifie un Repository, une requête EF Core/LINQ-to-Entities, un DbContext, une migration.
---

# Couche Persistence / EF Core (.NET)

Le repository encapsule l'accès aux données derrière une **interface** appartenant à la couche métier. Aucune logique métier ici : seulement charger/persister efficacement.

## Non-négociables

- **Batch plutôt que boucle** : exposer `GetByIdsAsync(IEnumerable<int> ids, …)` et faire **une** requête `Where(x => ids.Contains(x.Id))`, jamais une requête par ID dans une boucle (N+1).
- **Early-return sur entrée vide** : si la liste d'IDs est vide, retourner immédiatement une collection vide — pas de requête `WHERE Id IN ()` inutile.
- **`AsNoTracking` en lecture** : tout chemin de lecture pure utilise `AsNoTracking()` (pas de surcoût de change-tracking).
- **Anti N+1** : précharger les relations nécessaires (`Include` ciblé ou projection), vérifier le SQL généré sur les chemins chauds.
- **Requêtes paramétrées** : jamais de SQL concaténé. EF/LINQ paramètre par défaut ; pour du SQL brut, paramètres nommés uniquement.
- **`CancellationToken = default`** sur les signatures, propagé à `ToListAsync`/`FirstOrDefaultAsync`.
- **Index** sur les colonnes de jointure/filtre fréquentes. **Migrations versionnées** ; pas de migration sur branche partagée sans coordination.

## Ancrage Aparte

- `Repositories/InternalOrganizerRepository.cs`, `InternalVenueRepository.cs`, `Catalog/EventSeriesRepository.cs` : ajout de `GetByIdsAsync` avec **garde early-return** quand la liste d'IDs est vide ; interfaces correspondantes (`IInternalOrganizerRepository`, `IInternalVenueRepository`) avec `CancellationToken = default`. Ces repos alimentent le `Task.WhenAll` du service ([[csharp-application-layer]]).

## Checklist

- [ ] `GetByIdsAsync` en une requête `Contains`, pas de N+1
- [ ] Early-return si liste d'IDs vide
- [ ] `AsNoTracking` sur les lectures pures
- [ ] `CancellationToken = default` propagé jusqu'au `…Async`
- [ ] Index présents ; migration versionnée et coordonnée
