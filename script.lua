-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration
getgenv().ScriptConfig = {
    ESP = false,
    ESPColor = Color3.fromRGB(255, 50, 50),
    Aimbot = false,
    FOVSize = 100
}

-- UI Initialization (SONIK HUB)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikHub_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- FOV Circle for Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Transparency = 0.7
FOVCircle.Thickness = 1.5
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.NumSides = 64
FOVCircle.Radius = ScriptConfig.FOVSize
FOVCircle.Filled = false

-- Main Frame (Черный дизайн)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 185)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -92)
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 1
MainFieldActive = true
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "SONIK HUB"
Title.TextSize = 15
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

-- Список всех элементов интерфейса (кроме самой кнопки скрытия), чтобы управлять их видимостью
local menuElements = {}

-- Minimize Button [ SH¿ ] (Скрывает и показывает ВСЁ меню целиком)
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 40, 0, 35)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MinimizeButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.Text = "SH¿"
MinimizeButton.TextSize = 11
MinimizeButton.Font = Enum.Font.Code
MinimizeButton.Parent = MainFrame

local isHidden = false
MinimizeButton.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    
    -- Скрываем/показываем фон и рамку главного окна
    MainFrame.BackgroundTransparency = isHidden and 1 or 0
    MainFrame.BorderSizePixel = isHidden and 0 or 1
    
    -- Скрываем/показываем все остальные элементы
    for _, element in ipairs(menuElements) do
        element.Visible = not isHidden
    end
end)

-- 1. ESP TOGGLE
local espButton = Instance.new("TextButton")
espButton.Size = UDim2.new(0.9, 0, 0, 32)
espButton.Position = UDim2.new(0.05, 0, 0, 42)
espButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
espButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
espButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espButton.Text = "ESP Players: [OFF]"
espButton.TextSize, espButton.Font = 12, Enum.Font.Code
espButton.Parent = MainFrame
table.insert(menuElements, espButton)

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

-- 2. COLOR PICKER (Кружки цветов: Красный, Синий, Зеленый, Белый)
local ColorContainer = Instance.new("Frame")
ColorContainer.Size = UDim2.new(0.9, 0, 0, 32)
ColorContainer.Position = UDim2.new(0.05, 0, 0, 80)
ColorContainer.BackgroundTransparency = 1
ColorContainer.Parent = MainFrame
table.insert(menuElements, ColorContainer)

local colors = {
    {Color3.fromRGB(255, 50, 50)},   -- Красный
    {Color3.fromRGB(50, 100, 255)},  -- Синий
    {Color3.fromRGB(50, 255, 50)},    -- Зеленый
    {Color3.fromRGB(255, 255, 255)}   -- Белый
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

-- 3. AIMBOT (Silent)
local aimButton = Instance.new("TextButton")
aimButton.Size = UDim2.new(0.9, 0, 0, 32)
aimButton.Position = UDim2.new(0.05, 0, 0, 118)
aimButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
aimButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
aimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
aimButton.Text = "Aimbot (Silent): [OFF]"
aimButton.TextSize, aimButton.Font = 12, Enum.Font.Code
aimButton.Parent = MainFrame
table.insert(menuElements, aimButton)

table.insert(menuElements, Title)

aimButton.MouseButton1Click:Connect(function()
    ScriptConfig.Aimbot = not ScriptConfig.Aimbot
    aimButton.Text = "Aimbot (Silent): " .. (ScriptConfig.Aimbot and "[ON]" or "[OFF]")
    FOVCircle.Visible = ScriptConfig.Aimbot
end)

-- ESP Loop (Убран контур/OutlineColor, добавлена максимальная яркость FillTransparency для видимости вдалеке)
RunService.RenderStepped:Connect(function()
    if ScriptConfig.ESP then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("SonikESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SonikESP"
                    highlight.Adornee = player.Character
                    highlight.OutlineTransparency = 1 -- Полностью убираем черный контур
                    highlight.Parent = player.Character
                end
                highlight.FillColor = ScriptConfig.ESPColor
                highlight.FillTransparency = 0.2 -- Делаем цвет ярче и заметнее на расстоянии
            end
        end
    end
end)

-- FOV Position
RunService.RenderStepped:Connect(function()
    if ScriptConfig.Aimbot then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Radius = ScriptConfig.FOVSize
    end
end)

-- Silent Aimbot Resolver
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
