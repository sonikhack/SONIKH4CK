local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikHackRivals"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if syn and syn.protect_gui then
    syn.protect_gui(ScreenGui)
    ScreenGui.Parent = CoreGui
elseif gethui then
    ScreenGui.Parent = gethui()
else
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

getgenv().SonikConfig = {
    Aimbot = false,
    AimSilent = false,
    FovSize = 80,
    AimPart = "Head",
    AimVisible = true,
    
    EspBox = false,
    EspLine = false,
    HpBar = false,
    Chams = false,
    EspColor = Color3.fromRGB(255, 0, 0),
    
    SpeedHack = false,
    InfJump = false,
    AimKill = false,
    WallHack = false
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Filled = false
FOVCircle.Thickness = 2
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 1

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 255)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -127)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local BgGradient = Instance.new("UIGradient")
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 35)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 10, 15))
})
BgGradient.Rotation = 45
BgGradient.Parent = MainFrame

local TitleBar = Instance.new("TextLabel")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 32)
TitleBar.BackgroundTransparency = 1
TitleBar.Font = Enum.Font.SourceSans
TitleBar.TextSize = 17
TitleBar.RichText = true
TitleBar.Text = '<font color="#0055FF">SONIK</font> <font color="#FFFFFF">HACK</font>  |  <font color="#FF0000">RIVALS</font>'
TitleBar.Parent = MainFrame

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 42, 0, 42)
ToggleButton.Position = UDim2.new(0, 20, 0, 100)
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18
ToggleButton.Font = Enum.Font.SourceSans
ToggleButton.Text = "♤"
ToggleButton.Active = true
ToggleButton.Draggable = true
ToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(1, 0)
ToggleCorner.Parent = ToggleButton

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local TabContainer = Instance.new("Frame")
TabContainer.Name = "TabContainer"
TabContainer.Size = UDim2.new(0, 105, 1, -38)
TabContainer.Position = UDim2.new(0, 0, 0, 32)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = MainFrame

local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -115, 1, -38)
ContentFrame.Position = UDim2.new(0, 110, 0, 32)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

local function createPage(name)
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = ContentFrame
    
    local tgLabel = Instance.new("TextLabel")
    tgLabel.Size = UDim2.new(1, -10, 0, 16)
    tgLabel.Position = UDim2.new(0, 5, 1, -18)
    tgLabel.BackgroundTransparency = 1
    tgLabel.Font = Enum.Font.SourceSans
    tgLabel.TextSize = 10
    tgLabel.RichText = true
    tgLabel.TextXAlignment = Enum.TextXAlignment.Center
    tgLabel.Text = '<font color="#0055FF">Telegram Channel</font> <font color="#FFFFFF">@dev_sonik</font>'
    tgLabel.Parent = page
    
    return page
end

local CombatPage = createPage("Combat")
local VisualsPage = createPage("Visuals")
local BrutalPage = createPage("Brutal")
CombatPage.Visible = true

local function createTabButton(text, page, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -8, 0, 30)
    btn.Position = UDim2.new(0, 4, 0, (order - 1) * 34)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.SourceSans
    btn.Text = text
    btn.Parent = TabContainer
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 5)
    corner.Parent = btn
    
    btn.MouseButton1Click:Connect(function()
        CombatPage.Visible = false
        VisualsPage.Visible = false
        BrutalPage.Visible = false
        page.Visible = true
    end)
end

createTabButton("Combat", CombatPage, 1)
createTabButton("Visuals", VisualsPage, 2)
createTabButton("Brutal", BrutalPage, 3)

local function createToggle(parent, text, callback, initial)
    local yPos = (#parent:GetChildren() - 2) * 27
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(1, -8, 0, 23)
    toggleBtn.Position = UDim2.new(0, 4, 0, yPos)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleBtn.TextSize = 11
    toggleBtn.Font = Enum.Font.SourceSans
    toggleBtn.TextXAlignment = Enum.TextXAlignment.Left
    toggleBtn.Text = "  " .. text
    toggleBtn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 4)
    corner.Parent = toggleBtn
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1.5
    stroke.Color = initial and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 80)
    stroke.Parent = toggleBtn
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0, 50, 1, 0)
    statusLabel.Position = UDim2.new(1, -55, 0, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.SourceSans
    statusLabel.TextSize = 11
    statusLabel.TextColor3 = initial and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 150, 150)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Right
    statusLabel.Text = initial and "ON" or "OFF"
    statusLabel.Parent = toggleBtn
    
    local state = initial
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        stroke.Color = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 80)
        statusLabel.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(150, 150, 150)
        statusLabel.Text = state and "ON" or "OFF"
        callback(state)
    end)
end

