--!strict
--[[
	MiningTypes.lua
	Shared type definitions for mining system.
]]

export type OreName = "SilverOre" | "Baguerite"

export type OreRuntimeData = {
	model: Model,
	oreName: OreName,
	originalCFrame: CFrame,
	originalParent: Instance?,
	hitsByPlayer: { [Player]: number },
	respawnTask: thread?,
	isMined: boolean,
}

export type MiningValidationResult = {
	valid: boolean,
	reason: string?,
	ore: Model?,
}

export type MiningHitResult = {
	success: boolean,
	hits: number,
	requiredHits: number,
	rewardGranted: boolean,
	rewardName: string?,
	rewardAmount: number?,
	message: string?,
}

export type OreConfig = {
	hitsRequired: number,
	rewardName: string,
	rewardAmount: number,
}

export type MiningConfig = {
	ores: { [OreName]: OreConfig },
	maxDistance: number,
	requiredTool: string,
	cooldown: number,
	respawnSeconds: number,
	bagLimit: number,
}