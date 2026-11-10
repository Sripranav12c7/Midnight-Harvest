--!strict
--[[
	NetworkTypes.lua
	Shared type definitions for RemoteEvent/RemoteFunction payloads.
	All client→server requests MUST be validated on server.
]]

-- ============================================
-- Client → Server Requests (Validated)
-- ============================================

export type MineOreRequest = {
	ore: Model,
}

export type MineOreResponse = {
	success: boolean,
	hits: number,
	requiredHits: number,
	rewardGranted: boolean,
	message: string?,
}

export type ShopPurchaseRequest = {
	shopId: string,
}

export type ShopPurchaseResponse = {
	success: boolean,
	itemName: string?,
	message: string?,
	newCoins: number?,
}

export type GhostAbsorbRequest = {
	ghost: Model,
}

export type GhostAbsorbResponse = {
	success: boolean,
	energyGranted: number,
	message: string?,
}

export type ScrapCollectRequest = {
	scrap: Model,
}

export type ScrapCollectResponse = {
	success: boolean,
	message: string?,
}

export type ScrapSellRequest = {}

export type ScrapSellResponse = {
	success: boolean,
	scrapSold: number,
	coinsEarned: number,
	message: string?,
}

export type OreSellRequest = {}

export type OreSellResponse = {
	success: boolean,
	silverSold: number,
	bagueriteSold: number,
	coinsEarned: number,
	message: string?,
}

export type BossFightStartRequest = {}

export type BossFightStartResponse = {
	success: boolean,
	message: string?,
}

export type BossEnergyTransferRequest = {
	amount: number,
}

export type BossEnergyTransferResponse = {
	success: boolean,
	energyTransferred: number,
	bossEnergy: number,
	message: string?,
}

export type DialogueStartRequest = {
	npcId: string,
}

export type DialogueStartResponse = {
	success: boolean,
	dialogueId: string?,
	message: string?,
}

-- ============================================
-- Server → Client Events (Fire-and-forget)
-- ============================================

export type PlayerDataLoadedEvent = {
	playerData: any, -- EconomyTypes.PlayerData
}

export type DataUpdateEvent = {
	currencies: { [string]: number }?,
	bagItems: number?,
	currentDay: number?,
	isNight: boolean?,
	ghostEnergy: number?,
	bossEnergy: number?,
	bossBattleActive: boolean?,
	storyFlags: { [string]: boolean }?,
}

export type AliceCutsceneEvent = {}

export type AliceRevealEvent = {}

export type MineCutsceneEvent = {}

export type MineCutsceneFinishedEvent = {}

export type BossDialogueEvent = {}

export type BossFinalEvent = {}

export type ShopPurchaseResultEvent = {
	success: boolean,
	itemName: string?,
}

export type DialogueStartEvent = {
	npcName: string,
	dialogueLines: { string },
}

export type MiningProgressEvent = {
	ore: Model,
	hits: number,
	requiredHits: number,
}

export type GhostAbsorbEvent = {
	ghost: Model,
	energyGranted: number,
}

export type DayChangedEvent = {
	day: number,
	isNight: boolean,
}

export type GhostSpawnEvent = {
	count: number,
	deepCount: number,
}

export type GhostDespawnEvent = {}

-- ============================================
-- Bindable Events (Server Internal)
-- ============================================

export type BossFinalEventBindable = {}

-- ============================================
-- Remote Names (Constants)
-- ============================================

export type RemoteEventNames = {
	MineOre: "MineOre",
	ShopPurchase: "ShopPurchase",
	ShopPurchaseResult: "ShopPurchaseResult",
	GhostAbsorb: "GhostAbsorb",
	ScrapCollect: "ScrapCollect",
	ScrapSell: "ScrapSell",
	OreSell: "OreSell",
	BossFightStart: "BossFightStart",
	BossEnergyTransfer: "BossEnergyTransfer",
	BossDialogueEvent: "BossDialogueEvent",
	BossFinalEvent: "BossFinalEvent",
	AliceCutsceneEvent: "AliceCutsceneEvent",
	AliceRevealEvent: "AliceRevealEvent",
	MineCutsceneEvent: "MineCutsceneEvent",
	MineCutsceneFinished: "MineCutsceneFinished",
	DialogueStart: "DialogueStart",
	PlayerDataLoaded: "PlayerDataLoaded",
	DataUpdate: "DataUpdate",
}

export type RemoteFunctionNames = {
	-- None currently; all async via RemoteEvent
}