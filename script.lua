local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().ScriptConfig = {
    ESP = false,
    ESPLine = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    Aimbot = false,
    AimKill = false,
    WallHack = false,
    FOVSize = 45
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikHub_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.NumSides = 64
FOVCircle.Radius = ScriptConfig.FOVSize
FOVCircle.Filled = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 255)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -127)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SONIK HUB"
Title.TextSize = 15
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "SonikHub_ToggleOnly"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = game.CoreGui

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 60, 0, 35)
MinimizeButton.Position = UDim2.new(0.5, 100, 0.5, -127)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizeButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "HIDE"
MinimizeButton.TextSize = 11
MinimizeButton.Font = Enum.Font.Code
MinimizeButton.Parent = ToggleGui

local isHidden = false
MinimizeButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    MainFrame.Visible = not isHidden
    MinimizeButton.Text = isHidden and "SHOW" or "HIDE"
end)

MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    MinimizeButton.Position = UDim2.new(MainFrame.Position.Scale.X, MainFrame.Position.Offset.X + 260, MainFrame.Position.Scale.Y, MainFrame.Position.Offset.Y)
end)

local Tabs = {
    AIM = Instance.new("Folder"),
    ESP = Instance.new("Folder"),
    MISC = Instance.new("Folder")
}

for _, tab in pairs(Tabs) do
    tab.Parent = MainFrame
end

local function ShowTab(tabName)
    for name, folder in pairs(Tabs) do
        for _, child in ipairs(folder:GetChildren()) do
            child.Visible = (name == tabName)
        end
    end
end

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 160, 0, 25)
TabContainer.Position = UDim2.new(1, -165, 0, 5)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabNames = {"AIM", "ESP", "MISC"}
for i, tName in ipairs(tabNames) do
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 50, 0, 25)
    tBtn.Position = UDim2.new(0, (i - 1) * 53, 0, 0)
    tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.Text = tName
    tBtn.TextSize = 10
    tBtn.Font = Enum.Font.Code
    tBtn.Parent = TabContainer
    
    tBtn.MouseButton1Click:Connect(function()
        ShowTab(tName)
    end)
end

local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0.9, 0, 0, 32)
aimButton.Position = UDim2.new(0.05, 0, 0, 42)
aimButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimButton.Text = "AIM SILENT: [OFF]"
aimButton.TextSize, aimButton.Font = 12, Enum.Font.Code
aimButton.Parent = Tabs.AIM

aimButton.MouseButton1Click:Connect(function()
    ScriptConfig.Aimbot = not ScriptConfig.Aimbot
    aimButton.Text = "AIM SILENT: " .. (ScriptConfig.Aimbot and "[ON]" or "[OFF]")
    FOVCircle.Visible = ScriptConfig.Aimbot
end)

local FovContainer = Instance.new("Frame")
FovContainer.Size = UDim2.new(0.9, 0, 0, 45)
FovContainer.Position = UDim2.new(0.05, 0, 0, 80)
FovContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FovContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
FovContainer.Parent = Tabs.AIM

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(1, 0, 0, 20)
FovLabel.Position = UDim2.new(0, 0, 0, 2)
FovLabel.BackgroundTransparency = 1
FovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovLabel.Text = "FOV Size: 45"
FovLabel.TextSize, FovLabel.Font = 11, Enum.Font.Code
FovLabel.Parent = FovContainer

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0.8, 0, 0, 4)
SliderBar.Position = UDim2.new(0.1, 0, 0, 28)
SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = FovContainer

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new(0, -7, 0.5, -7)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local draggingSlider = false
SliderButton.MouseButton1Down:Connect(function()
    draggingSlider = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local sliderPos = SliderBar.AbsolutePosition.X
        local sliderSize = SliderBar.AbsoluteSize.X
        local mouseX = input.Position.X
        local relativeX = math.clamp((mouseX - sliderPos) / sliderSize, 0, 1)
        SliderButton.Position = UDim2.new(relativeX, -7, 0.5, -7)
        local calculatedFOV = math.floor(45 + (relativeX * (360 - 45)))
        ScriptConfig.FOVSize = calculatedFOV
        FovLabel.Text = "FOV Size: " .. calculatedFOV
    end
end)

local aimKillButton = Instance.new("TextButton")
aimKillButton.Size = UDim2.new(0.9, 0, 0, 32)
aimKillButton.Position = UDim2.new(0.05, 0, 0, 131)
aimKillButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimKillButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimKillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimKillButton.Text = "AIM KILL: [OFF]"
aimKillButton.TextSize, aimKillButton.Font = 12, Enum.Font.Code
aimKillButton.Parent = Tabs.AIM

