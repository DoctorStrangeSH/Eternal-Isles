local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local state = ReplicatedStorage:WaitForChild("WorldState")
local phase = state:WaitForChild("Phase")
local remaining = state:WaitForChild("SecondsRemaining")

local gui = Instance.new("ScreenGui")
gui.Name = "EternalIslesHUD"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = false
gui.Parent = player:WaitForChild("PlayerGui")

local panel = Instance.new("Frame")
panel.Name = "WorldClockPanel"
panel.AnchorPoint = Vector2.new(0.5, 0)
panel.Position = UDim2.fromScale(0.5, 0.02)
panel.Size = UDim2.new(0, 260, 0, 72)
panel.BackgroundColor3 = Color3.fromRGB(22, 26, 42)
panel.BackgroundTransparency = 0.12
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(183, 153, 96)
stroke.Thickness = 2
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -16, 0, 30)
title.Position = UDim2.fromOffset(8, 6)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.TextColor3 = Color3.fromRGB(245, 218, 161)
title.Text = "ETERNAL ISLES"
title.Parent = panel

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -16, 0, 25)
info.Position = UDim2.fromOffset(8, 38)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextScaled = true
info.TextColor3 = Color3.fromRGB(236, 239, 247)
info.Parent = panel

local function update()
    local seconds = remaining.Value
    local minutes = math.floor(seconds / 60)
    local rest = seconds % 60
    local label = phase.Value == "Night" and "Ночь" or "День"
    info.Text = string.format("%s · %02d:%02d", label, minutes, rest)
end

phase.Changed:Connect(update)
remaining.Changed:Connect(update)
update()
