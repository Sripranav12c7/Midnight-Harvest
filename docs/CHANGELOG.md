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

## [Milestone 1] — 2026-11-10 (In Progress)

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

### Pending (Milestone 1 Implementation)
- Shared Config modules (GameConfig, ShopConfig, GhostConfig, MiningConfig, DayNightConfig)
- Shared Types modules (EconomyTypes, GhostTypes, MiningTypes, ProgressionTypes, NetworkTypes)
- Shared Constants modules (RemoteNames, StatNames, ToolNames)
- Shared Utilities modules (Signal, TableUtil, MathUtil)
- Remotes declarations (RemoteEvents, RemoteFunctions)
- Server Services (PlayerService, EconomyService, InventoryService, ShopService, PersistenceService skeletons)
- Server Systems (Mining, Scrap, Ghost, DayNight, NPC, Cutscene, Boss stubs)
- Client Bootstraps (Bootstrap.server.luau, Bootstrap.client.luau)
- Client Controllers (HUD, Mining, Shop, Dialogue, Cutscene, Boss, Ghost stubs)
- UI Interfaces (CoinGui, DayGui, GhostEnergyGui, DialogueGui, BossDialogueGui, MineCutsceneGui, MiningProgressGui stubs)
- Linux-side checks (rojo build, selene, stylua --check)

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