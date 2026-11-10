--!strict
--[[
	GhostController.client.luau
	Ghost visual effects: glow, sounds, absorption feedback.
	MILESTONE 3: Full implementation. MILESTONE 1: Skeleton.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local function initialize()
	print("[GhostController] Initializing (SKELETON)...")

	RemoteEvents.getRemoteEvent("GhostAbsorb").OnClientEvent:Connect(onGhostAbsorb)

	-- MILESTONE 3: Listen for ghost spawn/despawn
	-- GhostService.ghostSpawned:Connect(onGhostSpawned)
	-- GhostService.ghostDespawned:Connect(onGhostDespawned)

	print("[GhostController] Skeleton initialized")
end

local function onGhostAbsorb(data: any)
	-- MILESTONE 3: Visual feedback for ghost absorption
	-- Purple highlight, particle effect, sound
end

local function onGhostSpawned(ghost: Model, ghostType: string)
	-- MILESTONE 3: Setup visual effects (night glow, sounds)
end

local function onGhostDespawned(ghost: Model)
	-- MILESTONE 3: Cleanup effects
end

return {
	initialize = initialize,
	onGhostAbsorb = onGhostAbsorb,
}