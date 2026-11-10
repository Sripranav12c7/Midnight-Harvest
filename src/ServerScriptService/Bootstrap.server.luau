--!strict
--[[
	Bootstrap.server.luau
	Server initialization entry point.
	Defines explicit service load order and dependency wiring.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

-- Shared modules
local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)
local RemoteFunctions = require(ReplicatedStorage.Remotes.RemoteFunctions)
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local ShopConfig = require(ReplicatedStorage.Shared.Config.ShopConfig)
local GhostConfig = require(ReplicatedStorage.Shared.Config.GhostConfig)
local MiningConfig = require(ReplicatedStorage.Shared.Config.MiningConfig)
local DayNightConfig = require(ReplicatedStorage.Shared.Config.DayNightConfig)

-- Services
local PlayerService = require(ServerScriptService.Services.PlayerService)
local EconomyService = require(ServerScriptService.Services.EconomyService)
local InventoryService = require(ServerScriptService.Services.InventoryService)
local ShopService = require(ServerScriptService.Services.ShopService)
local PersistenceService = require(ServerScriptService.Services.PersistenceService)

-- Systems
local MiningService = require(ServerScriptService.Systems.MiningService)
local ScrapService = require(ServerScriptService.Systems.ScrapService)
local GhostService = require(ServerScriptService.Systems.GhostService)
local DayNightService = require(ServerScriptService.Systems.DayNightService)
local NPCService = require(ServerScriptService.Systems.NPCService)
local CutsceneService = require(ServerScriptService.Systems.CutsceneService)
local BossService = require(ServerScriptService.Systems.BossService)

-- Initialize Remotes
RemoteEvents.initializeRemoteEvents()
RemoteFunctions.initializeRemoteFunctions()

-- Service initialization order (dependencies first)
local function initializeServices()
	print("[Bootstrap] Initializing services...")

	-- 1. PersistenceService: Load player data first
	PersistenceService.initialize(GameConfig)

	-- 2. PlayerService: Character setup
	PlayerService.initialize()

	-- 3. EconomyService: Leaderstats, currencies
	EconomyService.initialize(GameConfig, PersistenceService)

	-- 4. InventoryService: Tool ownership
	InventoryService.initialize(PersistenceService)

	-- 5. ShopService: Register shops
	ShopService.initialize(GameConfig, ShopConfig, EconomyService, InventoryService)

	-- 6. DayNightService: Start cycle
	DayNightService.initialize(DayNightConfig, CutsceneService, GhostService)

	-- 7. GhostService: Initial spawn
	GhostService.initialize(GhostConfig, DayNightService)

	-- 8. MiningService: Register ores
	MiningService.initialize(MiningConfig, EconomyService, InventoryService)

	-- 9. ScrapService: Register scrap
	ScrapService.initialize(GameConfig, EconomyService)

	-- 10. NPCService: Register NPCs
	NPCService.initialize(GameConfig)

	-- 11. CutsceneService: Ready for triggers
	CutsceneService.initialize(GameConfig)

	-- 12. BossService: Ready for activation
	BossService.initialize(GameConfig, GhostConfig, CutsceneService)

	print("[Bootstrap] All services initialized")
end

-- Player lifecycle
Players.PlayerAdded:Connect(function(player)
	-- PersistenceService handles load in PlayerAdded
	PersistenceService.onPlayerAdded(player)

	-- Wait for data load before initializing player services
	task.spawn(function()
		-- Data load is async; services check PersistenceService.isLoaded(player)
		-- EconomyService/InventoryService will apply loaded data when ready
	end)
end)

Players.PlayerRemoving:Connect(function(player)
	PersistenceService.onPlayerRemoving(player)
end)

-- Server shutdown
game:BindToClose(function()
	PersistenceService.onBindToClose()
end)

-- Heartbeat for lock renewal (PersistenceService)
RunService.Heartbeat:Connect(function()
	PersistenceService.heartbeat()
end)

-- Initialize all services
initializeServices()

print("[Bootstrap] Server bootstrap complete")