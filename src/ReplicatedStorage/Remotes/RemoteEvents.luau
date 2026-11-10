--!strict
--[[
	RemoteEvents.lua
	Declaration and creation of all RemoteEvents.
	Server creates these on startup; Client accesses via RemoteNames.getRemoteEvent().
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)

-- RemoteEvent names (from RemoteNames)
local EVENTS = RemoteNames.Events

-- Create all RemoteEvents
local function createRemoteEvents(): { [string]: RemoteEvent }
	local events = {}

	for _, name in pairs(EVENTS) do
		local existing = ReplicatedStorage:FindFirstChild(name)
		if existing then
			if existing:IsA("RemoteEvent") then
				events[name] = existing
			else
				warn(`"${name}" exists but is not a RemoteEvent; replacing`)
				existing:Destroy()
				local remote = Instance.new("RemoteEvent")
				remote.Name = name
				remote.Parent = ReplicatedStorage
				events[name] = remote
			end
		else
			local remote = Instance.new("RemoteEvent")
			remote.Name = name
			remote.Parent = ReplicatedStorage
			events[name] = remote
		end
	end

	return events
end

-- Server-only: call this in Bootstrap.server.luau
export function initializeRemoteEvents(): { [string]: RemoteEvent }
	return createRemoteEvents()
end

-- Client accessor: returns typed RemoteEvent
export function getRemoteEvent(name: string): RemoteEvent
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local remote = ReplicatedStorage:WaitForChild(name, 10)
	if not remote then
		error(`RemoteEvent "${name}" not found`)
	end
	if not remote:IsA("RemoteEvent") then
		error(`"${name}" is not a RemoteEvent`)
	end
	return remote
end

return {
	initializeRemoteEvents = initializeRemoteEvents,
	getRemoteEvent = getRemoteEvent,
}