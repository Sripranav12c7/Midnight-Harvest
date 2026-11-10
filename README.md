# Midnight Harvest — Rebuild

A complete, modular, server-authoritative rewrite of the Midnight Harvest Roblox game.

## Project Status

**Milestone 0:** Discovery & Design — Complete  
**Milestone 1:** Foundation — In Progress  
**Target:** Single-player first, multiplayer-ready architecture

## Original Game

Reference: `Sripranav12c7/Midnight-Harvest` (original `.rbxl` place file)  
Audit: `Midnight-Harvest-ANALYSIS.md`, `Midnight-Harvest-PROJECT-STATUS.md`

## Architecture

- **Rojo 7.x** compatible
- **Server-authoritative** gameplay (currency, mining, ghosts, boss)
- **Modular services** with explicit initialization order
- **Config-driven** balance values (all unapproved until reviewed)
- **Type-safe** Luau (`--!strict` throughout)
- **Per-player persistence** via DataStoreService with session locking

## Development Setup

### Prerequisites

- [Rojo 7.x](https://rojo.space/docs/getting-started/installation/)
- [Aftman](https://github.com/LPGhatguy/aftman) for Luau tooling
- Roblox Studio (Windows) for runtime testing

### Install Tools

```bash
aftman install
```

This installs `selene` (lint) and `stylua` (format) per `aftman.toml`.

### Build & Serve

```bash
# Build place file
rojo build -o MidnightHarvest.rbxl

# Serve for live sync
rojo serve
```

### Lint & Format

```bash
# Check formatting
stylua --check .

# Format
stylua .

# Lint
selene .
```

## Project Structure

```
MidnightHarvest/
├── default.project.json      # Rojo project config
├── README.md
├── .gitignore
├── aftman.toml               # Toolchain (selene, stylua)
├── selene.toml               # Lint rules
├── stylua.toml               # Format rules
├── docs/                     # Project documentation
└── src/
    ├── ReplicatedStorage/
    │   ├── Shared/
    │   │   ├── Config/       # GameConfig, ShopConfig, GhostConfig, etc.
    │   │   ├── Types/        # EconomyTypes, GhostTypes, MiningTypes, etc.
    │   │   ├── Constants/    # RemoteNames, StatNames, ToolNames
    │   │   └── Utilities/    # Signal, TableUtil, MathUtil
    │   └── Remotes/          # RemoteEvent/Function declarations
    ├── ServerScriptService/
    │   ├── Bootstrap.server.luau
    │   ├── Services/         # PlayerService, EconomyService, InventoryService, ShopService, PersistenceService
    │   └── Systems/          # MiningService, ScrapService, GhostService, DayNightService, NPCService, CutsceneService, BossService
    ├── ServerStorage/
    │   ├── Assets/
    │   ├── Tools/            # Tool templates (Axe, Bat, etc.)
    │   └── Templates/        # Ghosts, Ores, ScrapMetal, Alice, Boss, EnvironmentSounds
    ├── StarterPlayer/
    │   └── StarterPlayerScripts/
    │       ├── Bootstrap.client.luau
    │       └── Controllers/  # HUDController, MiningController, ShopController, etc.
    └── StarterGui/
        └── Interfaces/       # CoinGui, DayGui, GhostEnergyGui, DialogueGui, BossDialogueGui, MineCutsceneGui, MiningProgressGui
```

## Documentation

| Document | Purpose |
|----------|---------|
| `docs/ARCHITECTURE.md` | Module responsibilities, dependencies, client/server boundaries |
| `docs/GAME_DESIGN.md` | Gameplay concepts, resources, items, shops, world mechanics |
| `docs/PROGRESSION.md` | Day progression, NPC progression, story events, boss prerequisites, ending |
| `docs/SYSTEMS.md` | Implementation status of each system |
| `docs/TEST_PLAN.md` | Test cases and results |
| `docs/BUGS.md` | Confirmed bugs, unverified issues, fixes, regression risks |
| `docs/CHANGELOG.md` | Every significant project change |

## Milestones

| # | Name | Status |
|---|------|--------|
| 0 | Discovery & Design | ✅ Complete |
| 1 | Foundation (Rojo, types, bootstrap, skeleton services) | 🔄 In Progress |
| 2 | Core Economy & Interaction (shops, mining, scrap, working persistence) | ⏳ Pending |
| 3 | Supernatural Gameplay (ghosts, absorption, energy) | ⏳ Pending |
| 4 | World Progression (day/night, NPCs, cutscenes) | ⏳ Pending |
| 5 | Boss & Ending | ⏳ Pending |
| 6 | Persistence Hardening | ⏳ Pending |
| 7 | UI & Polish | ⏳ Pending |
| 8 | Complete Validation | ⏳ Pending |

## Branch Strategy

- `main` — Original `.rbxl` reference (never modified)
- `Scratch_Build` — Rebuild development branch (this branch)

## License

Private project. Do not distribute without authorization.