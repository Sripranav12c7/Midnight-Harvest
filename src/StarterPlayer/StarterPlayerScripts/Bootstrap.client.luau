--!strict
--[[
	Bootstrap.client.luau
	Client initialization entry point.
	Waits for PlayerDataLoaded, then initializes all controllers.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayerScripts = game:GetService("StarterPlayer").StarterPlayerScripts

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

local function onPlayerDataLoaded(playerData: any)
	print("[Bootstrap.client] Player data loaded")
	print(`[Bootstrap.client] Coins: ${playerData.coins}, Silver: ${playerData.silver}, Baguerite: ${playerData.baguerite}, Scrap: ${playerData.scrap}, GhostEnergy: ${playerData.ghostEnergy}`)
	print(`[Bootstrap.client] Day: ${playerData.currentDay}`)

	-- Initialize all controllers
	HUDController.initialize(playerData)
	MiningController.initialize()
	ShopController.initialize()
	DialogueController.initialize()
	CutsceneController.initialize()
	BossController.initialize()
	GhostController.initialize()

	print("[Bootstrap.client] All controllers initialized")
end

local function onDataUpdate(update: any)
	-- Forward to HUDController
	HUDController.onDataUpdate(update)
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

	print("[Bootstrap.client] Initialized")
end

initialize()