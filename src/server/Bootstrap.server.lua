local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local WorldClock = require(script.Parent:WaitForChild("WorldClock"))
local ManaHarvest = require(script.Parent:WaitForChild("ManaHarvest"))

WorldBuilder.build()
ManaHarvest.start()
WorldClock.start()

print("[Eternal Isles] Pre-alpha world initialized")
