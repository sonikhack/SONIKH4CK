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
    AimSilent = false,
    ESP = false,
    ESPLine = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    FPS = false,
    FPSUnlocker = false,
    NoClip = false,
    AntiAFK = false,
    FOVSize = 45,
    FlyUp = false,
    FlyDown = false,
    FlySpeed = 50
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
ScreenGui.Name = "SonikHack"
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

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 28)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SONIK HACK"
Title.TextSize, Title.Font = 12, Enum.Font.Code
Title.Parent = MainFrame

local ToggleGui = Instance.new("ScreenGui")
ToggleGui.Name = "SonikHack_Toggle"
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
    
    tBtn.MouseButton1Click:Connect(function()
        ShowTab(tName)
    end)
end

local function UpdateButtonState(btn, state, text)
    btn.Text = text .. " " .. (state and "[ON]" or "[OFF]")
    btn.BorderColor3 = state and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(255, 255, 255)
end

-- AIM вкладка
local aimSilentButton = Instance.new("TextButton")
aimSilentButton.Size = UDim2.new(0.8, 0, 0, 32)
aimSilentButton.Position = UDim2.new(0.18, 0, 0, 32)
aimSilentButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimSilentButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimSilentButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimSilentButton.Text = "AIM SILENT: [OFF]"
aimSilentButton.TextSize, aimSilentButton.Font = 11, Enum.Font.Code
aimSilentButton.Parent = Tabs.AIM

aimSilentButton.MouseButton1Click:Connect(function()
    ScriptConfig.AimSilent = not ScriptConfig.AimSilent
    UpdateButtonState(aimSilentButton, ScriptConfig.AimSilent, "AIM SILENT:")
    FOVCircle.Visible = ScriptConfig.AimSilent
end)

local FovContainer = Instance.new("Frame")
FovContainer.Size = UDim2.new(0.8, 0, 0, 42)
FovContainer.Position = UDim2.new(0.18, 0, 0, 68)
FovContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
FovContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
FovContainer.Parent = Tabs.AIM

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

-- ESP вкладка
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.8, 0, 0, 32)
espButton.Position = UDim2.new(0.18, 0, 0, 32)
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
lineButton.Size = UDim2.new(0.8, 0, 0, 32)
lineButton.Position = UDim2.new(0.18, 0, 0, 68)
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
ColorContainer.Size = UDim2.new(0.8, 0, 0, 28)
ColorContainer.Position = UDim2.new(0.18, 0, 0, 104)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = Tabs.ESP

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
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.Position = UDim2.new(0, (i - 1) * 29, 0, 0)
    btn.BackgroundColor3 = clr
    btn.BorderColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = ""
    btn.Parent = ColorContainer
    
    btn.MouseButton1Click:Connect(function()
        ScriptConfig.ESPColor = clr
    end)
end

-- Отдельное мини-меню полета для No Clip (Up / Down)
local FlyMiniGui = Instance.new("ScreenGui")
FlyMiniGui.Name = "SonikFlyMini"
FlyMiniGui.ResetOnSpawn = false
FlyMiniGui.Enabled = false
FlyMiniGui.Parent = game.CoreGui

local FlyFrame = Instance.new("Frame")
FlyFrame.Size = UDim2.new(0, 120, 0, 55)
FlyFrame.Position = UDim2.new(0.5, -60, 0.8, 0)
FlyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FlyFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
FlyFrame.BorderSizePixel = 1
FlyFrame.Active = true
FlyFrame.Draggable = true
FlyFrame.Parent = FlyMiniGui

local btnUp = Instance.new("TextButton")
btnUp.Size = UDim2.new(0.5, -4, 1, -6)
btnUp.Position = UDim2.new(0, 2, 0, 3)
btnUp.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnUp.BorderColor3 = Color3.fromRGB(255, 255, 255)
btnUp.TextColor3 = Color3.fromRGB(255, 255, 255)
btnUp.Text = "UP"
btnUp.TextSize = 11
btnUp.Font = Enum.Font.Code
btnUp.Parent = FlyFrame

