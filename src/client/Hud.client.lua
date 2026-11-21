local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local config = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("WorldConfig"))
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
panel.Size = UDim2.new(0, 280, 0, 126)
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

local objective = manaLabel:Clone()
objective.Name = "ExpeditionObjective"
objective.Position = UDim2.fromOffset(10, 85)
objective.Size = UDim2.new(1, -20, 0, 36)
objective.TextWrapped = true
objective.TextSize = 13
objective.TextColor3 = title.TextColor3
objective.Text = ""
objective.Parent = panel

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
        local stage = player:GetAttribute("TrailStage") or 0
        if player:GetAttribute("Flying") then
            objective.Text = "Искра ловит восходящий поток…"
        elseif player:GetAttribute("AtWindIsle") then
            objective.Text = stage == 3 and "Связь II · Насест открыл прямой путь домой." or "Остров Ветров · Найди золотистый янтарь."
        elseif stage >= 2 then
            objective.Text = player:GetAttribute("AtRookery") and "Позови Искру ещё раз для полёта на Остров Ветров." or (stage == 3 and "Связь II · Коллекция 2/2 · Чешуя и янтарь" or "Связь I · Вернись через портал к Искре.")
        elseif player:GetAttribute("FoundDawnScale") then
            objective.Text = player:GetAttribute("AtRookery") and "Чешуя тёплая! Покажи её дракону у камня." or "Коллекция 1/2 · Отнеси чешую Искре через портал."
        elseif player:GetAttribute("AtRookery") then
            objective.Text = "Исследуй гнездовье. Что там блестит в траве?"
        elseif mana.Value >= config.PortalMana then
            objective.Text = "Портал готов. Активируй фиолетовую арку."
        elseif player:GetAttribute("Collected_ManaCrystal_3") then
            objective.Text = "Ищи голубые кристаллы на поляне у рощи."
        else
            objective.Text = "Собери кристаллы. Один спрятан в гроте у ручья."
        end
    end
    for _, attribute in ipairs({"Flying", "AtWindIsle", "TrailStage", "FoundDawnScale", "AtRookery", "Collected_ManaCrystal_3"}) do
        player:GetAttributeChangedSignal(attribute):Connect(updateMana)
    end
    mana.Changed:Connect(updateMana)
    updateMana()
end

phase.Changed:Connect(updateClock)
remaining.Changed:Connect(updateClock)
updateClock()
task.spawn(bindMana)
