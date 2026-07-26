local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().ScriptConfig = {
    Aimbot = false,
    AimSilent = false,
    AimKill = false,
    ESP = false,
    ESPLine = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    FPSColor = Color3.fromRGB(255, 255, 255),
    WallHack = false,
    FPS = false,
    SpeedHack = false,
    FOVSize = 45
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Sonik_Hub"
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
MainFrame.Size = UDim2.new(0, 320, 0, 330)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -65, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SONIK HACK"
Title.TextSize = 14
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "Sonik_Hub_ToggleOnly"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = game.CoreGui

local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Size = UDim2.new(0, 45, 0, 45)
MinimizeButton.Position = UDim2.new(0.5, 100, 0.5, -165)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizeButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Image = "rbxassetid://78816472968902"
MinimizeButton.Parent = ToggleGui

local isHidden = true
local isAnimating = false

local function AnimateMenu(open)
    if isAnimating then return end
    isAnimating = true
    
    if open then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tw = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 320, 0, 330),
            Position = UDim2.new(0.5, -160, 0.5, -165)
        })
        tw:Play()
        tw.Completed:Wait()
    else
        local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        local tw = TweenService:Create(MainFrame, tweenInfo, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        tw:Play()
        tw.Completed:Wait()
        MainFrame.Visible = false
    end
    isAnimating = false
end

MinimizeButton.MouseButton1Click:Connect(function()
    if isAnimating then return end
    isHidden = not isHidden
    if isHidden then
        AnimateMenu(false)
    else
        AnimateMenu(true)
    end
end)

MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    MinimizeButton.Position = UDim2.new(MainFrame.Position.Scale.X, MainFrame.Position.Offset.X + 275, MainFrame.Position.Scale.Y, MainFrame.Position.Offset.Y)
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
TabContainer.Size = UDim2.new(0, 25, 0, 160)
TabContainer.Position = UDim2.new(0, 5, 0, 42)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabNames = {"AIM", "ESP", "MISC"}
for i, tName in ipairs(tabNames) do
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 25, 0, 50)
    tBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 53)
    tBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    tBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.Text = tName
    tBtn.TextSize = 9
    tBtn.Font = Enum.Font.Code
    tBtn.Parent = TabContainer
    
    tBtn.MouseButton1Click:Connect(function()
        ShowTab(tName)
    end)
end

local function UpdateButtonState(btn, state, text)
    btn.Text = text .. " " .. (state and "[ON]" or "[OFF]")
    btn.BorderColor3 = state and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 255, 255)
end

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0.78, 0, 0, 32)
aimbotButton.Position = UDim2.new(0.2, 0, 0, 42)
aimbotButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimbotButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.Text = "AIMBOT: [OFF]"
aimbotButton.TextSize, aimbotButton.Font = 11, Enum.Font.Code
aimbotButton.Parent = Tabs.AIM

aimbotButton.MouseButton1Click:Connect(function()
    ScriptConfig.Aimbot = not ScriptConfig.Aimbot
    UpdateButtonState(aimbotButton, ScriptConfig.Aimbot, "AIMBOT:")
    FOVCircle.Visible = ScriptConfig.Aimbot
end)

local aimSilentButton = Instance.new("TextButton")
aimSilentButton.Size = UDim2.new(0.78, 0, 0, 32)
aimSilentButton.Position = UDim2.new(0.2, 0, 0, 80)
aimSilentButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimSilentButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimSilentButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimSilentButton.Text = "AIM SILENT: [OFF]"
aimSilentButton.TextSize, aimSilentButton.Font = 11, Enum.Font.Code
aimSilentButton.Parent = Tabs.AIM

aimSilentButton.MouseButton1Click:Connect(function()
    ScriptConfig.AimSilent = not ScriptConfig.AimSilent
    UpdateButtonState(aimSilentButton, ScriptConfig.AimSilent, "AIM SILENT:")
end)

local aimKillButton = Instance.new("TextButton")
aimKillButton.Size = UDim2.new(0.78, 0, 0, 32)
aimKillButton.Position = UDim2.new(0.2, 0, 0, 118)
aimKillButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimKillButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimKillButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimKillButton.Text = "AIM KILL: [OFF]"
aimKillButton.TextSize, aimKillButton.Font = 11, Enum.Font.Code
aimKillButton.Parent = Tabs.AIM

aimKillButton.MouseButton1Click:Connect(function()
    ScriptConfig.AimKill = not ScriptConfig.AimKill
    UpdateButtonState(aimKillButton, ScriptConfig.AimKill, "AIM KILL:")
end)

local FovContainer = Instance.new("Frame")
FovContainer.Size = UDim2.new(0.78, 0, 0, 45)
FovContainer.Position = UDim2.new(0.2, 0, 0, 156)
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

local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.78, 0, 0, 32)
espButton.Position = UDim2.new(0.2, 0, 0, 42)
espButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
espButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Text = "ESP Players: [OFF]"
espButton.TextSize, espButton.Font = 11, Enum.Font.Code
espButton.Parent = Tabs.ESP

espButton.MouseButton1Click:Connect(function()
    ScriptConfig.ESP = not ScriptConfig.ESP
    UpdateButtonState(espButton, ScriptConfig.ESP, "ESP Players:")
    if not ScriptConfig.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("SonikESP") then
                player.Character.SonikESP:Destroy()
            end
        end
    end
end)

