local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

local ManaHarvest = {}
local REWARD_DEFAULT = 5

local function setupPlayer(player)
    local leaderstats = player:FindFirstChild("leaderstats")
    if not leaderstats then
        leaderstats = Instance.new("Folder")
        leaderstats.Name = "leaderstats"
        leaderstats.Parent = player
    end

    if not leaderstats:FindFirstChild("Mana") then
        local mana = Instance.new("IntValue")
        mana.Name = "Mana"
        mana.Value = 0
        mana.Parent = leaderstats
    end
end

local function setupCrystal(crystal)
    if not crystal:IsA("BasePart") then
        return
    end

    local prompt = crystal:FindFirstChildOfClass("ProximityPrompt")
    if prompt then
        return
    end

    prompt = Instance.new("ProximityPrompt")
    prompt.ActionText = "Собрать"
    prompt.ObjectText = "Кристалл маны"
    prompt.KeyboardKeyCode = Enum.KeyCode.E
    prompt.GamepadKeyCode = Enum.KeyCode.ButtonX
    prompt.HoldDuration = 0.35
    prompt.MaxActivationDistance = 11
    prompt.RequiresLineOfSight = false
    prompt.Parent = crystal

    prompt.Triggered:Connect(function(player)
        if not player or not player:IsA("Player") then
            return
        end

        local collectedAttribute = "Collected_" .. crystal.Name
        if player:GetAttribute(collectedAttribute) then
            return
        end

        setupPlayer(player)
        local mana = player.leaderstats:FindFirstChild("Mana")
        if not mana then
            return
        end

        player:SetAttribute(collectedAttribute, true)
        mana.Value += crystal:GetAttribute("ManaReward") or REWARD_DEFAULT
    end)
end

function ManaHarvest.start()
    Players.PlayerAdded:Connect(setupPlayer)
    for _, player in Players:GetPlayers() do
        setupPlayer(player)
    end

    for _, crystal in CollectionService:GetTagged("ManaCrystal") do
        setupCrystal(crystal)
    end
    CollectionService:GetInstanceAddedSignal("ManaCrystal"):Connect(setupCrystal)
end

return ManaHarvest
