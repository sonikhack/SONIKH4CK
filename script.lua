local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

getgenv().ScriptConfig = {
    Aimbot = false,
    Chams = false,
    ChamsOutline = true,
    BoxESP = false,
    ESPLine = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    FPS = false,
    FPSUnlocker = false,
    AntiAFK = false,
    WaterKey = false,
    FOVSize = 45
}

local SafeZonePosition = Vector3.new(436.69, 156.07, -154.02)

LocalPlayer.Idled:Connect(function()
    if ScriptConfig.AntiAFK then
        local vu = game:GetService("VirtualUser")
        vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
    end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikGui"
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
MainFrame.Size = UDim2.new(0, 280, 0, 185)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -92)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SONIK HACK"
Title.TextSize, Title.Font = 12, Enum.Font.Code
Title.Parent = MainFrame

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "SonikToggle"
ToggleGui.ResetOnSpawn = false
ToggleGui.Parent = game.CoreGui

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 42, 0, 42)
MinimizeButton.Position = UDim2.new(0.5, 110, 0.5, -92)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizeButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BorderSizePixel = 1
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "♧"
MinimizeButton.TextSize = 24
MinimizeButton.Font = Enum.Font.Code
MinimizeButton.Active = true
MinimizeButton.Draggable = true
MinimizeButton.Parent = ToggleGui

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(1, 0)
MinimizeCorner.Parent = MinimizeButton

local WaterKeyButton = Instance.new("TextButton")
WaterKeyButton.Size = UDim2.new(0, 42, 0, 42)
WaterKeyButton.Position = UDim2.new(0.5, -152, 0.5, -92)
WaterKeyButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
WaterKeyButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
WaterKeyButton.BorderSizePixel = 1
WaterKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
WaterKeyButton.Text = "KEY"
WaterKeyButton.TextSize = 12
WaterKeyButton.Font = Enum.Font.Code
WaterKeyButton.Active = true
WaterKeyButton.Draggable = true
WaterKeyButton.Visible = false
WaterKeyButton.Parent = ToggleGui

local WaterKeyCorner = Instance.new("UICorner")
WaterKeyCorner.CornerRadius = UDim.new(1, 0)
WaterKeyCorner.Parent = WaterKeyButton

local function UpdateWaterKeyVisual()
    if ScriptConfig.WaterKey then
        WaterKeyButton.BorderColor3 = Color3.fromRGB(50, 255, 50)
        WaterKeyButton.TextColor3 = Color3.fromRGB(50, 255, 50)
    else
        WaterKeyButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
        WaterKeyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

local isHidden = true
local isAnimating = false

local function AnimateMenu(open)
    if isAnimating then return end
    isAnimating = true
    if open then
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        local tw = TweenService:Create(MainFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 280, 0, 185),
            Position = UDim2.new(0.5, -140, 0.5, -92)
        })
        tw:Play()
        tw.Completed:Wait()
    else
        local tw = TweenService:Create(MainFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
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
    AnimateMenu(not isHidden)
end)

local Tabs = {
    AIM = Instance.new("Folder"),
    ESP = Instance.new("Folder"),
    MISC = Instance.new("Folder"),
    DEV = Instance.new("Folder")
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
TabContainer.Size = UDim2.new(0, 30, 0, 145)
TabContainer.Position = UDim2.new(0, 6, 0, 32)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local tabNames = {"AIM", "ESP", "MISC", "DEV"}
for i, tName in ipairs(tabNames) do
    local tBtn = Instance.new("TextButton")
    tBtn.Size = UDim2.new(0, 30, 0, 33)
    tBtn.Position = UDim2.new(0, 0, 0, (i - 1) * 37)
    tBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    tBtn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tBtn.Text = tName
    tBtn.TextSize = 8
    tBtn.Font = Enum.Font.Code
    tBtn.Parent = TabContainer
    
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 6)
    tCorner.Parent = tBtn
    
    tBtn.MouseButton1Click:Connect(function()
        ShowTab(tName)
    end)
end

local function UpdateButtonState(btn, state, text)
    btn.Text = text .. " " .. (state and "[ON]" or "[OFF]")
    btn.BorderColor3 = state and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 255, 255)
end

local aimbotButton = Instance.new("TextButton")
aimbotButton.Size = UDim2.new(0.8, 0, 0, 32)
aimbotButton.Position = UDim2.new(0.18, 0, 0, 32)
aimbotButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimbotButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimbotButton.Text = "AIMBOT: [OFF]"
aimbotButton.TextSize, aimbotButton.Font = 11, Enum.Font.Code
aimbotButton.Parent = Tabs.AIM

