--!strict
--[[
	DayNightService.lua
	100-day cycle, 25s/day, 10d/15n, lighting, audio, day 20/100 triggers.
	MILESTONE 4: Full implementation. MILESTONE 1: Skeleton.
]]

local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local RunService = game:GetService("RunService")

local DayNightConfig = require(ReplicatedStorage.Shared.Config.DayNightConfig)
local StatNames = require(ReplicatedStorage.Shared.Constants.StatNames)

local dayChanged = Instance.new("BindableEvent")
local nightChanged = Instance.new("BindableEvent")

local currentDay = 1
local isNight = false
local cycleTask: thread?
local morningSounds: { Sound } = {}

local function initialize(config: any, cutscene: any, ghost: any)
	print("[DayNightService] Initializing (SKELETON)...")

	-- Create ReplicatedStorage values
	local currentDayValue = Instance.new("IntValue")
	currentDayValue.Name = StatNames.Names.CurrentDay
	currentDayValue.Value = 1
	currentDayValue.Parent = ReplicatedStorage

	local isNightValue = Instance.new("BoolValue")
	isNightValue.Name = StatNames.Names.IsNight
	isNightValue.Value = false
	isNightValue.Parent = ReplicatedStorage

	-- Load morning sounds
	-- morningSounds.chicken = SoundService:WaitForChild(config.audio.morningChickenSound)
	-- morningSounds.birds = SoundService:WaitForChild(config.audio.morningBirdsSound)

	-- Start cycle (MILESTONE 4: full implementation with RunService.Heartbeat or task.spawn loop)
	-- cycleTask = task.spawn(runCycle)

	-- Expose events
	-- _G.DayNightService = { dayChanged = dayChanged.Event, nightChanged = nightChanged.Event }

	print("[DayNightService] Skeleton initialized")
end

local function runCycle()
	-- MILESTONE 4: Full 100-day loop with 25s days (10s day, 15s night)
	-- while currentDay <= config.cycle.totalDays do
	--     -- Day
	--     Lighting.ClockTime = config.lighting.daytimeClockTime
	--     isNight = false
	--     playMorningSounds()
	--     task.wait(config.cycle.daytimeSeconds)
	--     -- Night
	--     Lighting.ClockTime = config.lighting.nighttimeClockTime
	--     isNight = true
	--     stopMorningSounds()
	--     task.wait(config.cycle.nighttimeSeconds)
	--     -- Next day
	--     currentDay += 1
	--     updateReplicatedValues()
	--     dayChanged:Fire(currentDay, isNight)
	--     if currentDay == config.triggers.aliceCutsceneDay then
	--         triggerAliceCutscene()
	--     elseif currentDay == config.triggers.mineCutsceneDay then
	--         triggerMineCutscene()
	--     elseif currentDay == config.triggers.cycleEndDay then
	--         endCycle()
	--     end
	-- end
end

local function triggerAliceCutscene()
	-- Fire AliceCutsceneEvent
end

local function triggerMineCutscene()
	-- Fire MineCutsceneEvent
end

local function endCycle()
	-- Stop cycle, trigger ending
end

return {
	initialize = initialize,
	dayChanged = dayChanged.Event,
	nightChanged = nightChanged.Event,
}