---
name: engineering-standards
description: Standards d'ingénierie production (sécurité, performance, maintenabilité, observabilité, transparence) à appliquer dès qu'on écrit, modifie, conçoit ou relit du code, qu'on implémente une feature ou qu'on prépare un déploiement. S'active pour toute tâche de développement.
---

# Standards d'ingénierie Forge — les 5 piliers

Ces standards sont **non négociables** sur tout code produit. Ils sont vérifiés de façon déterministe par les hooks ; ceci en est la référence.

## 1. Sécurité
- Aucun secret en clair dans le code ou le repo (clés, mots de passe, tokens). Utiliser variables d'environnement / coffre.
- Validation/échappement de toute entrée externe. Requêtes paramétrées (jamais de concaténation SQL).
- Contrôle d'accès explicite (RBAC) là où des données sont exposées ; auth scaffoldée, pas bricolée.
- Chiffrement at-rest et in-transit pour les données sensibles. Audit trail des actions sensibles.

## 2. Performance
- Index sur les colonnes de jointure/filtre. Pas de N+1 (vérifier les requêtes ORM).
- Pagination des listes. Pas de chargement de collections entières en mémoire sans borne.
- Front : bundle maîtrisé, pas de re-render inutile.

## 3. Maintenabilité
- Architecture en couches claire (séparation domaine / application / infra).
- **Pas de code sans test** ; tests de non-régression verts avant de continuer.
- Nommage explicite ; fonctions courtes à responsabilité unique.
- Code documenté là où l'intention n'est pas évidente (le « pourquoi », pas le « quoi »).

## 4. Observabilité
- Logs structurés (clé/valeur), pas de `print`. Codes d'erreur stables et catégorisés.
- Points de traçage (OpenTelemetry) sur les opérations critiques et les frontières I/O.
- Messages d'erreur actionnables, sans fuite de données sensibles.

## 5. Transparence
- Toute décision d'architecture non triviale est consignée dans `.forge/decisions/` (format : Décision / Justification / Alternatives écartées / Impact).
- La traçabilité feature ↔ spec ↔ code ↔ test est tenue à jour.
- Aucune dette introduite en silence : un TODO assumé > un raccourci caché.

> Règle d'or : si tu hésites à appliquer un pilier « pour aller plus vite », c'est le signal de l'appliquer.
