--!strict
--[[
	GhostService.lua
	Spawn 26+3, AI, single damage authority, absorption, energy rewards, respawn.
	MILESTONE 3: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GhostConfig = require(ReplicatedStorage.Shared.Config.GhostConfig)
local EconomyService = require(script.Parent.Parent.Services.EconomyService)
local DayNightService = require(script.Parent.DayNightService)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

export type GhostRuntimeData = {
	model: Model,
	ghostType: "Ghost" | "DeepGhost",
	humanoid: Humanoid,
	rootPart: BasePart,
	isAlive: boolean,
	isVisible: boolean,
	absorptionPrompt: ProximityPrompt?,
	lastDamageTime: number,
	chaseTarget: Player?,
}

local ghostPopulation: { [Model]: GhostRuntimeData } = {}
local ghostTemplates: { Ghost: Model, DeepGhost: Model } = {}

-- Forward declarations for callbacks (must be before initialize)
local function onGhostAbsorb(player: Player, ghost: Model)
	-- MILESTONE 3: Validate tool (GhostVacuum), grant energy, destroy ghost
end

local function spawnGhost(ghostType: "Ghost" | "DeepGhost", position: CFrame?)
	-- MILESTONE 3: Clone template, position, setup AI/damage/absorption
end

local function onDayChanged(newDay: number, isNight: boolean)
	-- MILESTONE 3: Toggle visibility, respawn if needed
	-- RESPAWN BEHAVIOR UNRESOLVED: restore 26+3 or 23+2?
end

local function initialize(config: any, dayNight: any)
	print("[GhostService] Initializing (SKELETON)...")

	-- MILESTONE 3: Load templates from ServerStorage/Templates/Ghosts/
	-- ghostTemplates.Ghost = ServerStorage.Templates.Ghosts.Ghost
	-- ghostTemplates.DeepGhost = ServerStorage.Templates.Ghosts.DeepGhost

	-- MILESTONE 3: Initial spawn (26 Ghost + 3 Deep Ghost)
	-- for i = 1, config.spawn.ghostCount do spawnGhost("Ghost") end
	-- for i = 1, config.spawn.deepGhostCount do spawnGhost("DeepGhost") end

	-- Day/night visibility
	-- DayNightService.dayChanged:Connect(onDayChanged)

	-- Absorption remote
	RemoteEvents.getRemoteEvent("GhostAbsorb").OnServerEvent:Connect(onGhostAbsorb)

	print("[GhostService] Skeleton initialized")
end

return {
	initialize = initialize,
}