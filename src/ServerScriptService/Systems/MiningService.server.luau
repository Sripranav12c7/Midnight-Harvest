--!strict
--[[
	MiningService.lua
	Ore state, hit tracking, rewards, 150s respawn, tool requirement validation.
	MILESTONE 2: Full implementation. MILESTONE 1: Skeleton.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")

local MiningConfig = require(ReplicatedStorage.Shared.Config.MiningConfig)
local EconomyService = require(script.Parent.Parent.Services.EconomyService)
local InventoryService = require(script.Parent.Parent.Services.InventoryService)
local ToolNames = require(ReplicatedStorage.Shared.Constants.ToolNames)

local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)

-- Ore runtime state
export type OreRuntimeData = {
	model: Model,
	oreName: string,
	originalCFrame: CFrame,
	originalParent: Instance?,
	hitsByPlayer: { [Player]: number },
	respawnTask: thread?,
	isMined: boolean,
}

local oreStates: { [Model]: OreRuntimeData } = {}
local playerCooldowns: { [Player]: number } = {}
local COOLDOWN = 0.5

local function getOreConfig(oreName: string)
	return MiningConfig.ores[oreName]
end

local function validateMiningRequest(player: Player, ore: Model): (boolean, string?)
	if not player or not ore then return false, "Invalid request" end

	-- Check tool equipped
	if not InventoryService.isToolEquipped(player, ToolNames.Names.WoodPick) then
		return false, "WoodPick not equipped"
	end

	-- Check cooldown
	local now = os.clock()
	if playerCooldowns[player] and now - playerCooldowns[player] < COOLDOWN then
		return false, "Mining on cooldown"
	end

	-- Check ore exists in workspace
	if not ore:IsDescendantOf(Workspace) then
		return false, "Ore not in workspace"
	end

	-- Check ore name
	local config = getOreConfig(ore.Name)
	if not config then
		return false, "Invalid ore type"
	end

	-- Check distance
	local character = player.Character
	if not character then return false, "No character" end
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return false, "No HumanoidRootPart" end

	local orePos = ore:GetPivot().Position
	local distance = (rootPart.Position - orePos).Magnitude
	if distance > MiningConfig.validation.maxDistance then
		return false, "Too far from ore"
	end

	-- Check if already mined
	local state = oreStates[ore]
	if state and state.isMined then
		return false, "Ore already mined"
	end

	return true, nil
end

local function processMiningHit(player: Player, ore: Model): (boolean, string?)
	local config = getOreConfig(ore.Name)
	if not config then return false, "Invalid ore" end

	local state = oreStates[ore]
	if not state then
		-- Initialize state
		state = {
			model = ore,
			oreName = ore.Name,
			originalCFrame = ore:GetPivot(),
			originalParent = ore.Parent,
			hitsByPlayer = {},
			respawnTask = nil,
			isMined = false,
		}
		oreStates[ore] = state
	end

	-- Increment hits
	state.hitsByPlayer[player] = (state.hitsByPlayer[player] or 0) + 1
	local hits = state.hitsByPlayer[player]

	-- Fire progress event
	RemoteEvents.getRemoteEvent("MiningProgress"):FireClient(player, {
		ore = ore,
		hits = hits,
		requiredHits = config.hitsRequired,
	})

	-- Check if mining complete
	if hits >= config.hitsRequired then
		state.isMined = true

		-- Check bag capacity
		if EconomyService.isBagFull(player) then
			state.hitsByPlayer[player] = nil
			return false, "Bag is full"
		end

		-- Grant reward
		local addResult = EconomyService.addCurrency(player, config.reward, config.rewardAmount)
		if not addResult.success then
			return false, addResult.message or "Failed to grant reward"
		end

		-- Hide ore
		ore.Parent = nil

		-- Start respawn timer
		state.respawnTask = task.delay(MiningConfig.respawn.seconds, function()
			if state and ore then
				ore:PivotTo(state.originalCFrame)
				ore.Parent = state.originalParent
				state.isMined = false
				state.hitsByPlayer = {}
				state.respawnTask = nil
				print(`[MiningService] ${ore.Name} respawned`)
			end
		end)

		return true, "Mined"
	end

	return true, "Hit"
end

local function onMineOre(player: Player, ore: Model)
	local valid, message = validateMiningRequest(player, ore)
	if not valid then
		warn(`[MiningService] ${player.Name} mining validation failed: ${message}`)
		return
	end

	-- Set cooldown
	playerCooldowns[player] = os.clock()

	local success, msg = processMiningHit(player, ore)
	if not success then
		warn(`[MiningService] Mining failed for ${player.Name}: ${msg}`)
	end
end

local function initialize(config: any, economy: any, inventory: any)
	print("[MiningService] Initializing (SKELETON)...")

	-- Register ores in workspace (MILESTONE 2: scan workspace for ores)
	-- for _, obj in ipairs(Workspace:GetDescendants()) do
	--     if config.ores[obj.Name] then
	--         oreStates[obj] = { ... }
	--     end
	-- end

	RemoteEvents.getRemoteEvent("MineOre").OnServerEvent:Connect(onMineOre)

	print("[MiningService] Skeleton initialized")
end

return {
	initialize = initialize,
	validateMiningRequest = validateMiningRequest,
	processMiningHit = processMiningHit,
}