local Players = game:GetService("Players")
local Actions = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local input = game:GetService("ReplicatedStorage"):WaitForChild("DragonFlightInput")
local up, down = false, false
local buttons = {
    {"IskraUp", "Выше", Enum.KeyCode.Space, Enum.KeyCode.ButtonR2},
    {"IskraDown", "Ниже", Enum.KeyCode.LeftControl, Enum.KeyCode.ButtonL2},
    {"IskraLand", "Сесть", Enum.KeyCode.F, Enum.KeyCode.ButtonY},
}
local function handle(name, state)
    local pressed = state == Enum.UserInputState.Begin
    if name == "IskraUp" then up = pressed
    elseif name == "IskraDown" then down = pressed
    elseif pressed then input:FireServer(Vector3.zero, true) end
    return Enum.ContextActionResult.Sink
end
local function refresh()
    up, down = false, false
    for index, item in buttons do
        Actions:UnbindAction(item[1])
        if player:GetAttribute("ManualFlight") then
            Actions:BindActionAtPriority(item[1],handle,true,3000,item[3],item[4])
            Actions:SetTitle(item[1],item[2])
            Actions:SetPosition(item[1],UDim2.new(1,-62-index*52,.55,0))
        end
    end
end
player:GetAttributeChangedSignal("ManualFlight"):Connect(refresh)
refresh()
local elapsed = 0
RunService.Heartbeat:Connect(function(dt)
    if not player:GetAttribute("ManualFlight") then return end
    elapsed += dt
    if elapsed < .08 then return end
    elapsed = 0
    local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    local move = humanoid.MoveDirection
    local v = Vector3.new(move.X,(up and 1 or 0)-(down and 1 or 0),move.Z)
    input:FireServer(v / math.max(1,v.Magnitude))
end)
