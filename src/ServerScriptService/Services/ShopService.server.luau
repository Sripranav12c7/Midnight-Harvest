--!strict
--[[
	ShopService.lua
	All 7 shops, purchase validation, ownership guards, distance checks.
	ALL VALUES UNAPPROVED.
]]

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local ShopConfig = require(ReplicatedStorage.Shared.Config.ShopConfig)
local ToolNames = require(ReplicatedStorage.Shared.Constants.ToolNames)
local EconomyService = require(script.Parent.EconomyService)
local InventoryService = require(script.Parent.InventoryService)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

-- Shop interaction distance (studs)
local INTERACTION_DISTANCE = 12

-- Track purchase cooldowns per player per shop
local purchaseCooldowns: { [Player]: { [string]: number } } = {}
local COOLDOWN_DURATION = 0.5

local function getShopConfig(shopId: string)
	return ShopConfig.shops[shopId]
end

local function validatePurchase(player: Player, shopId: string): (boolean, string?)
	if not player then return false, "Invalid player" end

	local shop = getShopConfig(shopId)
	if not shop then return false, "Shop not found" end

	-- Check cooldown
	local now = os.clock()
	local playerCooldowns = purchaseCooldowns[player]
	if playerCooldowns and playerCooldowns[shopId] then
		if now - playerCooldowns[shopId] < COOLDOWN_DURATION then
			return false, "Purchase on cooldown"
		end
	end

	-- Check distance (ProximityPrompt handles this, but double-check)
	local character = player.Character
	if not character then return false, "No character" end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return false, "No HumanoidRootPart" end

	-- Find shop prompt in workspace
	local shopTool = workspace:FindFirstChild(shopId)
	if not shopTool then return false, "Shop not found in workspace" end
	local prompt = shopTool:FindFirstChild("Handle") and shopTool.Handle:FindFirstChild("ProximityPrompt")
	if not prompt then return false, "No ProximityPrompt" end

	local distance = (rootPart.Position - prompt.Parent.Position).Magnitude
	if distance > INTERACTION_DISTANCE then
		return false, "Too far from shop"
	end

	-- Check ownership guard
	if shop.ownershipGuard == "backpack" then
		if player.Backpack:FindFirstChild(shop.toolName) or (character and character:FindFirstChild(shop.toolName)) then
			return false, "Already owned"
		end
	elseif shop.ownershipGuard == "attribute" then
		if player:GetAttribute(shop.attributeName) then
			return false, "Already owned"
		end
	end

	-- Check currency
	local price = GameConfig.shopPrices[shop.priceKey]
	if not price then return false, "Price not configured" end
	if not EconomyService.canAfford(player, "Coins", price) then
		return false, "Insufficient coins"
	end

	return true, nil
end

local function processPurchase(player: Player, shopId: string): (boolean, string?)
	local shop = getShopConfig(shopId)
	if not shop then return false, "Shop not found" end

	local price = GameConfig.shopPrices[shop.priceKey]
	if not price then return false, "Price not configured" end

	-- Deduct coins
	local result = EconomyService.removeCurrency(player, "Coins", price)
	if not result.success then
		return false, result.message or "Purchase failed"
	end

	-- Grant tool
	local toolName = shop.toolName
	local toolTemplate = ServerStorage:WaitForChild("Tools"):WaitForChild(toolName, 5)
	if not toolTemplate then
		-- Refund on failure
		EconomyService.addCurrency(player, "Coins", price)
		return false, "Tool template not found"
	end

	local newTool = toolTemplate:Clone()
	newTool.Parent = player.Backpack

	-- Update inventory
	InventoryService.grantTool(player, toolName)

	-- Set ownership attribute if needed
	local shopConfig = getShopConfig(shopId)
	if shopConfig.ownershipGuard == "attribute" and shopConfig.attributeName then
		player:SetAttribute(shopConfig.attributeName, true)
	end

	-- Set cooldown
	purchaseCooldowns[player] = purchaseCooldowns[player] or {}
	purchaseCooldowns[player][shopId] = os.clock()

	return true, nil
end

local function onShopPurchase(player: Player, shopId: string)
	local success, message = validatePurchase(player, shopId)
	if not success then
		RemoteEvents.getRemoteEvent("ShopPurchaseResult"):FireClient(player, {
			success = false,
			message = message,
		})
		return
	end

	success, message = processPurchase(player, shopId)
	RemoteEvents.getRemoteEvent("ShopPurchaseResult"):FireClient(player, {
		success = success,
		itemName = getShopConfig(shopId)?.name,
		message = message,
		newCoins = EconomyService.getCurrencies(player).Coins,
	})
end

local function initialize(config: any, shopConfig: any, economy: any, inventory: any)
	print("[ShopService] Initializing...")

	-- Connect RemoteEvent
	RemoteEvents.getRemoteEvent("ShopPurchase").OnServerEvent:Connect(onShopPurchase)

	print("[ShopService] Initialized")
end

return {
	initialize = initialize,
	validatePurchase = validatePurchase,
	processPurchase = processPurchase,
}