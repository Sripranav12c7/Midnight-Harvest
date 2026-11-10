--!strict
--[[
	StatNames.lua
	Single source of truth for leaderstat and IntValue names.
]]

export type StatName =
	| "Coins"
	| "Silver"
	| "Baguerite"
	| "Scrap"
	| "GhostEnergy"
	| "CurrentDay"
	| "IsNight"
	| "BossEnergy"
	| "BossEnergyRequired"
	| "BossBattleActive"

local StatNames: { [StatName]: StatName } = {
	Coins = "Coins",
	Silver = "Silver",
	Baguerite = "Baguerite",
	Scrap = "Scrap",
	GhostEnergy = "GhostEnergy",
	CurrentDay = "CurrentDay",
	IsNight = "IsNight",
	BossEnergy = "BossEnergy",
	BossEnergyRequired = "BossEnergyRequired",
	BossBattleActive = "BossBattleActive",
}

export const STAT_NAMES = StatNames

export function getStatName(name: StatName): StatName
	return StatNames[name]
end

export function getAllStatNames(): { StatName }
	local names = {}
	for _, v in pairs(StatNames) do
		table.insert(names, v)
	end
	return names
end

return {
	Names = StatNames,
	getStatName = getStatName,
	getAllStatNames = getAllStatNames,
}