--!strict
--[[
	RemoteFunctions.lua
	Declaration and creation of all RemoteFunctions.
	Currently none used; all async communication via RemoteEvents.
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteNames = require(ReplicatedStorage.Shared.Constants.RemoteNames)

local FUNCTIONS = RemoteNames.Functions

local function createRemoteFunctions(): { [string]: RemoteFunction }
	local funcs = {}

	for _, name in pairs(FUNCTIONS) do
		local existing = ReplicatedStorage:FindFirstChild(name)
		if existing then
			if existing:IsA("RemoteFunction") then
				funcs[name] = existing
			else
				warn(`"${name}" exists but is not a RemoteFunction; replacing`)
				existing:Destroy()
				local func = Instance.new("RemoteFunction")
				func.Name = name
				func.Parent = ReplicatedStorage
				funcs[name] = func
			end
		else
			local func = Instance.new("RemoteFunction")
			func.Name = name
			func.Parent = ReplicatedStorage
			funcs[name] = func
		end
	end

	return funcs
end

export function initializeRemoteFunctions(): { [string]: RemoteFunction }
	return createRemoteFunctions()
end

export function getRemoteFunction(name: string): RemoteFunction
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local func = ReplicatedStorage:WaitForChild(name, 10)
	if not func then
		error(`RemoteFunction "${name}" not found`)
	end
	if not func:IsA("RemoteFunction") then
		error(`"${name}" is not a RemoteFunction`)
	end
	return func
end

return {
	initializeRemoteFunctions = initializeRemoteFunctions,
	getRemoteFunction = getRemoteFunction,
}