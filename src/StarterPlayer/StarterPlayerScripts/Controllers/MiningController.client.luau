--!strict
--[[
	MiningController.client.luau
	SelectionBox, raycast, mining progress UI.
	MILESTONE 2: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ToolNames = require(ReplicatedStorage.Shared.Constants.ToolNames)
local MiningConfig = require(ReplicatedStorage.Shared.Config.MiningConfig)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local selectionBox: SelectionBox?
local currentOre: Model?
local moveConnection: RBXScriptConnection?
local clickConnection: RBXScriptConnection?
local cooldown = 0

local function initialize()
	print("[MiningController] Initializing (SKELETON)...")

	-- MILESTONE 2: Create SelectionBox
	-- selectionBox = Instance.new("SelectionBox")
	-- selectionBox.Name = "OreSelection"
	-- selectionBox.Color = BrickColor.new("Really red")
	-- selectionBox.LineThickness = 0.05
	-- selectionBox.Visible = false
	-- selectionBox.Parent = player.PlayerGui

	-- Tool equipped/unequipped handling
	-- player.CharacterAdded:Connect(onCharacterAdded)

	-- Mining progress UI
	-- Create progress bar UI

	print("[MiningController] Skeleton initialized")
end

local function onCharacterAdded(character: Model)
	-- MILESTONE 2: Handle tool equip/unequip
end

local function onToolEquipped(tool: Tool)
	if tool.Name ~= ToolNames.Names.WoodPick then return end

	-- Start mouse raycast loop
	-- moveConnection = RunService.RenderStepped:Connect(onMouseMove)
	-- clickConnection = mouse.Button1Down:Connect(onClick)
end

local function onToolUnequipped(tool: Tool)
	if tool.Name ~= ToolNames.Names.WoodPick then return end

	-- Cleanup
	-- if moveConnection then moveConnection:Disconnect() end
	-- if clickConnection then clickConnection:Disconnect() end
	-- if selectionBox then selectionBox.Visible = false end
	-- currentOre = nil
end

local function onMouseMove()
	-- MILESTONE 2: Raycast to find valid ore
	-- local target = mouse.Target
	-- local ore = getValidOre(target)
	-- if ore then
	--     selectionBox.Adornee = ore
	--     selectionBox.Visible = true
	--     currentOre = ore
	-- else
	--     selectionBox.Visible = false
	--     currentOre = nil
	-- end
end

local function getValidOre(target: Instance?): Model?
	-- MILESTONE 2: Check if target is part of valid ore model
	return nil
end

local function onClick()
	-- MILESTONE 2: Fire MineOre remote if valid ore selected
	-- if currentOre and os.clock() > cooldown then
	--     RemoteEvents.getRemoteEvent("MineOre"):FireServer(currentOre)
	--     cooldown = os.clock() + 0.5
	-- end
end

local function onMiningProgress(data: any)
	-- MILESTONE 2: Update progress UI
	-- progress = data.hits / data.requiredHits
	-- updateProgressBar(data.ore, progress)
end

return {
	initialize = initialize,
	onMiningProgress = onMiningProgress,
}