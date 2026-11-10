--!strict
--[[
	ScrapService.lua
	Per-player scrap state, collection, day respawn, selling.
	MILESTONE 2: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local EconomyService = require(script.Parent.Parent.Services.EconomyService)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

-- Scrap runtime state per node
export type ScrapRuntimeData = {
	model: Model,
	originalCFrame: CFrame,
	collectedBy: { [Player]: boolean },
}

local scrapStates: { [Model]: ScrapRuntimeData } = {}
local currentDay = 1

local function onScrapCollect(player: Player, scrap: Model)
	-- MILESTONE 2: Validate and grant scrap
end

local function onScrapSell(player: Player)
	-- MILESTONE 2: Sell all scrap for coins
end

local function onDayChanged(newDay: number)
	currentDay = newDay
	-- Respawn all collected scrap
	for _, state in pairs(scrapStates) do
		if next(state.collectedBy) then
			-- Respawn logic
		end
	end
end

local function initialize(config: any, economy: any)
	print("[ScrapService] Initializing (SKELETON)...")

	-- MILESTONE 2: Register scrap nodes from Workspace/Scarps
	-- for _, obj in ipairs(Workspace.Scarps:GetChildren()) do
	--     if obj.Name == "ScrapMetal" then
	--         scrapStates[obj] = { ... }
	--         -- Connect ProximityPrompt
	--     end
	-- end

	-- Day change listener
	-- DayNightService.dayChanged:Connect(onDayChanged)

	RemoteEvents.getRemoteEvent("ScrapCollect").OnServerEvent:Connect(onScrapCollect)
	RemoteEvents.getRemoteEvent("ScrapSell").OnServerEvent:Connect(onScrapSell)

	print("[ScrapService] Skeleton initialized")
end

return {
	initialize = initialize,
}