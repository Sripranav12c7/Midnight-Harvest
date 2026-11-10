--!strict
--[[
	ShopService.test.luau
	Unit tests for ShopService (require TestEZ in Roblox Studio).
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TestEZ = require(ReplicatedStorage:WaitForChild("TestEZ", 10))

local ShopService = require(script.Parent.Parent.ServerScriptService.Services.ShopService)
local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local ShopConfig = require(ReplicatedStorage.Shared.Config.ShopConfig)

return function()
	describe("ShopService", function()
		beforeEach(function()
			ShopService.initialize(GameConfig, ShopConfig, nil, nil)
		end)

		describe("Shop configuration", function()
			it("should have all 7 shops", function()
				local count = 0
				for _ in pairs(ShopConfig.shops) do count += 1 end
				expect(count).to.equal(7)
			end)

			it("should have correct prices", function()
				expect(GameConfig.shopPrices.Axe).to.equal(150)
				expect(GameConfig.shopPrices.Hammer).to.equal(250)
				expect(GameConfig.shopPrices.WoodPick).to.equal(200)
				expect(GameConfig.shopPrices.Bat).to.equal(200)
				expect(GameConfig.shopPrices.Gun).to.equal(300)
				expect(GameConfig.shopPrices.TrenchGun).to.equal(500)
				expect(GameConfig.shopPrices.Scythe).to.equal(500)
				expect(GameConfig.shopPrices.CoconutDrink).to.equal(100)
				expect(GameConfig.shopPrices.GhostVacuum).to.equal(300)
			end)
		end)

		describe("Ownership guards", function()
			it("should have backpack guard for Axe, Hammer, WoodPick, Gun, TrenchGun, GhostVacuum, CoconutDrink", function()
				local backpackShops = { "Axe", "Hammer", "WoodPick", "Gun", "TrenchGun", "GhostVacuum", "CoconutDrink" }
				for _, shopId in ipairs(backpackShops) do
					expect(ShopConfig.shops[shopId].ownershipGuard).to.equal("backpack")
				end
			end)

			it("should have attribute guard for Bat and Scythe", function()
				expect(ShopConfig.shops.Bat.ownershipGuard).to.equal("attribute")
				expect(ShopConfig.shops.Scythe.ownershipGuard).to.equal("attribute")
			end)

			it("should have attribute names for Bat and Scythe", function()
				expect(ShopConfig.shops.Bat.attributeName).to.equal("OwnsBat")
				expect(ShopConfig.shops.Scythe.attributeName).to.equal("OwnsScythe")
			end)
		end)

		describe("Validation", function()
			it("should reject purchase if insufficient coins", function()
				-- MILESTONE 2: Test insufficient funds rejection
			end)

			it("should reject purchase if already owned (backpack guard)", function()
				-- MILESTONE 2: Test backpack ownership check
			end)

			it("should reject purchase if already owned (attribute guard)", function()
				-- MILESTONE 2: Test attribute ownership check
			end)

			it("should reject purchase if too far from shop", function()
				-- MILESTONE 2: Test distance validation
			end)

			it("should enforce purchase cooldown", function()
				-- MILESTONE 2: Test 0.5s cooldown
			end)
		end)

		describe("Tool granting", function()
			it("should grant correct tool from ServerStorage/Tools", function()
				-- MILESTONE 2: Test tool cloning and granting
			end)

			it("should update InventoryService ownership", function()
				-- MILESTONE 2: Test InventoryService.grantTool called
			end)

			it("should set ownership attribute for attribute-guarded shops", function()
				-- MILESTONE 2: Test attribute setting
			end)
		end)
	end)
end