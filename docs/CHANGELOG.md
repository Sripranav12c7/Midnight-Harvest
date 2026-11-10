# Changelog

All significant project changes documented here.

## [Milestone 0] — 2026-11-10

### Added
- Complete project discovery and analysis of original `the real one.rbxl`
- Static audit of 755 script instances, 196 unique bodies (136 gameplay, 60 toolbox)
- Verified instance counts from hierarchy.txt + manifest.json (60,820 instances)
- 78 scripts inspected line-by-line; 58 gameplay bodies classified only
- Documented all gameplay systems, bugs, assets, and discrepancies
- Ghost populations verified: World 26+3, Backup 23+2 (respawn behavior UNRESOLVED)
- 5 NPCs verified (Arwin, Barn Keeper, Murugesan, Old Miner, The Older)
- Script classification discrepancy documented: Audit 156 vs Extraction 136 gameplay bodies
- Created `REBUILD_MASTER_PLAN.md` with full architecture, milestones, and unapproved decisions

### Documentation
- `REBUILD_MASTER_PLAN.md` — Master rebuild plan
- `docs/ARCHITECTURE.md` — Module responsibilities, initialization order, client/server boundaries
- `docs/GAME_DESIGN.md` — Resources, shops, mining, ghosts, day/night, boss, progression
- `docs/SYSTEMS.md` — Implementation status table
- `docs/PROGRESSION.md` — Day progression, story flags, NPC progression, boss prerequisites
- `docs/TEST_PLAN.md` — Test classification, unit/integration/playthrough test cases
- `docs/BUGS.md` — 18 confirmed bugs, unverified issues, regression risks
- `docs/CHANGELOG.md` — This file

## [Milestone 1] — 2026-11-10

### Added
- `default.project.json` — Rojo 7.x project configuration
- `.gitignore` — Build outputs, IDE, OS, logs, temp files
- `aftman.toml` — Toolchain (selene, stylua)
- `selene.toml` — Lint rules (Roblox std, strict globals, deprecated APIs)
- `stylua.toml` — Format rules (120 col, tabs, double quotes)
- `README.md` — Project overview, setup, structure, milestones
- Git repository initialized, connected to `origin`, branch `Scratch_Build` created

### Directory Structure Created
```
src/
├── ReplicatedStorage/
│   ├── Shared/Config/
│   ├── Shared/Types/
│   ├── Shared/Constants/
│   ├── Shared/Utilities/
│   └── Remotes/
├── ServerScriptService/
│   ├── Services/
│   └── Systems/
├── ServerStorage/
│   ├── Assets/
│   ├── Tools/
│   └── Templates/
├── StarterPlayer/StarterPlayerScripts/Controllers/
└── StarterGui/Interfaces/
tests/
```

### Documentation Placeholders
- All `docs/*.md` files created with Milestone 0 content

### Milestone 1 Implementation (Completed)
- Shared Config modules (GameConfig, ShopConfig, GhostConfig, MiningConfig, DayNightConfig) — all values marked UNAPPROVED
- Shared Types modules (EconomyTypes, GhostTypes, MiningTypes, ProgressionTypes, NetworkTypes)
- Shared Constants modules (RemoteNames, StatNames, ToolNames)
- Shared Utilities modules (Signal, TableUtil, MathUtil)
- Remotes declarations (RemoteEvents, RemoteFunctions)
- Server Services (PlayerService, EconomyService, InventoryService, ShopService, PersistenceService skeletons)
- Server Systems (Mining, Scrap, Ghost, DayNight, NPC, Cutscene, Boss stubs)
- Client Bootstraps (Bootstrap.server.luau, Bootstrap.client.luau)
- Client Controllers (HUD, Mining, Shop, Dialogue, Cutscene, Boss, Ghost stubs)
- UI Interfaces (CoinGui, DayGui, GhostEnergyGui, DialogueGui, BossDialogueGui, MineCutsceneGui, MiningProgressGui stubs)
- TestEZ test files (Economy, Mining, Ghost, Shop, Persistence)

### Milestone 1 Repair Pass (2026-11-10)

#### Fixed
1. **Bootstrap.server.luau**: Added `PersistenceService.registerServices(EconomyService, InventoryService)` to wire service callbacks; fixed service initialization order documentation.
2. **Bootstrap.client.luau**: Added 30-second timeout watchdog for `PlayerDataLoaded`; wrapped each controller initialization in `pcall` for independent error handling; fixed `StarterPlayerScripts` reference to use `WaitForChild`.
3. **PersistenceService.server.luau**: Added `registerServices()` function for dependency injection; exported `getDefaultPlayerData()` for tests; removed `_G.PersistenceService` global; fixed `onPlayerRemoving` to clean all state tables (`playerLocks`, `autosaveTasks`); removed `_G` global pollution; `playerLoaded` now only set to `true` after actual load (M2).
4. **DayNightService.server.luau**: Properly exposes `dayChanged` and `nightChanged` BindableEvent events via return table for GhostService and other dependents.
4. **RemoteNames.luau**: Resolved name collision — renamed BindableEvent from `BossFinalEvent` to `BossFinalEventBindable` (was conflicting with RemoteEvent `BossFinalEvent`).
5. **BossService.server.luau**: Updated comment to reference new `BossFinalEventBindable` name.
5. **PersistenceService.server.luau**: Added `registerServices()` function; exported `getDefaultPlayerData()`; removed `_G` global; cleans all state tables (`playerLocks`, `autosaveTasks`) on `onPlayerRemoving`; removed `_G` global pollution.
6. **Tests/EconomyService.test.luau**: Fixed mock player (no longer uses `Players.LocalPlayer`); tests no longer depend on `playerLoaded` state (simulates loaded state by calling functions directly).
6. **Tests/PersistenceService.test.luau**: Can now access `getDefaultPlayerData()` via exported function.
7. **RemoteNames.luau**: Resolved RemoteEvent/BindableEvent name collision — `BossFinalEvent` (RemoteEvent) vs `BossFinalEventBindable` (BindableEvent).
7. **BossService.server.luau**: Updated comment to reference `BossFinalEventBindable`.

#### Verified
- Rojo build succeeds (42 KB output)
- Git commit `988beb1` on `Scratch_Build` branch pushed to `origin/Scratch_Build`

#### Remaining (Deferred to Milestone 2)
- Working DataStore persistence (UpdateAsync, session locking, autosave)
- Full gameplay system implementations
- Asset migration and visual inspection
- Roblox Studio runtime tests
- Selene/Stylua linting (tools not installed on this machine)

---

## Versioning Scheme

- Milestone 0: Discovery complete
- Milestone 1: Foundation (Rojo, types, bootstrap, skeleton services)
- Milestone 2: Core Economy & Interaction
- Milestone 3: Supernatural Gameplay
- Milestone 4: World Progression
- Milestone 5: Boss & Ending
- Milestone 6: Persistence Hardening
- Milestone 7: UI & Polish
- Milestone 8: Complete Validation

Each milestone targets a descriptive commit on `Scratch_Build` branch.