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
panel.Position = UDim2.fromScale(0.5, 0.025)
panel.Size = UDim2.new(0, 280, 0, 92)
panel.BackgroundColor3 = Color3.fromRGB(22, 26, 42)
panel.BackgroundTransparency = 0.1
panel.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = panel

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(183, 153, 96)
stroke.Thickness = 2
stroke.Parent = panel

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.fromOffset(10, 7)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(245, 218, 161)
title.Text = "ETERNAL ISLES"
title.Parent = panel

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 23)
info.Position = UDim2.fromOffset(10, 39)
info.BackgroundTransparency = 1
info.Font = Enum.Font.GothamMedium
info.TextSize = 16
info.TextColor3 = Color3.fromRGB(236, 239, 247)
info.Parent = panel

local manaLabel = Instance.new("TextLabel")
manaLabel.Size = UDim2.new(1, -20, 0, 20)
manaLabel.Position = UDim2.fromOffset(10, 65)
manaLabel.BackgroundTransparency = 1
manaLabel.Font = Enum.Font.GothamBold
manaLabel.TextSize = 14
manaLabel.TextColor3 = Color3.fromRGB(111, 226, 235)
manaLabel.Text = "✧ Мана: 0"
manaLabel.Parent = panel

local function updateClock()
    local seconds = remaining.Value
    local minutes = math.floor(seconds / 60)
    local rest = seconds % 60
    local label = phase.Value == "Night" and "Ночь" or "День"
    info.Text = string.format("%s · %02d:%02d", label, minutes, rest)
end

local function bindMana()
    local leaderstats = player:WaitForChild("leaderstats")
    local mana = leaderstats:WaitForChild("Mana")
    local function updateMana()
        manaLabel.Text = string.format("✧ Мана: %d", mana.Value)
    end
    mana.Changed:Connect(updateMana)
    updateMana()
end

phase.Changed:Connect(updateClock)
remaining.Changed:Connect(updateClock)
updateClock()
task.spawn(bindMana)
