# Game Design

## Core Concept

Midnight Harvest is a supernatural survival, mining, exploration, and progression game.

**Core Loop:** Mine → Sell → Buy Gear → Survive Night → Absorb Ghosts → Feed Dreadon → Boss Fight → Ending

## Resources (Verified Starting Values)

| Resource | Start | Source | Sink | Notes |
|----------|-------|--------|------|-------|
| **Coins** | 500 | Chests, selling ore/scrap | All shops | Not counted in bag limit |
| **Silver** | 0 | Mining Silver Ore (8 nodes) | MineExchanger (50 each) | Bag limit item |
| **Baguerite** | 0 | Mining Baguerite (11 nodes) | MineExchanger (25 each) | Shown as "Bronze" in original UI — **UNAPPROVED** |
| **Scrap** | 0 | Scrap pickups (10 nodes) | Scrap Collector (20 each) | Bag limit item, per-player state |
| **Ghost Energy** | 0 | Absorbing ghosts | Dreadon transfer | **UNAPPROVED** values: 20 normal / 50 deep |

## Bag Limit

- **Capacity:** 10 items (Silver + Baguerite + Scrap only)
- Coins are NOT counted
- Enforced by MiningService, ScrapService, EconomyService

## Shops (7 Total — All UNAPPROVED)

| Shop | Item | Price | Source Template | Ownership Guard |
|------|------|-------|-----------------|-----------------|
| Axe | Axe | 150 | ServerStorage.Axe | Backpack/Character check |
| Hammer | Hammer | 250 | ServerStorage.Hammer | Backpack/Character check |
| WoodPick | WoodPick | 200 | ServerStorage.WoodPick | **Missing in original** — add guard |
| Bat | Bat | 200 | ServerStorage.Bat | Player attribute |
| Gun (Revolver) | Gun | 300 | ServerStorage.Gun | Backpack/Character check |
| TrenchGun | TrenchGun | 500 | ServerStorage.TrenchGun | Backpack/Character check |
| Scythe | Guestium Scythe | 500 | ServerStorage.Guestium Scythe | Player attribute |
| CoconutDrink | CoconutDrink | 100 | ServerStorage.CoconutDrink | **Missing in original** — add guard |
| GhostVacuum | GhostVacuum | 300 | ServerStorage.GhostVacuum | Backpack/Character check |

## Mining

| Ore | Nodes | Hits Required | Reward | Respawn |
|-----|-------|---------------|--------|---------|
| Silver Ore | 8 | 6 | 1 Silver | 150s |
| Baguerite | 11 | 4 | 1 Baguerite | 150s |

- **Tool Requirement:** WoodPick must be equipped (server-validated)
- **Distance Check:** ≤ 12 studs from ore
- **Cooldown:** Per-player debounce (0.5s)

## Scrap

- **Nodes:** 10 ScrapMetal models with ProximityPrompts
- **Per-Player State:** Each player can collect each node once per day
- **Respawn:** All collected scrap respawns on day change
- **Sell Price:** 20 Coins per Scrap

## Ghosts

### Verified Populations

| Type | Initial World | GhostBackup Templates |
|------|---------------|----------------------|
| Ghost | 26 | 23 |
| Deep Ghost | 3 | 2 |

### Behavior (UNAPPROVED)

| Aspect | Ghost | Deep Ghost |
|--------|-------|------------|
| Damage | 15 | 25 |
| Chase | No | Yes (35 studs/s, 200 stud range) |
| Visibility | Night only (18:00–06:00) | Night only |
| Absorption Reward | 20 Ghost Energy | 50 Ghost Energy |
| Absorption Tool | GhostVacuum (fix typo from GhostVaccumShop) | GhostVacuum |

### Respawn — UNRESOLVED

Original `GhostRespawn` clones GhostBackup (23+2) on day change, causing drift from 29→25. Intended behavior not documented.

## Day/Night Cycle (UNAPPROVED)

| Parameter | Value |
|-----------|-------|
| Total Days | 100 |
| Day Duration | 25 seconds |
| Daytime | 10 seconds (ClockTime = 12) |
| Nighttime | 15 seconds (ClockTime = 0) |
| Total Game Time | ~41 minutes |

### Key Triggers

- **Day 20:** Alice cutscene + Alice spawn
- **Day 100:** Cycle ends, final event available

## NPCs (5 Verified)

| NPC | Role | Dialogue Style |
|-----|------|----------------|
| Arwin | Shopkeeper | Shop price list |
| Barn Keeper | Villager | Atmosphere/warning |
| Murugesan | Villager | Ghost warning |
| Old Miner | Mine Worker | Mine warning |
| The Older | Old Villager | Dreadon lore |

## Boss (Dreadon) — UNAPPROVED

| Aspect | Value |
|--------|-------|
| Energy Required | 20,000 (config) vs 20 (trigger) — **Recommend 2,000** |
| Attack Damage | 25 |
| Chase Speed | 30 |
| Detection Range | 200 studs |
| Defeat Condition | **Not implemented in original** — design needed |
| BGM | BossBattleBGM (SoundService) |

## Progression Summary

1. **Day 1–19:** Mine, sell, buy gear, survive nights, absorb ghosts
2. **Day 20:** Alice cutscene → Alice spawns in world
3. **Day 20–99:** Continue mining/ghosts, feed Dreadon Ghost Energy
4. **Boss Activation:** Transfer enough Ghost Energy to Dreadon → Boss fight
5. **Day 100:** Cycle ends, ending sequence

## Original vs Rebuild Differences

| Original Issue | Rebuild Fix |
|----------------|-------------|
| No persistence | Full DataStore persistence |
| Mining exploit (no tool check) | Server-validated tool requirement |
| Ghost absorption conflict (2 paths) | Single path: GhostVacuum only |
| Ghost population drift (29→25) | Respawn behavior UNRESOLVED — design decision needed |
| Boss trigger at 20 energy | Reconcile with 20,000 config — **Recommend 2,000** |
| Boss no defeat state | Implement defeat condition + BGM stop |
| Duplicate tools/chests | Single templates, per-player state |
| Baguerite shown as "Bronze" | Consistent naming — **UNAPPROVED** |
| Mine cutscene dead (missing remote) | Create AliceCutsceneFinished or redesign trigger |