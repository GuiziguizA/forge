---
name: csharp-api-layer
description: Conventions de la couche API/Controllers .NET (ASP.NET Core) — contrôleurs minces, modèles de contrat au bord, propagation CancellationToken, codes HTTP et ProblemDetails, validation d'entrée. S'active dès qu'on écrit ou modifie un Controller, un endpoint minimal API, un DTO de requête/réponse, ou qu'on expose une route HTTP.
---

# Couche API / Controllers (.NET)

La couche API est une **frontière mince** : elle traduit HTTP ↔ application, rien de plus. Aucune logique métier, aucun accès direct à la base.

## Non-négociables

- **Contrôleur mince** : le contrôleur valide l'entrée, appelle un service applicatif, mappe le retour vers le modèle de contrat. Zéro requête DB, zéro règle métier dans le contrôleur.
- **Modèle de contrat au bord** : exposer des DTO / modèles de contrat (ex. modèles IAS), jamais les entités du domaine. Le mapping entité→contrat appartient à la couche mapping ([[csharp-mapping-layer]]), pas au contrôleur.
- **Propager `CancellationToken`** : chaque action `async` reçoit le `CancellationToken` de la requête et le passe au service. Jamais de `.Result`/`.Wait()`.
- **Codes HTTP explicites** : `200/201/204` succès, `400` validation, `404` introuvable, `409` conflit. Erreurs renvoyées en **`ProblemDetails`**, jamais de stack trace ni de message exposant l'interne.
- **Validation d'entrée** : valider à l'entrée (DataAnnotations / FluentValidation / garde explicite). Une entrée invalide → `400`, pas une exception 500.
- **Pas de secret, pas de config dure** : la configuration vient de l'injection (`IOptions`), jamais codée dans le contrôleur.

## Ancrage Aparte

- `InventoryController` expose `POST /update` : il reçoit la requête IAS, délègue à `InventoryUpdateService`, renvoie le modèle de contrat IAS. Tout le câblage données↔DB est dans le service + le mapper, pas dans le contrôleur.
- Le modèle exposé (`Ias.Event`, etc.) vient du package NuGet **figé** `InventoryApiServer` → voir [[csharp-contracts-integration]].

## Checklist

- [ ] Aucune logique métier ni accès DB dans le contrôleur
- [ ] DTO/contrat exposé, pas l'entité domaine
- [ ] `CancellationToken` reçu et propagé
- [ ] Codes HTTP corrects + `ProblemDetails` sur erreur
- [ ] Entrée validée avant délégation
