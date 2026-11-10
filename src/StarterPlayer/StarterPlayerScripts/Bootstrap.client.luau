--!strict
--[[
	Bootstrap.client.luau
	Client initialization entry point.
	Waits for PlayerDataLoaded, then initializes all controllers.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

-- Controllers
local HUDController = require(StarterPlayerScripts.Controllers.HUDController)
local MiningController = require(StarterPlayerScripts.Controllers.MiningController)
local ShopController = require(StarterPlayerScripts.Controllers.ShopController)
local DialogueController = require(StarterPlayerScripts.Controllers.DialogueController)
local CutsceneController = require(StarterPlayerScripts.Controllers.CutsceneController)
local BossController = require(StarterPlayerScripts.Controllers.BossController)
local GhostController = require(StarterPlayerScripts.Controllers.GhostController)

local player = Players.LocalPlayer

-- Configuration
local PLAYER_DATA_TIMEOUT = 30 -- seconds
local RETRY_DELAY = 5 -- seconds

local dataLoaded = false
local playerData: any = nil

local function onPlayerDataLoaded(loadedPlayerData: any)
	if dataLoaded then
		warn("[Bootstrap.client] PlayerDataLoaded fired multiple times, ignoring duplicate")
		return
	end

	print("[Bootstrap.client] Player data loaded")
	print(`[Bootstrap.client] Coins: ${loadedPlayerData.coins}, Silver: ${loadedPlayerData.silver}, Baguerite: ${loadedPlayerData.baguerite}, Scrap: ${loadedPlayerData.scrap}, GhostEnergy: ${loadedPlayerData.ghostEnergy}`)
	print(`[Bootstrap.client] Day: ${loadedPlayerData.currentDay}`)

	playerData = loadedPlayerData
	dataLoaded = true

	-- Initialize all controllers with independent error handling
	local controllers = {
		{ name = "HUDController", init = function() HUDController.initialize(playerData) end },
		{ name = "MiningController", init = function() MiningController.initialize() end },
		{ name = "ShopController", init = function() ShopController.initialize() end },
		{ name = "DialogueController", init = function() DialogueController.initialize() end },
		{ name = "CutsceneController", init = function() CutsceneController.initialize() end },
		{ name = "BossController", init = function() BossController.initialize() end },
		{ name = "GhostController", init = function() GhostController.initialize() end },
	}

	for _, controller in ipairs(controllers) do
		local success, err = pcall(controller.init)
		if not success then
			warn(`[Bootstrap.client] Failed to initialize ${controller.name}: ${err}`)
		else
			print(`[Bootstrap.client] Initialized ${controller.name}`)
		end
	end

	print("[Bootstrap.client] All controllers initialized (with any errors logged above)")
end

local function onDataUpdate(update: any)
	-- Forward to HUDController
	HUDController.onDataUpdate(update)
end

local function startTimeout()
	task.delay(PLAYER_DATA_TIMEOUT, function()
		if not dataLoaded then
			warn(`[Bootstrap.client] PlayerDataLoaded not received after ${PLAYER_DATA_TIMEOUT}s, retrying...`)
			-- Request data again (server may have missed the initial fire)
			-- In M2, server will handle retries; for M1 we just log
			warn("[Bootstrap.client] UI may show default/empty state until data arrives")
		end
	end)
end

local function initialize()
	print("[Bootstrap.client] Initializing...")

	-- Connect RemoteEvents
	RemoteEvents.getRemoteEvent("PlayerDataLoaded").OnClientEvent:Connect(onPlayerDataLoaded)
	RemoteEvents.getRemoteEvent("DataUpdate").OnClientEvent:Connect(onDataUpdate)

	-- Connect other RemoteEvents to controllers
	RemoteEvents.getRemoteEvent("ShopPurchaseResult").OnClientEvent:Connect(ShopController.onPurchaseResult)
	RemoteEvents.getRemoteEvent("AliceCutsceneEvent").OnClientEvent:Connect(CutsceneController.onAliceCutscene)
	RemoteEvents.getRemoteEvent("AliceRevealEvent").OnClientEvent:Connect(CutsceneController.onAliceReveal)
	RemoteEvents.getRemoteEvent("MineCutsceneEvent").OnClientEvent:Connect(CutsceneController.onMineCutscene)
	RemoteEvents.getRemoteEvent("BossDialogueEvent").OnClientEvent:Connect(BossController.onBossDialogue)
	RemoteEvents.getRemoteEvent("DialogueStart").OnClientEvent:Connect(DialogueController.onDialogueStart)
	RemoteEvents.getRemoteEvent("MiningProgress").OnClientEvent:Connect(MiningController.onMiningProgress)
	RemoteEvents.getRemoteEvent("GhostAbsorb").OnClientEvent:Connect(GhostController.onGhostAbsorb)
	RemoteEvents.getRemoteEvent("DayChanged").OnClientEvent:Connect(HUDController.onDayChanged)

	-- Start timeout watchdog
	startTimeout()

	print("[Bootstrap.client] Initialized")
end

initialize()