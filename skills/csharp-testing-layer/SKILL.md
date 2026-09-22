---
name: csharp-testing-layer
description: Conventions de tests .NET avec xUnit — un test par critère d'acceptation, repositories mockés, structure Arrange/Act/Assert, nommage Method_Scenario_Expected, test d'intégration sur l'endpoint complet, suite verte avant de continuer. S'active dès qu'on écrit ou modifie un test, qu'on couvre un service/mapper/repository, ou qu'on met en place une stratégie de test.
---

# Couche Tests / xUnit (.NET)

Pas de code sans test. Chaque critère d'acceptation produit du code **et** le(s) test(s) qui le couvre(nt). La suite est verte avant de passer à la suite.

## Non-négociables

- **Test par critère d'acceptation** : chaque comportement spécifié a son test. Les cas limites (liste vide, parent null, valeur surchargée) sont testés explicitement.
- **Repositories mockés** : tester le service en isolant la DB (mock/fake des interfaces de repository). Vérifier l'orchestration (appels, parallélisme, repli sur liste vide), pas EF.
- **Arrange / Act / Assert** : structure visible, un comportement par test.
- **Nommage `Method_Scenario_Expected`** : ex. `MapEvent_WhenParentSeriesNull_UsesNullDates`, `GetByIdsAsync_WhenIdsEmpty_ReturnsEmpty`.
- **Test d'intégration sur l'endpoint complet** : au-delà des unitaires, un test bout-en-bout de l'endpoint (ex. `POST /update`) valide le câblage réel controller→service→mapper→repo.
- **Déterminisme** : pas de dépendance à l'heure réelle ni à l'ordre d'exécution ; injecter une horloge si besoin.
- **Vert avant de continuer** : un test rouge bloque (le hook `post-edit` exécute `FORGE_TEST_CMD`).

## Ancrage Aparte

- Tests `InventoryUpdateService` (7+) : couvrent l'orchestration du `/update` avec repos mockés — fallback parent null, repli sur listes vides, cohérence des `VenueIds`. Étape suivante identifiée : ajouter un **test d'intégration** sur l'endpoint `/update` complet.

## Checklist

- [ ] Un test par critère + cas limites (vide, null, override)
- [ ] Repos mockés ; on teste l'orchestration, pas EF
- [ ] AAA + nommage `Method_Scenario_Expected`
- [ ] Test d'intégration sur l'endpoint complet
- [ ] Suite verte (`dotnet test`) avant de continuer
