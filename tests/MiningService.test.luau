--!strict
--[[
	MiningService.test.luau
	Unit tests for MiningService (require TestEZ in Roblox Studio).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ", 10))

local MiningService = require(script.Parent.Parent.ServerScriptService.Systems.MiningService)
local MiningConfig = require(ReplicatedStorage.Shared.Config.MiningConfig)
local ToolNames = require(ReplicatedStorage.Shared.Constants.ToolNames)

local Players = game:GetService("Players")

local function createMockPlayer(): Player
	return Players.LocalPlayer
end

return function()
	describe("MiningService", function()
		beforeEach(function()
			MiningService.initialize(MiningConfig, nil, nil)
		end)

		describe("Ore configuration", function()
			it("should have correct hit requirements", function()
				expect(MiningConfig.ores.SilverOre.hitsRequired).to.equal(6)
				expect(MiningConfig.ores.Baguerite.hitsRequired).to.equal(4)
			end)

			it("should have correct rewards", function()
				expect(MiningConfig.ores.SilverOre.reward).to.equal("Silver")
				expect(MiningConfig.ores.SilverOre.rewardAmount).to.equal(1)
				expect(MiningConfig.ores.Baguerite.reward).to.equal("Baguerite")
				expect(MiningConfig.ores.Baguerite.rewardAmount).to.equal(1)
			end)
		end)

		describe("Validation", function()
			it("should require WoodPick equipped", function()
				-- MILESTONE 2: Test that validation fails without WoodPick
			end)

			it("should enforce distance limit (12 studs)", function()
				-- MILESTONE 2: Test distance validation
			end)

			it("should enforce cooldown", function()
				-- MILESTONE 2: Test cooldown enforcement
			end)

			it("should validate ore type", function()
				-- MILESTONE 2: Test invalid ore rejection
			end)

			it("should check bag capacity before granting reward", function()
				-- MILESTONE 2: Test bag full prevention
			end)
		end)

		describe("Hit tracking", function()
			it("should track hits per player per ore", function()
				-- MILESTONE 2: Test hit counting
			end)

			it("should grant reward on hit threshold", function()
				-- MILESTONE 2: Silver at 6 hits, Baguerite at 4 hits
			end)
		end)

		describe("Respawn", function()
			it("should respawn ore after 150 seconds", function()
				-- MILESTONE 2: Test respawn timer
			end)
		end)
	end)
end