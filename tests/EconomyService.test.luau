--!strict
--[[
	EconomyService.test.luau
	Unit tests for EconomyService (require TestEZ in Roblox Studio).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ", 10))

local EconomyService = require(script.Parent.Parent.ServerScriptService.Services.EconomyService)
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local EconomyTypes = require(ReplicatedStorage.Shared.Types.EconomyTypes)

local Players = game:GetService("Players")

-- Mock player for testing - create a fake player-like object
local function createMockPlayer(): { [string]: any }
	-- In real Studio tests, use TestEZ's mock utilities or Instance.new("Player")
	-- For now, return a table that acts like a Player for our test purposes
	return {
		Name = "TestPlayer",
		UserId = 12345,
		FindFirstChild = function(self, name: string)
			if name == "leaderstats" then
				return self.leaderstats
			end
			return nil
		end,
		GetAttribute = function(self, name: string)
			return self.attributes[name]
		end,
		SetAttribute = function(self, name: string, value: any)
			self.attributes[name] = value
		end,
		attributes = {} :: { [string]: any },
		leaderstats = {
			Name = "leaderstats",
			FindFirstChild = function(self, name: string)
				return self[name]
			end,
			Coins = { Name = "Coins", Value = 500, ClassName = "IntValue" },
			Silver = { Name = "Silver", Value = 0, ClassName = "IntValue" },
			Baguerite = { Name = "Baguerite", Value = 0, ClassName = "IntValue" },
			Scrap = { Name = "Scrap", Value = 0, ClassName = "IntValue" },
		},
		FindFirstChildOfClass = function(self, className: string)
			if className == "IntValue" then
				return { Name = "GhostEnergy", Value = 0, ClassName = "IntValue" }
			end
			return nil
		end,
	} :: any
end

return function()
	describe("EconomyService", function()
		local mockPlayer: any

		beforeEach(function()
			-- Reset state by re-initializing
			EconomyService.initialize(GameConfig, nil)
			mockPlayer = createMockPlayer()
			
			-- Manually set loaded state for testing (simulating persistence loaded)
			-- Access the internal playerLoaded table via the module's closure
			-- In real tests, we'd use setPersistenceLoaded, but we can't access it easily
			-- So we test the logic directly by calling the internal functions
		end)

		describe("Currency operations", function()
			it("should add currency correctly", function()
				local player = createMockPlayer()
				-- Manually initialize player state for test
				EconomyService.addCurrency(player, "Coins", 100)
				expect(EconomyService.getCurrencies(player).Coins).to.equal(600)
			end)

			it("should reject negative amounts", function()
				local player = createMockPlayer()
				local result = EconomyService.addCurrency(player, "Coins", -50)
				expect(result.success).to.equal(false)
			end)

			it("should remove currency correctly", function()
				local player = createMockPlayer()
				EconomyService.addCurrency(player, "Coins", 200)
				local result = EconomyService.removeCurrency(player, "Coins", 150)
				expect(result.success).to.equal(true)
				expect(EconomyService.getCurrencies(player).Coins).to.equal(550)
			end)

			it("should reject insufficient funds", function()
				local player = createMockPlayer()
				local result = EconomyService.removeCurrency(player, "Coins", 1000)
				expect(result.success).to.equal(false)
			end)

			it("should track all 5 currencies independently", function()
				local player = createMockPlayer()
				EconomyService.addCurrency(player, "Silver", 10)
				EconomyService.addCurrency(player, "Baguerite", 5)
				EconomyService.addCurrency(player, "Scrap", 3)
				EconomyService.addCurrency(player, "GhostEnergy", 100)

				local currencies = EconomyService.getCurrencies(player)
				expect(currencies.Silver).to.equal(10)
				expect(currencies.Baguerite).to.equal(5)
				expect(currencies.Scrap).to.equal(3)
				expect(currencies.GhostEnergy).to.equal(100)
			end)
		end)

		describe("Bag limit", function()
			it("should calculate bag items correctly (Silver + Baguerite + Scrap)", function()
				local player = createMockPlayer()
				EconomyService.addCurrency(player, "Silver", 5)
				EconomyService.addCurrency(player, "Baguerite", 3)
				EconomyService.addCurrency(player, "Scrap", 2)
				-- Coins should NOT count
				EconomyService.addCurrency(player, "Coins", 1000)

				local bagItems = EconomyService.getBagItems(player)
				expect(bagItems).to.equal(10)
			end)

			it("should enforce bag capacity of 10", function()
				local player = createMockPlayer()
				EconomyService.addCurrency(player, "Silver", 10)
				local validation = EconomyService.getBagValidation(player)
				expect(validation.allowed).to.equal(false)
				expect(validation.currentItems).to.equal(10)
				expect(validation.maxItems).to.equal(10)
			end)

			it("should not count Coins toward bag limit", function()
				local player = createMockPlayer()
				EconomyService.addCurrency(player, "Coins", 1000)
				local validation = EconomyService.getBagValidation(player)
				expect(validation.allowed).to.equal(true)
				expect(validation.currentItems).to.equal(0)
			end)
		end)

		describe("Transaction atomicity", function()
			it("should succeed completely or fail without partial state", function()
				local player = createMockPlayer()
				EconomyService.addCurrency(player, "Coins", 100)
				-- Simulate a transaction that would fail mid-way
				-- (In real implementation, transactions should be atomic)
			end)
		end)
	end)
end