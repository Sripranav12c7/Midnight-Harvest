--!strict
--[[
	DayNightConfig.lua
	Day/Night cycle configuration.
	ALL VALUES UNAPPROVED.
]]

export type DayNightConfig = {
	cycle: {
		totalDays: number,
		dayDurationSeconds: number,
		daytimeSeconds: number,
		nighttimeSeconds: number,
	},
	lighting: {
		daytimeClockTime: number,
		nighttimeClockTime: number,
	},
	triggers: {
		aliceCutsceneDay: number,
		mineCutsceneDay: number,
		cycleEndDay: number,
	},
	audio: {
		morningChickenSound: string,
		morningBirdsSound: string,
	},
}

local Config: DayNightConfig = {
	cycle = {
		totalDays = 100,
		dayDurationSeconds = 25,
		daytimeSeconds = 10,
		nighttimeSeconds = 15,
	},
	lighting = {
		daytimeClockTime = 12,
		nighttimeClockTime = 0,
	},
	triggers = {
		aliceCutsceneDay = 20,
		mineCutsceneDay = 20, -- Same day as Alice — UNAPPROVED design
		cycleEndDay = 100,
	},
	audio = {
		morningChickenSound = "ChickenMorning",
		morningBirdsSound = "BirdsMorning",
	},
}

return Config