local function createOptionsGrid(parent, titleText, options, callback)
    local yPos = (#parent:GetChildren() - 2) * 27
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 14)
    label.Position = UDim2.new(0, 4, 0, yPos)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 10
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = " " .. titleText
    label.Parent = parent
    
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -8, 0, 20)
    container.Position = UDim2.new(0, 4, 0, yPos + 14)
    container.BackgroundTransparency = 1
    container.Parent = parent
    
    local count = #options
    for i, opt in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1/count, -3, 1, 0)
        btn.Position = UDim2.new((i-1)/count, 1.5, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextSize = 10
        btn.Font = Enum.Font.SourceSans
        btn.Text = tostring(opt.name or opt)
        btn.Parent = container
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            callback(opt.val or opt)
        end)
    end
end

local function createSlider(parent, text, min, max, initial, callback)
    local yPos = (#parent:GetChildren() - 2) * 27
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -8, 0, 14)
    label.Position = UDim2.new(0, 4, 0, yPos)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(180, 180, 180)
    label.TextSize = 10
    label.Font = Enum.Font.SourceSans
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Text = " " .. text .. ": " .. initial
    label.Parent = parent
    
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -8, 0, 11)
    sliderBg.Position = UDim2.new(0, 4, 0, yPos + 14)
    sliderBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    sliderBg.Parent = parent
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 3)
    sliderCorner.Parent = sliderBg
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((initial - min)/(max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0, 3)
    fillCorner.Parent = fill
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = sliderBg
    
    local dragging = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            label.Text = " " .. text .. ": " .. val
            callback(val)
        end
    end)
end

createToggle(CombatPage, "AIMBOT", function(v) getgenv().SonikConfig.Aimbot = v end, false)
createToggle(CombatPage, "AIM SILENT", function(v) getgenv().SonikConfig.AimSilent = v end, false)
createSlider(CombatPage, "FOV", 45, 360, 80, function(v) 
    getgenv().SonikConfig.FovSize = v 
    FOVCircle.Radius = v
end)
createOptionsGrid(CombatPage, "Aim Part", {"Head", "Neck", "Body", "Leg"}, function(v)
    getgenv().SonikConfig.AimPart = v
end)
createToggle(CombatPage, "AIM VISIBLE", function(v) getgenv().SonikConfig.AimVisible = v end, true)

createToggle(VisualsPage, "ESP BOX", function(v) getgenv().SonikConfig.EspBox = v end, false)
createToggle(VisualsPage, "ESP LINE", function(v) getgenv().SonikConfig.EspLine = v end, false)
createToggle(VisualsPage, "HP BAR", function(v) getgenv().SonikConfig.HpBar = v end, false)
createToggle(VisualsPage, "CHAMS", function(v) getgenv().SonikConfig.Chams = v end, false)

local colorOptions = {
    {name = "Red", val = Color3.fromRGB(255, 0, 0)},
    {name = "Blue", val = Color3.fromRGB(0, 0, 255)},
    {name = "Lime", val = Color3.fromRGB(0, 255, 0)},
    {name = "White", val = Color3.fromRGB(255, 255, 255)}
}
createOptionsGrid(VisualsPage, "ESP Colors", colorOptions, function(v)
    getgenv().SonikConfig.EspColor = v
end)

createToggle(BrutalPage, "SPEED HACK", function(v) getgenv().SonikConfig.SpeedHack = v end, false)
createToggle(BrutalPage, "INF JUMP", function(v) getgenv().SonikConfig.InfJump = v end, false)
createToggle(BrutalPage, "AIM KILL", function(v) getgenv().SonikConfig.AimKill = v end, false)
createToggle(BrutalPage, "WALL HACK", function(v) getgenv().SonikConfig.WallHack = v end, false)

local function isVisible(targetPart)
    if not getgenv().SonikConfig.AimVisible then return true end
    local origin = Camera.CFrame.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    
    local result = Workspace:Raycast(origin, targetPart.Position - origin, raycastParams)
    if result then
        local hitPart = result.Instance
        return hitPart:IsDescendantOf(targetPart.Parent)
    end
    return true
end

local function getClosestEnemy()
    local closestTarget = nil
    local shortestDist = getgenv().SonikConfig.FovSize
    local mousePos = UserInputService:GetMouseLocation()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
            local char = player.Character
            local partName = getgenv().SonikConfig.AimPart
            local targetPart = char:FindFirstChild(partName) or char:FindFirstChild("Head")
            
            if targetPart then
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                    if dist < shortestDist then
                        if isVisible(targetPart) then
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