local aimCorner = Instance.new("UICorner")
aimCorner.CornerRadius = UDim.new(0, 6)
aimCorner.Parent = aimbotButton

local function ToggleAimbot()
    ScriptConfig.Aimbot = not ScriptConfig.Aimbot
    UpdateButtonState(aimbotButton, ScriptConfig.Aimbot, "AIMBOT:")
    FOVCircle.Visible = ScriptConfig.Aimbot
    UpdateWaterKeyVisual()
end

aimbotButton.MouseButton1Click:Connect(ToggleAimbot)

WaterKeyButton.MouseButton1Click:Connect(function()
    ToggleAimbot()
end)

local waterKeyMenuButton = Instance.new("TextButton")
waterKeyMenuButton.Size = UDim2.new(0.8, 0, 0, 32)
waterKeyMenuButton.Position = UDim2.new(0.18, 0, 0, 68)
waterKeyMenuButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
waterKeyMenuButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
waterKeyMenuButton.TextColor3 = Color3.fromRGB(255, 255, 255)
waterKeyMenuButton.Text = "WATER KEY: [OFF]"
waterKeyMenuButton.TextSize, waterKeyMenuButton.Font = 11, Enum.Font.Code
waterKeyMenuButton.Parent = Tabs.AIM

local waterKeyCorner = Instance.new("UICorner")
waterKeyCorner.CornerRadius = UDim.new(0, 6)
waterKeyCorner.Parent = waterKeyMenuButton

waterKeyMenuButton.MouseButton1Click:Connect(function()
    ScriptConfig.WaterKey = not ScriptConfig.WaterKey
    UpdateButtonState(waterKeyMenuButton, ScriptConfig.WaterKey, "WATER KEY:")
    WaterKeyButton.Visible = ScriptConfig.WaterKey
end)

local FovContainer = Instance.new("Frame")
FovContainer.Size = UDim2.new(0.8, 0, 0, 42)
FovContainer.Position = UDim2.new(0.18, 0, 0, 104)
FovContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FovContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
FovContainer.Parent = Tabs.AIM

local fovCorner = Instance.new("UICorner")
fovCorner.CornerRadius = UDim.new(0, 6)
fovCorner.Parent = FovContainer

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(1, 0, 0, 18)
FovLabel.Position = UDim2.new(0, 0, 0, 2)
FovLabel.BackgroundTransparency = 1
FovLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
FovLabel.Text = "FOV Size: 45"
FovLabel.TextSize, FovLabel.Font = 10, Enum.Font.Code
FovLabel.Parent = FovContainer

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(0.8, 0, 0, 3)
SliderBar.Position = UDim2.new(0.1, 0, 0, 26)
SliderBar.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = FovContainer

local SliderButton = Instance.new("TextButton")
SliderButton.Size = UDim2.new(0, 12, 0, 12)
SliderButton.Position = UDim2.new(0, -6, 0.5, -6)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
SliderButton.Text = ""
SliderButton.Parent = SliderBar

local sliderBtnCorner = Instance.new("UICorner")
sliderBtnCorner.CornerRadius = UDim.new(1, 0)
sliderBtnCorner.Parent = SliderButton

local draggingSlider = false
SliderButton.MouseButton1Down:Connect(function() draggingSlider = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSlider = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local relativeX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
        SliderButton.Position = UDim2.new(relativeX, -6, 0.5, -6)
        local calculatedFOV = math.floor(45 + (relativeX * (360 - 45)))
        ScriptConfig.FOVSize = calculatedFOV
        FovLabel.Text = "FOV Size: " .. calculatedFOV
    end
end)

local EspScroll = Instance.new("ScrollingFrame")
EspScroll.Size = UDim2.new(0.8, 0, 0, 145)
EspScroll.Position = UDim2.new(0.18, 0, 0, 32)
EspScroll.BackgroundTransparency = 1
EspScroll.BorderSizePixel = 0
EspScroll.CanvasSize = UDim2.new(0, 0, 0, 175)
EspScroll.ScrollBarThickness = 3
EspScroll.Parent = Tabs.ESP

local function createEspButton(posY, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 26)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize, btn.Font = 10, Enum.Font.Code
    btn.Parent = EspScroll
    
    local eCorner = Instance.new("UICorner")
    eCorner.CornerRadius = UDim.new(0, 6)
    eCorner.Parent = btn
    
    return btn
end

