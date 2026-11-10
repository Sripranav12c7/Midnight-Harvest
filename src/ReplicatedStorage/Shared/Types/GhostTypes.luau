--!strict
--[[
	GhostTypes.lua
	Shared type definitions for ghost system.
]]

export type GhostType = "Ghost" | "DeepGhost"

export type GhostRuntimeData = {
	model: Model,
	ghostType: GhostType,
	humanoid: Humanoid,
	rootPart: BasePart,
	isAlive: boolean,
	isVisible: boolean,
	absorptionPrompt: ProximityPrompt?,
	lastDamageTime: number,
	chaseTarget: Player?,
}

export type GhostTemplate = {
	model: Model,
	ghostType: GhostType,
}

export type AbsorptionResult = {
	success: boolean,
	energyGranted: number,
	message: string?,
}

export type GhostSpawnConfig = {
	ghostCount: number,
	deepGhostCount: number,
	spawnPositions: { [number]: CFrame },
}

export type GhostPopulationState = {
	activeGhosts: { [Model]: GhostRuntimeData },
	spawnedCount: number,
	deepGhostSpawnedCount: number,
}

export type GhostConfig = {
	ghostDamage: number,
	deepGhostDamage: number,
	damageCooldown: number,
	absorptionToolName: string,
	ghostEnergyReward: number,
	deepGhostEnergyReward: number,
	chaseSpeed: number,
	chaseRange: number,
	chaseInterval: number,
	respawnBehaviorUnresolved: boolean,
}