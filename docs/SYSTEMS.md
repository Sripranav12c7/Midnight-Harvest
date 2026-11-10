# Systems Implementation Status

| System | Milestone | Status | Notes |
|--------|-----------|--------|-------|
| **PlayerService** | 1 | 🔄 Skeleton | Character init, health=200, scale=2×, speed=32, pouch |
| **EconomyService** | 1 | 🔄 Skeleton | 5 currencies, bag limit, transactions (no persistence) |
| **InventoryService** | 1 | 🔄 Skeleton | Tool ownership, equipped state (no persistence) |
| **ShopService** | 1 | 🔄 Skeleton | 7 shops config, purchase validation stubs |
| **PersistenceService** | 1 | 🔄 Skeleton | Schema v1, lock design, stubs only |
| **MiningService** | 2 | ⏳ Pending | Tool validation, hit tracking, 150s respawn |
| **ScrapService** | 2 | ⏳ Pending | Per-player state, day respawn, selling |
| **GhostService** | 3 | ⏳ Pending | 26+3 spawn, single damage auth, absorption, energy |
| **DayNightService** | 4 | ⏳ Pending | 100-day cycle, day 20/100 triggers |
| **NPCService** | 4 | ⏳ Pending | 5 NPCs, dialogue queues, story flags |
| **CutsceneService** | 4 | ⏳ Pending | Reusable controller, Alice + Mine sequences |
| **BossService** | 5 | ⏳ Pending | Activation, fight state, defeat condition |
| **HUDController** | 1 | 🔄 Skeleton | Currency/bag/day/energy display |
| **MiningController** | 2 | ⏳ Pending | SelectionBox, raycast, progress UI |
| **ShopController** | 2 | ⏳ Pending | Shop UI, purchase requests |
| **DialogueController** | 4 | ⏳ Pending | Typewriter display |
| **CutsceneController** | 4 | ⏳ Pending | Camera, fade, input locking |
| **BossController** | 5 | ⏳ Pending | Health bar, dialogue, effects |
| **GhostController** | 3 | ⏳ Pending | Glow, sounds |

## Legend

- ✅ Complete
- 🔄 In Progress (Milestone 1 skeletons)
- ⏳ Pending (future milestones)
- ❌ Blocked/Removed