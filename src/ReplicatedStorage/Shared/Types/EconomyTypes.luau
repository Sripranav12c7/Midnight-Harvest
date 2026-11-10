--!strict
--[[
	EconomyTypes.lua
	Shared type definitions for economy, inventory, and player data.
]]

-- Currency types
export type CurrencyName = "Coins" | "Silver" | "Baguerite" | "Scrap" | "GhostEnergy"

export type CurrencyMap = {
	Coins: number,
	Silver: number,
	Baguerite: number,
	Scrap: number,
	GhostEnergy: number,
}

-- Transaction result
export type TransactionResult = {
	success: boolean,
	message: string?,
	newBalances: CurrencyMap?,
}

-- Bag limit validation
export type BagValidationResult = {
	allowed: boolean,
	currentItems: number,
	maxItems: number,
	reason: string?,
}

-- Tool ownership
export type ToolOwnership = {
	[toolName: string]: boolean,
}

-- Player data schema v1 (persisted)
export type PlayerData = {
	-- Currency
	coins: number,
	silver: number,
	baguerite: number,
	scrap: number,
	ghostEnergy: number,

	-- Inventory
	ownedTools: ToolOwnership,
	equippedTool: string?,
	purchasedAttributes: { [string]: boolean },

	-- Progression
	currentDay: number,
	storyFlags: { [string]: boolean },
	questProgress: { [string]: number },

	-- Meta
	schemaVersion: number,
	lastSaved: number,
}

-- Default player data factory
export function getDefaultPlayerData(): PlayerData
	return {
		coins = 500,
		silver = 0,
		baguerite = 0,
		scrap = 0,
		ghostEnergy = 0,
		ownedTools = {},
		equippedTool = nil,
		purchasedAttributes = {},
		currentDay = 1,
		storyFlags = {},
		questProgress = {},
		schemaVersion = 1,
		lastSaved = 0,
	}
end

-- Validation
export function validatePlayerData(data: any): (boolean, string?)
	if type(data) ~= "table" then
		return false, "PlayerData must be a table"
	end
	if type(data.coins) ~= "number" or data.coins < 0 then
		return false, "Invalid coins"
	end
	if type(data.silver) ~= "number" or data.silver < 0 then
		return false, "Invalid silver"
	end
	if type(data.baguerite) ~= "number" or data.baguerite < 0 then
		return false, "Invalid baguerite"
	end
	if type(data.scrap) ~= "number" or data.scrap < 0 then
		return false, "Invalid scrap"
	end
	if type(data.ghostEnergy) ~= "number" or data.ghostEnergy < 0 then
		return false, "Invalid ghostEnergy"
	end
	if type(data.currentDay) ~= "number" or data.currentDay < 1 then
		return false, "Invalid currentDay"
	end
	if type(data.schemaVersion) ~= "number" then
		return false, "Missing schemaVersion"
	end
	return true, nil
end

-- Bag calculation
export function calculateBagItems(currencies: CurrencyMap): number
	return currencies.Silver + currencies.Baguerite + currencies.Scrap
end

export function isBagFull(currencies: CurrencyMap, capacity: number): boolean
	return calculateBagItems(currencies) >= capacity
end