--!strict
--[[
	MiningConfig.lua
	Mining-specific configuration.
	ALL VALUES UNAPPROVED.
]]

export type MiningConfig = {
	ores: {
		SilverOre: {
			hitsRequired: number,
			reward: string, -- "Silver"
			rewardAmount: number,
		},
		Baguerite: {
			hitsRequired: number,
			reward: string, -- "Baguerite"
			rewardAmount: number,
		},
	},
	validation: {
		maxDistance: number,
		requiredTool: string, -- "WoodPick"
		cooldown: number,
	},
	respawn: {
		seconds: number,
	},
	bagLimit: {
		maxItems: number, -- Silver + Baguerite + Scrap
	},
}

local Config: MiningConfig = {
	ores = {
		SilverOre = {
			hitsRequired = 6,
			reward = "Silver",
			rewardAmount = 1,
		},
		Baguerite = {
			hitsRequired = 4,
			reward = "Baguerite",
			rewardAmount = 1,
		},
	},
	validation = {
		maxDistance = 12,
		requiredTool = "WoodPick",
		cooldown = 0.5,
	},
	respawn = {
		seconds = 150,
	},
	bagLimit = {
		maxItems = 10,
	},
}

return Config