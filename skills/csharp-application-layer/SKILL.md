---
name: csharp-application-layer
description: Conventions de la couche Application/Services .NET — orchestration de repositories et mappers, parallélisme Task.WhenAll, dégradation gracieuse via try/catch isolé, fallback conditionnel vs valeurs sentinelles, CancellationToken = default sur les interfaces, non-fuite d'entités. S'active dès qu'on écrit ou modifie un service applicatif, un orchestrateur de cas d'usage, un handler de commande/requête.
---

# Couche Application / Services (.NET)

Le service applicatif **orchestre** : il appelle des repositories ([[csharp-persistence-layer]]), assemble via des mappers ([[csharp-mapping-layer]]), et renvoie un résultat. Il contient le flux du cas d'usage, pas les détails d'accès aux données ni le HTTP.

## Non-négociables

- **Paralléliser les lectures indépendantes** : plusieurs requêtes DB sans dépendance entre elles → `Task.WhenAll`, pas en séquentiel. Attention à ne pas partager un même `DbContext` entre tâches concurrentes (un contexte / une portée par requête parallèle).
- **Dégradation gracieuse** : isoler les résolutions secondaires (ex. venues, organizers) dans un `try/catch` qui retombe sur une **liste vide** plutôt que de faire échouer toute la réponse. L'échec d'un enrichissement optionnel ne casse pas le cas d'usage principal.
- **Fallback conditionnel, pas sentinelle** : préférer `parent is not null ? parent.Date : (DateTime?)null` à `DateTime.MinValue`. Une sentinelle (epoch, 0) pollue le consommateur en aval.
- **`CancellationToken = default`** sur les paramètres d'interface, propagé jusqu'aux repositories.
- **Ne pas fuiter d'entités** : le service renvoie un modèle applicatif / de contrat, pas l'entité EF brute.
- **Idempotence & cohérence** : collecter les IDs depuis la source canonique (inclure les parents) pour éviter les jeux d'IDs incohérents entre requêtes.

## Ancrage Aparte

- `Catalog/Services/InventoryUpdateService.cs` : orchestration du `/update` — requêtes DB parallélisées en `Task.WhenAll`, try/catch isolé sur résolution venue/organizer (retombe sur listes vides), fallback conditionnel `parentSeries is not null` au lieu de `DateTime.MinValue`, `VenueIds` collectés depuis `seriesDict.Values` (parents inclus) pour rester cohérent.

## Checklist

- [ ] Lectures indépendantes en `Task.WhenAll` (sans partager le `DbContext`)
- [ ] Enrichissements optionnels isolés en try/catch → repli liste vide
- [ ] Fallback conditionnel, pas de valeur sentinelle
- [ ] `CancellationToken = default` propagé
- [ ] Retour = modèle applicatif/contrat, pas l'entité EF
