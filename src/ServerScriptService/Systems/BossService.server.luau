--!strict
--[[
	BossService.lua
	Dreadon activation, energy transfer, fight state, defeat condition.
	MILESTONE 5: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local GhostConfig = require(ReplicatedStorage.Shared.Config.GhostConfig)

local EconomyService = require(script.Parent.Parent.Services.EconomyService)
local GhostService = require(script.Parent.GhostService)
local CutsceneService = require(script.Parent.CutsceneService)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)
local StatNames = require(ReplicatedStorage.Shared.Constants.StatNames)

-- Boss state
local bossEnergy = 0
local bossBattleActive = false
local bossDefeated = false
local bossModel: Model? = nil

local function initialize(config: any, ghostConfig: any, cutscene: any)
	print("[BossService] Initializing (SKELETON)...")

	-- Create ReplicatedStorage values
	local bossEnergyValue = Instance.new("IntValue")
	bossEnergyValue.Name = StatNames.Names.BossEnergy
	bossEnergyValue.Value = 0
	bossEnergyValue.Parent = ReplicatedStorage

	local bossEnergyRequiredValue = Instance.new("IntValue")
	bossEnergyRequiredValue.Name = StatNames.Names.BossEnergyRequired
	bossEnergyRequiredValue.Value = config.boss.energyRequired -- UNAPPROVED: 2000
	bossEnergyRequiredValue.Parent = ReplicatedStorage

	local bossBattleActiveValue = Instance.new("BoolValue")
	bossBattleActiveValue.Name = StatNames.Names.BossBattleActive
	bossBattleActiveValue.Value = false
	bossBattleActiveValue.Parent = ReplicatedStorage

	-- MILESTONE 5: Load Dreadon from ServerStorage/Templates/Boss/
	-- bossModel = ServerStorage.Templates.Boss.Dreadon:Clone()
	-- bossModel.Parent = Workspace

	-- Energy transfer remote
	RemoteEvents.getRemoteEvent("BossEnergyTransfer").OnServerEvent:Connect(onEnergyTransfer)

	-- Boss fight start remote
	RemoteEvents.getRemoteEvent("BossFightStart").OnServerEvent:Connect(onBossFightStart)

	-- BossFinalEvent bindable (MILESTONE 5: connect to bindable event)
	-- RemoteEvents.getBindableEvent(RemoteNames.Bindables.BossFinalEventBindable).Event:Connect(onBossFinalEvent)

	print("[BossService] Skeleton initialized")
end

local function onEnergyTransfer(player: Player, amount: number)
	-- MILESTONE 5: Validate amount, transfer from player.GhostEnergy to bossEnergy
	-- Fire BossFinalEvent when bossEnergy >= bossEnergyRequired
end

local function onBossFightStart(player: Player)
	-- MILESTONE 5: Validate bossEnergy >= required, boss exists, not already active
	-- Start fight state machine: Idle -> Dialogue -> Active -> Defeated
	-- Play BossBattleBGM
end

local function onBossFinalEvent()
	-- MILESTONE 5: Fire BossDialogueEvent, then enable BossFightStart
end

local function startBossFight()
	-- MILESTONE 5: Boss AI (chase, attack, health pool), defeat condition, BGM, cleanup
end

local function defeatBoss()
	-- MILESTONE 5: Stop BGM, reset bossBattleActive, fire victory event
end

return {
	initialize = initialize,
}