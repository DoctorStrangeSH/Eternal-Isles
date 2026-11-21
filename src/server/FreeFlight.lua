local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Flight = {}

function Flight.start(world, guide, sites, interact)
    local input = Instance.new("RemoteEvent")
    input.Name = "DragonFlightInput"
    input.Parent = ReplicatedStorage
    local riders = {}

    local function finish(player, site)
        local ride = riders[player]
        if not ride then return end
        riders[player] = nil
        ride.dragon:Destroy()
        if ride.root.Parent then
            if site then
                ride.character:PivotTo(CFrame.new(site.position + Vector3.yAxis*4))
                player:SetAttribute("AtRookery", site.id == "rookery")
                player:SetAttribute("AtWindIsle", site.id == "wind")
                player:SetAttribute("AtObservatory", site.id == "observatory")
            end
            ride.root.Anchored = false
        end
        player:SetAttribute("LandingSite", nil)
        player:SetAttribute("ManualFlight", false)
        player:SetAttribute("Flying", false)
    end

    for _, site in sites do
        local pad = Instance.new("Part")
        pad.Name = "FlightPad_" .. site.id
        pad.Anchored = true
        pad.Size = Vector3.new(7,1,7)
        pad.Material = Enum.Material.Marble
        pad.Color = Color3.fromRGB(108,193,169)
        pad.Position = site.position
        pad.Parent = world
        interact(pad, "Насест · " .. site.label, "Оседлать Искру", function(player, character)
            if (player:GetAttribute("TrailStage") or 0) < 3 then return end
            local root = character.HumanoidRootPart
            local mount = guide:Clone()
            for _, item in mount:GetDescendants() do
                if item:IsA("ProximityPrompt") then item:Destroy() end
            end
            mount.Name = "RiddenDragon"
            local pose = CFrame.new(site.position + Vector3.yAxis * (32 + sites[1].position.Y - site.position.Y))
            root.Anchored = true
            character:PivotTo(pose)
            mount:PivotTo(pose * CFrame.new(0,-2,0))
            mount.Parent = world
            riders[player] = {character = character, root = root, dragon = mount, position = pose.Position,
                facing = pose.LookVector, direction = Vector3.zero, lastInput = 0}
            player:SetAttribute("Flying", true)
            player:SetAttribute("ManualFlight", true)
        end)
    end

    input.OnServerEvent:Connect(function(player, direction, land)
        local ride = riders[player]
        if not ride then return end
        if land == true then
            if ride.site then finish(player, ride.site) end
            return
        end
        if typeof(direction) ~= "Vector3" or not (direction.Magnitude <= 1.01) then return end
        local now = os.clock()
        if now - ride.lastInput < .035 then return end
        ride.direction, ride.lastInput = direction, now
    end)

    Players.PlayerRemoving:Connect(function(player) finish(player) end)
    RunService.Heartbeat:Connect(function(dt)
        for player, ride in riders do
            if player.Character ~= ride.character or not ride.root.Parent or ride.character.Humanoid.Health <= 0 then
                finish(player)
                continue
            end
            local direction = os.clock() - ride.lastInput < .4 and ride.direction or Vector3.zero
            local p = ride.position + direction * 38 * math.min(dt,.1)
            local home = sites[1].position
            local offset = p - home
            ride.position = home + Vector3.new(math.clamp(offset.X,-172,137),math.clamp(offset.Y,32,100),math.clamp(offset.Z,-255,96))
            local flat = Vector3.new(direction.X,0,direction.Z)
            if flat.Magnitude > .05 then ride.facing = flat.Unit end
            local pose = CFrame.lookAt(ride.position, ride.position + ride.facing)
            ride.character:PivotTo(pose)
            ride.dragon:PivotTo(pose * CFrame.new(0,-2,0))
            local nearby
            for _, site in sites do
                local delta = ride.position - site.position
                if Vector2.new(delta.X,delta.Z).Magnitude < 19 then nearby = site break end
            end
            if nearby ~= ride.site then
                ride.site = nearby
                player:SetAttribute("LandingSite", nearby and nearby.label)
            end
        end
    end)
end

return Flight
