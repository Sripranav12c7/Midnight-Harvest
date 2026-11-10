--!strict
--[[
	NPCService.lua
	5 NPCs, dialogue queues, typewriter, story flags.
	MILESTONE 4: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

export type NPCData = {
	id: string,
	name: string,
	dialogueLines: { string },
	model: Model,
	prompt: ProximityPrompt,
}

local npcs: { [string]: NPCData } = {}

local function initialize(config: any)
	print("[NPCService] Initializing (SKELETON)...")

	-- MILESTONE 4: Register 5 NPCs from Workspace
	-- Arwin, Barn Keeper, Murugesan, Old Miner, The Older
	-- Connect ProximityPrompt.Triggered to onNPCTalk

	RemoteEvents.getRemoteEvent("DialogueStart").OnServerEvent:Connect(onDialogueStart)

	print("[NPCService] Skeleton initialized")
end

local function onNPCTalk(player: Player, npcId: string)
	-- MILESTONE 4: Show dialogue with typewriter effect
end

local function onDialogueStart(player: Player, npcId: string)
	-- Client requests dialogue (for UI sync)
end

return {
	initialize = initialize,
}