# MIDNIGHT HARVEST — REBUILD MASTER PLAN

**Prepared:** 2026-11-10  
**Status:** Milestone 0 — Discovery complete, ready for review  
**Original repo:** https://github.com/Sripranav12c7/Midnight-Harvest (cloned at `/tmp/opencode/mh-original`)  
**Audit sources:** `Midnight-Harvest-ANALYSIS.md`, `Midnight-Harvest-PROJECT-STATUS.md` (both in `~/DevProjects/`)  
**Extracted scripts:** `~/DevProjects/Midnight-Harvest-analysis/real/scripts/` (755 files extracted from `the real one.rbxl`)

---

## 1. PROJECT OVERVIEW

Midnight Harvest is a supernatural survival/mining/progression Roblox game. The player explores a village, mines ores by day, fights ghosts at night, absorbs them for Ghost Energy, powers up a boss (Dreadon), and reaches an ending at day 100.

**Core loop:** Mine → Sell → Buy gear → Survive night → Absorb ghosts → Feed Dreadon → Boss fight → Ending.

**Original state:** Single `.rbxl` place file (3.1 MB, SHA-256: `64e469d5810811e4b01cbf2bb4b4e25757beb1ffce37c3e1c5c03c55693fbe74`), 60,821 instances, 755 script instances. No Rojo, no modules, no tests, **no persistence**. Built as beginner-style top-down scripts reaching into Workspace/ReplicatedStorage by name.

**Goal:** Rebuild from scratch as a modular, server-authoritative, Rojo-compatible project with full persistence, clean architecture, and single-player stability first.

---

## 2. ORIGINAL GAME ANALYSIS (VERIFIED FROM SOURCE)

### 2.1 Script Inventory — Discrepancy Noted

| Metric | Audit Report (ANALYSIS.md) | Independent Extraction (SHA-256 of 755 files) | Notes |
|--------|---------------------------|-----------------------------------------------|-------|
| Total script instances | 755 | 755 | **Match** |
| Unique script bodies (all) | 196 | 196 | **Match** |
| Unique non-asset gameplay scripts | 156 | 136* | **Discrepancy: 20 bodies** |
| Unique non-empty bodies | 151 | — | Audit classification not reproduced |
| Scripts line-by-line inspected | 78 | 78 | **Match** (17 SSS + 7 Player + 8 Gui + 1 Pack + 45 Workspace) |
| Scripts classified only (unique bodies) | — | 58 | Extraction: 136 gameplay bodies − 78 inspected = 58 unique bodies classified only. Audit: 156 gameplay scripts − 78 inspected = 78 scripts classified only (counts instances, not unique bodies). **Not directly comparable — see reconciliation below.** |

\* **Extraction classification method:** Automated regex filter for toolbox/asset patterns (Animate, qPerfectionWeld, PackageLink, TextureConfiguration, Constant, qTexture, Cart Ride map, Cave decor, fan/TV/door scripts, M16A4 gun scripts, etc.). 60 bodies classified as toolbox/asset, 136 as gameplay.

\** **Discrepancy explanation:** The audit's "156 unique non-asset gameplay scripts" and "151 unique non-empty bodies" use a classification method not reproduced by the automated filter. The 20-body difference likely represents scripts in a gray area (e.g., tool swing animations, campfire effects, fan motors, bullet visualizers) that the audit counted as gameplay but the filter caught as toolbox/asset. **Neither count is labeled verified** until the audit's classification method is reproduced or the discrepancy is resolved.

\*** **Script-classification arithmetic reconciliation:**
    - **156 (audit "gameplay scripts"):** Reported in `ANALYSIS.md` §3 Coverage Ledger as "Unique non-asset gameplay scripts". Methodology not documented; appears to be a manual or semi-automated classification that treats certain toolbox-adjacent scripts (tool swing LocalScripts, campfire/fan motor scripts, bullet visualizers) as gameplay because they belong to tools/models used in gameplay.
    - **136 (extraction "gameplay bodies"):** SHA-256 unique bodies after automated regex filter. Filter removes any script whose path matches toolbox patterns (Animate, qPerfectionWeld, PackageLink, TextureConfiguration, Constant, qTexture, Cart Ride, Cave decor, fan/TV/door, M16A4, bullet/gun visualizers, motor controllers, water/TV sounds). 60 bodies removed → 136 remain.
    - **78 (line-by-line inspected):** Scripts fully read by human during audit — 17 SSS + 7 StarterPlayer + 8 StarterGui + 1 StarterPack + 45 Workspace. All 78 are drawn from the 136 extraction-gameplay set.
    - **118 (classified only):** The remaining unique gameplay bodies not inspected line-by-line.
      - Extraction view: 136 gameplay bodies − 78 inspected = 58 unique bodies classified only.
      - Audit view: 156 gameplay scripts − 78 inspected = 78 scripts classified only.
      - **The 58 vs 78 difference reflects methodology, not a missing set.** "Scripts" in the audit counts instances (a body duplicated across 4 Workspace Axes counts 4×); "bodies" in extraction counts unique hashes (those 4 Axes share 1 body → count 1×). The 118 figure in the previous table ("Scripts classified only") conflated unique bodies with instance counts. **Correct reconciliation:**
        - 78 unique bodies inspected line-by-line.
        - 58 unique bodies classified only (extraction: 136 − 78).
        - 20-body gap between audit (156) and extraction (136) = gray-area scripts counted as gameplay by audit but filtered out by extraction.
    - **Do not claim all 755 scripts were inspected line by line.** Only 78 unique bodies were. The remaining 118 unique bodies (58 extraction + 60 toolbox) were classified automatically.

### 2.2 Verified Instance Counts (from hierarchy.txt + manifest.json)

| Metric | Count | Source |
|--------|-------|--------|
| Total instances (excl. DataModel) | 60,820 | manifest.json |
| Script instances | 755 | manifest.json (Script: 479, LocalScript: 120, ModuleScript: 156) |
| Unique script bodies (all) | 196 | SHA-256 of 755 extracted files |
| Non-empty sources | 750 | manifest.json (5 empty) |
| Scripts line-by-line inspected | **78** | 17 SSS + 7 Player + 8 Gui + 1 Pack + 45 Workspace |
| Scripts classified only (extraction) | **58** | 136 gameplay bodies - 78 inspected |

### 2.3 Verified Gameplay Systems (from 78 inspected scripts + hierarchy)

