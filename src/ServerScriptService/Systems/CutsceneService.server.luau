--!strict
--[[
	CutsceneService.lua
	Reusable camera/dialogue/fade controller. Alice + Mine sequences. Mutual exclusion.
	MILESTONE 4: Full implementation. MILESTONE 1: Skeleton.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local DayNightService = require(script.Parent.DayNightService)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local activeCutscene: string? = nil
local cutsceneQueue: { string } = {}

-- Forward declarations for callbacks (must be before initialize)
local function onMineCutsceneFinished(player: Player)
	-- MILESTONE 4: Mine cutscene complete
end

local function startAliceCutscene()
	-- MILESTONE 4: Fire AliceCutsceneEvent, then AliceRevealEvent after spawn
end

local function startMineCutscene()
	-- MILESTONE 4: Design UNRESOLVED — missing AliceCutsceneFinished remote
	-- Option A: Create the remote and implement full sequence
	-- Option B: Redesign trigger (e.g., day 20 after Alice, same CurrentDay signal)
end

local function initialize(config: any)
	print("[CutsceneService] Initializing (SKELETON)...")

	-- MILESTONE 4: Create reusable cutscene controller
	-- Supports: camera control, fade in/out, typewriter, sequencing, callbacks

	-- Alice cutscene
	-- DayNightService.dayChanged:Connect(function(day)
	--     if day == config.triggers.aliceCutsceneDay then
	--         startAliceCutscene()
	--     end
	-- end)

	-- Mine cutscene (design UNRESOLVED: missing AliceCutsceneFinished remote)
	-- DayNightService.dayChanged:Connect(function(day)
	--     if day == config.triggers.mineCutsceneDay then
	--         startMineCutscene()
	--     end
	-- end)

	RemoteEvents.getRemoteEvent("MineCutsceneFinished").OnServerEvent:Connect(onMineCutsceneFinished)

	print("[CutsceneService] Skeleton initialized")
end

return {
	initialize = initialize,
}