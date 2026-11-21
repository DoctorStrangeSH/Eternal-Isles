local Journal = {}

local gold = Color3.fromRGB(246, 211, 142)
local ink = Color3.fromRGB(24, 35, 43)
local paper = Color3.fromRGB(224, 233, 221)

local entries = {
    {stage = 1, name = "Золотая чешуя", hint = "За фиолетовой аркой, у края гнездовья, в траве мерцает золото.", lore = "Даже в холодном тумане чешуя Искры хранит тепло рассвета."},
    {stage = 3, name = "Янтарь ветров", hint = "Искра знает путь к острову, где ветер застыл в камне.", lore = "Внутри янтаря дрожит золотая нить. По ней Искра находит дорогу домой."},
    {stage = 4, name = "Линза звездочёта", hint = "Слева от арки, если смотреть из рощи, ищи в небе медное кольцо.", lore = "В старой линзе сохранилось отражение звезды, по которой всадники находили путь сквозь туман."},
}

local function round(target)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = target
end

local function button(parent, name, caption)
    local b = Instance.new("TextButton")
    b.Name, b.Text = name, caption
    b.Font, b.TextSize = Enum.Font.GothamBold, 15
    b.BackgroundColor3, b.TextColor3 = ink, gold
    round(b)
    b.Parent = parent
    return b
end

function Journal.mount(gui, panel, player)
    local toggle = button(panel, "OpenJournal", "Журнал реликвий")
    toggle.Size = UDim2.new(1, 0, 0, 44)
    toggle.Position = UDim2.new(0, 0, 1, 4)

    local page = Instance.new("Frame")
    page.Name = "RelicJournal"
    page.AnchorPoint = Vector2.new(.5, .5)
    page.Position = UDim2.fromScale(.5, .5)
    page.Size = UDim2.new(1, -28, 1, -22)
    page.BackgroundColor3 = ink
    page.Visible = false
    round(page)
    local limit = Instance.new("UISizeConstraint")
    limit.MaxSize = Vector2.new(388, 358)
    limit.Parent = page
    page.Parent = gui

    local close = button(page, "CloseJournal", "Закрыть")
    close.Size = UDim2.fromOffset(88, 44)
    close.Position = UDim2.new(1, -96, 0, 4)

    local function label(parent, name, size, color)
        local text = Instance.new("TextLabel")
        text.Name = name
        text.BackgroundTransparency = 1
        text.Font, text.TextSize, text.TextColor3 = Enum.Font.Gotham, size, color
        text.TextXAlignment = Enum.TextXAlignment.Left
        text.TextWrapped = true
        text.Parent = parent
        return text
    end
    local heading = label(page, "Heading", 19, gold)
    heading.Font = Enum.Font.GothamBold
    heading.Position = UDim2.fromOffset(14, 4)
    heading.Size = UDim2.new(1, -116, 0, 44)
    local scroll = Instance.new("ScrollingFrame")
    scroll.Name = "Entries"
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.Position = UDim2.fromOffset(14, 52)
    scroll.Size = UDim2.new(1, -28, 1, -64)
    scroll.CanvasSize = UDim2.new()
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ScrollBarThickness = 4
    scroll.Parent = page
    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 9)
    layout.Parent = scroll

    local function line(name, order, size, color)
        local t = label(scroll, name, size, color)
        t.LayoutOrder = order
        t.Size = UDim2.new(1, -8, 0, 0)
        t.AutomaticSize = Enum.AutomaticSize.Y
        return t
    end
    local rows = {}
    for i, entry in entries do
        local title = line("Relic"..i, i*2, 17, gold)
        title.Font = Enum.Font.GothamBold
        rows[i] = {title = title, body = line("Note"..i, i*2+1, 15, paper)}
    end
    local bond = line("Bond", 10, 15, Color3.fromRGB(154, 226, 203))
    local function refresh()
        local stage = player:GetAttribute("TrailStage") or 0
        local count = 0
        for i, entry in entries do
            local found = stage >= entry.stage
            if found then count += 1 end
            rows[i].title.Text = found and entry.name or "Неизвестная реликвия"
            rows[i].body.Text = found and entry.lore or entry.hint
        end
        heading.Text = string.format("Реликвии · %d/%d", count, #entries)
        if stage >= 3 then
            bond.Text = "Связь II · Свободный полёт с нефритовых насестов."
        elseif stage == 2 then
            bond.Text = "Связь I · Позови Искру в гнездовье, чтобы лететь на Остров Ветров."
        elseif stage == 1 then
            bond.Text = "Покажи чешую Искре у камня возвращения."
        else
            bond.Text = "Первая экспедиция · Три кристалла пробудят портал."
        end
    end
    toggle.Activated:Connect(function()
        panel.Visible = false
        scroll.CanvasPosition = Vector2.zero
        page.Visible = true
    end)
    close.Activated:Connect(function()
        page.Visible = false
        panel.Visible = true
    end)
    player:GetAttributeChangedSignal("TrailStage"):Connect(refresh)
    refresh()
end

return Journal
