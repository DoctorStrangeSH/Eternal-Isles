local ReplicatedStorage = game:GetService("ReplicatedStorage")
local WorldConfig = require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("WorldConfig"))

local WorldBuilder = {}

local function createPart(parent, name, size, position, color, material, shape)
    local part = Instance.new("Part")
    part.Name = name
    part.Anchored = true
    part.Size = size
    part.Position = position
    part.Color = color
    part.Material = material
    if shape then
        part.Shape = shape
    end
    part.Parent = parent
    return part
end

function WorldBuilder.build()
    local existing = workspace:FindFirstChild("EternalIslesWorld")
    if existing then
        existing:Destroy()
    end

    local world = Instance.new("Folder")
    world.Name = "EternalIslesWorld"
    world.Parent = workspace

    local center = WorldConfig.IslandCenter
    local radius = WorldConfig.IslandRadius

    createPart(world, "FloatingRock", Vector3.new(radius * 2 - 8, WorldConfig.IslandThickness, radius * 2 - 8), center - Vector3.new(0, 10, 0), Color3.fromRGB(86, 81, 92), Enum.Material.Slate, Enum.PartType.Ball)
    createPart(world, "GrassPlateau", Vector3.new(radius * 2, 12, radius * 2), center, Color3.fromRGB(95, 165, 101), Enum.Material.Grass, Enum.PartType.Cylinder).Orientation = Vector3.new(0, 0, 90)

    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "StarterSpawn"
    spawn.Anchored = true
    spawn.Neutral = true
    spawn.Duration = 0
    spawn.Size = Vector3.new(10, 1, 10)
    spawn.Position = center + Vector3.new(0, WorldConfig.SpawnHeight, 0)
    spawn.Material = Enum.Material.SmoothPlastic
    spawn.Color = Color3.fromRGB(184, 222, 190)
    spawn.Parent = world

    -- A visual landmark only: portal travel is reserved for the next milestone.
    local portalBase = createPart(world, "PortalPedestal", Vector3.new(16, 2, 16), center + Vector3.new(0, 7, -42), Color3.fromRGB(67, 62, 93), Enum.Material.Slate)
    createPart(world, "PortalLeft", Vector3.new(3, 18, 3), portalBase.Position + Vector3.new(-6, 10, 0), Color3.fromRGB(87, 64, 145), Enum.Material.Neon)
    createPart(world, "PortalRight", Vector3.new(3, 18, 3), portalBase.Position + Vector3.new(6, 10, 0), Color3.fromRGB(87, 64, 145), Enum.Material.Neon)
    createPart(world, "PortalTop", Vector3.new(15, 3, 3), portalBase.Position + Vector3.new(0, 19, 0), Color3.fromRGB(87, 64, 145), Enum.Material.Neon)

    for index = 1, 12 do
        local angle = (index / 12) * math.pi * 2
        local distance = 50 + (index % 3) * 6
        local position = center + Vector3.new(math.cos(angle) * distance, 9, math.sin(angle) * distance)
        createPart(world, "TreeTrunk" .. index, Vector3.new(3, 11, 3), position, Color3.fromRGB(98, 68, 50), Enum.Material.Wood)
        createPart(world, "TreeCrown" .. index, Vector3.new(14, 15, 14), position + Vector3.new(0, 10, 0), Color3.fromRGB(38, 112 + (index % 3) * 12, 78), Enum.Material.Grass, Enum.PartType.Ball)
    end

    workspace.FallenPartsDestroyHeight = -250
    return world
end

return WorldBuilder
