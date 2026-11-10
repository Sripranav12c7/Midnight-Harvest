--!strict
--[[
	ShopConfig.lua
	Shop definitions separate from prices (which are in GameConfig).
	ALL VALUES UNAPPROVED.
]]

export type ShopItemConfig = {
	name: string,
	toolName: string, -- Must match ToolNames
	priceKey: string, -- Key in GameConfig.shopPrices
	ownershipGuard: "backpack" | "attribute" | "none",
	attributeName: string?, -- If guard == "attribute"
	distance: number, -- Interaction distance (studs)
}

export type ShopConfig = {
	shops: { [string]: ShopItemConfig },
}

local Config: ShopConfig = {
	shops = {
		Axe = {
			name = "Axe",
			toolName = "Axe",
			priceKey = "Axe",
			ownershipGuard = "backpack",
			distance = 12,
		},
		Hammer = {
			name = "Hammer",
			toolName = "Hammer",
			priceKey = "Hammer",
			ownershipGuard = "backpack",
			distance = 12,
		},
		WoodPick = {
			name = "WoodPick",
			toolName = "WoodPick",
			priceKey = "WoodPick",
			ownershipGuard = "backpack", -- Original had NO guard — adding
			distance = 12,
		},
		Bat = {
			name = "Bat",
			toolName = "Bat",
			priceKey = "Bat",
			ownershipGuard = "attribute",
			attributeName = "OwnsBat",
			distance = 12,
		},
		Gun = {
			name = "Gun",
			toolName = "Gun",
			priceKey = "Gun",
			ownershipGuard = "backpack",
			distance = 12,
		},
		TrenchGun = {
			name = "TrenchGun",
			toolName = "TrenchGun",
			priceKey = "TrenchGun",
			ownershipGuard = "backpack",
			distance = 12,
		},
		Scythe = {
			name = "Guestium Scythe",
			toolName = "Guestium Scythe",
			priceKey = "Scythe",
			ownershipGuard = "attribute",
			attributeName = "OwnsScythe",
			distance = 12,
		},
		CoconutDrink = {
			name = "CoconutDrink",
			toolName = "CoconutDrink",
			priceKey = "CoconutDrink",
			ownershipGuard = "backpack", -- Original had NO guard — adding
			distance = 12,
		},
		GhostVacuum = {
			name = "GhostVacuum",
			toolName = "GhostVacuum",
			priceKey = "GhostVacuum",
			ownershipGuard = "backpack",
			distance = 12,
		},
	},
}

return Config