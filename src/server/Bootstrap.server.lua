local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local WorldClock = require(script.Parent:WaitForChild("WorldClock"))
local ManaHarvest = require(script.Parent:WaitForChild("ManaHarvest"))

local Expedition = require(script.Parent:WaitForChild("Expedition"))
local gate, beacon, scale, spawn = WorldBuilder.build()
Expedition.start(gate, beacon, scale, spawn)
ManaHarvest.start()
WorldClock.start()

print("[Eternal Isles] Pre-alpha world initialized")