| System | Original Implementation | Verified Status | Key Issues (Verified) |
|--------|------------------------|-----------------|----------------------|
| Day/Night | `SSS/Time` (48 lines) | Working | 100 days × 25s = 41 min; `CurrentDay` created at runtime, not saved |
| Currency | `SSS/Coins` + `SSS/Script` (GhostEnergy) | Working | 5 resources, no persistence, starting 500 Coins |
| Bag Limit | Duplicated in MiningScript/ScrapCollector/LootText | Working | MAX_ITEMS=10 (Silver+Baguerite+Scrap); Coins excluded |
| Mining | `SSS/MiningScript` + `WoodPick/MiningLocal` | **Partial** | Server validates ore name + distance; **no tool check** (exploitable) |
| Ore Respawn | 150s delay in MiningScript | Working | Hidden via Parent=nil |
| Scrap | `Workspace/Scarps/ScrapCollector` | **Partial** | Per-player state is **global** (first player takes it for all) |
| Selling | MineExchanger (50/25) + ScrapCollector (20) | Working | Server-authoritative, no validation gaps |
| Shops | 11 scripts (SSS + Workspace) | **Partial** | 2 broken (AxeTool/HammerTool missing), 2 unguarded (WoodPick, Coconut), 4-6× duplicates each |
| Ghosts | 3 damage paths, 2 absorption paths, respawn | **Broken** | 29→25 population loss; conflicting damage (15/25/10); tool typo (GhostVaccumShop vs GhostVacuum) |
| Ghost Energy | 0 (SSS/GhostAbsorbtion) or 20/50 (per-ghost) | **Conflicting** | Paid tool grants nothing; free tool grants energy |
| Boss (Dreadon) | ProximityPrompt → BossEnergy, Head triggers at 20 | **Broken** | BossEnergyRequired=20000 but trigger=20; no defeat state; BGM never stops; unvalidated RemoteEvent |
| Alice Cutscene | SSS + Client scripts | Working | Fires at day 20, spawns Alice |
| Mine Cutscene | StarterPlayerScripts/MineCutscene | **Dead** | Waits for non-existent `AliceCutsceneFinished` remote |
| NPC Dialogue | 5 Workspace NPCs | Working | Typewriter, no quest gating |
| HUD | 8 LocalScripts polling IntValues | Working | Duplicate GhostEnergyGui; Baguerite shown as "Bronze" |
| Player Health | StarterPlayerScripts/PlayerHealth | **Broken** | Looks for Humanoid in script.Parent (never exists) |
| Player Size | SSS/PlayerSize | Working | 2× scale, 32 WalkSpeed |
| Persistence | **None** | **Missing** | 0 DataStoreService references in any script |

### 2.4 Verified Asset Inventory (from hierarchy.txt)

**Ores:** 8 Silver Ore, 11 Baguerite (19 total)  
**Ghosts (initial world — VERIFIED):** 26 Ghost + 3 Deep Ghost = 29 total  
**GhostBackup (templates — VERIFIED):** 23 Ghost + 2 Deep Ghost = 25 total  
**Ghost respawn behavior:** **UNRESOLVED** — original `GhostRespawn` clones GhostBackup (23+2) on every day change, causing population drift from 29→25. Intended respawn population not documented.  
**Chests:** 4 (each with 4 Script children = 16 total scripts; two implementations → double payout)  
**NPCs with dialogue:** 5 (Arwin/Shopkeeper, Barn Keeper, Murugesan/Villager, Old Miner/Mine Worker, The Older/Old Villager)  
**Alice:** ServerStorage/Alice (cloned at day 20)  
**Dreadon:** Workspace/Dreadon (boss model)  
**Shop Tools in Workspace (duplicates):** Axe×5, Bandage×5, Bat×5, Gun×5, TrenchGun×5, Guestium Scythe×5, WoodPick×5, CoconutDrink×6, Hammer×5, M16A4×1  
**Shop Tools in ServerStorage (templates):** Axe, Bandage, Bat, BronzeOre, CoconutDrink, GhostSounds, GhostStorage, GhostVacuum, Guestium Scythe, Gun, Hammer, LootPouch, Medikit, RBX_ANIMSAVES, ScrapStorage, SilverSword, SwordShop, TrenchGun, WoodPick  
**ScreenGuis:** BossDialogueGui, CoinGui (CoinText, LootText, SilverText/BagueriteText), DayGui, DialogueGui, GhostEnergyGui (×2 LocalScripts), MineCutsceneGui, fps_counter×4 (toolbox)  
**Sounds:** 117 total; key ones: BossBattleBGM, ChickenMorning, BirdsMorning, PickupSound, SellSound, MiningHitSound, various tool sounds, ghost ScreamSound

---

## 3. ASSET PRESERVATION PLAN

### 3.1 Preserve As-Is (migrate to ServerStorage/Templates) — REQUIRES VISUAL & FUNCTIONAL INSPECTION

| Asset | Purpose | Destination | **Inspection Required** |
|-------|---------|-------------|-------------------------|
| All ServerStorage tools (Axe, Bat, CoconutDrink, GhostVacuum, Guestium Scythe, Gun, Hammer, TrenchGun, WoodPick, Bandage, Medikit, SilverSword, LootPouch) | Shop rewards, starter items | `ServerStorage/Tools/` | **Yes** — verify models, animations, sounds, stats, grip |
| GhostBackup models (23 Ghost, 2 Deep Ghost) | Respawn templates | `ServerStorage/Templates/Ghosts/` | **Yes** — verify appearance, animations, hitboxes, walk speed |
| Alice (ServerStorage) | Day 20 cutscene NPC | `ServerStorage/Templates/Alice/` | **Yes** — verify model, AI, animations |
| ScrapMetal template | Scrap respawning | `ServerStorage/Templates/ScrapMetal/` | **Yes** — verify model, ProximityPrompt |
| Ore models (Silver Ore, Baguerite) | Mining targets | `ServerStorage/Templates/Ores/` | **Yes** — verify models, hitboxes |
| Dreadon model + sounds | Boss fight | `ServerStorage/Templates/Boss/` | **Yes** — verify model, animations, fire effects, sounds |
| EnvironmentSounds (ChickenMorning, BirdsMorning) | Day/night audio | `ServerStorage/Templates/EnvironmentSounds/` | **Yes** — verify SoundIds valid |
| DialogueGui structure | NPC/boss dialogue UI | `StarterGui/Interfaces/DialogueGui` | **Yes** — verify layout, fonts, scaling |
| CoinGui, DayGui, GhostEnergyGui, BossDialogueGui, MineCutsceneGui | HUD | `StarterGui/Interfaces/` | **Yes** — verify layout, positions, fonts |
| BossBattleBGM | Boss music | `SoundService/` | **Yes** — verify SoundId, volume, looping |

### 3.2 Remove / Do Not Migrate

