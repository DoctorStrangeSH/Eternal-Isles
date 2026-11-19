local WorldBuilder = require(script.Parent:WaitForChild("WorldBuilder"))
local WorldClock = require(script.Parent:WaitForChild("WorldClock"))

WorldBuilder.build()
WorldClock.start()

print("[Eternal Isles] Pre-alpha world initialized")