local btnDown = Instance.new("TextButton")
btnDown.Size = UDim2.new(0.5, -4, 1, -6)
btnDown.Position = UDim2.new(0.5, 2, 0, 3)
btnDown.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btnDown.BorderColor3 = Color3.fromRGB(255, 255, 255)
btnDown.TextColor3 = Color3.fromRGB(255, 255, 255)
btnDown.Text = "DOWN"
btnDown.TextSize = 11
btnDown.Font = Enum.Font.Code
btnDown.Parent = FlyFrame

btnUp.MouseButton1Down:Connect(function() ScriptConfig.FlyUp = true end)
btnUp.MouseButton1Up:Connect(function() ScriptConfig.FlyUp = false end)
btnDown.MouseButton1Down:Connect(function() ScriptConfig.FlyDown = true end)
btnDown.MouseButton1Up:Connect(function() ScriptConfig.FlyDown = false end)

-- MISC Вкладка с прокруткой
local MiscScroll = Instance.new("ScrollingFrame")
MiscScroll.Size = UDim2.new(0.8, 0, 0, 145)
MiscScroll.Position = UDim2.new(0.18, 0, 0, 32)
MiscScroll.BackgroundTransparency = 1
MiscScroll.BorderSizePixel = 0
MiscScroll.CanvasSize = UDim2.new(0, 0, 0, 185)
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
    return btn
end

-- 1. REJOIN
local rejoinButton = createMiscButton(0, "REJOIN")
rejoinButton.MouseButton1Click:Connect(function()
    pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

-- 2. NO CLIP (+ отдельное меню полета и обход анти-чита Chameleon)
local noclipButton = createMiscButton(30, "NO CLIP [OFF]")
noclipButton.MouseButton1Click:Connect(function()
    ScriptConfig.NoClip = not ScriptConfig.NoClip
    UpdateButtonState(noclipButton, ScriptConfig.NoClip, "NO CLIP")
    FlyMiniGui.Enabled = ScriptConfig.NoClip
end)

-- 3. ANTI AFK
local afkButton = createMiscButton(60, "ANTI AFK [OFF]")
afkButton.MouseButton1Click:Connect(function()
    ScriptConfig.AntiAFK = not ScriptConfig.AntiAFK
    UpdateButtonState(afkButton, ScriptConfig.AntiAFK, "ANTI AFK")
end)

-- 4. TP SAFE ZONE
local safeTpButton = createMiscButton(90, "TP SAFE ZONE")
safeTpButton.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        char.HumanoidRootPart.CFrame = CFrame.new(SafeZonePosition)
    end
end)

-- 5. FPS UNLOCKER
local fpsUnlockButton = createMiscButton(120, "FPS UNLOCKER [OFF]")
fpsUnlockButton.MouseButton1Click:Connect(function()
    ScriptConfig.FPSUnlocker = not ScriptConfig.FPSUnlocker
    UpdateButtonState(fpsUnlockButton, ScriptConfig.FPSUnlocker, "FPS UNLOCKER")
    if ScriptConfig.FPSUnlocker then
        pcall(function() setfpscap(144) end)
    else
        pcall(function() setfpscap(60) end)
    end
end)

-- 6. FPS / PING
local fpsPingButton = createMiscButton(150, "FPS / PING [OFF]")
local StatsDisplay = Instance.new("TextLabel")
StatsDisplay.Size = UDim2.new(0, 120, 0, 40)
StatsDisplay.Position = UDim2.new(0, 10, 1, -45)
StatsDisplay.BackgroundTransparency = 1
StatsDisplay.TextColor3 = Color3.fromRGB(255, 255, 255)
StatsDisplay.TextStrokeTransparency = 0
StatsDisplay.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
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

-- DEV Вкладка (с точным оформлением каждого слова и открытием ссылки в браузере)
local DevContainer = Instance.new("TextButton")
DevContainer.Size = UDim2.new(0.8, 0, 0, 75)
DevContainer.Position = UDim2.new(0.18, 0, 0, 32)
DevContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
DevContainer.BorderColor3 = Color3.fromRGB(255, 255, 255)
DevContainer.AutoButtonColor = false
DevContainer.Text = ""
DevContainer.Visible = false
DevContainer.Parent = Tabs.DEV