| Asset | Reason |
|-------|--------|
| All duplicate placed tools in Workspace (Axe×5, Bandage×5, Bat×5, Gun×5, TrenchGun×5, Guestium Scythe×5, WoodPick×5, CoconutDrink×6, Hammer×5, M16A4×1) | Duplicate purchase handlers; keep 1 template in ServerStorage |
| 3 of 4 Chest models (keep 1) | Duplicate chest scripts cause double payout |
| M16A4 (full assault rifle with 5 remotes) | No purchase path, toolbox leftover |
| Abandoned House (fan, TV, sink, door scripts) | Decorative toolbox content, no gameplay role |
| Cart Ride Rail map ×36 | Toolbox map kit, unrelated |
| Cave ×31, Realistic Tree ×38, Wall ×38, Dirt ×69, etc. | Decorative parts, no scripts — **keep geometry only if needed for map layout** |
| `shopitems` empty folder, `SwordShop` 0-byte script, `SSS/Scrap System` print-only | Dead content |
| `Animate` LocalScript at Workspace root | LocalScripts don't run in Workspace |
| `fps_counter` ×4 ScreenGuis | Toolbox debug UI |

### 3.3 Redesign Required (New Implementation)

| System | Why |
|--------|-----|
| Ghost architecture | 3 damage paths + 2 absorption paths + population drift (29→25) |
| Shop system | Duplicate handlers, missing items (AxeTool/HammerTool), inconsistent guards |
| Mining validation | No server-side tool check (exploitable) |
| Boss fight | No defeat state, wrong trigger threshold (20 vs 20000), unvalidated remote |
| Cutscene system | Dead Mine cutscene (missing remote), no reusable controller |
| Persistence | Entirely missing — **must be designed into Milestone 1 foundation** |
| NPC dialogue | No quest/story gating |
| HUD | Duplicate scripts, inconsistent naming (Bronze vs Baguerite) |

---

## 4. GAMEPLAY SYSTEM INVENTORY (Rebuild Targets)

| System | Module Name | Responsibility | **Status** |
|--------|-------------|----------------|------------|
| **PlayerService** | `Services/PlayerService` | Character init, health (200 MaxHealth), scale (2×), speed (32), death/respawn, pouch attachment | **New design** |
| **EconomyService** | `Services/EconomyService` | Server-authoritative Coins/Silver/Baguerite/Scrap/GhostEnergy; bag limit (10); transactions; persistence | **Refactor** (from Coins, Script) |
| **InventoryService** | `Services/InventoryService` | Tool ownership, equipment state, capacity validation | **New design** |
| **ShopService** | `Services/ShopService` | All 7 shops; price config; purchase validation; ownership guards; distance checks | **Refactor** (from 11 scripts) |
| **MiningService** | `Systems/MiningService` | Ore state, hit tracking, rewards, respawn (150s), **tool requirement validation** | **Refactor** (from MiningScript) |
| **ScrapService** | `Systems/ScrapService` | Per-player scrap state, collection, respawning on day change, selling | **Refactor** (from ScrapCollector) |
| **GhostService** | `Systems/GhostService` | Spawn 26 Ghost + 3 Deep Ghost initially (**verified world counts**), AI (chase/visibility), **single damage authority**, absorption (single path, GhostVacuum), energy rewards, respawn behavior **UNRESOLVED** (GhostBackup=23+2, world=26+3 — intended respawn population not documented) | **Refactor** (from ghost, GhostAbsorbtion, GhostRespawn, per-ghost scripts) |
| **DayNightService** | `Systems/DayNightService` | 100-day cycle, 25s/day (10d/15n), lighting, audio, event triggers (day 20, day 100) | **Refactor** (from Time) |
| **NPCService** | `Systems/NPCService` | 5 NPCs, dialogue queues, typewriter, story flags | **Refactor** (from 5 NPC scripts) |
| **CutsceneService** | `Systems/CutsceneService` | Reusable camera/dialogue/fade controller; Alice + Mine sequences; mutual exclusion | **New design** |
| **BossService** | `Systems/BossService` | Dreadon activation (validated), energy transfer, fight state, **defeat condition**, BGM, cleanup | **Refactor** (from Dreadon scripts) |
| **PersistenceService** | `Services/PersistenceService` | DataStore schema v1, load/save/autosave, session locking, retry/backoff | **New design** (Milestone 1 skeleton) |
| **UI Controllers** | `Controllers/` | HUD, Mining progress, Shop UI, Dialogue UI, Boss UI, Cutscene UI | **Refactor** (from 8 LocalScripts) |

---

## 5. PROPOSED ARCHITECTURE

```
MidnightHarvest/
├── default.project.json
├── README.md
├── .gitignore
├── aftman.toml
├── selene.toml
├── stylua.toml
├── docs/
│   ├── ARCHITECTURE.md
│   ├── GAME_DESIGN.md
│   ├── SYSTEMS.md
│   ├── PROGRESSION.md
│   ├── TEST_PLAN.md
│   ├── BUGS.md
│   └── CHANGELOG.md
├── src/
│   ├── ReplicatedStorage/
│   │   ├── Shared/
│   │   │   ├── Config/
│   │   │   │   ├── GameConfig.luau          -- All tunables (prices, damages, timings, limits) — **UNAPPROVED**
│   │   │   │   ├── ShopConfig.luau
│   │   │   │   ├── GhostConfig.luau
│   │   │   │   ├── MiningConfig.luau
│   │   │   │   └── DayNightConfig.luau
│   │   │   ├── Types/
│   │   │   │   ├── EconomyTypes.luau        -- Currency, Inventory, PlayerData
│   │   │   │   ├── GhostTypes.luau
│   │   │   │   ├── MiningTypes.luau
│   │   │   │   ├── ProgressionTypes.luau
│   │   │   │   └── NetworkTypes.luau
│   │   │   ├── Constants/
│   │   │   │   ├── RemoteNames.luau         -- Single source of truth for all RemoteEvent/Function names
│   │   │   │   ├── StatNames.luau
│   │   │   │   └── ToolNames.luau
│   │   │   └── Utilities/
│   │   │       ├── Signal.luau              -- Simple typed event wrapper
│   │   │       ├── TableUtil.luau
│   │   │       └── MathUtil.luau
│   │   └── Remotes/
│   │       ├── RemoteEvents.luau            -- Server→Client, Client→Server declarations
│   │       └── RemoteFunctions.luau
│   ├── ServerScriptService/
│   │   ├── Bootstrap.server.luau            -- Service initialization order
│   │   ├── Services/
│   │   │   ├── PlayerService.server.luau
│   │   │   ├── EconomyService.server.luau
│   │   │   ├── InventoryService.server.luau
│   │   │   ├── ShopService.server.luau
│   │   │   └── PersistenceService.server.luau
│   │   └── Systems/
│   │       ├── MiningService.server.luau
│   │       ├── ScrapService.server.luau
│   │       ├── GhostService.server.luau
│   │       ├── DayNightService.server.luau
│   │       ├── NPCService.server.luau
│   │       ├── CutsceneService.server.luau
│   │       └── BossService.server.luau
│   ├── ServerStorage/
│   │   ├── Assets/                          -- Migrated from original ServerStorage
│   │   ├── Tools/                           -- Tool templates (Axe, Bat, etc.)
│   │   └── Templates/
│   │       ├── Ghosts/
│   │       ├── Ores/
│   │       ├── ScrapMetal/
│   │       ├── Alice/
│   │       ├── Boss/
│   │       └── EnvironmentSounds/
│   ├── StarterPlayer/
│   │   └── StarterPlayerScripts/
│   │       ├── Bootstrap.client.luau
│   │       └── Controllers/
│   │           ├── HUDController.client.luau
│   │           ├── MiningController.client.luau
│   │           ├── ShopController.client.luau
│   │           ├── DialogueController.client.luau
│   │           ├── CutsceneController.client.luau
│   │           ├── BossController.client.luau
│   │           └── GhostController.client.luau
│   └── StarterGui/
│       └── Interfaces/
│           ├── CoinGui.luau
│           ├── DayGui.luau
│           ├── GhostEnergyGui.luau
│           ├── DialogueGui.luau
│           ├── BossDialogueGui.luau
│           ├── MineCutsceneGui.luau
│           └── MiningProgressGui.luau
└── tests/
    ├── EconomyService.test.luau
    ├── MiningService.test.luau
    ├── GhostService.test.luau
    ├── ShopService.test.luau
    └── PersistenceService.test.luau
```

