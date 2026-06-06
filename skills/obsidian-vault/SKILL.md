---
name: obsidian-vault
description: Opérer un vault Obsidian comme mémoire d'agent selon le pattern LLM Wiki de Karpathy (markdown local, wikilinks, frontmatter, index, compilation du brut). S'active dès qu'on lit/écrit/organise des notes du vault de fabrique, qu'on mémorise un apprentissage, ou qu'on interroge la connaissance accumulée.
---

# Opérer le vault de fabrique (LLM Wiki, pattern Karpathy)

Le vault est la mémoire durable de la fabrique : du **markdown local**, lisible par n'importe quel agent, compilé une fois plutôt que re-fouillé à chaque requête. Emplacement : `$FORGE_VAULT` (défaut `~/forge-brain`). Analogie : Obsidian = le viewer, l'agent = le programmeur du wiki, le vault = la codebase de connaissance.

## Structure
```
$FORGE_VAULT/
├── index.md       # sommaire / point d'entrée — tenir à jour
├── patterns/      # patterns d'archi réutilisables, ADR génériques
├── domains/       # glossaires métier, règles transverses
├── stacks/        # conventions par stack
├── postmortems/   # ce qui a marché / cassé, leçons
├── decisions/     # synthèses distillées des decision logs projet
├── projects/      # 1 note par projet, liée aux concepts
└── _raw/          # ingest brut avant compilation
```

## Conventions d'écriture
- **Wikilinks** `[[note]]` pour relier concepts/pages ; préférer relier qu'isoler.
- **Frontmatter** YAML en tête de note : `tags`, `status` (draft/stable), `created`, `project`, `source`.
- **Callouts** Obsidian (`> [!note]`, `> [!warning]`) pour les pièges.
- **index.md** : table des matières par section, avec liens vers les pages clés.

## Workflow
- **Compiler, pas accumuler** : transformer le brut de `_raw/` en pages synthétiques interconnectées, puis nettoyer.
- **Enrichir, pas dupliquer** : si une page existe sur le sujet, l'étendre.
- **Recall** : partir d'`index.md`, suivre les wikilinks, filtrer par frontmatter.

## Limites
- Cohérent jusqu'à ~100-400 notes / ~400k mots par vault ; au-delà, segmenter en sous-vaults thématiques.
- Accès via le filesystem local ; un MCP Obsidian/filesystem est optionnel pour Bases/canvas.
