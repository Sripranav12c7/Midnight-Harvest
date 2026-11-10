--!strict
--[[
	PlayerService.lua
	Character initialization, health, scale, speed, death/respawn, pouch attachment.
]]

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)

local pouchTemplate: Part? = nil

local function getPouchTemplate(): Part
	if not pouchTemplate then
		pouchTemplate = ServerStorage:WaitForChild("LootPouch", 5) :: Part
		if not pouchTemplate then
			warn("[PlayerService] LootPouch not found in ServerStorage")
		end
	end
	return pouchTemplate
end

local function setupCharacter(character: Model)
	local humanoid = character:WaitForChild("Humanoid", 5)
	if not humanoid then
		warn("[PlayerService] Humanoid not found for character")
		return
	end

	-- Health (original intended 200, was broken)
	humanoid.MaxHealth = GameConfig.player.maxHealth
	humanoid.Health = GameConfig.player.maxHealth

	-- Scale (2x)
	local bodyDepth = humanoid:WaitForChild("BodyDepthScale", 5)
	local bodyHeight = humanoid:WaitForChild("BodyHeightScale", 5)
	local bodyWidth = humanoid:WaitForChild("BodyWidthScale", 5)
	local headScale = humanoid:WaitForChild("HeadScale", 5)

	if bodyDepth then bodyDepth.Value = GameConfig.player.scale end
	if bodyHeight then bodyHeight.Value = GameConfig.player.scale end
	if bodyWidth then bodyWidth.Value = GameConfig.player.scale end
	if headScale then headScale.Value = GameConfig.player.scale end

	-- WalkSpeed
	humanoid.WalkSpeed = GameConfig.player.walkSpeed

	-- Loot Pouch
	local pouch = getPouchTemplate()
	if pouch then
		local clone = pouch:Clone()
		clone.Name = "LootPouch"
		clone.Parent = character

		local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
		if torso then
			clone.CFrame = torso.CFrame * CFrame.new(GameConfig.player.pouchOffset)
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = torso
			weld.Part1 = clone
			weld.Parent = clone
			clone.CanCollide = false
			clone.Anchored = false
		else
			warn("[PlayerService] No torso found for pouch attachment")
		end
	end
end

local function onPlayerAdded(player: Player)
	player.CharacterAdded:Connect(setupCharacter)
	if player.Character then
		setupCharacter(player.Character)
	end
end

local function initialize()
	print("[PlayerService] Initializing...")
	Players.PlayerAdded:Connect(onPlayerAdded)
	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end
	print("[PlayerService] Initialized")
end

return {
	initialize = initialize,
	setupCharacter = setupCharacter,
}