**Key architectural principles:**
- **Server-authoritative:** All gameplay decisions (currency, mining, ghost absorption, boss) on server
- **Single RemoteEvent per action:** Declared in `RemoteNames.luau`, no stringly-typed `WaitForChild`
- **Explicit initialization:** `Bootstrap.server.luau` defines service load order
- **Config-driven:** All balance values in `Config/` modules, not hardcoded — **all UNAPPROVED**
- **No `_G`, no globals:** Dependency injection via service registry
- **Type safety:** `--!strict` on all modules; shared types in `ReplicatedStorage.Shared.Types`
- **Testable:** Pure logic in modules, Roblox API at boundaries
- **Single-player first:** No multiplayer-specific code in Milestones 1–5; per-player tables used throughout
- **Player/world separation:** Player currencies, inventory, story flags, and progression are per-player (stored in PlayerData). Shared world state (day/night cycle, ghost population, boss state) is managed by server Systems and explicitly separated from PlayerData. One player's progression never modifies another player's data.

---

## 6. DATA MODEL

### 6.1 PlayerData (persisted — schema v1)

```luau
export type PlayerData = {
    -- Currency (verified starting values)
    coins: number,           -- Start 500
    silver: number,          -- Start 0
    baguerite: number,       -- Start 0 (shown as "Bronze" in original UI — **unapproved rename**)
    scrap: number,           -- Start 0
    ghostEnergy: number,     -- Start 0

    -- Inventory/Progression
    ownedTools: { [string]: boolean },    -- ToolName -> owned
    equippedTool: string?,                -- Currently equipped tool name
    purchasedAttributes: { [string]: boolean }, -- e.g. Bat, Scythe ownership flags

    -- World progression
    currentDay: number,        -- 1–100 (per-player — **unapproved decision**)
    storyFlags: { [string]: boolean },  -- e.g. aliceCutsceneSeen, mineCutsceneSeen, bossDefeated
    questProgress: { [string]: number }, -- NPC dialogue progress

    -- Meta
    schemaVersion: number,     -- 1
    lastSaved: number,         -- os.time()
}
```

### 6.2 Server-Side Runtime State (not persisted)

```luau
export type ServerRuntimeState = {
    -- Day/night
    currentDay: number,
    isNight: boolean,

    -- Ghosts
    ghostPopulation: { [Model]: GhostRuntimeData },
    ghostBackup: { GhostTemplate, DeepGhostTemplate },

    -- Mining
    oreStates: { [Model]: OreRuntimeData }, -- hits, respawnTask, originalCFrame

    -- Scrap
    scrapStates: { [Model]: ScrapRuntimeData }, -- collectedBy: { [Player]: boolean }

    -- Boss
    bossEnergy: number,
    bossBattleActive: boolean,
    bossDefeated: boolean,

    -- Cutscenes
    activeCutscene: string?,
}
```

### 6.3 ReplicatedStorage Values (for client observation)

| Name | Type | Purpose |
|------|------|---------|
| CurrentDay | IntValue | Day counter (1–100) |
| IsNight | BoolValue | Current phase |
| BossEnergy | IntValue | World boss energy (0–20000) |
| BossEnergyRequired | IntValue | 20000 (configurable — **unapproved threshold**) |
| BossBattleActive | BoolValue | Boss fight state |
| AliceCutsceneEvent | RemoteEvent | S→C: start Alice cutscene |
| AliceRevealEvent | RemoteEvent | S→C: Alice spawned |
| MineCutsceneEvent | RemoteEvent | S→C: start Mine cutscene |
| MineCutsceneFinished | RemoteEvent | C→S: mine cutscene done (**NEW** — was missing) |
| BossDialogueEvent | RemoteEvent | S→C: show boss dialogue |
| BossFightStart | RemoteEvent | C→S: request boss fight (validated) |
| BossFinalEvent | BindableEvent | Server-internal: boss triggered |
| MineOre | RemoteEvent | C→S: mine ore (validated) |
| ShopPurchase | RemoteEvent | C→S: buy item (validated) |
| ShopPurchaseResult | RemoteEvent | S→C: purchase success/fail |
| GhostAbsorb | RemoteEvent | C→S: absorb ghost (validated) |
| ScrapCollect | RemoteEvent | C→S: collect scrap (validated) |
| ScrapSell | RemoteEvent | C→S: sell scrap (validated) |
| OreSell | RemoteEvent | C→S: sell ore (validated) |
| DialogueStart | RemoteEvent | S→C: show NPC dialogue |
| PlayerDataLoaded | RemoteEvent | S→C: initial data + updates |
| DataUpdate | RemoteEvent | S→C: incremental updates |

---

## 7. REMOTE ARCHITECTURE

