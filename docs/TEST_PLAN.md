# Test Plan

## Test Classification

| Category | Runnable On | Status |
|----------|-------------|--------|
| Static Analysis (selene, stylua, luau-analyze) | Linux (Ryoku) | Not Executed |
| Rojo Build | Linux (Ryoku) | Not Executed |
| Unit Tests (TestEZ) | Roblox Studio | Not Executed |
| Integration Tests | Roblox Studio | Not Executed |
| Playthrough Test | Roblox Studio | Not Executed |

**Critical:** Rojo builds and static analysis **do not prove Roblox runtime correctness**. All Studio-required tests are **unverified until executed**.

## Unit Tests (TestEZ — Require Studio)

### EconomyService
- [ ] Add/remove currency (Coins, Silver, Baguerite, Scrap, GhostEnergy)
- [ ] Bag limit enforcement (10 items = Silver + Baguerite + Scrap)
- [ ] Coins excluded from bag limit
- [ ] Transaction atomicity (succeed completely or fail without partial state)
- [ ] Purchase validation (sufficient funds, ownership guards)
- [ ] Persistence round-trip (save → load → verify)

### MiningService
- [ ] Hit counting per player per ore
- [ ] Reward grant on hit threshold (Silver: 6 hits, Baguerite: 4 hits)
- [ ] Ore respawn after 150s
- [ ] Tool validation (WoodPick equipped required)
- [ ] Distance validation (≤12 studs)
- [ ] Bag full prevention (no reward if bag at capacity)
- [ ] Cooldown enforcement (0.5s debounce)

### ScrapService
- [ ] Per-player collection state (independent per player)
- [ ] Scrap respawn on day change
- [ ] Selling (20 Coins per Scrap)
- [ ] Bag limit enforcement

### GhostService
- [ ] Initial spawn: 26 Ghost + 3 Deep Ghost
- [ ] Damage application (Ghost=15, Deep Ghost=25 — UNAPPROVED)
- [ ] Day/night visibility toggle
- [ ] Deep Ghost chase AI
- [ ] Single absorption path (GhostVacuum only)
- [ ] Energy rewards (20 normal / 50 deep — UNAPPROVED)
- [ ] Respawn behavior (UNRESOLVED — design decision needed)

### ShopService
- [ ] Price validation for all 7 shops
- [ ] Ownership guards (backpack/character check, attributes)
- [ ] Duplicate purchase prevention
- [ ] Distance validation (ProximityPrompt range)
- [ ] Currency deduction atomicity

### DayNightService
- [ ] Cycle timing (25s total: 10s day, 15s night)
- [ ] Day 20 trigger (Alice cutscene + spawn)
- [ ] Day 100 trigger (cycle end)
- [ ] Lighting transitions (ClockTime 12 → 0)
- [ ] Audio triggers (ChickenMorning, BirdsMorning)

### NPCService
- [ ] 5 NPCs registered with dialogue queues
- [ ] Typewriter timing (0.035s per character)
- [ ] Story flag integration

### CutsceneService
- [ ] Camera control (Scriptable → Custom restoration)
- [ ] Fade in/out (TweenService)
- [ ] Typewriter integration
- [ ] Sequencing (callbacks between phases)
- [ ] Cancellation/recovery (input lock cleanup)
- [ ] Alice + Mine mutual exclusion

### BossService
- [ ] Energy transfer at Dreadon (validated)
- [ ] Activation threshold (UNAPPROVED: recommend 2,000)
- [ ] Fight state machine (Idle → Dialogue → Active → Defeated)
- [ ] Boss AI (chase, attack, health pool)
- [ ] Defeat condition + BGM stop
- [ ] BossBattleActive reset

### PersistenceService
- [ ] Schema v1 load/save
- [ ] Session lock acquisition/renewal/release
- [ ] Expired lock recovery
- [ ] Retry/backoff (3× exponential)
- [ ] PlayerRemoving save
- [ ] BindToClose save all (30s timeout)
- [ ] Schema validation on load
- [ ] Failure handling (never overwrite with defaults)

## Integration Tests (Require Studio)

- [ ] Full day/night cycle with ghost spawn/despawn
- [ ] Mining → Sell → Buy → Mine loop
- [ ] Day 20 Alice cutscene + Mine cutscene mutual exclusion
- [ ] Ghost kill → Absorb → Energy → Dreadon → Boss fight → Victory
- [ ] Rejoin with saved data restores all currency, tools, day, story flags

## Playthrough Test (Milestone 8 — Require Studio)

- [ ] New game → Day 100 completion without errors
- [ ] All HUD elements update correctly
- [ ] No memory leaks (connections cleaned on leave)
- [ ] Performance: < 30ms frame on mid-tier hardware
- [ ] Data persistence test (play → leave → rejoin → verify)

## Milestone 1 Verification (Linux)

- [ ] `rojo build` succeeds
- [ ] `selene .` passes (no errors)
- [ ] `stylua --check .` passes
- [ ] All skeleton files exist with correct structure