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
local 