**Principle:** Every client→server remote validates **all** preconditions on server. Server→client remotes are fire-and-forget for UI/cosmetics.

| Remote | Direction | Validation (Server) | **Status** |
|--------|-----------|---------------------|------------|
| `MineOre` | C→S | Player has WoodPick equipped, ore exists in workspace, distance ≤ 12 studs, ore not mined, bag not full, cooldown not active | **New validation** (original had no tool check) |
| `ShopPurchase` | C→S | Shop exists, player at prompt (distance), sufficient coins, not already owned (where applicable), tool template exists | **Refactored** (consolidated) |
| `GhostAbsorb` | C→S | Player has GhostVacuum equipped, ghost is dead, prompt exists, not already absorbed | **New validation** (original had conflicting paths) |
| `ScrapCollect` | C→S | Scrap exists, not collected by this player, bag not full, distance check | **Refactored** (per-player state) |
| `ScrapSell` | C→S | Player at Scrap Collector, has scrap > 0 | **Preserved** |
| `OreSell` | C→S | Player at MineExchanger, has silver/baguerite > 0 | **Preserved** |
| `BossFightStart` | C→S | BossEnergy ≥ requiredThreshold, boss exists, not already active, player progression valid | **New validation** (original unvalidated) |
| `BossEnergyTransfer` | C→S | Player at Dreadon prompt, has GhostEnergy > 0, transfer ≤ remaining capacity | **Refactored** |

**Rate limiting:** Per-player debounce (0.5s) on all C→S remotes via `EconomyService` / `MiningService` internal cooldowns.

---

## 8. SECURITY MODEL

| Threat | Mitigation | **Status** |
|--------|------------|------------|
| Currency manipulation | All currency changes through `EconomyService` server methods; client never sets IntValues | **New** |
| Mining exploit (no tool) | `MineOre` validates equipped WoodPick + distance + cooldown | **New** (fixes verified exploit) |
| Ghost energy duplication | Single absorption path; ghost destroyed on absorb; server grants energy once | **New** (fixes verified conflict) |
| Boss trigger abuse | `BossFightStart` requires actual energy transfer + boss presence + progression flag | **New** (fixes verified exploit) |
| Duplicate purchases | `ShopService` tracks ownership per player; server checks before charging | **Refactored** |
| Chest double payout | Single chest template with per-player state; no duplicate scripts | **New** (fixes verified bug) |
| Ghost population drift | GhostBackup (23+2) ≠ initial world (26+3) — **respawn behavior UNRESOLVED**, design decision required | **New** (fixes verified drift) |
| Data loss on leave | `PersistenceService` saves on PlayerRemoving + autosave (60s) + session locking | **New** |
| Data corruption | Schema versioning; validation on load; backup on mismatch | **New** |
| Stuck states | All services clean up on PlayerRemoving; cutscenes have timeouts; boss has defeat condition | **New** |

---

## 9. TESTING STRATEGY

### 9.1 Test Classification

| Test Type | Runnable on Ryoku Arch Linux | Requires Roblox Studio | Status |
|-----------|------------------------------|------------------------|--------|
| `selene` lint | ✅ | ❌ | **Not executed** |
| `stylua --check` | ✅ | ❌ | **Not executed** |
| `luau-analyze --strict` | ⚠️ (if installed via aftman) | ❌ | **Not executed** |
| Unit tests (TestEZ) | ❌ | ✅ | **Not executed** |
| Rojo build (`rojo build`) | ✅ | ❌ | **Not executed** |
| Integration tests | ❌ | ✅ | **Not executed** |
| Playthrough test | ❌ | ✅ | **Not executed** |

**Critical:** Rojo builds and static analysis **do not prove Roblox runtime correctness**. All tests requiring Studio are **unverified until executed**.

### 9.2 Unit Tests (TestEZ — require Studio — all unexecuted, unverified)
| Module | Test Cases |
|--------|------------|
| EconomyService | Add/remove currency, bag limit, transactions, persistence round-trip |
| MiningService | Hit counting, rewards, respawn timing, tool validation, bag full |
| ScrapService | Per-player collection, respawn on day change, selling |
| GhostService | Spawn count (23+3), damage application, absorption rewards, respawn population |
| ShopService | Price validation, ownership guards, duplicate prevention, distance |
| DayNightService | Cycle timing, day 20/100 triggers, lighting values |
| NPCService | Dialogue queue, typewriter timing, story flags |
| CutsceneService | Camera control, fade, sequencing, cancellation, restoration |
| BossService | Energy transfer, activation threshold, fight state, defeat, cleanup |
| PersistenceService | Save/load, schema migration, retry, session lock, corruption recovery |

### 9.3 Integration Tests (require Studio — unexecuted, unverified)
- Full day/night cycle with ghost spawn/despawn
- Mining → Sell → Buy → Mine loop
- Day 20 Alice cutscene + Mine cutscene mutual exclusion
- Ghost kill → Absorb → Energy → Dreadon → Boss fight → Victory
- Rejoin with saved data restores all currency, tools, day, story flags

### 9.4 Playthrough Test (Milestone 8 — require Studio — unexecuted, unverified)
- New game → Day 100 completion without errors
- All HUD elements update correctly
- No memory leaks (connections cleaned on leave)
- Performance: < 30ms frame on mid-tier hardware

---

## 10. MILESTONE IMPLEMENTATION PLAN

### Milestone 0 — Discovery & Design ✅ **COMPLETE**
- [x] Inspect original repo, audit docs, extracted scripts
- [x] Document systems, bugs, assets with verified counts
- [x] Identify script count discrepancy (156 vs 136 gameplay bodies)
- [x] Produce this REBUILD_MASTER_PLAN.md

