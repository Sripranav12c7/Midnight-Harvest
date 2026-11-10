--!strict
--[[
	PersistenceService.lua
	DataStore schema v1, session locking, retry/backoff, autosave.
	MILESTONE 1: SKELETON ONLY — types, interfaces, lock design.
	Working implementation in Milestone 2.
]]

local DataStoreService = game:GetService("DataStoreService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GameConfig = require(ReplicatedStorage.Shared.Config.GameConfig)
local EconomyTypes = require(ReplicatedStorage.Shared.Types.EconomyTypes)

-- DataStore configuration
local DATASTORE_NAME = "MidnightHarvest_v1"
local LOCK_TTL = 1800 -- 30 minutes
local LOCK_RENEWAL_INTERVAL = 1500 -- 25 minutes
local AUTOSAVE_INTERVAL = 60 -- 60 seconds
local RETRY_MAX = 3
local RETRY_BASE_DELAY = 1 -- seconds
local BIND_TO_CLOSE_TIMEOUT = 30 -- seconds

-- DataStore instances
local playerDataStore: GlobalDataStore?
local lockDataStore: GlobalDataStore?

-- In-memory state
local playerData: { [Player]: EconomyTypes.PlayerData } = {}
local playerLocks: { [Player]: { ownerJobId: string, expiresAt: number } } = {}
local playerLoaded: { [Player]: boolean } = {}
local autosaveTasks: { [Player]: thread } = {}

-- References to other services (set during initialization)
local EconomyService: any = nil
local InventoryService: any = nil

-- Job ID for this server
local JOB_ID = game.JobId

local function getDataStore()
	if not playerDataStore then
		playerDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)
	end
	return playerDataStore
end

local function getLockDataStore()
	if not lockDataStore then
		lockDataStore = DataStoreService:GetDataStore(DATASTORE_NAME .. "_locks")
	end
	return lockDataStore
end

local function getDataKey(userId: number): string
	return `Player_{userId}`
end

local function getLockKey(userId: number): string
	return `Player_{userId}_lock`
end

-- ============================================
-- Session Lock Design (MILESTONE 1 - DESIGN ONLY)
-- ============================================

--[[
	Session Lock Lifecycle:

	1. PlayerAdded — acquire lock:
	   UpdateAsync(lockKey, fn) where fn returns {ownerJobId = game.JobId, expiresAt = os.time() + LOCK_TTL}
	   iff current value is nil OR expiresAt < os.time() (expired).
	   Returns success + lock data, or failure if held by active session.

	2. Active retention & renewal:
	   Background task renews lock before LOCK_TTL expiry (e.g., at LOCK_RENEWAL_INTERVAL).
	   Renewal uses UpdateAsync(lockKey, fn) that verifies current.ownerJobId == game.JobId
	   before extending expiresAt. If verification fails, another server owns the lock —
	   stop writes, log conflict.

	3. PlayerRemoving — save then release:
	   Acquire lock (blocking with backoff if needed), save PlayerData via UpdateAsync(dataKey, fn)
	   while holding lock, then conditionally release lock via UpdateAsync(lockKey, fn) that
	   only clears if current.ownerJobId == game.JobId. If release fails, log warning.

	4. BindToClose — save active players:
	   For each loaded player, ensure lock ownership (renew if needed), save data,
	   then release lock where possible. Respect shutdown timeout (BIND_TO_CLOSE_TIMEOUT).
	   Force-save players whose locks cannot be acquired (log, save without lock as last resort).

	5. Expired-lock recovery:
	   In load(), if lock exists and expiresAt < os.time(), UpdateAsync(lockKey, fn)
	   atomically claims it for this server. Never blindly delete/overwrite a lock with
	   expiresAt >= os.time().

	6. Renewal failure handling:
	   If renewal UpdateAsync fails (lock stolen or conflict), immediately:
	   (a) stop all autosaves for that player
	   (b) mark player data as loaded: false to block further purchases
	   (c) attempt graceful re-acquisition with backoff
	   (d) if re-acquisition fails after N attempts, kick player with "session conflict"

	7. Save/release asymmetry handling:
	   If save succeeds but lock release fails — log, leave lock to expire naturally (TTL handles it).
	   If save fails but lock held — retry save with backoff while lock valid; if lock expires
	   during retry, re-acquire before continuing.
]]

