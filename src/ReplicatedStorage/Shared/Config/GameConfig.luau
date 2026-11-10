--!strict
--[[
	GameConfig.lua
	Central configuration for all tunable gameplay values.
	ALL VALUES ARE UNAPPROVED — Owner must review before Milestone 2.
	Original values documented where known; recommendations marked.
]]

export type GameConfig = {
	-- Economy
	startingCoins: number,
	startingSilver: number,
	startingBaguerite: number,
	startingScrap: number,
	startingGhostEnergy: number,
	bagCapacity: number, -- Silver + Baguerite + Scrap only

	-- Shops
	shopPrices: {
		Axe: number,
		Hammer: number,
		WoodPick: number,
		Bat: number,
		Gun: number,
		TrenchGun: number,
		Scythe: number,
		CoconutDrink: number,
		GhostVacuum: number,
	},

	-- Selling
	sellPrices: {
		Silver: number,
		Baguerite: number,
		Scrap: number,
	},

	-- Mining
	mining: {
		maxDistance: number,
		cooldown: number,
		oreRespawnSeconds: number,
		hitsRequired: {
			SilverOre: number,
			Baguerite: number,
		},
	},

	-- Scrap
	scrap: {
		nodeCount: number,
		respawnOnDayChange: boolean,
		collectCooldown: number,
	},

	-- Ghosts
	ghosts: {
		initialGhostCount: number,
		initialDeepGhostCount: number,
		backupGhostCount: number,
		backupDeepGhostCount: number,
		ghostDamage: number,
		deepGhostDamage: number,
		ghostAbsorptionEnergy: number,
		deepGhostAbsorptionEnergy: number,
		chaseSpeed: number,
		chaseRange: number,
		absorptionToolName: string, -- "GhostVacuum" (fix typo from "GhostVaccumShop")
		respawnBehaviorUnresolved: boolean, -- true = design decision needed
	},

	-- Day/Night
	dayNight: {
		totalDays: number,
		dayDurationSeconds: number,
		daytimeSeconds: number,
		nighttimeSeconds: number,
		daytimeClockTime: number,
		nighttimeClockTime: number,
		day20Trigger: number,
		day100Trigger: number,
		morningSounds: { chicken: string, birds: string },
	},

	-- Boss (Dreadon)
	boss: {
		energyRequired: number, -- Original: 20000 (config) vs 20 (trigger) — RECOMMEND 2000
		activationThreshold: number, -- Same as energyRequired in rebuild
		damage: number,
		chaseSpeed: number,
		detectionRange: number,
		attackRange: number,
		attackCooldown: number,
		health: number, -- Not in original; design needed
		bgmSoundId: string,
	},

	-- Player
	player: {
		maxHealth: number, -- Original intended: 200 (broken in original)
		scale: number, -- 2x
		walkSpeed: number, -- 32
		pouchOffset: Vector3,
	},

	-- NPCs
	npcs: {
		dialogueSpeed: number, -- seconds per character
		dialoguePause: number, -- seconds between lines
	},

	-- UI
	ui: {
		bagLabelName: string, -- "Baguerite" (not "Bronze") — UNAPPROVED
		miningProgressEnabled: boolean,
	},
}

local Config: GameConfig = {
	startingCoins = 500,
	startingSilver = 0,
	startingBaguerite = 0,
	startingScrap = 0,
	startingGhostEnergy = 0,
	bagCapacity = 10,

	shopPrices = {
		Axe = 150,
		Hammer = 250,
		WoodPick = 200,
		Bat = 200,
		Gun = 300,
		TrenchGun = 500,
		Scythe = 500,
		CoconutDrink = 100,
		GhostVacuum = 300,
	},

	sellPrices = {
		Silver = 50,
		Baguerite = 25,
		Scrap = 20,
	},

	mining = {
		maxDistance = 12,
		cooldown = 0.5,
		oreRespawnSeconds = 150,
		hitsRequired = {
			SilverOre = 6,
			Baguerite = 4,
		},
	},

	scrap = {
		nodeCount = 10,
		respawnOnDayChange = true,
		collectCooldown = 0.5,
	},

	ghosts = {
		initialGhostCount = 26,
		initialDeepGhostCount = 3,
		backupGhostCount = 23,
		backupDeepGhostCount = 2,
		ghostDamage = 15, -- UNAPPROVED (original SSS/ghost = 15)
		deepGhostDamage = 25, -- UNAPPROVED (original Deep Ghost = 25)
		ghostAbsorptionEnergy = 20, -- UNAPPROVED
		deepGhostAbsorptionEnergy = 50, -- UNAPPROVED
		chaseSpeed = 35,
		chaseRange = 200,
		absorptionToolName = "GhostVacuum", -- Fix typo from "GhostVaccumShop"
		respawnBehaviorUnresolved = true, -- Design decision needed: restore 26+3 or 23+2?
	},

	dayNight = {
		totalDays = 100,
		dayDurationSeconds = 25,
		daytimeSeconds = 10,
		nighttimeSeconds = 15,
		daytimeClockTime = 12,
		nighttimeClockTime = 0,
		day20Trigger = 20,
		day100Trigger = 100,
		morningSounds = {
			chicken = "ChickenMorning", -- Sound name in EnvironmentSounds
			birds = "BirdsMorning",
		},
	},

	boss = {
		energyRequired = 2000, -- RECOMMENDATION: 2000 (not 20, not 20000) — UNAPPROVED
		activationThreshold = 2000,
		damage = 25,
		chaseSpeed = 30,
		detectionRange = 200,
		attackRange = 12,
		attackCooldown = 1,
		health = 1000, -- Design needed — UNAPPROVED
		bgmSoundId = "BossBattleBGM",
	},

	player = {
		maxHealth = 200,
		scale = 2,
		walkSpeed = 32,
		pouchOffset = Vector3.new(0, 0, 0.7),
	},

	npcs = {
		dialogueSpeed = 0.035,
		dialoguePause = 2,
	},

	ui = {
		bagLabelName = "Baguerite", -- Not "Bronze" — UNAPPROVED
		miningProgressEnabled = true,
	},
}

return Config