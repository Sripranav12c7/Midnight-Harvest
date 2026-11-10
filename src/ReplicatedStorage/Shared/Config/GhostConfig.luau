--!strict
--[[
	GhostConfig.lua
	Ghost-specific configuration separated from GameConfig for clarity.
	ALL VALUES UNAPPROVED.
]]

export type GhostConfig = {
	spawn: {
		ghostCount: number,
		deepGhostCount: number,
	},
	backup: {
		ghostCount: number,
		deepGhostCount: number,
	},
	damage: {
		ghost: number,
		deepGhost: number,
		cooldown: number,
	},
	absorption: {
		toolName: string,
		ghostEnergy: number,
		deepGhostEnergy: number,
		holdDuration: number,
		distance: number,
	},
	ai: {
		deepGhostChaseSpeed: number,
		deepGhostChaseRange: number,
		deepGhostChaseInterval: number,
	},
	visibility: {
		dayStartHour: number, -- 6
		nightStartHour: number, -- 18
	},
	respawn: {
		behaviorUnresolved: boolean,
		restoreWorldCounts: boolean, -- If true, restore 26+3; if false, restore 23+2
	},
}

local Config: GhostConfig = {
	spawn = {
		ghostCount = 26,
		deepGhostCount = 3,
	},
	backup = {
		ghostCount = 23,
		deepGhostCount = 2,
	},
	damage = {
		ghost = 15,
		deepGhost = 25,
		cooldown = 1,
	},
	absorption = {
		toolName = "GhostVacuum",
		ghostEnergy = 20,
		deepGhostEnergy = 50,
		holdDuration = 2,
		distance = 10,
	},
	ai = {
		deepGhostChaseSpeed = 35,
		deepGhostChaseRange = 200,
		deepGhostChaseInterval = 0.2,
	},
	visibility = {
		dayStartHour = 6,
		nightStartHour = 18,
	},
	respawn = {
		behaviorUnresolved = true,
		restoreWorldCounts = true, -- RECOMMENDATION: restore 26+3 — UNAPPROVED
	},
}

return Config