--!strict
--[[
	CoinGui.luau
	Coin, Silver, Baguerite, Scrap, Bag count display.
	MILESTONE 7: Full implementation. MILESTONE 1: Stub.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")

local StatNames = require(ReplicatedStorage.Shared.Constants.StatNames)

-- This file documents the expected UI structure
-- Actual ScreenGui creation happens in Roblox Studio or via Rojo sync

--[[
Expected CoinGui Structure:

CoinGui (ScreenGui)
├── CoinText (TextLabel) - "Coins: 500"
├── SilverText (TextLabel) - "Silver: 0"
│   └── BagueriteText (TextLabel) - "Baguerite: 0"  -- NOT "Bronze"
├── LootText (TextLabel) - "Items: 0/10"  -- Silver + Baguerite + Scrap
└── GhostEnergyText (TextLabel) - "Ghost Energy: 0"  -- Or separate GhostEnergyGui
]]

-- This is a placeholder - actual implementation in Milestone 7
return {}