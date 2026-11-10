--!strict
--[[
	RemoteNames.lua
	Single source of truth for all RemoteEvent and RemoteFunction names.
	Prevents stringly-typed WaitForChild calls.
]]

export type RemoteEventName =
	| "MineOre"
	| "ShopPurchase"
	| "ShopPurchaseResult"
	| "GhostAbsorb"
	| "ScrapCollect"
	| "ScrapSell"
	| "OreSell"
	| "BossFightStart"
	| "BossEnergyTransfer"
	| "BossDialogueEvent"
	| "BossFinalEvent"
	| "AliceCutsceneEvent"
	| "AliceRevealEvent"
	| "MineCutsceneEvent"
	| "MineCutsceneFinished"
	| "DialogueStart"
	| "PlayerDataLoaded"
	| "DataUpdate"

export type RemoteFunctionName = never -- None currently

export type BindableEventName = "BossFinalEvent"

local RemoteEvents: { [RemoteEventName]: RemoteEventName } = {
	MineOre = "MineOre",
	ShopPurchase = "ShopPurchase",
	ShopPurchaseResult = "ShopPurchaseResult",
	GhostAbsorb = "GhostAbsorb",
	ScrapCollect = "ScrapCollect",
	ScrapSell = "ScrapSell",
	OreSell = "OreSell",
	BossFightStart = "BossFightStart",
	BossEnergyTransfer = "BossEnergyTransfer",
	BossDialogueEvent = "BossDialogueEvent",
	BossFinalEvent = "BossFinalEvent",
	AliceCutsceneEvent = "AliceCutsceneEvent",
	AliceRevealEvent = "AliceRevealEvent",
	MineCutsceneEvent = "MineCutsceneEvent",
	MineCutsceneFinished = "MineCutsceneFinished",
	DialogueStart = "DialogueStart",
	PlayerDataLoaded = "PlayerDataLoaded",
	DataUpdate = "DataUpdate",
}

local RemoteFunctions: { [RemoteFunctionName]: RemoteFunctionName } = {}

local BindableEvents: { [BindableEventName]: BindableEventName } = {
	BossFinalEvent = "BossFinalEvent",
}

-- Helper to get RemoteEvent from ReplicatedStorage with type safety
export function getRemoteEvent(name: RemoteEventName): RemoteEvent
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		error(`RemoteEvent "{name}" not found in ReplicatedStorage`)
	end
	if not remote:IsA("RemoteEvent") then
		error(`"{name}" is not a RemoteEvent`)
	end
	return remote
end

export function getRemoteFunction(name: RemoteFunctionName): RemoteFunction
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local remote = ReplicatedStorage:FindFirstChild(name)
	if not remote then
		error(`RemoteFunction "{name}" not found in ReplicatedStorage`)
	end
	if not remote:IsA("RemoteFunction") then
		error(`"{name}" is not a RemoteFunction`)
	end
	return remote
end

export function getBindableEvent(name: BindableEventName): BindableEvent
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local bindable = ReplicatedStorage:FindFirstChild(name)
	if not bindable then
		error(`BindableEvent "{name}" not found in ReplicatedStorage`)
	end
	if not bindable:IsA("BindableEvent") then
		error(`"{name}" is not a BindableEvent`)
	end
	return bindable
end

-- Expose raw names for declaration files
export const REMOTE_EVENT_NAMES = RemoteEvents
export const REMOTE_FUNCTION_NAMES = RemoteFunctions
export const BINDABLE_EVENT_NAMES = BindableEvents

return {
	Events = RemoteEvents,
	Functions = RemoteFunctions,
	Bindables = BindableEvents,
	getRemoteEvent = getRemoteEvent,
	getRemoteFunction = getRemoteFunction,
	getBindableEvent = getBindableEvent,
}