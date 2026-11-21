local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")

local Trail = {}
local profileStore
if game.GameId ~= 0 then
    profileStore = DataStoreService:GetDataStore("DawnTrail_v1")
end

local function advance(player, stage)
    if (player:GetAttribute("TrailStage") or 0) >= stage then return end
    player:SetAttribute("TrailStage", stage)
    player:SetAttribute("FoundDawnScale", true)
    if profileStore then
        task.spawn(function()
            for attempt = 1, 3 do
                local ok = pcall(function()
                    profileStore:UpdateAsync(tostring(player.UserId), function(old)
                        return math.max(old or 0, stage)
                    end)
                end)
                if ok then return end
                task.wait(attempt)
            end
            warn("DawnTrail: failed to save stage for", player.UserId)
        end)
    end
end

function Trail.collectScale(player)
    advance(player, 1)
end

local function piece(parent, name, size, position, color, material, shape)
    local p = Instance.new("Part")
    p.Name, p.Size, p.Position = name, size, position
    p.Anchored, p.Color, p.Material = true, color, material
    p.Shape = shape or Enum.PartType.Block
    p.Parent = parent
    return p
end

local function dragon(parent, origin)
    local model = Instance.new("Model")
    model.Name = "DawnDragon"
    local jade = Color3.fromRGB(65, 168, 150)
    local gold = Color3.fromRGB(255, 203, 102)
    local function oval(name, offset, size, tint)
        local p = piece(model, name, size, origin + offset, tint, Enum.Material.SmoothPlastic, Enum.PartType.Ball)
        p.CanCollide = false
        return p
    end
    model.PrimaryPart = oval("Body", Vector3.zero, Vector3.new(3, 3, 5), jade)
    oval("Head", Vector3.new(0, 1.5, -2.7), Vector3.new(2.8, 2.4, 3), jade)
    oval("Tail", Vector3.new(0, 0, 3.2), Vector3.new(1.3, 1.4, 4), jade)
    for _, side in {-1, 1} do
        local wing = oval("Wing", Vector3.new(side*2.5, 0.8, 0), Vector3.new(4.7, 0.45, 3), gold)
        wing.Orientation = Vector3.new(0, side*20, side*22)
        oval("Eye", Vector3.new(side*1.12, 1.9, -3.45), Vector3.new(.45,.45,.45), Color3.fromRGB(37,42,60))
        oval("Horn", Vector3.new(side*.8, 2.7, -2.3), Vector3.new(.5,1.6,.6), gold)
    end
    model.Parent = parent
    return model
end

local function fly(player, character, template, destination, location)
    if player:GetAttribute("Flying") then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    player:SetAttribute("Flying", true)
    local mount = template:Clone()
    mount.Name = "FlightDragon"
    for _, child in mount:GetDescendants() do
        if child:IsA("ProximityPrompt") then child:Destroy() end
    end
    mount.Parent = template.Parent
    local start = root.Position
    local direction = (destination - start).Unit
    root.Anchored = true
    local elapsed = 0
    while elapsed < 3.5 and root.Parent and player.Character == character and character.Humanoid.Health > 0 do
        elapsed += RunService.Heartbeat:Wait()
        local t = math.min(elapsed / 3.5, 1)
        local pos = start:Lerp(destination, t) + Vector3.yAxis * (math.sin(math.pi*t)*18)
        local pose = CFrame.lookAt(pos, pos + direction)
        character:PivotTo(pose)
        mount:PivotTo(pose * CFrame.new(0,-2,0))
    end
    mount:Destroy()
    if root.Parent then root.Anchored = false end
    if player.Parent then
        player:SetAttribute("Flying", false)
        if player.Character == character and elapsed >= 3.5 then
            player:SetAttribute("AtRookery", location == "rookery")
            player:SetAttribute("AtWindIsle", location == "wind")
        end
    end
end

function Trail.start(beacon, spawn, interact)
    local world = beacon.Parent
    local origin = beacon.Position + Vector3.new(84, 9, -55)
    local grass = Color3.fromRGB(89, 157, 119)
    piece(world, "WindCliff", Vector3.new(38,23,36), origin-Vector3.yAxis*9, Color3.fromRGB(74,76,98), Enum.Material.Slate, Enum.PartType.Ball)
    local lawn = piece(world, "WindIsle", Vector3.new(5,38,36), origin, grass, Enum.Material.Grass, Enum.PartType.Cylinder)
    lawn.Orientation = Vector3.new(0,0,90)
    local amber = Color3.fromRGB(255,195,92)
    local relic = piece(world, "WindAmber", Vector3.new(2,4,2), origin+Vector3.new(0,5,-8), amber, Enum.Material.Neon)
    relic.Orientation = Vector3.new(12,35,15)
    local perch = piece(world, "WindPerch", Vector3.new(5,2,5), origin+Vector3.new(0,3,9), amber, Enum.Material.Slate)
    local guide = dragon(world, beacon.Position + Vector3.new(10,0,-11))

    require(script.Parent.FreeFlight).start(world, guide, {
        {id="home", label="Роща", position=spawn.Position + Vector3.new(14,-1,4)},
        {id="rookery", label="Гнездовье", position=beacon.Position + Vector3.new(-12,-2.5,-8)},
        {id="wind", label="Остров Ветров", position=origin + Vector3.new(10,3,0)},
    }, interact)

    local function bind(player)
        player.CharacterAdded:Connect(function() player:SetAttribute("AtWindIsle", false) end)
        if not profileStore then return end
        task.spawn(function()
            local ok, stage = pcall(function() return profileStore:GetAsync(tostring(player.UserId)) end)
            if ok and type(stage) == "number" and player.Parent and stage > (player:GetAttribute("TrailStage") or 0) then
                player:SetAttribute("FoundDawnScale", true)
                player:SetAttribute("TrailStage", stage)
            elseif not ok then
                warn("DawnTrail: failed to load progress for", player.UserId)
            end
        end)
    end
    Players.PlayerAdded:Connect(bind)
    for _, player in Players:GetPlayers() do bind(player) end

    interact(guide.PrimaryPart, "Искра · рассветный дракон", "Позвать Искру", function(player, character)
        if not player:GetAttribute("AtRookery") then return end
        local stage = player:GetAttribute("TrailStage") or 0
        if stage == 1 then
            advance(player, 2)
        elseif stage >= 2 then
            fly(player, character, guide, origin + Vector3.new(0,6,2), "wind")
        end
    end)
    interact(relic, "Янтарь ветров", "Взять реликвию", function(player)
        if player:GetAttribute("AtWindIsle") then advance(player, 3) end
    end)
    interact(perch, "Насест Искры", "В обратный полёт", function(player, character)
        if not player:GetAttribute("AtWindIsle") then return end
        if player:GetAttribute("TrailStage") == 3 then
            fly(player, character, guide, spawn.Position + Vector3.yAxis*4, "home")
        else
            fly(player, character, guide, beacon.Position + Vector3.new(0,2,-5), "rookery")
        end
    end)
end

return Trail