### Milestone 1 — Foundation (Persistence skeleton only)
- [ ] Initialize git repo in `Midnight-Harvest-Rebuilt/`
- [ ] Create `default.project.json` (Rojo 7.x)
- [ ] Add `aftman.toml` (selene, stylua, luau-lsp if available)
- [ ] Add `selene.toml`, `stylua.toml`
- [ ] Write `src/ReplicatedStorage/Shared/Config/GameConfig.luau` (all tunables — **UNAPPROVED**)
- [ ] Write `src/ReplicatedStorage/Shared/Types/` (all type definitions including PlayerData schema v1)
- [ ] Write `src/ReplicatedStorage/Shared/Constants/RemoteNames.luau` + `StatNames.luau` + `ToolNames.luau`
- [ ] Write `src/ReplicatedStorage/Remotes/RemoteEvents.luau` (declarations only)
- [ ] Write `src/ServerScriptService/Bootstrap.server.luau` (service load order)
- [ ] Write `src/StarterPlayer/StarterPlayerScripts/Bootstrap.client.luau`
- [ ] Implement `PlayerService` (character init, health=200, scale=2, speed=32, pouch)
- [ ] Implement `EconomyService` (leaderstats, 5 currencies, bag limit, transactions — **no persistence dependency**)
- [ ] Implement `InventoryService` (tool ownership, equipped state — **no persistence dependency**)
- [ ] Implement `PersistenceService` **SKELETON ONLY** (design around `DataStore.UpdateAsync`):
  - DataStore key format: `Player_{UserId}` (data), `Player_{UserId}_lock` (session lock)
  - Schema v1 definition (PlayerData type)
  - **Session lock lifecycle (design only, stubbed for Milestone 1):**
    1. **PlayerAdded — acquire lock:** `UpdateAsync(lockKey, fn)` where fn returns `{ownerJobId = game.JobId, expiresAt = os.time() + 1800}` iff current value is nil OR `expiresAt < os.time()` (expired). Returns success + lock data, or failure if held by active session.
    2. **Active retention & renewal:** While player active, background task renews lock before 30-min expiry (e.g., at 25 min). Renewal uses `UpdateAsync(lockKey, fn)` that verifies `current.ownerJobId == game.JobId` before extending `expiresAt`. If verification fails, another server owns the lock — stop writes, log conflict.
    3. **PlayerRemoving — save then release:** Acquire lock (blocking with backoff if needed), save PlayerData via `UpdateAsync(dataKey, fn)` while holding lock, then conditionally release lock via `UpdateAsync(lockKey, fn)` that only clears if `current.ownerJobId == game.JobId`. If release fails, log warning but do not block shutdown.
    4. **BindToClose — save active players:** For each loaded player, ensure lock ownership (renew if needed), save data, then release lock where possible. Respect shutdown timeout (30s). Force-save players whose locks cannot be acquired (log, save without lock as last resort).
    5. **Expired-lock recovery:** In `load()`, if lock exists and `expiresAt < os.time()`, `UpdateAsync(lockKey, fn)` atomically claims it for this server. Never blindly delete/overwrite a lock with `expiresAt >= os.time()`.
    6. **Renewal failure handling:** If renewal `UpdateAsync` fails (lock stolen or conflict), immediately: (a) stop all autosaves for that player, (b) mark player data as `loaded: false` to block further purchases, (c) attempt graceful re-acquisition with backoff, (d) if re-acquisition fails after N attempts, kick player with "session conflict" to force clean rejoin.
    7. **Save/release asymmetry handling:** If save succeeds but lock release fails — log, leave lock to expire naturally (TTL handles it). If save fails but lock held — retry save with backoff while lock valid; if lock expires during retry, re-acquire before continuing.
  - `load(player)` stub returning default PlayerData + `loaded: false`
  - `save(player, data)` stub (no-op, logs)
  - Autosave interval config (60s), retry/backoff policy (3× exponential), validation hooks, failure handling (log, alert, do not overwrite)
  - **No working save/load in Milestone 1** — only types, interfaces, and lock lifecycle design
- [ ] Unit tests for EconomyService, PlayerService, InventoryService (require Studio — **unverified**)

### Milestone 2 — Core Economy & Interaction (Working persistence)
- [ ] Migrate tool templates to `ServerStorage/Tools/` (**after visual inspection**)
- [ ] Implement `ShopService` with config-driven shops (7 shops — **prices UNAPPROVED**)
- [ ] Implement `ShopController` + Shop UI
- [ ] Implement `MiningService` (server validation, tool check, cooldown, rewards, 150s respawn)
- [ ] Implement `MiningController` (SelectionBox, raycast, progress UI)
- [ ] Implement `ScrapService` (per-player state, collection, day respawn, selling)
- [ ] Complete `PersistenceService` (implement Milestone 1 design):
  - `load(player)` → `UpdateAsync` with retry (3× exponential backoff), acquires session lock, validates schema v1, returns PlayerData + `loaded: true`
  - `save(player, data)` → `UpdateAsync` with session lock verification, writes PlayerData, updates `lastSaved`, releases lock on success
  - Autosave every 60s via `task.spawn` loop + on `PlayerRemoving`
  - Schema validation on load (ranges, types, version migration path)
  - Block purchases until `loaded: true` (EconomyService/ShopService check)
  - `BindToClose`: wait for all pending saves with timeout (30s), force-save if needed
  - Failure handling: log to `DataStoreErrors` key, alert via `warn`, never overwrite with defaults on transient failure
- [ ] Unit tests for ShopService, MiningService, ScrapService, PersistenceService (require Studio — **unverified**)

### Milestone 3 — Supernatural Gameplay
- [ ] Migrate Ghost/DeepGhost templates to `ServerStorage/Templates/Ghosts/` (**after visual inspection**)
- [ ] Implement `GhostService`:
  - Spawn 26 Ghost + 3 Deep Ghost initially (**verified original world counts**)
  - Single damage authority (**damage values UNAPPROVED**: Ghost=15, Deep Ghost=25 recommended)
  - Day/night visibility toggle
  - Chase AI (Deep Ghost only)
  - Single absorption path: **GhostVacuum** (fix typo), grants 20/50 energy (**UNAPPROVED**)
  - Respawn behavior **UNRESOLVED** — GhostBackup has 23 Ghost + 2 Deep Ghost; world starts with 26+3. Original `GhostRespawn` clones backup (23+2) causing drift. Intended respawn population not documented. Design decision required.
- [ ] Implement `GhostController` (client effects: glow, sounds)
- [ ] Unit tests for GhostService (require Studio — **unverified**)

### Milestone 4 — World Progression
- [ ] Implement `DayNightService` (100 days, 25s/day, 10d/15n, lighting, sounds — **timing UNAPPROVED**)
- [ ] Day 20 triggers: Alice cutscene, Alice spawn
- [ ] Day 100: cycle ends, final event available
- [ ] Implement `NPCService` (5 NPCs — **verified count**, dialogue queues, story flags)
- [ ] Implement `CutsceneService` (reusable: camera, fade, typewriter, callbacks)
- [ ] Build Alice cutscene + Mine cutscene sequences
- [ ] Implement `DialogueController` + `CutsceneController`
- [ ] Fix Mine cutscene: create `AliceCutsceneFinished` remote OR redesign trigger (**design UNAPPROVED**)

