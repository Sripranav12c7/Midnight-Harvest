--!strict
--[[
	ProgressionTypes.lua
	Shared type definitions for progression, story flags, quests.
]]

export type StoryFlagName =
	| "aliceCutsceneSeen"
	| "aliceSpawned"
	| "mineCutsceneSeen"
	| "bossActivated"
	| "bossDefeated"
	| "gameCompleted"

export type QuestName =
	| "talkToArwin"
	| "talkToBarnKeeper"
	| "talkToMurugesan"
	| "talkToOldMiner"
	| "talkToTheOlder"
	| "mineFirstOre"
	| "buyFirstTool"
	| "absorbFirstGhost"
	| "feedDreadon"
	| "defeatBoss"

export type StoryFlags = {
	[StoryFlagName]: boolean,
}

export type QuestProgress = {
	[QuestName]: number, -- 0 = not started, 1 = in progress, 2 = completed
}

export type DayState = {
	currentDay: number,
	isNight: boolean,
	dayChanged: RBXScriptSignal,
}

export type ProgressionConfig = {
	totalDays: number,
	aliceCutsceneDay: number,
	mineCutsceneDay: number,
	cycleEndDay: number,
}