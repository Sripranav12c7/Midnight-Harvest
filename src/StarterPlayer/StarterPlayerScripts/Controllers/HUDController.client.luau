--!strict
--[[
	HUDController.client.luau
	Consolidated HUD: Coins, Silver, Baguerite, Scrap, Ghost Energy, Bag count, Day counter.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local StatNames = require(ReplicatedStorage.Shared.Constants.StatNames)

-- UI references (created from StarterGui/Interfaces in Milestone 7)
local coinText: TextLabel?
local silverText: TextLabel?
local bagueriteText: TextLabel?
local scrapText: TextLabel?
local ghostEnergyText: TextLabel?
local bagText: TextLabel?
local dayText: TextLabel?

local STAT_NAMES = StatNames.Names

local function updateFromPlayerData(data: any)
	if not data then return end

	-- MILESTONE 7: Update UI elements
	-- if coinText then coinText.Text = `Coins: {data.coins}` end
	-- if silverText then silverText.Text = `Silver: {data.silver}` end
	-- if bagueriteText then bagueriteText.Text = `Baguerite: {data.baguerite}` end
	-- if scrapText then scrapText.Text = `Scrap: {data.scrap}` end
	-- if ghostEnergyText then ghostEnergyText.Text = `Ghost Energy: {data.ghostEnergy}` end
	-- if bagText then bagText.Text = `Items: {data.silver + data.baguerite + data.scrap}/10` end
	-- if dayText then dayText.Text = `Day {data.currentDay}` end
end

local function onDataUpdate(update: any)
	if not update then return end

	-- MILESTONE 7: Incremental updates
	-- if update.currencies then
	--     if coinText and update.currencies.Coins then coinText.Text = `Coins: {update.currencies.Coins}` end
	--     ...
	-- end
	-- if update.bagItems and bagText then bagText.Text = `Items: {update.bagItems}/10` end
	-- if update.currentDay and dayText then dayText.Text = `Day {update.currentDay}` end
	-- if update.ghostEnergy and ghostEnergyText then ghostEnergyText.Text = `Ghost Energy: {update.ghostEnergy}` end
end

local function onDayChanged(day: number, isNight: boolean)
	-- MILESTONE 7: Update day display
	-- if dayText then dayText.Text = `Day {day}` end
end

local function initialize(playerData: any)
	print("[HUDController] Initializing...")

	-- MILESTONE 7: Create/find UI elements from StarterGui/Interfaces
	-- coinText = PlayerGui:WaitForChild("CoinGui"):WaitForChild("CoinText")
	-- silverText = PlayerGui:WaitForChild("CoinGui"):WaitForChild("SilverText")
	-- bagueriteText = PlayerGui:WaitForChild("CoinGui"):WaitForChild("SilverText"):WaitForChild("BagueriteText")
	-- scrapText = PlayerGui:WaitForChild("CoinGui"):WaitForChild("LootText") -- or separate
	-- ghostEnergyText = PlayerGui:WaitForChild("GhostEnergyGui"):WaitForChild("GhostEnergyText")
	-- bagText = PlayerGui:WaitForChild("CoinGui"):WaitForChild("LootText")
	-- dayText = PlayerGui:WaitForChild("DayGui"):WaitForChild("DayLabel")

	-- Initial update
	updateFromPlayerData(playerData)

	print("[HUDController] Initialized")
end

return {
	initialize = initialize,
	updateFromPlayerData = updateFromPlayerData,
	onDataUpdate = onDataUpdate,
	onDayChanged = onDayChanged,
}