### Milestone 5 — Boss & Ending
- [ ] Migrate Dreadon to `ServerStorage/Templates/Boss/` (**after visual inspection**)
- [ ] Implement `BossService`:
  - Energy transfer at Dreadon (validated)
  - **Reconcile threshold:** BossEnergyRequired=20000 but trigger=20 — **recommend 2000** (requires ~100 ghosts over 19 days) — **UNAPPROVED**
  - Fight state machine: Idle → Dialogue → Active → Defeated
  - Boss AI: chase, attack (25 dmg — **UNAPPROVED**), health pool, defeat condition
  - BGM start/stop
  - `BossBattleActive` reset on defeat
- [ ] Implement `BossController` (dialogue UI, health bar, effects)
- [ ] Final event + ending sequence

### Milestone 6 — Persistence Hardening
- [ ] Integrate `PersistenceService` with all services (Economy, Inventory, Progression, GhostEnergy, StoryFlags)
- [ ] Migration path for future schema versions
- [ ] Corruption detection and recovery

### Milestone 7 — UI & Polish
- [ ] Consolidate HUD: single `HUDController` managing all currency/bag/day/energy
- [ ] Fix naming: **Baguerite** everywhere (not "Bronze") — **UNAPPROVED**
- [ ] Mining progress indicator (client-side, synced to server hits)
- [ ] Shop UI (price, owned state, equipped check)
- [ ] Dialogue UI polish (typewriter sound, skip, auto-advance)
- [ ] Boss UI (health bar, phase indicators)
- [ ] Cutscene polish (smooth camera, skip option, input locking)
- [ ] Audio: verify all SoundIds valid, volume balancing

### Milestone 8 — Complete Validation
- [ ] Full single-player playthrough (new game → day 100 → ending) — **unverified until Studio test**
- [ ] Regression test all unit/integration tests
- [ ] Memory leak check (connections, tables cleaned on leave)
- [ ] Performance profile
- [ ] Data persistence test (play → leave → rejoin → verify)
- [ ] Bug fix pass
- [ ] Documentation complete
- [ ] `README.md` with setup/build instructions

---

## 11. KNOWN UNCERTAINTIES (Require Owner Decision — ALL UNAPPROVED)

| # | Question | Impact | Recommendation (UNVERIFIED) |
|---|----------|--------|----------------------------|
| 1 | **Mine cutscene intent:** Was `AliceCutsceneFinished` ever implemented, or is the mine cutscene aspirational? | Determines whether to create the remote or redesign the trigger | Ask owner; if unknown, make mine cutscene trigger on day 20 after Alice, using same `CurrentDay` signal |
| 2 | **Boss energy threshold:** Is 20,000 the intended goal or is 20 the bug? | Changes boss pacing from "1 ghost = boss" to "~100 ghosts = boss" | **Recommend 2,000** — reachable in 19 days with active play (≈10 ghosts/night × 19 nights × 20 energy = 3,800) |
| 3 | **Day progression:** Per-server (shared) or per-player? | Affects persistence design and multiplayer later | **Per-player** — fits single-player focus; each player has own 100-day journey |
| 4 | **M16A4 weapon:** Intended content or toolbox leftover? | If kept, needs shop + balance | **Remove** — no purchase script, 5 remotes, clearly toolbox |
| 5 | **Ghost damage values:** Three paths use 15 (SSS/ghost), 25 (Deep Ghost), 10 (GhostHandAttack). Which is correct? | Combat balance | **Recommend:** Ghost = 15, Deep Ghost = 25 (stronger variant), remove GhostHandAttack duplicate |
| 6 | **Baguerite vs Bronze:** UI shows "Bronze" but stat is "Baguerite". Which is canon? | UI consistency | **Use "Baguerite"** everywhere (stat name); update UI label |
| 7 | **World reset on empty server?** | Affects day/night service design | **No** — per-player day means world state is per-player anyway |
| 8 | **Player scale 2×, speed 32:** Are these intended final values? | Movement feel | Keep as-is unless owner specifies |
| 9 | **Ore hits required:** Baguerite=4, Silver=6 — verified from code, confirm balance? | Mining pacing | Keep as-is unless owner specifies |
| 10 | **Scrap sell price:** 20 coins — verified, confirm? | Economy | Keep as-is unless owner specifies |
| 11 | **Ghost respawn population:** GhostBackup=23+2, world=26+3. Original `GhostRespawn` clones backup causing drift. Intended behavior not documented. | Population stability | **UNRESOLVED** — design decision required |
| 12 | **Script classification discrepancy:** 156 vs 136 gameplay bodies | Audit completeness | Reproduce audit classification method or accept extraction count |

---

## 12. ORIGINAL MAP & ASSET PRESERVATION PROCEDURE

**Rule:** The original `the real one.rbxl` is **never modified**. All work occurs in the Rojo `src/` tree.

### 12.1 Asset Migration Procedure (for each asset in Section 3.1)

1. **Extract to test place:** Load original `.rbxl` in Roblox Studio on Windows (or serve via Rojo)
2. **Verify visual fidelity:** Model proportions, textures, materials, animations
3. **Verify functional properties:**
   - Tools: Grip, stats (Damage if applicable), animations, sounds, equip behavior
   - Ghosts: Hitboxes, walk speed, animations, death behavior, absorption prompt
   - Ores: Hitboxes, visual states (mined/available)
   - Dreadon: Animations, fire particles, sound emitters, proximity prompt
   - Alice: Model, animations, AI behavior
   - Sounds: All SoundIds resolve, volume appropriate, looping correct
   - UI: Layout, fonts, scaling, visibility, text alignment
4. **Document in `docs/ASSET_INVENTORY.md`:**
   - Asset name, source path (e.g., `Workspace/Ghosts/Ghost`), destination path (e.g., `ServerStorage/Templates/Ghosts/Ghost`)
   - Verified properties (grip, damage, walkspeed, animation IDs, sound IDs, SoundId validity)
   - Any modifications needed for rebuild (e.g., fix GhostVacuum typo, remove duplicate scripts)
   - Screenshot/video reference
5. **Owner sign-off** before committing to `src/`

**Original place file protection:** The original `the real one.rbxl` is **never modified**. All work occurs in the Rojo `src/` tree. The original file remains at `/tmp/opencode/mh-original/the real one.rbxl` (SHA-256 verified) as immutable reference.

### 12.2 Assets Requiring Inspection (20)

**Tools (13):** Axe, Bat, CoconutDrink, GhostVacuum, Guestium Scythe, Gun, Hammer, TrenchGun, WoodPick, Bandage, Medikit, SilverSword, LootPouch  
**Models (7):** Ghost (×23), Deep Ghost (×2), Alice, ScrapMetal, Silver Ore, Baguerite, Dreadon  
**UI (7):** CoinGui, DayGui, GhostEnergyGui, DialogueGui, BossDialogueGui, MineCutsceneGui, MiningProgressGui (new)

