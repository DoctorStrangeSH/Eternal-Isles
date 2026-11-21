local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local config = require(ReplicatedStorage.Shared.WorldConfig)

local Expedition = {}

local function interact(part, label, action, callback)
    local prompt = Instance.new("ProximityPrompt")
    prompt.ObjectText = label
    prompt.ActionText = action
    prompt.RequiresLineOfSight = false
    prompt.Parent = part
    prompt.Triggered:Connect(function(player)
        local character = player.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if root and humanoid and humanoid.Health > 0
            and (root.Position - part.Position).Magnitude <= prompt.MaxActivationDistance + 2 then
            callback(player, character)
        end
    end)
end

function Expedition.start(gate, beacon, scale, spawn)
    local function bindSpawn(player)
        player.RespawnLocation = spawn
        player.CharacterAdded:Connect(function()
            player:SetAttribute("AtRookery", false)
        end)
    end
    Players.PlayerAdded:Connect(bindSpawn)
    for _, player in Players:GetPlayers() do
        bindSpawn(player)
    end

    interact(gate, "Портал · " .. config.PortalMana .. " маны", "К гнездовью", function(player, character)
        local stats = player:FindFirstChild("leaderstats")
        local mana = stats and stats:FindFirstChild("Mana")
        if mana and mana.Value >= config.PortalMana then
            local arrival = beacon.Position + Vector3.new(0, 2, -6)
            character:PivotTo(CFrame.lookAt(arrival, scale.Position))
            player:SetAttribute("AtRookery", true)
        end
    end)
    interact(scale, "Золотая чешуя", "Подобрать", function(player)
        if player:GetAttribute("AtRookery") then
            player:SetAttribute("FoundDawnScale", true)
        end
    end)
    interact(beacon, "Камень возвращения", "Домой", function(player, character)
        character:PivotTo(spawn.CFrame + Vector3.new(0, 5, 0))
        player:SetAttribute("AtRookery", false)
    end)
end

return Expedition
