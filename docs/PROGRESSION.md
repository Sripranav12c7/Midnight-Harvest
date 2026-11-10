# Progression Design

## Day Progression (UNAPPROVED)

| Day | Event | Script/Trigger |
|-----|-------|----------------|
| 1 | Game start, 500 Coins, GhostVacuum in Backpack | PlayerService, EconomyService |
| 1–19 | Mining, selling, shopping, night survival | MiningService, ShopService, GhostService |
| 20 | Alice cutscene + Alice spawn | DayNightService → CutsceneService + NPCService |
| 20–99 | Continued progression, Ghost Energy → Dreadon | GhostService, BossService |
| Boss Activation | Transfer threshold Ghost Energy to Dreadon | BossService (threshold UNAPPROVED: recommend 2,000) |
| 100 | Cycle ends, ending sequence | DayNightService → CutsceneService |

## Story Flags (Per-Player)

| Flag | Description | Set By |
|------|-------------|--------|
| `aliceCutsceneSeen` | Alice cutscene completed | CutsceneService |
| `aliceSpawned` | Alice NPC exists in world | NPCService |
| `mineCutsceneSeen` | Mine cutscene completed | CutsceneService |
| `bossActivated` | Dreadon energy threshold reached | BossService |
| `bossDefeated` | Boss fight won | BossService |
| `gameCompleted` | Ending reached | CutsceneService |

## NPC Progression

| NPC | Unlock Condition | Progression |
|-----|------------------|-------------|
| Arwin | Day 1 | Always available |
| Barn Keeper | Day 1 | Always available |
| Murugesan | Day 1 | Always available |
| Old Miner | Day 1 | Always available |
| The Older | Day 1 | Always available |
| Alice | Day 20 | After Alice cutscene |

## Quest/Story Gating (UNAPPROVED)

- No quest system in original — rebuild adds story flags
- Dialogue can be gated by flags (e.g., The Older only mentions Dreadon after day 20)
- Shop unlocks: all available day 1 (original behavior)

## Boss Prerequisites (UNAPPROVED)

1. Reach day 20 (Alice cutscene done)
2. Accumulate Ghost Energy (threshold: recommend 2,000)
3. Transfer to Dreadon via ProximityPrompt
4. BossDialogueEvent fires → BossFightStart available
5. Defeat Dreadon (defeat condition TBD)

## Ending (UNAPPROVED)

- Triggered by `bossDefeated` flag
- Final cutscene sequence
- Credits / completion screen
- Save `gameCompleted` flag

## Per-Player vs Shared State

| State | Scope | Persisted |
|-------|-------|-----------|
| Currencies (5) | Per-player | Yes |
| Tool ownership | Per-player | Yes |
| Story flags | Per-player | Yes |
| Current day | **Per-player** (UNAPPROVED) | Yes |
| Ghost population | Shared (server) | No (respawns from template) |
| Boss state | Shared (server) | No (resets on server restart) |
| Ore states | Shared (server) | No (150s respawn timer) |
| Scrap states | Shared (server) | Per-player collection only |