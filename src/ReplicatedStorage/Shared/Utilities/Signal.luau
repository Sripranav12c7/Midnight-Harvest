--!strict
--[[
	Signal.lua
	Typed event wrapper similar to RBXScriptSignal but for pure Luau.
	Allows type-safe event firing and connection.
]]

export type Connection = {
	Disconnect: (self: Connection) -> (),
	Connected: boolean,
}

export type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	Fire: (self: Signal<T...>, T...) -> (),
	Wait: (self: Signal<T...>) -> T...,
	DisconnectAll: (self: Signal<T...>) -> (),
}

local function createConnection(callback: () -> ()): Connection
	local connected = true
	return {
		Disconnect = function(self)
			connected = false
		end,
		Connected = function(self): boolean
			return connected
		end,
	}
end

local function createSignal<T...>(): Signal<T...>
	local connections: { Connection } = {}

	local function connect(callback: (T...) -> ()): Connection
		local connection = createConnection(function()
			-- Find and remove this connection
			for i, conn in ipairs(connections) do
				if conn == connection then
					table.remove(connections, i)
					break
				end
			end
		end)
		connection.callback = callback
		table.insert(connections, connection)
		return connection
	end

	local function fire(...: T...)
		-- Copy connections to avoid issues if callbacks disconnect during iteration
		local conns = table.clone(connections)
		for _, conn in ipairs(conns) do
			if conn.Connected then
				task.spawn(conn.callback, ...)
			end
		end
	end

	local function wait(...: T...): T...
		local thread = coroutine.running()
		local connection: Connection?
		connection = connect(function(...: T...)
			if connection then
				connection:Disconnect()
			end
			task.spawn(thread, ...)
		end)
		return coroutine.yield()
	end

	local function disconnectAll()
		for _, conn in ipairs(connections) do
			conn:Disconnect()
		end
		table.clear(connections)
	end

	return {
		Connect = connect,
		Fire = fire,
		Wait = wait,
		DisconnectAll = disconnectAll,
	}
end

export type SignalConstructor = {
	new: <T...>() -> Signal<T...>,
}

export const Signal: SignalConstructor = {
	new = createSignal,
}

return {
	new = createSignal,
}