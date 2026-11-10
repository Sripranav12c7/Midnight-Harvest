--!strict
--[[
	DialogueController.client.luau
	Typewriter dialogue display.
	MILESTONE 4: Full implementation. MILESTONE 1: Skeleton.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local dialogueFrame: Frame?
local dialogueText: TextLabel?
local npcNameLabel: TextLabel?

-- Forward declarations for callbacks (must be before initialize)
local function typewriter(text: string, speed: number)
	-- MILESTONE 4: Typewriter animation
	-- dialogueText.Text = ""
	-- for i = 1, #text do
	--     dialogueText.Text = string.sub(text, 1, i)
	--     task.wait(speed)
	-- end
end

local function onDialogueStart(data: any)
	-- MILESTONE 4: Show dialogue with typewriter effect
	-- npcNameLabel.Text = data.npcName
	-- dialogueFrame.Visible = true
	-- for _, line in ipairs(data.dialogueLines) do
	--     typewriter(line, GameConfig.npcs.dialogueSpeed)
	--     task.wait(GameConfig.npcs.dialoguePause)
	-- end
	-- dialogueFrame.Visible = false
end

local function initialize()
	print("[DialogueController] Initializing (SKELETON)...")

	-- MILESTONE 4: Find/create DialogueGui from StarterGui/Interfaces
	-- dialogueFrame = PlayerGui:WaitForChild("DialogueGui"):WaitForChild("DialogueFrame")
	-- dialogueText = dialogueFrame:WaitForChild("DialogueText")
	-- npcNameLabel = dialogueFrame:WaitForChild("NPCName")

	RemoteEvents.getRemoteEvent("DialogueStart").OnClientEvent:Connect(onDialogueStart)

	print("[DialogueController] Skeleton initialized")
end

return {
	initialize = initialize,
	onDialogueStart = onDialogueStart,
}