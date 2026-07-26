-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configuration Table
getgenv().ScriptConfig = {
    AutoPaint = {
        Enabled = false,
        CheckInterval = 0.1,
    },
    ESP = {
        Enabled = false,
        Color = Color3.fromRGB(255, 255, 255), -- Стандартный белый
    },
    WallHack = {
        Enabled = false,
    },
    Aimbot = {
        Enabled = false,
        FOV = 120,
        ShowFOV = true,
    }
}

-- UI Initialization (SONIK HUB Branding)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikHub_Menu"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 380)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 23, 42)
MainFrame.BorderColor3 = Color3.fromRGB(56, 189, 248)
MainFrame.BorderSizePixel = 1
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
Title.TextColor3 = Color3.fromRGB(56, 189, 248)
Title.Text = "SONIK HUB"
Title.TextSize = 16
Title.Font = Enum.Font.Code
Title.Parent = MainFrame

-- FOV Circle for Aimbot
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = false
FOVCircle.Thickness = 1
FOVCircle.NumSides = 64
FOVCircle.Radius = ScriptConfig.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Color = Color3.fromRGB(56, 189, 248)
FOVCircle.Transparency = 1

local function CreateToggle(name, yPos, callback)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.9, 0, 0, 35)
    Button.Position = UDim2.new(0.05, 0, 0, yPos)
    Button.BackgroundColor3 = Color3.fromRGB(30, 41, 59)
    Button.BorderColor3 = Color3.fromRGB(56, 189, 248)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.Text = name .. ": [OFF]"
    Button.TextSize, Button.Font = 12, Enum.Font.Code
    Button.Parent = MainFrame
    
    local state = false
    Button.MouseButton1Click:Connect(function()
        state = not state
        Button.Text = name .. ": " .. (state and "[ON]" or "[OFF]")
        callback(state)
    end)
end

-- 1. AUTO-PAINT
CreateToggle("Auto-Paint", 55, function(state)
    ScriptConfig.AutoPaint.Enabled = state
    task.spawn(function()
        while ScriptConfig.AutoPaint.Enabled do
            task.wait(ScriptConfig.AutoPaint.CheckInterval)
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPart = character.HumanoidRootPart
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {character}
                rayParams.FilterType = Enum.RaycastFilterType.Exclude
                
                local rayResult = Workspace:Raycast(rootPart.Position, rootPart.CFrame.LookVector * 3, rayParams)
                if not rayResult then
                    rayResult = Workspace:Raycast(rootPart.Position, Vector3.new(0, -5, 0), rayParams)
                end
                
                if rayResult and rayResult.Instance then
                    local hitPart = rayResult.Instance
                    if hitPart:IsA("BasePart") then
                        local surfaceColor = hitPart.Color
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                part.Color = surfaceColor
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-- 2. ESP
local espHighlights = {}
CreateToggle("ESP Players", 100, function(state)
    ScriptConfig.ESP.Enabled = state
    if not state then
        for _, h in pairs(espHighlights) do h:Destroy() end
        espHighlights = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if ScriptConfig.ESP.Enabled then
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                if not espHighlights[player] then
                    local hl = Instance.new("Highlight")
                    hl.Adornee = player.Character
                    hl.FillColor = ScriptConfig.ESP.Color
                    hl.OutlineColor = Color3.fromRGB(0, 0, 0)
                    hl.Parent = player.Character
                    espHighlights[player] = hl
                else
                    espHighlights[player].FillColor = ScriptConfig.ESP.Color
                end
            end
        end
    end
end)

-- 3. WALL HACK
CreateToggle("WallHack (NoCollide)", 145, function(state)
    ScriptConfig.WallHack.Enabled = state
end)

RunService.Stepped:Connect(function()
    local character = LocalPlayer.Character
    if character and ScriptConfig.WallHack.Enabled then
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Name ~= "HumanoidRootPart" and part.Position.Y > character.PrimaryPart.Position.Y - 2 then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- 4. AIMBOT
CreateToggle("Aimbot", 190, function(state)
    ScriptConfig.Aimbot.Enabled = state
    FOVCircle.Visible = state
end)

RunService.RenderStepped:Connect(function()
    FOVCircle.Position = UserInputService:GetMouseLocation()
    if not ScriptConfig.Aimbot.Enabled then return end
    
    if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local closestTarget = nil
        local shortestDist = ScriptConfig.Aimbot.FOV
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                local torso = player.Character:FindFirstChild("UpperTorso") or player.Character:FindFirstChild("Torso")
                if torso then
                    local screenPoint, onScreen = Camera:WorldToViewportPoint(torso.Position)
                    if onScreen then
                        local mousePos = UserInputService:GetMouseLocation()
                        local dist = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        
                        if dist < shortestDist then
                            local rayParams = RaycastParams.new()
                            rayParams.FilterDescendantsInstances = {LocalPlayer.Character, player.Character}
                            rayParams.FilterType = Enum.RaycastFilterType.Exclude
                            local ray = Workspace:Raycast(Camera.CFrame.Position, (torso.Position - Camera.CFrame.Position).Unit * 500, rayParams)
                            
                            if not ray then
                                shortestDist = dist
                                closestTarget = torso
                            end
                        end
                    end
                end
            end
        end
        
        if closestTarget then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, closestTarget.Position)
        end
    end
end)
