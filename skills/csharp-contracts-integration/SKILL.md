---
name: csharp-contracts-integration
description: Conventions d'intégration de contrats externes .NET — packages NuGet/SDK générés traités comme immuables, versions épinglées, toute adaptation confinée en mapping/service (anti-corruption layer), interdiction d'éditer le client généré. S'active dès qu'on consomme un package d'API généré, un SDK tiers, un client OpenAPI/gRPC, ou qu'on adapte un modèle externe au domaine.
---

# Couche Contrats / Intégration externe (.NET)

Un contrat externe (package NuGet généré, SDK, client OpenAPI) est une **frontière qu'on ne possède pas**. On l'isole derrière une couche anti-corruption ; on ne le plie pas à nos besoins, on s'y adapte au bord.

## Non-négociables

- **Contrat = immuable** : ne jamais éditer du code généré ni patcher un package. Si le contrat manque quelque chose, l'écart se résout dans **notre** mapping/service, pas dans le leur.
- **Versions épinglées** : référencer une version exacte (pas de plage flottante). Une montée de version est un changement délibéré, tracé en ADR si elle modifie le comportement.
- **Anti-corruption layer** : le modèle externe ne s'infiltre pas dans le domaine. Le mapping ([[csharp-mapping-layer]]) traduit externe↔domaine ; le service ([[csharp-application-layer]]) orchestre. Le domaine ([[csharp-domain-layer]]) ignore l'existence du package.
- **Écarts documentés** : champs non transmis, valeurs hardcodées faute de source, casts d'enums partagés → consignés (doc de mapping / ADR), jamais silencieux.
- **Pas de secret dans la config du client** : clés/tokens du SDK via configuration injectée, jamais en clair.

## Ancrage Aparte

- Packages NuGet **figés** `FrontendApiServer v0.5.0` et `InventoryApiServer v0.19.1` : interdiction de les modifier — toute la logique de wiring du `/update` vit dans `IasMapper` + `InventoryUpdateService`. Écarts documentés dans `_inventory-update-mapping.adoc` (champs DB non transmis : `Subtitle`, `Code`, `SessionType`, `VenueMapType`, adresse complète ; valeurs hardcodées : `GenreId`, `SalesLogo`, `Genres`).

## Checklist

- [ ] Aucune édition du code/package généré
- [ ] Version du package épinglée (exacte)
- [ ] Adaptation confinée au mapping/service (anti-corruption)
- [ ] Écarts (champs absents, hardcodés, casts) documentés
- [ ] Secrets du client via config injectée
