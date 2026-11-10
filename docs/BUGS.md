# Bugs & Issues

## Confirmed by Construction (Static Analysis — No Runtime Needed)

| # | Bug | Original Location | Severity | Rebuild Fix |
|---|-----|-------------------|----------|-------------|
| 1 | MineCutscene infinite yield on missing `AliceCutsceneFinished` | `StarterPlayerScripts/MineCutscene` L13 | Critical | Create remote OR redesign trigger (UNAPPROVED) |
| 2 | Axeshop charges 150 then hangs on missing `AxeTool` | `ServerScriptService/Axeshop` L40 | Critical | Remove duplicate listener; use `ServerStorage.Axe` |
| 3 | HammerShop warns on missing `HammerTool` | `ServerScriptService/HammerShop` L38 | High | Remove dead duplicate |
| 4 | SwordScript syntax error (unbalanced `)`) | `Workspace/WoodPick/SwordScript` L66 | Critical | Fix or delete (KnifeScript handles axe) |
| 5 | PlayerHealth targets wrong parent (never applies 200 HP) | `StarterPlayerScripts/PlayerHealth` L5 | Critical | Move to `StarterCharacterScripts`, target `script.Parent` |
| 6 | Boss trigger at 20 vs `BossEnergyRequired`=20,000 | `Dreadon/Head` vs `ReplicatedStorage` | Critical | Reconcile threshold (recommend 2,000 — UNAPPROVED) |
| 7 | Boss fight no defeat state, BGM never stops | `Dreadon/HumanoidRootPart/BossAttack` | Critical | Implement defeat condition + BGM stop + reset |
| 8 | Ghost absorption conflict: paid tool grants 0, free tool grants energy | `SSS/GhostAbsorbtion` vs `Ghosts/*/GhostAbsorption` | Critical | Single path: GhostVacuum only (fix typo) |
| 9 | Chest double payout (4 scripts × 2 implementations) | `Workspace/Chest` (4 models × 4 scripts) | High | Single template, per-player state |
| 10 | Ghost population drift 29→25 after day 1 | `SSS/GhostRespawn` clones backup (23+2) | High | Respawn behavior UNRESOLVED — design decision needed |
| 11 | Mining no tool check (exploitable) | `SSS/MiningScript` validates only name+distance | High | Server-validated WoodPick equipped |
| 12 | BossFightStart unvalidated | `SSS/BossFinalEventHandler` L22 | High | Validate energy transfer + progression |
| 13 | Scrap global state (first player takes for all) | `Workspace/Scarps/ScrapCollector` | High | Per-player collection state |
| 14 | No persistence | 0 DataStoreService references | Critical | Full DataStore implementation (Milestone 1–2) |
| 15 | Duplicate placed tools (4-6× each) | Workspace Axe×5, Bandage×5, etc. | Medium | Single templates in ServerStorage |
| 16 | Global variable leaks (`CanDmg`, `Can`, `r`, `sword`, `Tool`) | `KnifeScript`, `SwordScript` | Medium | Remove globals, use local |
| 17 | Deprecated APIs (`FindPartOnRay`, `SetPrimaryPartCFrame`, `LoadAnimation`, `wait()`, `:connect()`) | Multiple scripts | Low | Replace with modern equivalents |
| 18 | Baguerite shown as "Bronze" in UI | `CoinGui/SilverText/BagueriteText` | Low | Consistent naming — UNAPPROVED |

## Unverified (Require Studio Runtime)

| # | Potential Issue | Location | Status |
|---|-----------------|----------|--------|
| 1 | Toolbox asset SoundIds/AnimationIds invalid | Various | Unverified |
| 2 | Toolbox model hitboxes incorrect | Ghosts, Ores, Tools | Unverified |
| 3 | M16A4 free weapon with 5 remotes | `Workspace/M16A4` | Unverified |
| 4 | Abandoned House scripts error | Fan, TV, sink, door | Unverified |
| 5 | Cart Ride map kit (36×) performance | `Workspace/Cart Ride...` | Unverified |

## Regression Risks (Rebuild)

| Risk | Mitigation |
|------|------------|
| Ghost respawn behavior change breaks progression | Design decision required before Milestone 3 |
| Boss threshold change alters game pacing | Owner must approve threshold (recommend 2,000) |
| Per-player day breaks shared world feel | Architecture supports both; per-player chosen for single-player |
| Baguerite rename confuses returning players | UI migration with clear labeling |
| Mine cutscene redesign changes story | Owner must approve design |

## Fixed in Rebuild (by Design)

| Original Bug | Rebuild Resolution |
|--------------|-------------------|
| No persistence | DataStore schema v1 + session locking |
| Mining exploit | Server tool validation |
| Ghost absorption conflict | Single path (GhostVacuum) |
| Boss no defeat | State machine with defeat condition |
| Chest double payout | Single template + per-player state |
| Duplicate tools | ServerStorage templates only |
| Global variables | Strict mode, no globals |
| Deprecated APIs | Modern equivalents only |