RunService.RenderStepped:Connect(function()
    if getgenv().SonikConfig.Aimbot or getgenv().SonikConfig.AimKill then
        FOVCircle.Visible = true
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = getgenv().SonikConfig.FovSize
    else
        FOVCircle.Visible = false
    end
    
    if getgenv().SonikConfig.Aimbot then
        local target = getClosestEnemy()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
        end
    end
    
    if getgenv().SonikConfig.AimKill then
        local target = getClosestEnemy()
        if target then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
            local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then
                pcall(function() tool:Activate() end)
            end
        end
    end
    
    if getgenv().SonikConfig.SpeedHack and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        local hum = LocalPlayer.Character.Humanoid
        hum.WalkSpeed = 48
    elseif LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16
    end
    
    if getgenv().SonikConfig.WallHack and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local hl = char:FindFirstChild("SonikChamsHighlight")
            if getgenv().SonikConfig.Chams then
                if not hl then
                    hl = Instance.new("Highlight")
                    hl.Name = "SonikChamsHighlight"
                    hl.Adornee = char
                    hl.Parent = char
                end
                hl.FillColor = getgenv().SonikConfig.EspColor
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.Enabled = true
            else
                if hl then
                    hl.Enabled = false
                end
            end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if getgenv().SonikConfig.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

local espDrawings = {}

local function removeEsp(player)
    if espDrawings[player] then
        for _, obj in pairs(espDrawings[player]) do
            pcall(function() obj:Remove() end)
        end
        espDrawings[player] = nil
    end
end

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 and char:FindFirstChild("HumanoidRootPart") then
                if not espDrawings[player] then
                    espDrawings[player] = {
                        Box = Drawing.new("Square"),
                        Line = Drawing.new("Line"),
                        HpBar = Drawing.new("Square"),
                        HpBg = Drawing.new("Square"),
                        HpText = Drawing.new("Text")
                    }
                    espDrawings[player].Box.Filled = false
                    espDrawings[player].Box.Thickness = 1.5
                    
                    espDrawings[player].Line.Thickness = 1
                    
                    espDrawings[player].HpBar.Filled = true
                    espDrawings[player].HpBg.Filled = true
                    espDrawings[player].HpBg.Color = Color3.fromRGB(0, 0, 0)
                    
                    espDrawings[player].HpText.Size = 13
                    espDrawings[player].HpText.Center = true
                    espDrawings[player].HpText.Outline = true
                    espDrawings[player].HpText.Color = Color3.fromRGB(255, 255, 255)
                end
                
                local visuals = espDrawings[player]
                local hrp = char.HumanoidRootPart
                local color = getgenv().SonikConfig.EspColor
                
                local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    local headVec = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(0, 3, 0))
                    local legVec = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headVec.Y - legVec.Y)
                    local width = height / 2
                    
                    if getgenv().SonikConfig.EspBox then
                        visuals.Box.Visible = true
                        visuals.Box.Size = Vector2.new(width, height)
                        visuals.Box.Position = Vector2.new(vector.X - width / 2, vector.Y - height / 2)
                        visuals.Box.Color = color
                    else
                        visuals.Box.Visible = false
                    end
                    
                    if getgenv().SonikConfig.EspLine then
                        visuals.Line.Visible = true
                        visuals.Line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        visuals.Line.To = Vector2.new(vector.X, vector.Y)
                        visuals.Line.Color = color
                    else
                        visuals.Line.Visible = false
                    end
                    
                    if getgenv().SonikConfig.HpBar then
                        local hp = char.Humanoid.Health
                        local maxHp = char.Humanoid.MaxHealth
                        local hpPercent = math.clamp(hp / maxHp, 0, 1)
                        
                        visuals.HpBg.Visible = true
                        visuals.HpBg.Size = Vector2.new(6, height)
                        visuals.HpBg.Position = Vector2.new(vector.X + width / 2 + 3, vector.Y - height / 2)
                        
                        visuals.HpBar.Visible = true
                        visuals.HpBar.Size = Vector2.new(4, height * hpPercent)
                        visuals.HpBar.Position = Vector2.new(visuals.HpBg.Position.X + 1, visuals.HpBg.Position.Y + (height * (1 - hpPercent)))
                        visuals.HpBar.Color = Color3.fromRGB(0, 255, 0)
                        
                        visuals.HpText.Visible = true
                        visuals.HpText.Text = tostring(math.floor(hp))
                        visuals.HpText.Position = Vector2.new(vector.X, vector.Y - height / 2 - 16)
                    else
                        visuals.HpBg.Visible = false
                        visuals.HpBar.Visible = false
                        visuals.HpText.Visible = false
                    end
                else
                    visuals.Box.Visible = false
                    visuals.Line.Visible = false
                    visuals.HpBg.Visible = false
                    visuals.HpBar.Visible = false
                    visuals.HpText.Visible = false
                end
            else
                removeEsp(player)
            end
        end
    end
end)

Players.PlayerRemoving:Connect(removeEsp)
