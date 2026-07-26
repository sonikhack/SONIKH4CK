-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Configuration
getgenv().ScriptConfig = {
    ESP = false,
    ESPColorIndex = 1,
    WallHack = false,
}

-- Colors for ESP (White, Red, Blue, Green)
local ESPColors = {
    Color3.fromRGB(255, 255, 255), -- Белый
    Color3.fromRGB(255, 50, 50),   -- Красный
    Color3.fromRGB(50, 100, 255),  -- Синий
    Color3.fromRGB(50, 255, 50)    -- Зеленый
}
local ESPColorNames = {"White", "Red", "Blue", "Green"}

-- UI Initialization (SONIK HUB)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikHub_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Главное меню (высота подогнана строго под содержимое, без лишнего пустого места)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 160)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -80)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BorderColor3 = Color3.fromRGB(56, 189, 248)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
Title.TextColor3 = Color3.fromRGB(56, 189, 248)
Title.Text = "SONIK HUB"
Title.TextSize = 15
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

-- Кнопка сворачивания с текстом [ SH¿ ]
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 40, 0, 35)
MinimizeButton.Position = UDim2.new(1, -40, 0, 0)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
MinimizeButton.BorderColor3 = Color3.fromRGB(56, 189, 248)
MinimizeButton.TextColor3 = Color3.fromRGB(56, 189, 248)
MinimizeButton.Text = "SH¿"
MinimizeButton.TextSize = 11
MinimizeButton.Font = Enum.Font.Code
MinimizeButton.Parent = MainFrame

local isMinimized = false
MinimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    for _, child in ipairs(MainFrame:GetChildren()) do
        if child ~= Title and child ~= MinimizeButton then
            child.Visible = not isMinimized
        end
    end
    MainFrame.Size = isMinimized and UDim2.new(0, 320, 0, 35) or UDim2.new(0, 320, 0, 160)
end)

local function CreateButton(yPos, initialText, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    Button.BorderColor3 = Color3.fromRGB(56, 189, 248)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = initialText
    Button.TextSize, Button.Font = 12, Enum.Font.Code
    Button.Parent = MainFrame
    
    Button.MouseButton1Click:Connect(callback)
    return Button
end

-- 1. ESP TOGGLE
local espButton
espButton = CreateButton(42, "ESP Players: [OFF]", function()
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

-- 2. ESP COLOR SELECTOR (Красный, синий, зеленый, белый)
local colorButton
colorButton = CreateButton(80, "ESP Color: [White]", function()
    ScriptConfig.ESPColorIndex = ScriptConfig.ESPColorIndex + 1
    if ScriptConfig.ESPColorIndex > #ESPColors then
        ScriptConfig.ESPColorIndex = 1
    end
    colorButton.Text = "ESP Color: [" .. ESPColorNames[ScriptConfig.ESPColorIndex] .. "]"
end)

-- 3. WALL HACK
local whButton
whButton = CreateButton(118, "WallHack: [OFF]", function()
    ScriptConfig.WallHack = not ScriptConfig.WallHack
    whButton.Text = "WallHack: " .. (ScriptConfig.WallHack and "[ON]" or "[OFF]")
    
    local character = LocalPlayer.Character
    if character then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = not ScriptConfig.WallHack
            end
        end
    end
end)

-- ESP Loop
RunService.RenderStepped:Connect(function()
    if ScriptConfig.ESP then
        local currentColor = ESPColors[ScriptConfig.ESPColorIndex]
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("SonikESP")
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "SonikESP"
                    highlight.Adornee = player.Character
                    highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
                    highlight.Parent = player.Character
                end
                highlight.FillColor = currentColor
            end
        end
    end
end)

-- WallHack Loop
RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if character and ScriptConfig.WallHack then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                part.CanCollide = false
            end
        end
    end
end)