local lineButton = Instance.new("TextButton")
lineButton.Size = UDim2.new(0.78, 0, 0, 32)
lineButton.Position = UDim2.new(0.2, 0, 0, 80)
lineButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
lineButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
lineButton.TextColor3 = Color3.fromRGB(255, 255, 255)
lineButton.Text = "LINE: [OFF]"
lineButton.TextSize, lineButton.Font = 11, Enum.Font.Code
lineButton.Parent = Tabs.ESP

lineButton.MouseButton1Click:Connect(function()
    ScriptConfig.ESPLine = not ScriptConfig.ESPLine
    UpdateButtonState(lineButton, ScriptConfig.ESPLine, "LINE:")
end)

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(0.78, 0, 0, 32)
ColorContainer.Position = UDim2.new(0.2, 0, 0, 118)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = Tabs.ESP

local colors = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(50, 100, 255),
    Color3.fromRGB(50, 255, 50),
    Color3.fromRGB(255, 255, 255)
}

for i, clr in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(0, (i - 1) * 42, 0, 0)
    btn.BackgroundColor3 = clr
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.Parent = ColorContainer
    
    btn.MouseButton1Click:Connect(function()
        ScriptConfig.ESPColor = clr
    end)
end

local originalWalkSpeed = 16
local speedCaptured = false

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0.78, 0, 0, 32)
speedButton.Position = UDim2.new(0.2, 0, 0, 42)
speedButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
speedButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.Text = "SpeedHack (x2): [OFF]"
speedButton.TextSize, speedButton.Font = 11, Enum.Font.Code
speedButton.Parent = Tabs.MISC

speedButton.MouseButton1Click:Connect(function()
    ScriptConfig.SpeedHack = not ScriptConfig.SpeedHack
    UpdateButtonState(speedButton, ScriptConfig.SpeedHack, "SpeedHack (x2):")
    
    local char = LocalPlayer.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if ScriptConfig.SpeedHack then
                if not speedCaptured then
                    originalWalkSpeed = humanoid.WalkSpeed
                    speedCaptured = true
                end
                humanoid.WalkSpeed = originalWalkSpeed * 2
            else
                if speedCaptured then
                    humanoid.WalkSpeed = originalWalkSpeed
                end
            end
        end
    end
end)

local fpsButton = Instance.new("TextButton")
fpsButton.Size = UDim2.new(0.78, 0, 0, 32)
fpsButton.Position = UDim2.new(0.2, 0, 0, 80)
fpsButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
fpsButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
fpsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsButton.Text = "FPS Counter: [OFF]"
fpsButton.TextSize, fpsButton.Font = 11, Enum.Font.Code
fpsButton.Parent = Tabs.MISC

local FpsDisplay = Instance.new("TextLabel")
FpsDisplay.Size = UDim2.new(0, 120, 0, 25)
FpsDisplay.Position = UDim2.new(0.5, -60, 1, -35)
FpsDisplay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FpsDisplay.BorderColor3 = Color3.fromRGB(255, 255, 255)
FpsDisplay.BorderSizePixel = 1
FpsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsDisplay.Text = "FPS: 90"
FpsDisplay.TextSize, FpsDisplay.Font = 12, Enum.Font.Code
FpsDisplay.Visible = false
FpsDisplay.Parent = ScreenGui

fpsButton.MouseButton1Click:Connect(function()
    ScriptConfig.FPS = not ScriptConfig.FPS
    UpdateButtonState(fpsButton, ScriptConfig.FPS, "FPS Counter:")
    FpsDisplay.Visible = ScriptConfig.FPS
end)

local FpsColorContainer = Instance.new("Frame")
FpsColorContainer.Size = UDim2.new(0.78, 0, 0, 32)
FpsColorContainer.Position = UDim2.new(0.2, 0, 0, 118)
FpsColorContainer.BackgroundTransparency = 1
FpsColorContainer.Parent = Tabs.MISC

for i, clr in ipairs(colors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = UDim2.new(0, (i - 1) * 42, 0, 0)
    btn.BackgroundColor3 = clr
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.Parent = FpsColorContainer
    
    btn.MouseButton1Click:Connect(function()
        ScriptConfig.FPSColor = clr
        FpsDisplay.TextColor3 = clr
    end)
end

LocalPlayer.CharacterAdded:Connect(function(char)
    speedCaptured = false
    task.wait(0.5)
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        originalWalkSpeed = humanoid.WalkSpeed
        speedCaptured = true
        if ScriptConfig.SpeedHack then
            humanoid.WalkSpeed = originalWalkSpeed * 2
        end
    end
end)

ShowTab("AIM")

local activeLines = {}
local lastFpsUpdate = 0
local frameCount = 0

RunService.RenderStepped:Connect(function(dt)
    if ScriptConfig.FPS then
        frameCount = frameCount + 1
        local currentTick = tick()
        if currentTick - lastFpsUpdate >= 1 then
            FpsDisplay.Text = "FPS: " .. math.floor(frameCount / (currentTick - lastFpsUpdate))
            frameCount = 0
            lastFpsUpdate = currentTick
        end
    end

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

    if ScriptConfig.Aimbot or ScriptConfig.AimKill then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = ScriptConfig.FOVSize
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
    if ScriptConfig.Aimbot or ScriptConfig.AimKill then
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
    if ScriptConfig.AimSilent and not checkcaller() then
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
