--!strict
--[[
	GhostService.test.luau
	Unit tests for GhostService (require TestEZ in Roblox Studio).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ", 10))

local GhostService = require(script.Parent.Parent.ServerScriptService.Systems.GhostService)
local GhostConfig = require(ReplicatedStorage.Shared.Config.GhostConfig)

return function()
	describe("GhostService", function()
		beforeEach(function()
			GhostService.initialize(GhostConfig, nil)
		end)

		describe("Spawn counts", function()
			it("should spawn 26 Ghost + 3 Deep Ghost initially", function()
				expect(GhostConfig.spawn.ghostCount).to.equal(26)
				expect(GhostConfig.spawn.deepGhostCount).to.equal(3)
			end)

			it("should have GhostBackup of 23 Ghost + 2 Deep Ghost", function()
				expect(GhostConfig.backup.ghostCount).to.equal(23)
				expect(GhostConfig.backup.deepGhostCount).to.equal(2)
			end)
		end)

		describe("Damage values (UNAPPROVED)", function()
			it("should use Ghost=15, DeepGhost=25", function()
				expect(GhostConfig.damage.ghost).to.equal(15)
				expect(GhostConfig.damage.deepGhost).to.equal(25)
			end)
		end)

		describe("Absorption", function()
			it("should require GhostVacuum tool (not GhostVaccumShop)", function()
				expect(GhostConfig.absorption.toolName).to.equal("GhostVacuum")
			end)

			it("should grant 20 energy for Ghost, 50 for Deep Ghost", function()
				expect(GhostConfig.absorption.ghostEnergy).to.equal(20)
				expect(GhostConfig.absorption.deepGhostEnergy).to.equal(50)
			end)
		end)

		describe("Respawn behavior", function()
			it("should mark respawn behavior as unresolved", function()
				expect(GhostConfig.respawn.behaviorUnresolved).to.equal(true)
			end)
		end)
	end)
end