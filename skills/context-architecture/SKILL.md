---
name: context-architecture
description: Modèle de gestion du contexte de la fabrique (couches de contexte, chargement just-in-time, mémoire durable). S'active quand on s'interroge sur quel contexte charger, comment structurer la mémoire, pourquoi un CLAUDE.md unique ne suffit pas, ou comment éviter de saturer/diluer le contexte.
---

# Architecture de contexte Forge

Un seul `CLAUDE.md` ne suffit pas sur un vrai codebase : on structure le contexte en couches, chargées au bon moment.

## Les 4 couches
1. **Standards globaux** (skill always-on) : `engineering-standards` (5 piliers), conventions sécurité. Toujours présent.
2. **Contexte projet** (`CLAUDE.md` + mémoire projet) : domaine métier, stack retenue (`stack-defaults`), conventions du repo.
3. **Contexte tâche** (just-in-time) : injecté par commande à partir de `.forge/spec/SPEC.md` / `.forge/design/ARCHITECTURE.md` / résultat d'un `/forge:recall`. On ne charge que ce qui sert à la tâche en cours.
4. **Mémoire de fabrique** (durable, transverse) : le vault Obsidian (cf. skill `obsidian-vault`). Survit aux projets et **alimente** les couches 1 et 2.

## Règles de chargement
- **Juste-à-temps** : ne pas tout charger d'emblée ; tirer la couche 3 au moment où la tâche le demande.
- **Recall avant build** : avant de concevoir/coder, interroger la couche 4 (`/forge:recall`) pour réutiliser.
- **Remember après** : après un projet/une review, distiller vers la couche 4 (`/forge:remember`).
- **Éviter la dilution** : un contexte trop large dégrade le raisonnement autant qu'un contexte trop pauvre. Préférer des pages ciblées et liées à un gros document fourre-tout.

## Distinction
- Mémoire **projet** (`.forge/`, versionnée Git) = éphémère, liée au repo.
- Mémoire **fabrique** (vault) = durable, transverse, compoundante.
