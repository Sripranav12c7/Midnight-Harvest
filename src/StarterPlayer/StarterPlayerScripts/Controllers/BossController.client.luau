--!strict
--[[
	BossController.client.luau
	Boss dialogue, health bar, effects.
	MILESTONE 5: Full implementation. MILESTONE 1: Skeleton.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local dialogueBox: Frame?
local dialogueText: TextLabel?
local fadeFrame: Frame?
local healthBar: Frame?
local bossNameLabel: TextLabel?

local function onBossDialogue()
	-- MILESTONE 5: Boss dialogue sequence (4 lines + fade)
	-- Similar to original Typewriter script
end

local function showHealthBar(bossName: string, currentHealth: number, maxHealth: number)
	-- MILESTONE 5: Show/update boss health bar
end

local function hideHealthBar()
	-- MILESTONE 5: Hide health bar
end

local function initialize()
	print("[BossController] Initializing (SKELETON)...")

	-- MILESTONE 5: Find BossDialogueGui from StarterGui/Interfaces
	-- dialogueBox = PlayerGui:WaitForChild("BossDialogueGui"):WaitForChild("DialogueBox")
	-- dialogueText = dialogueBox:WaitForChild("DialogueText")
	-- fadeFrame = PlayerGui:WaitForChild("BossDialogueGui"):WaitForChild("FadeFrame")

	RemoteEvents.getRemoteEvent("BossDialogueEvent").OnClientEvent:Connect(onBossDialogue)

	print("[BossController] Skeleton initialized")
end

return {
	initialize = initialize,
	onBossDialogue = onBossDialogue,
	showHealthBar = showHealthBar,
	hideHealthBar = hideHealthBar,
}