local chamsButton = createEspButton(0, "CHAMS: [OFF]")
chamsButton.MouseButton1Click:Connect(function()
    ScriptConfig.Chams = not ScriptConfig.Chams
    UpdateButtonState(chamsButton, ScriptConfig.Chams, "CHAMS:")
    if not ScriptConfig.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("SonikESP") then
                player.Character.SonikESP:Destroy()
            end
        end
    end
end)

local outlineButton = createEspButton(30, "OUTLINE: [ON]")
outlineButton.MouseButton1Click:Connect(function()
    ScriptConfig.ChamsOutline = not ScriptConfig.ChamsOutline
    UpdateButtonState(outlineButton, ScriptConfig.ChamsOutline, "OUTLINE:")
end)

local boxButton = createEspButton(60, "BOX: [OFF]")
boxButton.MouseButton1Click:Connect(function()
    ScriptConfig.BoxESP = not ScriptConfig.BoxESP
    UpdateButtonState(boxButton, ScriptConfig.BoxESP, "BOX:")
    if not ScriptConfig.BoxESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("SonikBox") then
                player.Character.SonikBox:Remove()
            end
        end
    end
end)

local lineButton = createEspButton(90, "LINE: [OFF]")
lineButton.MouseButton1Click:Connect(function()
    ScriptConfig.ESPLine = not ScriptConfig.ESPLine
    UpdateButtonState(lineButton, ScriptConfig.ESPLine, "LINE:")
end)

local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(1, -6, 0, 24)
ColorContainer.Position = UDim2.new(0, 0, 0, 120)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = EspScroll

local paletteColors = {
    Color3.fromRGB(255, 50, 50),
    Color3.fromRGB(50, 100, 255),
    Color3.fromRGB(50, 255, 50),
    Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(255, 255, 0),
    Color3.fromRGB(170, 0, 255)
}

for i, clr in ipairs(paletteColors) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 22, 0, 24)
    btn.Position = UDim2.new(0, (i - 1) * 26, 0, 0)
    btn.BackgroundColor3 = clr
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.Parent = ColorContainer
    
    local clrCorner = Instance.new("UICorner")
    clrCorner.CornerRadius = UDim.new(0, 6)
    clrCorner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        ScriptConfig.ESPColor = clr
    end)
end

local MiscScroll = Instance.new("ScrollingFrame")
MiscScroll.Size = UDim2.new(0.8, 0, 0, 145)
MiscScroll.Position = UDim2.new(0.18, 0, 0, 32)
MiscScroll.BackgroundTransparency = 1
MiscScroll.BorderSizePixel = 0
MiscScroll.CanvasSize = UDim2.new(0, 0, 0, 160)
MiscScroll.ScrollBarThickness = 3
MiscScroll.Parent = Tabs.MISC

local function createMiscButton(posY, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -6, 0, 26)
    btn.Position = UDim2.new(0, 0, 0, posY)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextSize, btn.Font = 10, Enum.Font.Code
    btn.Parent = MiscScroll
    
    local mBtnCorner = Instance.new("UICorner")
    mBtnCorner.CornerRadius = UDim.new(0, 6)
    mBtnCorner.Parent = btn
    
    return btn
end

local rejoinButton = createMiscButton(0, "REJOIN")
rejoinButton.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

local afkButton = createMiscButton(30, "ANTI AFK [OFF]")
afkButton.MouseButton1Click:Connect(function()
    ScriptConfig.AntiAFK = not ScriptConfig.AntiAFK
    UpdateButtonState(afkButton, ScriptConfig.AntiAFK, "ANTI AFK")
end)

local safeTpButton = createMiscButton(60, "TP SAFE ZONE")
safeTpButton.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(SafeZonePosition)
        task.wait(0.1)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum.PlatformStand = false
        end
    end
end)

local fpsUnlockButton = createMiscButton(90, "FPS UNLOCKER [OFF]")
fpsUnlockButton.MouseButton1Click:Connect(function()
    ScriptConfig.FPSUnlocker = not ScriptConfig.FPSUnlocker
    UpdateButtonState(fpsUnlockButton, ScriptConfig.FPSUnlocker, "FPS UNLOCKER")
    if ScriptConfig.FPSUnlocker then
        pcall(function() setfpscap(144) end)
    else
        pcall(function() setfpscap(60) end)
    end
end)