local DevRichLabel = Instance.new("TextLabel")
DevRichLabel.Size = UDim2.new(1, -6, 1, -4)
DevRichLabel.Position = UDim2.new(0, 3, 0, 2)
DevRichLabel.BackgroundTransparency = 1
DevRichLabel.TextWrapped = true
DevRichLabel.TextXAlignment = Enum.TextXAlignment.Left
DevRichLabel.TextYAlignment = Enum.TextYAlignment.Top
DevRichLabel.RichText = true
-- Точная покраска по твоим правилам: гласные/согласные только у CHAMELEON, раздельные цвета для tg, Telegram, Channel и сброс на белые
DevRichLabel.Text = 'SONIK HACK SCRIPT FOR <font color="rgb(50,255,50)">C</font><font color="rgb(255,140,0)">H</font><font color="rgb(50,255,50)">A</font><font color="rgb(50,255,50)">M</font><font color="rgb(50,255,50)">E</font><font color="rgb(50,255,50)">L</font><font color="rgb(50,255,50)">E</font><font color="rgb(50,255,50)">O</font><font color="rgb(255,140,0)">N</font><font color="rgb(255,255,255)"><br/><font color="rgb(0,136,204)">tg</font> @sonik_hack<br/>Other scripts on <font color="rgb(0,136,204)">Telegram</font> <font color="rgb(245,222,179)">Channel</font> @dev_sonik</font>'
DevRichLabel.TextSize, DevRichLabel.Font = 8, Enum.Font.Code
DevRichLabel.Parent = DevContainer

DevContainer.MouseButton1Click:Connect(function()
    pcall(function()
        if setclipboard then setclipboard("https://t.me/dev_sonik") end
    end)
    pcall(function()
        if syn and syn.request then
            syn.request({Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = game:GetService("HttpService"):JSONEncode({cmd = "INVITE_BROWSER", args = {code = "dev_sonik"}})})
        elseif request then
            request({Url = "https://t.me/dev_sonik", Method = "GET"})
        end
    end)
end)

ShowTab("AIM")

local activeLines = {}
local lastFpsUpdate = 0
local frameCount = 0

-- Плавный полет (Fly) и NoClip с обходом анти-чита стен Chameleon
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

    local char = LocalPlayer.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if ScriptConfig.NoClip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            
            if hrp then
                local moveDir = humanoid and humanoid.MoveDirection or Vector3.new(0,0,0)
                local flySpeed = ScriptConfig.FlySpeed
                local yVel = 0
                
                if ScriptConfig.FlyUp then yVel = flySpeed elseif ScriptConfig.FlyDown then yVel = -flySpeed end
                
                if moveDir.Magnitude > 0 or yVel ~= 0 then
                    hrp.Velocity = Vector3.new(moveDir.X * flySpeed, yVel, moveDir.Z * flySpeed)
                    hrp.AssemblyLinearVelocity = hrp.Velocity
                else
                    -- Зависание в воздухе при остановке (фикс падения и смещения)
                    hrp.Velocity = Vector3.new(0, 0, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                end
            end
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
                    highlight.Parent = player.Character
                end
                highlight.FillColor = ScriptConfig.ESPColor
                highlight.FillTransparency = 0.3
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                highlight.OutlineTransparency = 0
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

    if ScriptConfig.AimSilent then
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
                local targetPart = player.Character:FindFirstChild("Head") or player.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - screenCenter).Magnitude
                        if dist < shortestDist then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local rayResult = Workspace:Raycast(Camera.CFrame.Position, (targetPart.Position - Camera.CFrame.Position), rayParams)
                            
                            if not rayResult or (rayResult.Instance and rayResult.Instance.Transparency > 0.5) or (rayResult.Instance and rayResult.Instance.Size.Magnitude < 3) then
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
