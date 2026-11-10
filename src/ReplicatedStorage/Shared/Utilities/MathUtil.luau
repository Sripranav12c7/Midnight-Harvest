--!strict
--[[
	MathUtil.lua
	Math utilities.
]]

-- Clamp value between min and max
export function clamp(value: number, min: number, max: number): number
	return math.max(min, math.min(max, value))
end

-- Linear interpolation
export function lerp(a: number, b: number, t: number): number
	return a + (b - a) * clamp(t, 0, 1)
end

-- Inverse lerp (get t from value)
export function inverseLerp(a: number, b: number, value: number): number
	if a == b then return 0 end
	return clamp((value - a) / (b - a), 0, 1)
end

-- Remap value from one range to another
export function remap(value: number, inMin: number, inMax: number, outMin: number, outMax: number): number
	return lerp(outMin, outMax, inverseLerp(inMin, inMax, value))
end

-- Round to specified decimal places
export function round(value: number, decimals: number?): number
	local mult = 10 ^ (decimals or 0)
	return math.floor(value * mult + 0.5) / mult
end

-- Round up to nearest multiple
export function roundUp(value: number, multiple: number): number
	return math.ceil(value / multiple) * multiple
end

-- Round down to nearest multiple
export function roundDown(value: number, multiple: number): number
	return math.floor(value / multiple) * multiple
end

-- Random float between min and max
export function randomFloat(min: number, max: number): number
	return min + math.random() * (max - min)
end

-- Random integer between min and max (inclusive)
export function randomInt(min: number, max: number): number
	return math.random(min, max)
end

-- Weighted random choice from { [item]: weight }
export function weightedChoice<T>(choices: { [T]: number }): T?
	local totalWeight = 0
	for _, weight in pairs(choices) do
		totalWeight += weight
	end
	if totalWeight <= 0 then return nil end

	local roll = math.random() * totalWeight
	local cumulative = 0
	for item, weight in pairs(choices) do
		cumulative += weight
		if roll <= cumulative then
			return item
		end
	end
	return nil
end

-- Distance between two Vector3 positions
export function distance(a: Vector3, b: Vector3): number
	return (a - b).Magnitude
end

-- Distance squared (avoids sqrt)
export function distanceSquared(a: Vector3, b: Vector3): number
	return (a - b).Magnitude ^ 2
end

-- Check if two positions are within distance
export function withinDistance(a: Vector3, b: Vector3, maxDistance: number): boolean
	return distanceSquared(a, b) <= maxDistance ^ 2
end

-- Lerp Vector3
export function lerpVector3(a: Vector3, b: Vector3, t: number): Vector3
	return a:Lerp(b, clamp(t, 0, 1))
end

-- Lerp CFrame
export function lerpCFrame(a: CFrame, b: CFrame, t: number): CFrame
	return a:Lerp(b, clamp(t, 0, 1))
end

-- Sign of number (-1, 0, or 1)
export function sign(x: number): number
	if x > 0 then return 1
	elseif x < 0 then return -1
	else return 0 end
end

-- Wrap value to range [0, max)
export function wrap(value: number, max: number): number
	return (value % max + max) % max
end

-- Smoothstep interpolation (ease in/out)
export function smoothstep(t: number): number
	t = clamp(t, 0, 1)
	return t * t * (3 - 2 * t)
end

-- Smootherstep interpolation
export function smootherstep(t: number): number
	t = clamp(t, 0, 1)
	return t * t * t * (t * (t * 6 - 15) + 10)
end

return {
	clamp = clamp,
	lerp = lerp,
	inverseLerp = inverseLerp,
	remap = remap,
	round = round,
	roundUp = roundUp,
	roundDown = roundDown,
	randomFloat = randomFloat,
	randomInt = randomInt,
	weightedChoice = weightedChoice,
	distance = distance,
	distanceSquared = distanceSquared,
	withinDistance = withinDistance,
	lerpVector3 = lerpVector3,
	lerpCFrame = lerpCFrame,
	sign = sign,
	wrap = wrap,
	smoothstep = smoothstep,
	smootherstep = smootherstep,
}