--!strict
--[[
	InventoryService.lua
	Tool ownership, equipped state, capacity validation.
	No persistence dependency in Milestone 1 (stubbed).
]]

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolNames = require(ReplicatedStorage.Shared.Constants.ToolNames)
local EconomyTypes = require(ReplicatedStorage.Shared.Types.EconomyTypes)

local PersistenceService: any = nil

-- Per-player inventory state
local playerInventories: { [Player]: EconomyTypes.ToolOwnership } = {}
local playerEquipped: { [Player]: string? } = {}
local playerLoaded: { [Player]: boolean } = {}

local function getInventory(player: Player): EconomyTypes.ToolOwnership
	return playerInventories[player] or {}
end

local function setInventory(player: Player, inventory: EconomyTypes.ToolOwnership)
	playerInventories[player] = inventory
end

local function ownsTool(player: Player, toolName: string): boolean
	local inventory = getInventory(player)
	return inventory[toolName] == true
end

local function grantTool(player: Player, toolName: string): boolean
	if ownsTool(player, toolName) then
		return false
	end
	local inventory = getInventory(player)
	inventory[toolName] = true
	setInventory(player, inventory)
	return true
end

local function revokeTool(player: Player, toolName: string): boolean
	local inventory = getInventory(player)
	if inventory[toolName] then
		inventory[toolName] = nil
		setInventory(player, inventory)
		return true
	end
	return false
end

local function getEquippedTool(player: Player): string?
	return playerEquipped[player]
end

local function setEquippedTool(player: Player, toolName: string?)
	playerEquipped[player] = toolName
end

local function isToolEquipped(player: Player, toolName: string): boolean
	return playerEquipped[player] == toolName
end

local function canEquipTool(player: Player, toolName: string): boolean
	-- Check ownership
	if not ownsTool(player, toolName) then
		return false
	end
	-- Check if already equipped
	if isToolEquipped(player, toolName) then
		return false
	end
	-- Check if another tool is equipped (unequip first)
	return true
end

local function onPlayerAdded(player: Player)
	playerInventories[player] = {}
	playerEquipped[player] = nil
	playerLoaded[player] = false
end

local function onPlayerRemoving(player: Player)
	playerInventories[player] = nil
	playerEquipped[player] = nil
	playerLoaded[player] = nil
end

local function initialize(persistence: any)
	PersistenceService = persistence
	print("[InventoryService] Initializing...")

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end

	print("[InventoryService] Initialized")
end

local function setPersistenceLoaded(player: Player, loaded: boolean)
	playerLoaded[player] = loaded
	if loaded and PersistenceService then
		local data = PersistenceService.getPlayerData(player)
		if data then
			setInventory(player, data.ownedTools or {})
			playerEquipped[player] = data.equippedTool
		end
	end
end

return {
	initialize = initialize,
	setPersistenceLoaded = setPersistenceLoaded,
	getInventory = getInventory,
	ownsTool = ownsTool,
	grantTool = grantTool,
	revokeTool = revokeTool,
	getEquippedTool = getEquippedTool,
	setEquippedTool = setEquippedTool,
	isToolEquipped = isToolEquipped,
	canEquipTool = canEquipTool,
}