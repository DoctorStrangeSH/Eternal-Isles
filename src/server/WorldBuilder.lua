local CollectionService = game:GetService("CollectionService")
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
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    if shape then
        part.Shape = shape
    end
    part.Parent = parent
    return part
end

local function createCrystal(parent, index, position)
    local crystal = createPart(
        parent,
        "ManaCrystal_" .. index,
        Vector3.new(3, 6, 3),
        position,
        Color3.fromRGB(93, 224, 235),
        Enum.Material.Neon,
        Enum.PartType.Block
    )
    crystal.CFrame = CFrame.new(position) * CFrame.Angles(0, math.rad(45), math.rad(45))
    crystal.CanCollide = false
    crystal:SetAttribute("ManaReward", 5)
    CollectionService:AddTag(crystal, "ManaCrystal")

    local light = Instance.new("PointLight")
    light.Color = crystal.Color
    light.Brightness = 1.4
    light.Range = 13
    light.Parent = crystal

    return crystal
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

    -- Broad, flat grass crown sits above a tapered-looking rocky underside.
    createPart(world, "FloatingRock", Vector3.new(radius * 1.78, WorldConfig.IslandThickness, radius * 1.78),
        center - Vector3.new(0, 10, 0), Color3.fromRGB(75, 73, 91), Enum.Material.Slate, Enum.PartType.Ball)
    createPart(world, "GrassPlateau", Vector3.new(radius * 2, 12, radius * 2),
        center, Color3.fromRGB(103, 166, 105), Enum.Material.Grass, Enum.PartType.Cylinder)

    -- A broken stone ring gives the spawn a readable focal point.
    for index = 1, 8 do
        local angle = (index / 8) * math.pi * 2
        local offset = Vector3.new(math.cos(angle) * 12, 6.5, math.sin(angle) * 12)
        local stone = createPart(world, "SpawnRune_" .. index, Vector3.new(5, 1.2, 2.4),
            center + offset, Color3.fromRGB(128, 125, 145), Enum.Material.Slate)
        stone.CFrame = CFrame.new(stone.Position) * CFrame.Angles(0, -angle, 0)
    end

    local spawn = Instance.new("SpawnLocation")
    spawn.Name = "StarterSpawn"
    spawn.Anchored = true
    spawn.Neutral = true
    spawn.Duration = 0
    spawn.Size = Vector3.new(10, 1, 10)
    spawn.Position = center + Vector3.new(0, WorldConfig.SpawnHeight, 0)
    spawn.Material = Enum.Material.SmoothPlastic
    spawn.Color = Color3.fromRGB(191, 224, 191)
    spawn.Parent = world

    -- Portal is currently a landmark; functional travel comes in the next milestone.
    local portalBase = createPart(world, "PortalPedestal", Vector3.new(16, 2, 16),
        center + Vector3.new(0, 7, -42), Color3.fromRGB(57, 54, 79), Enum.Material.Slate)
    createPart(world, "PortalLeft", Vector3.new(3, 18, 3), portalBase.Position + Vector3.new(-6, 10, 0),
        Color3.fromRGB(91, 74, 170), Enum.Material.Neon)
    createPart(world, "PortalRight", Vector3.new(3, 18, 3), portalBase.Position + Vector3.new(6, 10, 0),
        Color3.fromRGB(91, 74, 170), Enum.Material.Neon)
    createPart(world, "PortalTop", Vector3.new(15, 3, 3), portalBase.Position + Vector3.new(0, 19, 0),
        Color3.fromRGB(91, 74, 170), Enum.Material.Neon)
    local portalLight = Instance.new("PointLight")
    portalLight.Color = Color3.fromRGB(151, 119, 255)
    portalLight.Brightness = 2
    portalLight.Range = 24
    portalLight.Parent = portalBase

    -- A small grove frames the clearing without crowding the playable space.
    for index = 1, 12 do
        local angle = (index / 12) * math.pi * 2
        local distance = 53 + (index % 3) * 5
        local position = center + Vector3.new(math.cos(angle) * distance, 9, math.sin(angle) * distance)
        createPart(world, "TreeTrunk_" .. index, Vector3.new(3, 11, 3), position,
            Color3.fromRGB(91, 63, 48), Enum.Material.Wood)
        local crown = createPart(world, "TreeCrown_" .. index, Vector3.new(15, 16, 15),
            position + Vector3.new(0, 10, 0), Color3.fromRGB(42, 113 + (index % 3) * 10, 76),
            Enum.Material.Grass, Enum.PartType.Ball)
        crown.CanCollide = false
    end

    -- Three visible resources teach the first interaction immediately.
    createCrystal(world, 1, center + Vector3.new(-28, 11, 18))
    createCrystal(world, 2, center + Vector3.new(31, 11, 14))
    createCrystal(world, 3, center + Vector3.new(18, 11, -25))

    workspace.FallenPartsDestroyHeight = -250
    return world
end

return WorldBuilder