-- ============================================
-- Skeleton Implementation (Stubs for Milestone 1)
-- ============================================

local function initialize(config: any)
	print("[PersistenceService] Initializing (SKELETON)...")

	-- TODO: Initialize DataStores
	-- playerDataStore = DataStoreService:GetDataStore(DATASTORE_NAME)
	-- lockDataStore = DataStoreService:GetDataStore(DATASTORE_NAME .. "_locks")

	Players.PlayerAdded:Connect(onPlayerAdded)
	Players.PlayerRemoving:Connect(onPlayerRemoving)

	print("[PersistenceService] Skeleton initialized")
end

local function onPlayerAdded(player: Player)
	-- MILESTONE 1: Stub - just create default data
	local defaultData = getDefaultPlayerData()
	playerData[player] = defaultData
	playerLoaded[player] = false -- Will be true after load()

	-- MILESTONE 2: Actual lock acquisition and load
	-- local success, data = loadPlayerData(player)
	-- if success then
	--     playerData[player] = data
	--     playerLoaded[player] = true
	-- else
	--     player:Kick("Failed to load data. Please rejoin.")
	--     return
	-- end

	-- Notify other services
	if EconomyService then EconomyService.setPersistenceLoaded(player, true) end
	if InventoryService then InventoryService.setPersistenceLoaded(player, true) end

	-- Fire PlayerDataLoaded event
	task.spawn(function()
		local RemoteEvents = require(ReplicatedStorage.Remotes.RemoteEvents)
		RemoteEvents.getRemoteEvent("PlayerDataLoaded"):FireClient(player, defaultData)
	end)
end

local function onPlayerRemoving(player: Player)
	-- MILESTONE 2: Save with lock, then release
	-- savePlayerData(player)
	-- releaseLock(player)

	playerData[player] = nil
	playerLoaded[player] = nil
end

local function getDefaultPlayerData(): EconomyTypes.PlayerData
	return {
		coins = 500,
		silver = 0,
		baguerite = 0,
		scrap = 0,
		ghostEnergy = 0,
		ownedTools = {},
		equippedTool = nil,
		purchasedAttributes = {},
		currentDay = 1,
		storyFlags = {},
		questProgress = {},
		schemaVersion = 1,
		lastSaved = os.time(),
	}
end

-- MILESTONE 2: loadPlayerData, savePlayerData, acquireLock, releaseLock, renewLock, etc.

local function load(player: Player): (boolean, EconomyTypes.PlayerData?)
	-- MILESTONE 2: Implement with UpdateAsync retry, lock acquisition, schema validation
	warn("[PersistenceService] load() not implemented (Milestone 1 skeleton)")
	return false, nil
end

local function save(player: Player): boolean
	-- MILESTONE 2: Implement with UpdateAsync, lock verification
	warn("[PersistenceService] save() not implemented (Milestone 1 skeleton)")
	return false
end

local function isLoaded(player: Player): boolean
	return playerLoaded[player] == true
end

local function getPlayerData(player: Player): EconomyTypes.PlayerData?
	return playerData[player]
end

local function onBindToClose()
	-- MILESTONE 2: Save all loaded players with timeout
	warn("[PersistenceService] BindToClose not implemented (Milestone 1 skeleton)")
end

local function heartbeat()
	-- MILESTONE 2: Lock renewal, autosave
end

local function initialize(config: any)
	print("[PersistenceService] Skeleton initialized")
end

-- Expose for other services
_G.PersistenceService = {
	initialize = initialize,
	load = load,
	save = save,
	isLoaded = isLoaded,
	getPlayerData = getPlayerData,
	onBindToClose = onBindToClose,
	heartbeat = heartbeat,
}

return {
	initialize = initialize,
	load = load,
	save = save,
	isLoaded = isLoaded,
	getPlayerData = getPlayerData,
	onBindToClose = onBindToClose,
	heartbeat = heartbeat,
}