--!strict
--[[
	TableUtil.lua
	Table manipulation utilities.
]]

-- Deep copy a table (handles nested tables, not cyclic)
export function deepCopy<T>(original: T): T
	if type(original) ~= "table" then
		return original
	end
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = deepCopy(value)
	end
	return copy
end

-- Shallow copy a table
export function shallowCopy<T>(original: T): T
	if type(original) ~= "table" then
		return original
	end
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

-- Merge two tables (target is modified)
export function merge<T>(target: T, source: T): T
	for key, value in pairs(source) do
		if type(value) == "table" and type(target[key]) == "table" then
			merge(target[key], value)
		else
			target[key] = value
		end
	end
	return target
end

-- Deep merge (creates new table)
export function deepMerge<T>(target: T, source: T): T
	local result = deepCopy(target)
	return merge(result, source)
end

-- Check if table is empty
export function isEmpty(t: { [any]: any }): boolean
	return next(t) == nil
end

-- Get table size (count of keys)
export function size(t: { [any]: any }): number
	local count = 0
	for _ in pairs(t) do
		count += 1
	end
	return count
end

-- Get keys as array
export function keys<K, V>(t: { [K]: V }): { K }
	local result = {}
	for k in pairs(t) do
		table.insert(result, k)
	end
	return result
end

-- Get values as array
export function values<K, V>(t: { [K]: V }): { V }
	local result = {}
	for _, v in pairs(t) do
		table.insert(result, v)
	end
	return result
end

-- Find first key matching predicate
export function find<K, V>(t: { [K]: V }, predicate: (V, K) -> boolean): (K?, V?)
	for k, v in pairs(t) do
		if predicate(v, k) then
			return k, v
		end
	end
	return nil, nil
end

-- Filter table by predicate
export function filter<K, V>(t: { [K]: V }, predicate: (V, K) -> boolean): { [K]: V }
	local result = {}
	for k, v in pairs(t) do
		if predicate(v, k) then
			result[k] = v
		end
	end
	return result
end

-- Map table values
export function map<K, V, R>(t: { [K]: V }, mapper: (V, K) -> R): { [K]: R }
	local result = {}
	for k, v in pairs(t) do
		result[k] = mapper(v, k)
	end
	return result
end

-- Check if table contains value
export function contains<V>(t: { [any]: V }, value: V): boolean
	for _, v in pairs(t) do
		if v == value then
			return true
		end
	end
	return false
end

-- Remove keys from table (returns new table)
export function omit<K, V>(t: { [K]: V }, keysToOmit: { K }): { [K]: V }
	local omitSet = {}
	for _, k in ipairs(keysToOmit) do
		omitSet[k] = true
	end
	local result = {}
	for k, v in pairs(t) do
		if not omitSet[k] then
			result[k] = v
		end
	end
	return result
end

-- Pick keys from table (returns new table)
export function pick<K, V>(t: { [K]: V }, keysToPick: { K }): { [K]: V }
	local pickSet = {}
	for _, k in ipairs(keysToPick) do
		pickSet[k] = true
	end
	local result = {}
	for k, v in pairs(t) do
		if pickSet[k] then
			result[k] = v
		end
	end
	return result
end

-- Clear table (in place)
export function clear<K, V>(t: { [K]: V })
	for k in pairs(t) do
		t[k] = nil
	end
end

return {
	deepCopy = deepCopy,
	shallowCopy = shallowCopy,
	merge = merge,
	deepMerge = deepMerge,
	isEmpty = isEmpty,
	size = size,
	keys = keys,
	values = values,
	find = find,
	filter = filter,
	map = map,
	contains = contains,
	omit = omit,
	pick = pick,
	clear = clear,
}