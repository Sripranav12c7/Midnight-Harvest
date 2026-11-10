--!strict
--[[
	CutsceneController.client.luau
	Camera control, fade, typewriter, input locking.
	MILESTONE 4: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

local isInCutscene = false
local originalCameraType = Enum.CameraType.Custom
local originalCameraCFrame = CFrame.new()
local inputConnections: { RBXScriptConnection } = {}

local function initialize()
	print("[CutsceneController] Initializing (SKELETON)...")

	RemoteEvents.getRemoteEvent("AliceCutsceneEvent").OnClientEvent:Connect(onAliceCutscene)
	RemoteEvents.getRemoteEvent("AliceRevealEvent").OnClientEvent:Connect(onAliceReveal)
	RemoteEvents.getRemoteEvent("MineCutsceneEvent").OnClientEvent:Connect(onMineCutscene)

	print("[CutsceneController] Skeleton initialized")
end

local function onAliceCutscene()
	-- MILESTONE 4: Alice cutscene sequence
	-- 1. Lock input
	-- 2. Fade to black
	-- 3. Typewriter dialogue
	-- 4. Camera on Alice
	-- 5. Fade back
	-- 6. Unlock input
end

local function onAliceReveal()
	-- MILESTONE 4: Alice spawns, camera on her
end

local function onMineCutscene()
	-- MILESTONE 4: Mine cutscene (design UNRESOLVED)
	-- Missing AliceCutsceneFinished remote in original
	-- Option A: Create remote, implement full sequence
	-- Option B: Redesign trigger
end

local function startCutscene()
	isInCutscene = true
	originalCameraType = camera.CameraType
	originalCameraCFrame = camera.CFrame
	camera.CameraType = Enum.CameraType.Scriptable

	-- Lock input
	lockInput()
end

local function endCutscene()
	isInCutscene = false
	camera.CameraType = originalCameraType
	camera.CFrame = originalCameraCFrame
	unlockInput()
end

local function lockInput()
	-- Disable movement, jumping, etc.
	-- UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
end

local function unlockInput()
	-- Restore input
	-- UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

local function fadeIn(duration: number): Tween
	-- MILESTONE 4: Create fade frame, tween transparency 1 -> 0
	return nil :: any
end

local function fadeOut(duration: number): Tween
	-- MILESTONE 4: Fade 0 -> 1
	return nil :: any
end

local function typewriter(textLabel: TextLabel, text: string, speed: number)
	-- MILESTONE 4: Typewriter animation
end

return {
	initialize = initialize,
	startCutscene = startCutscene,
	endCutscene = endCutscene,
}