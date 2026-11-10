--!strict
--[[
	ToolNames.lua
	Single source of truth for all tool identifiers.
	Must match tool names in ServerStorage/Tools exactly.
]]

export type ToolName =
	| "Axe"
	| "Hammer"
	| "WoodPick"
	| "Bat"
	| "Gun"
	| "TrenchGun"
	| "GhostVacuum"
	| "Guestium Scythe"
	| "CoconutDrink"
	| "Bandage"
	| "Medikit"
	| "SilverSword"
	| "LootPouch"
	| "M16A4" -- Toolbox leftover; not in rebuild shops

local ToolNames: { [ToolName]: ToolName } = {
	Axe = "Axe",
	Hammer = "Hammer",
	WoodPick = "WoodPick",
	Bat = "Bat",
	Gun = "Gun",
	TrenchGun = "TrenchGun",
	GhostVacuum = "GhostVacuum",
	["Guestium Scythe"] = "Guestium Scythe",
	CoconutDrink = "CoconutDrink",
	Bandage = "Bandage",
	Medikit = "Medikit",
	SilverSword = "SilverSword",
	LootPouch = "LootPouch",
	M16A4 = "M16A4",
}

local ShopToolNames: { [ToolName]: ToolName } = {
	Axe = "Axe",
	Hammer = "Hammer",
	WoodPick = "WoodPick",
	Bat = "Bat",
	Gun = "Gun",
	TrenchGun = "TrenchGun",
	GhostVacuum = "GhostVacuum",
	["Guestium Scythe"] = "Guestium Scythe",
	CoconutDrink = "CoconutDrink",
	-- Bandage, Medikit, SilverSword, LootPouch, M16A4 not in shops
}

local MiningToolNames: { [ToolName]: ToolName } = {
	WoodPick = "WoodPick",
}

export const TOOL_NAMES = ToolNames
export const SHOP_TOOL_NAMES = ShopToolNames
export const MINING_TOOL_NAMES = MiningToolNames

export function getToolName(name: ToolName): ToolName
	return ToolNames[name]
end

export function isShopTool(name: string): boolean
	return ShopToolNames[name as ToolName] ~= nil
end

export function isMiningTool(name: string): boolean
	return MiningToolNames[name as ToolName] ~= nil
end

export function getAllToolNames(): { ToolName }
	local names = {}
	for _, v in pairs(ToolNames) do
		table.insert(names, v)
	end
	return names
end

export function getAllShopToolNames(): { ToolName }
	local names = {}
	for _, v in pairs(ShopToolNames) do
		table.insert(names, v)
	end
	return names
end

return {
	Names = ToolNames,
	ShopTools = ShopToolNames,
	MiningTools = MiningToolNames,
	getToolName = getToolName,
	isShopTool = isShopTool,
	isMiningTool = isMiningTool,
	getAllToolNames = getAllToolNames,
	getAllShopToolNames = getAllShopToolNames,
}