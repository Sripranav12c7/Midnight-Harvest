--!strict
--[[
	EconomyService.lua
	Server-authoritative currency management for 5 resources.
	Bag limit enforcement, transactions, leaderstats.
	No persistence dependency in Milestone 1 (stubbed).
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local EconomyTypes = require(ReplicatedStorage.Shared.Types.EconomyTypes)
local StatNames = require(ReplicatedStorage.Shared.Constants.StatNames)
local Signal = require(ReplicatedStorage.Shared.Utilities.Signal)

-- PersistenceService reference (set later)
local PersistenceService: any = nil

-- Per-player currency data
local playerCurrencies: { [Player]: EconomyTypes.CurrencyMap } = {}
local playerLoaded: { [Player]: boolean } = {}

-- Events
local currencyChanged = Signal.new()

-- Leaderstats folder name
local LEADERSTATS_NAME = "leaderstats"

-- Stat names
local STAT_NAMES = StatNames.Names

local function createLeaderstats(player: Player): Folder
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = LEADERSTATS_NAME
	leaderstats.Parent = player

	local coins = Instance.new("IntValue")
	coins.Name = STAT_NAMES.Coins
	coins.Value = GameConfig.startingCoins
	coins.Parent = leaderstats

	local silver = Instance.new("IntValue")
	silver.Name = STAT_NAMES.Silver
	silver.Value = GameConfig.startingSilver
	silver.Parent = leaderstats

	local baguerite = Instance.new("IntValue")
	baguerite.Name = STAT_NAMES.Baguerite
	baguerite.Value = GameConfig.startingBaguerite
	baguerite.Parent = leaderstats

	local scrap = Instance.new("IntValue")
	scrap.Name = STAT_NAMES.Scrap
	scrap.Value = GameConfig.startingScrap
	scrap.Parent = leaderstats

	local ghostEnergy = Instance.new("IntValue")
	ghostEnergy.Name = STAT_NAMES.GhostEnergy
	ghostEnergy.Value = GameConfig.startingGhostEnergy
	ghostEnergy.Parent = player -- Not in leaderstats per original

	return leaderstats
end

local function getCurrencies(player: Player): EconomyTypes.CurrencyMap
	return playerCurrencies[player] or {
		Coins = GameConfig.startingCoins,
		Silver = GameConfig.startingSilver,
		Baguerite = GameConfig.startingBaguerite,
		Scrap = GameConfig.startingScrap,
		GhostEnergy = GameConfig.startingGhostEnergy,
	}
end

local function setCurrencies(player: Player, currencies: EconomyTypes.CurrencyMap)
	playerCurrencies[player] = currencies

	-- Update leaderstats
	local leaderstats = player:FindFirstChild(LEADERSTATS_NAME)
	if leaderstats then
		local coins = leaderstats:FindFirstChild(STAT_NAMES.Coins)
		local silver = leaderstats:FindFirstChild(STAT_NAMES.Silver)
		local baguerite = leaderstats:FindFirstChild(STAT_NAMES.Baguerite)
		local scrap = leaderstats:FindFirstChild(STAT_NAMES.Scrap)

		if coins then coins.Value = currencies.Coins end
		if silver then silver.Value = currencies.Silver end
		if baguerite then baguerite.Value = currencies.Baguerite end
		if scrap then scrap.Value = currencies.Scrap end
	end

	-- GhostEnergy on player directly
	local ghostEnergy = player:FindFirstChild(STAT_NAMES.GhostEnergy)
	if ghostEnergy then
		ghostEnergy.Value = currencies.GhostEnergy
	end

	-- Fire change event
	currencyChanged:Fire(player, currencies)
end

local function addCurrency(player: Player, currency: string, amount: number): EconomyTypes.TransactionResult
	if amount <= 0 then
		return { success = false, message = "Amount must be positive" }
	end

	if not playerLoaded[player] then
		return { success = false, message = "Player data not loaded yet" }
	end

	local currencies = getCurrencies(player)
	if currencies[currency] == nil then
		return { success = false, message = "Invalid currency" }
	end

	currencies[currency] += amount
	setCurrencies(player, currencies)

	return {
		success = true,
		newBalances = currencies,
	}
end

local function removeCurrency(player: Player, currency: string, amount: number): EconomyTypes.TransactionResult
	if amount <= 0 then
		return { success = false, message = "Amount must be positive" }
	end

	if not playerLoaded[player] then
		return { success = false, message = "Player data not loaded yet" }
	end

	local currencies = getCurrencies(player)
	if currencies[currency] == nil then
		return { success = false, message = "Invalid currency" }
	end

	if currencies[currency] < amount then
		return { success = false, message = "Insufficient funds" }
	end

	currencies[currency] -= amount
	setCurrencies(player, currencies)

	return {
		success = true,
		newBalances = currencies,
	}
end

local function canAfford(player: Player, currency: string, amount: number): boolean
	if amount <= 0 then return false end
	local currencies = getCurrencies(player)
	return currencies[currency] ~= nil and currencies[currency] >= amount
end

local function getBagItems(player: Player): number
	return EconomyTypes.calculateBagItems(getCurrencies(player))
end

local function isBagFull(player: Player): boolean
	return EconomyTypes.isBagFull(getCurrencies(player), GameConfig.bagCapacity)
end

local function getBagValidation(player: Player): EconomyTypes.BagValidationResult
	local current = getBagItems(player)
	return {
		allowed = current < GameConfig.bagCapacity,
		currentItems = current,
		maxItems = GameConfig.bagCapacity,
		reason = current >= GameConfig.bagCapacity and "Bag is full" or nil,
	}
end

local function onPlayerAdded(player: Player)
	createLeaderstats(player)
	playerCurrencies[player] = {
		Coins = GameConfig.startingCoins,
		Silver = GameConfig.startingSilver,
		Baguerite = GameConfig.startingBaguerite,
		Scrap = GameConfig.startingScrap,
		GhostEnergy = GameConfig.startingGhostEnergy,
	}
	playerLoaded[player] = false -- Will be set to true when persistence loads
end

local function onPlayerRemoving(player: Player)
	playerCurrencies[player] = nil
	playerLoaded[player] = nil
end

local function initialize(config: any, persistence: any)
	PersistenceService = persistence
	print("[EconomyService] Initializing...")

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	for _, player in ipairs(Players:GetPlayers()) do
		onPlayerAdded(player)
	end

	print("[EconomyService] Initialized")
end

local function setPersistenceLoaded(player: Player, loaded: boolean)
	playerLoaded[player] = loaded
	if loaded and PersistenceService then
		local data = PersistenceService.getPlayerData(player)
		if data then
			setCurrencies(player, {
				Coins = data.coins,
				Silver = data.silver,
				Baguerite = data.baguerite,
				Scrap = data.scrap,
				GhostEnergy = data.ghostEnergy,
			})
		end
	end
end

return {
	initialize = initialize,
	setPersistenceLoaded = setPersistenceLoaded,
	getCurrencies = getCurrencies,
	addCurrency = addCurrency,
	removeCurrency = removeCurrency,
	canAfford = canAfford,
	getBagItems = getBagItems,
	isBagFull = isBagFull,
	getBagValidation = getBagValidation,
	currencyChanged = currencyChanged,
}