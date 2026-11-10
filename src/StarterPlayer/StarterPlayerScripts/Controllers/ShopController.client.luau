--!strict
--[[
	ShopController.client.luau
	Shop UI, purchase requests.
	MILESTONE 2: Full implementation. MILESTONE 1: Skeleton.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

local player = Players.LocalPlayer

local function initialize()
	print("[ShopController] Initializing (SKELETON)...")

	-- MILESTONE 2: Create shop UI
	-- Listen for ProximityPrompt.Triggered on shop tools
	-- Show purchase confirmation UI

	-- RemoteEvents.getRemoteEvent("ShopPurchaseResult").OnClientEvent:Connect(onPurchaseResult)

	print("[ShopController] Skeleton initialized")
end

local function onPurchaseResult(data: any)
	-- MILESTONE 2: Show success/failure notification
	-- Update HUD coins
end

local function requestPurchase(shopId: string)
	RemoteEvents.getRemoteEvent("ShopPurchase"):FireServer(shopId)
end

return {
	initialize = initialize,
	onPurchaseResult = onPurchaseResult,
	requestPurchase = requestPurchase,
}