local Players = game:GetService("Players")
local CollectionService = game:GetService("CollectionService")
local config = require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("WorldConfig"))
local player = Players.LocalPlayer
local mana = player:WaitForChild("leaderstats"):WaitForChild("Mana")

local function refreshRune(rune)
    local index = rune:GetAttribute("RuneIndex")
    if not index then return end
    local open = (player:GetAttribute("TrailStage") or 0) >= 1 or mana.Value >= config.PortalMana
    local active = open or player:GetAttribute("Collected_ManaCrystal_" .. index)
    rune.Material = active and Enum.Material.Neon or Enum.Material.Slate
    rune.Color = active and Color3.fromRGB(107, 246, 228) or Color3.fromRGB(49, 46, 63)
end

local tag = "ExpeditionGateRune"
local function refresh()
    for _, rune in CollectionService:GetTagged(tag) do
        refreshRune(rune)
    end
end
CollectionService:GetInstanceAddedSignal(tag):Connect(refreshRune)
for index = 1, 3 do
    player:GetAttributeChangedSignal("Collected_ManaCrystal_" .. index):Connect(refresh)
end
player:GetAttributeChangedSignal("TrailStage"):Connect(refresh)
mana.Changed:Connect(refresh)
refresh()