local fpsPingButton = createMiscButton(120, "FPS / PING [OFF]")
local StatsDisplay = Instance.new("TextLabel")
StatsDisplay.Size = UDim2.new(0, 120, 0, 40)
StatsDisplay.Position = UDim2.new(0, 10, 1, -45)
StatsDisplay.BackgroundTransparency = 1
StatsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsDisplay.TextXAlignment = Enum.TextXAlignment.Left
StatsDisplay.Text = "FPS: 90\nPING: 30ms"
StatsDisplay.TextSize, StatsDisplay.Font = 12, Enum.Font.Code
StatsDisplay.Visible = false
StatsDisplay.Parent = ScreenGui

fpsPingButton.MouseButton1Click:Connect(function()
    ScriptConfig.FPS = not ScriptConfig.FPS
    UpdateButtonState(fpsPingButton, ScriptConfig.FPS, "FPS / PING")
    StatsDisplay.Visible = ScriptConfig.FPS
end)

local DevContainer = Instance.new("TextButton")
DevContainer.Size = UDim2.new(0.8, 0, 0, 75)
DevContainer.Position = UDim2.new(0.18, 0, 0, 32)
DevContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
DevContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
DevContainer.AutoButtonColor = false
DevContainer.Text = ""
DevContainer.Visible = false
DevContainer.Parent = Tabs.DEV

local devContainerCorner = Instance.new("UICorner")
devContainerCorner.CornerRadius = UDim.new(0, 6)
devContainerCorner.Parent = DevContainer

local DevRichLabel = Instance.new("TextLabel")
DevRichLabel.Size = UDim2.new(1, -6, 1, -4)
DevRichLabel.Position = UDim2.new(0, 3, 0, 2)
DevRichLabel.BackgroundTransparency = 1
DevRichLabel.TextWrapped = true
DevRichLabel.TextXAlignment = Enum.TextXAlignment.Left
DevRichLabel.TextYAlignment = Enum.TextYAlignment.Top
DevRichLabel.RichText = true
DevRichLabel.Text = '<font color="rgb(255,255,255)">SONIK HACK FOR CHAMELEON</font><br/><font color="rgb(50,100,255)">tg</font><font color="rgb(255,255,255)"> @sonik_hack</font><br/><font color="rgb(255,255,255)">Other scripts on </font><font color="rgb(50,100,255)">Telegram</font><font color="rgb(255,255,255)"> Channel @dev_sonik</font>'
DevRichLabel.TextSize, DevRichLabel.Font = 8, Enum.Font.Code
DevRichLabel.Parent = DevContainer

ShowTab("AIM")

local activeLines = {}
local activeBoxes = {}
local lastFpsUpdate = 0
local frameCount = 0

local function IsVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = RaycastParams.FilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    raycastParams.IgnoreWater = true
    
    local result = Workspace:Raycast(origin, direction, raycastParams)
    if result then
        return false
    end
    return true
end

local function GetClosestTarget()
    local closestTarget = nil
    local shortestDist = ScriptConfig.FOVSize
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPart = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Head")
                if targetPart and IsVisible(targetPart) then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                        if dist < shortestDist then
                            shortestDist = dist
                            closestTarget = targetPart
                        end
                    end
                end
            end
        end
    end
    return closestTarget
end

RunService.RenderStepped:Connect(function(dt)
    if ScriptConfig.FPS then
        frameCount = frameCount + 1
        local currentTick = tick()
        if currentTick - lastFpsUpdate >= 1 then
            local currentFPS = math.floor(frameCount / (currentTick - lastFpsUpdate))
            local currentPing = 0
            pcall(function()
                currentPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)
            StatsDisplay.Text = string.format("FPS: %d\nPING: %dms", currentFPS, currentPing)
            frameCount = 0
            lastFpsUpdate = currentTick
        end
    end

    if ScriptConfig.Chams then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("SonikESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SonikESP"
                    highlight.Adornee = player.Character
                    highlight.Parent = player.Character
                end
                highlight.FillColor = ScriptConfig.ESPColor
                highlight.FillTransparency = 0.3
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = ScriptConfig.ChamsOutline and 0 or 1
            end
        end
    end
    
    if ScriptConfig.BoxESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local box = activeBoxes[player]
                if not box then
                    box = Drawing.new("Square")
                    box.Thickness = 1.5
                    box.Filled = false
                    activeBoxes[player] = box
                end
                if hrp then
                    local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        box.Visible = true
                        box.Size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
                        box.Position = Vector2.new(pos.X - box.Size.X / 2, pos.Y - box.Size.Y / 2)
                        box.Color = ScriptConfig.ESPColor
                    else
                        box.Visible = false
                    end
                else
                    box.Visible = false
                end
            end
        end
    else
        for _, box in pairs(activeBoxes) do
            box.Visible = false
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
        
        local target = GetClosestTarget()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
end)
