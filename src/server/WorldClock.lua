local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WorldConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("WorldConfig"))

local WorldClock = {}

function WorldClock.start()
    local elapsed = 0
    local state = Instance.new("Folder")
    state.Name = "WorldState"
    state.Parent = ReplicatedStorage

    local phase = Instance.new("StringValue")
    phase.Name = "Phase"
    phase.Parent = state

    local remaining = Instance.new("IntValue")
    remaining.Name = "SecondsRemaining"
    remaining.Parent = state

    task.spawn(function()
        while true do
            local day = elapsed < WorldConfig.DayDurationSeconds
            local duration = day and WorldConfig.DayDurationSeconds or WorldConfig.NightDurationSeconds
            local phaseElapsed = day and elapsed or (elapsed - WorldConfig.DayDurationSeconds)
            phase.Value = day and "Day" or "Night"
            remaining.Value = math.max(0, duration - phaseElapsed)
            Lighting.ClockTime = day and (7 + (phaseElapsed / duration) * 11) or (18 + (phaseElapsed / duration) * 13) % 24
            Lighting.Brightness = day and 2.5 or 1
            task.wait(1)
            elapsed = (elapsed + 1) % (WorldConfig.DayDurationSeconds + WorldConfig.NightDurationSeconds)
        end
    end)
end

return WorldClock