---

## 13. RISKS & DEPENDENCIES

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| No Roblox Studio on Linux for runtime testing | High | Cannot verify visuals, physics, animations | Develop on Linux with Rojo + unit tests; test in Studio on Windows periodically (owner or CI) |
| Luau type checker (`luau-analyze`) not installed | Medium | Cannot enforce `--!strict` in CI | Install via `aftman` or use Rojo's built-in type checking; defer to manual check |
| Asset IDs (animations, meshes, sounds) may be invalid | Medium | Runtime errors, missing visuals | Validate all SoundIds/AnimationIds during migration; replace with placeholders if needed |
| DataStore limits (4MB/key, 60 writes/min) | Low | Persistence failures | Single key per player; batch writes; retry with backoff |
| Scope creep from "fixing" vs "rebuilding" | Medium | Delayed milestones | Strict milestone gates; no feature additions without plan update |
| Original `.rbxl` binary changes if opened in Studio | Low | Drift from audited state | Never edit original; work only in Rojo `src/` |
| **Balance changes unapproved** | High | Gameplay feels different | All config values marked unapproved; owner must review `GameConfig.luau` before Milestone 2 |
| **Script classification discrepancy** | Medium | Audit completeness uncertain | Document discrepancy; proceed with extraction count (136) but flag for review |

---

## 14. FACTUAL CORRECTIONS FROM PREVIOUS DRAFTS

| Item | Previous | Corrected (Verified) |
|------|----------|----------------------|
| Unique gameplay script bodies | 151 / 156 / 134 | **136 by extraction filter; audit reports 156 — discrepancy of 20 not resolved** |
| Scripts inspected vs classified | Not clearly distinguished | **78 inspected line-by-line; 58 classified only (by extraction)** |
| GhostBackup population | "23 + 2" / "23 + 3" | **Verified: 23 Ghost + 2 Deep Ghost = 25** |
| Initial world ghosts | "26 + 3" / "23 + 3" | **Verified: 26 Ghost + 3 Deep Ghost = 29** |
| NPC count | 4 | **5** (Arwin, Barn Keeper, Murugesan, Old Miner, The Older) |
| Balance changes | Presented as decisions | **All marked UNAPPROVED** |
| Verified vs recommended behavior | Mixed | **Separated: Verified (from source) vs Recommendation (unapproved) vs New design** |
| Assets needing inspection | Not listed | **20 assets explicitly listed with 5-step procedure** |
| Multiplayer complexity | Not addressed | **Confirmed: Single-player architecture; no MP code in Milestones 1–5** |
| Persistence timing | Milestone 6 / Milestone 1 skeleton | **Milestone 1: skeleton only (no working save/load); Milestone 2: working save/load** |
| Test classification | Not separated | **Separated: Linux-runnable (lint, format, build) vs Studio-required (unit, integration, playthrough)** |

---

## 15. UNRESOLVED UNCERTAINTIES

1. **Script body discrepancy:** Audit reports 156 unique non-asset gameplay scripts; extraction finds 136. The 20-body gap is unclassified. Audit method not reproduced. **Do not claim all 755 scripts were inspected line by line — only 78 were.**
2. **Boss energy threshold:** 20,000 (config) vs 20 (trigger) — no documented intent.
3. **Day progression model:** Per-server vs per-player — no documented intent.
4. **Ghost damage values:** Three conflicting implementations (15, 25, 10) — no documented intent.
5. **Baguerite naming:** Stat="Baguerite", UI="Bronze" — no documented intent.
6. **Mine cutscene design:** Missing `AliceCutsceneFinished` remote — no documented intent.
7. **M16A4 fate:** No purchase path, 5 remotes — no documented intent.
8. **Ghost respawn population:** GhostBackup=23+2, world=26+3. Original `GhostRespawn` clones backup causing drift. Intended behavior not documented.
9. **All config values in `GameConfig.luau`** — unapproved.
10. **All untested Roblox runtime behavior** — marked unverified. No Studio tests executed.

---

## 16. TESTS ACTUALLY EXECUTED

| Test | Executed | Result |
|------|----------|--------|
| Git clone original repo | ✅ | Success |
| SHA-256 verification of `the real one.rbxl` | ✅ | Matches audit (`64e469d...`) |
| Lune extraction of 755 scripts | ✅ | Success (188 unique files + 567 duplicates with numeric suffixes) |
| SHA-256 hashing of 755 extracted files | ✅ | 196 unique bodies |
| Automated toolbox/asset classification | ✅ | 60 toolbox, 136 gameplay |
| Hierarchy parsing from `hierarchy.txt` | ✅ | Verified instance counts |
| Static reading of **78** gameplay scripts | ✅ | Verified system behaviors |
| Git remote verification | ✅ | Origin reachable, 2 commits |

**Scripts NOT inspected line-by-line:** 58 unique gameplay bodies (136 extraction gameplay − 78 inspected) classified only by automated filter; plus 60 toolbox/asset bodies also classified only. The previous "118" figure conflated unique bodies with instance counts. **Do not claim all 755 scripts were inspected line by line — only 78 unique bodies were.**
**No Roblox Studio tests executed.** No unit tests, integration tests, or playthrough tests executed. All Studio-dependent tests are **unverified**.
**Rojo builds and static analysis do not prove Roblox runtime correctness.**

---

## 17. MILESTONE 1 STATUS

**MILESTONE 1 HAS NOT STARTED.**

No gameplay code has been written. No files have been created in `Midnight-Harvest-Rebuilt/` except this plan. No modifications to the original `.rbxl`. No assets migrated. No git repository initialized.

---

## 18. NEXT STEPS

**Awaiting owner review of this plan.** Specifically:

1. Approve/reject the **architecture structure** (Rojo layout, service/module boundaries)
2. Decide on **uncertainties #1–12** above (all marked unapproved)
3. Confirm **boss energy threshold recommendation (2,000)** or provide intended value
4. Authorize **asset inspection** on Windows Studio (required before Milestone 1 migration)
5. Authorize **Milestone 1 start** (repo init, configs, bootstrap, Player/Economy/Inventory/Persistence skeleton services)

Once approved, I will:
1. Initialize the git repository in `Midnight-Harvest-Rebuilt/`
2. Create all config/type/constant modules with **unapproved values clearly marked**
3. Implement `Bootstrap.server.luau` + `PlayerService` + `EconomyService` + `InventoryService` + `PersistenceService` skeleton
4. Write unit tests for the foundation services (to run in Studio)
5. Report results for Milestone 1 review

---

*End of REBUILD_MASTER_PLAN.md*