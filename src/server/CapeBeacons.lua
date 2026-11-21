local CapeBeacons = {}

local SIGNAL_SECONDS = 20
local dark = Color3.fromRGB(82, 109, 115)
local green = Color3.fromRGB(119, 255, 210)
local gold = Color3.fromRGB(255, 208, 125)

local function makeBeacon(world, name, base)
    local pillar = Instance.new("Part")
    pillar.Name = name
    pillar.Size = Vector3.new(3, 4, 3)
    pillar.Color = Color3.fromRGB(78, 75, 95)
    pillar.Material = Enum.Material.Slate
    pillar.Anchored = true
    pillar.Position = base + Vector3.yAxis * 2
    pillar.Parent = world

    local gem = Instance.new("Part")
    gem.Name = "SignalCrystal"
    gem.Size = Vector3.new(1.8, 2.4, 1.8)
    gem.Anchored = true
    gem.CanCollide = false
    gem.CFrame = CFrame.new(base + Vector3.yAxis * 5) * CFrame.Angles(0, 0, math.rad(35))
    gem.Parent = pillar
    local socket = Instance.new("Attachment")
    socket.Parent = gem

    local sign = Instance.new("BillboardGui")
    sign.Size = UDim2.fromOffset(230, 48)
    sign.StudsOffsetWorldSpace = Vector3.yAxis * 5
    sign.MaxDistance = 55
    sign.Parent = gem
    local caption = Instance.new("TextLabel")
    caption.Size = UDim2.fromScale(1, 1)
    caption.BackgroundTransparency = 1
    caption.Font = Enum.Font.GothamBold
    caption.TextSize = 15
    caption.TextWrapped = true
    caption.TextColor3 = Color3.fromRGB(255, 246, 216)
    caption.TextStrokeTransparency = .25
    caption.Parent = sign
    return {part = pillar, gem = gem, socket = socket, caption = caption}
end

local function beam(from, to, color)
    local line = Instance.new("Beam")
    line.Name = "BeaconSignal"
    line.Attachment0, line.Attachment1 = from, to
    line.FaceCamera = true
    line.Width0, line.Width1 = .65, .35
    line.Color = ColorSequence.new(color)
    line.LightEmission = 1
    line.Enabled = false
    line.Parent = from
    return line
end

function CapeBeacons.start(world, interact)
    local center = world.GrassPlateau.Position
    local stones = {
        makeBeacon(world, "TrailBeacon", center + Vector3.new(-66, 6, 18)),
        makeBeacon(world, "CapeBeacon", center + Vector3.new(-120, 5.5, -15)),
    }
    local target = Instance.new("Attachment")
    target.Parent = world.StarLens
    local link = beam(stones[1].socket, stones[2].socket, green)
    local signal = beam(stones[2].socket, target, gold)
    local armed, shining

    local function display()
        for i, stone in stones do
            local lit = shining or armed == i
            stone.gem.Color = shining and gold or (lit and green or dark)
            stone.gem.Material = lit and Enum.Material.Neon or Enum.Material.Glass
            if shining then
                stone.caption.Text = "Луч ведёт к Обсерватории"
            elseif armed then
                stone.caption.Text = i == armed and "Иди по лучу ко второму маяку" or "Зажги этот маяк"
            else
                stone.caption.Text = "Огни мыса · Зажгите оба маяка"
            end
        end
        link.Enabled = armed ~= nil or shining == true
        signal.Enabled = shining == true
    end
    local function activate(index)
        if shining or armed == index then return end
        if armed then
            armed, shining = nil, true
            display()
            task.delay(SIGNAL_SECONDS, function()
                shining = false
                display()
            end)
        else
            armed = index
            display()
        end
    end
    for i, stone in stones do
        interact(stone.part, "Сигнальный камень", "Зажечь", function() activate(i) end)
    end
    display()
end

return CapeBeacons
