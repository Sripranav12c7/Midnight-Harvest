# Architecture

## Overview

Midnight Harvest Rebuild follows a **server-authoritative, modular service architecture** with explicit initialization order and clear client/server boundaries.

## Module Responsibilities

### Shared (ReplicatedStorage.Shared)

| Module | Responsibility |
|--------|----------------|
| `Config/GameConfig.luau` | All tunable constants (prices, damages, timings, limits) — **UNAPPROVED** |
| `Config/ShopConfig.luau` | Shop definitions (items, prices, requirements) — **UNAPPROVED** |
| `Config/GhostConfig.luau` | Ghost stats, damage values, spawn counts — **UNAPPROVED** |
| `Config/MiningConfig.luau` | Ore hit requirements, respawn times, distances — **UNAPPROVED** |
| `Config/DayNightConfig.luau` | Day/night cycle timing, lighting values — **UNAPPROVED** |
| `Types/EconomyTypes.luau` | Currency, Inventory, PlayerData, TransactionResult |
| `Types/GhostTypes.luau` | GhostRuntimeData, GhostTemplate, AbsorptionResult |
| `Types/MiningTypes.luau` | OreRuntimeData, MiningResult, HitValidation |
| `Types/ProgressionTypes.luau` | StoryFlags, QuestProgress, DayState |
| `Types/NetworkTypes.luau` | RemoteEvent payloads, validation schemas |
| `Constants/RemoteNames.luau` | Single source of truth for all RemoteEvent/Function names |
| `Constants/StatNames.luau` | Leaderstat and IntValue names |
| `Constants/ToolNames.luau` | Tool identifiers used across client/server |
| `Utilities/Signal.luau` | Typed event wrapper (like RBXScriptSignal but for Luau) |
| `Utilities/TableUtil.luau` | Table manipulation helpers (deepCopy, merge, etc.) |
| `Utilities/MathUtil.luau` | Math helpers (clamp, lerp, randomRange, etc.) |

### Remotes (ReplicatedStorage.Remotes)

| Module | Responsibility |
|--------|----------------|
| `RemoteEvents.luau` | All RemoteEvent declarations with typed payloads |
| `RemoteFunctions.luau` | All RemoteFunction declarations with typed payloads |

### Server Services (ServerScriptService.Services)

| Service | Responsibility | Dependencies |
|---------|----------------|--------------|
| `PlayerService` | Character init, health (200), scale (2×), speed (32), pouch | None |
| `EconomyService` | 5 currencies, bag limit (10), transactions, leaderstats | PlayerService |
| `InventoryService` | Tool ownership, equipped state, capacity validation | EconomyService |
| `ShopService` | 7 shops, purchase validation, ownership guards, distance checks | EconomyService, InventoryService |
| `PersistenceService` | DataStore schema v1, load/save/autosave, session locking | EconomyService, InventoryService |

### Server Systems (ServerScriptService.Systems)

| System | Responsibility | Dependencies |
|--------|----------------|--------------|
| `MiningService` | Ore state, hit tracking, rewards, 150s respawn, tool validation | EconomyService, InventoryService |
| `ScrapService` | Per-player scrap state, collection, day respawn, selling | EconomyService |
| `GhostService` | Spawn 26+3, AI, single damage authority, absorption, energy rewards | EconomyService, DayNightService |
| `DayNightService` | 100-day cycle, 25s/day, lighting, audio, day 20/100 triggers | GhostService, CutsceneService |
| `NPCService` | 5 NPCs, dialogue queues, typewriter, story flags | None |
| `CutsceneService` | Reusable camera/dialogue/fade controller, Alice + Mine sequences | DayNightService, NPCService |
| `BossService` | Dreadon activation, energy transfer, fight state, defeat condition | EconomyService, GhostService, CutsceneService |

### Client Controllers (StarterPlayer.StarterPlayerScripts.Controllers)

| Controller | Responsibility |
|------------|----------------|
| `HUDController` | All currency/bag/day/energy display |
| `MiningController` | SelectionBox, raycast, progress UI |
| `ShopController` | Shop UI, purchase requests |
| `DialogueController` | Typewriter dialogue display |
| `CutsceneController` | Camera, fade, input locking |
| `BossController` | Boss dialogue, health bar, effects |
| `GhostController` | Client ghost effects (glow, sounds) |

### UI Interfaces (StarterGui.Interfaces)

| Interface | Purpose |
|-----------|---------|
| `CoinGui` | Coins, Silver, Baguerite, Scrap, Bag count |
| `DayGui` | Day counter |
| `GhostEnergyGui` | Ghost Energy display |
| `DialogueGui` | NPC dialogue with typewriter |
| `BossDialogueGui` | Boss dialogue + fade |
| `MineCutsceneGui` | Mine cutscene title/fade |
| `MiningProgressGui` | Mining hit progress indicator |

## Initialization Order

```
Bootstrap.server.luau
├── 1. PersistenceService (load player data)
├── 2. PlayerService (character setup)
├── 3. EconomyService (leaderstats from loaded data)
├── 4. InventoryService (tool ownership from loaded data)
├── 5. ShopService (register shops)
├── 6. DayNightService (start cycle)
├── 7. GhostService (initial spawn)
├── 8. MiningService (register ores)
├── 9. ScrapService (register scrap)
├── 10. NPCService (register NPCs)
├── 11. CutsceneService (ready)
├── 12. BossService (ready)
└── 13. Signal PlayerDataLoaded to client

Bootstrap.client.luau
├── 1. Wait for PlayerDataLoaded
├── 2. Initialize all Controllers
└── 3. Connect RemoteEvent handlers
```

## Client/Server Boundaries

| Direction | Pattern |
|-----------|---------|
| Server → Client | RemoteEvent (fire-and-forget for UI/cosmetics) |
| Client → Server | RemoteEvent with **full validation** (never trust client) |
| Server ↔ Server | Module function calls (no network) |
| Client ↔ Client | Not used (no client-to-client) |

**Validation Rule:** Every client→server remote validates **all** preconditions on server. Server never trusts client-submitted currency, ownership, damage, or progression.

## Data Flow

```
PlayerData (persisted)
    │
    ├── EconomyService ──► leaderstats (Coins, Silver, Baguerite, Scrap)
    ├── InventoryService ──► Tool ownership, equipped state
    ├── GhostService ◄─── GhostEnergy (IntValue on player)
    ├── DayNightService ◄─── CurrentDay (IntValue in ReplicatedStorage)
    ├── MiningService ◄─── Ore states (server-only)
    ├── ScrapService ◄─── Scrap states (server-only)
    └── BossService ◄─── BossEnergy, BossBattleActive (ReplicatedStorage)
```

## Session Locking (Persistence)

```
Player_{UserId}          → PlayerData (schema v1)
Player_{UserId}_lock     → {ownerJobId, expiresAt}
```

- Lock acquired on `PlayerAdded` via `UpdateAsync` compare-and-swap
- Renewed every 25 minutes (30 min TTL)
- Released on `PlayerRemoving` after save
- Expired locks atomically claimed via `UpdateAsync`
- `BindToClose` saves all active players with 30s timeout

## Configuration Philosophy

**All balance values are UNAPPROVED** until explicitly reviewed. Config modules export tables with clear documentation of original values vs recommendations. No hardcoded magic numbers in service/system code.