aimKillButton.MouseButton1Click:Connect(function()
    ScriptConfig.AimKill = not ScriptConfig.AimKill
    aimKillButton.Text = "AIM KILL: " .. (ScriptConfig.AimKill and "[ON]" or "[OFF]")
end)

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.9, 0, 0, 32)
espButton.Position = UDim2.new(0.05, 0, 0, 42)
espButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
espButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Text = "ESP Players: [OFF]"
espButton.TextSize, espButton.Font = 12, Enum.Font.Code
espButton.Parent = Tabs.ESP

espButton.MouseButton1Click:Connect(function()
    ScriptConfig.ESP = not ScriptConfig.ESP
    espButton.Text = "ESP Players: " .. (ScriptConfig.ESP and "[ON]" or "[OFF]")
    if not ScriptConfig.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("SonikESP") then
                player.Character.SonikESP:Destroy()
            end
        end
    end
end)

local lineButton = Instance.new("TextButton")
lineButton.Size = UDim2.new(0.9, 0, 0, 32)
lineButton.Position = UDim2.new(0.05, 0, 0, 80)
lineButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
lineButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
lineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lineButton.Text = "LINE: [OFF]"
lineButton.TextSize, lineButton.Font = 12, Enum.Font.Code
lineButton.Parent = Tabs.ESP

lineButton.MouseButton1Click:Connect(function()
    ScriptConfig.ESPLine = not ScriptConfig.ESPLine
    lineButton.Text = "LINE: " .. (ScriptConfig.ESPLine and "[ON]" or "[OFF]")
end)

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(0.9, 0, 0, 32)
ColorContainer.Position = UDim2.new(0.05, 0, 0, 118)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = Tabs.ESP

local colors = {
    {Color3.fromRGB(255, 50, 50)},
    {Color3.fromRGB(50, 100, 255)},
    {Color3.fromRGB(50, 255, 50)},
    {Color3.fromRGB(255, 255, 255)}
}

for i, clrData in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(0, (i - 1) * 42, 0, 0)
    btn.BackgroundColor3 = clrData[1]
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.Parent = ColorContainer
    
    btn.MouseButton1Click:Connect(function()
        ScriptConfig.ESPColor = clrData[1]
    end)
end

local whButton = Instance.new("TextButton")
whButton.Size = UDim2.new(0.9, 0, 0, 32)
whButton.Position = UDim2.new(0.05, 0, 0, 42)
whButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
whButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
whButton.TextColor3 = Color3.fromRGB(255, 255, 255)
whButton.Text = "WallHack: [OFF]"
whButton.TextSize, whButton.Font = 12, Enum.Font.Code
whButton.Parent = Tabs.MISC

whButton.MouseButton1Click:Connect(function()
    ScriptConfig.WallHack = not ScriptConfig.WallHack
    whButton.Text = "WallHack: " .. (ScriptConfig.WallHack and "[ON]" or "[OFF]")
end)

ShowTab("AIM")

local activeLines = {}

RunService.RenderStepped:Connect(function()
    if ScriptConfig.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("SonikESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SonikESP"
                    highlight.Adornee = player.Character
                    highlight.OutlineTransparency = 1
                    highlight.Parent = player.Character
                end
                highlight.FillColor = ScriptConfig.ESPColor
                highlight.FillTransparency = 0.2
            end
        end
    end
    
    if ScriptConfig.ESPLine then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    local line = activeLines[player]
                    if not line then
                        line = Drawing.new("Line")
                        line.Thickness = 1.5
                        activeLines[player] = line
                    end
                    if onScreen then
                        line.Visible = true
                        line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        line.To = Vector2.new(screenPos.X, screenPos.Y)
                        line.Color = ScriptConfig.ESPColor
                    else
                        line.Visible = false
                    end
                end
            end
        end
    else
        for _, line in pairs(activeLines) do
            line.Visible = false
        end
    end

    if ScriptConfig.Aimbot then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = ScriptConfig.FOVSize
    end
end)

RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if character and ScriptConfig.WallHack then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

local function GetClosestVisibleTarget()
    local closestTarget = nil
    local shortestDist = ScriptConfig.FOVSize
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
                if targetPart then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                        if dist < shortestDist then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = Workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), rayParams)
                            
                            if not rayResult then
                                shortestDist = dist
                                closestTarget = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function()
    if ScriptConfig.AimKill then
        local target = GetClosestVisibleTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)

local mt = getrawmetatable(game)
local oldIndex = mt.__index
setreadonly(mt, false)

mt.__index = newcclosure(function(self, k)
    if ScriptConfig.Aimbot and not checkcaller() then
        if k == "Hit" then
            local target = GetClosestVisibleTarget()
            if target then
                return target.CFrame
            end
        end
    end
    return oldIndex(self, k)
end)
setreadonly(mt, true)
