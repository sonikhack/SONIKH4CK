--[========================================================================]--
-- MM2 SCRIPT SONIK HACK
--[========================================================================]--

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local function isVisible(targetPart)
	if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return false end
	local origin = LocalPlayer.Character.HumanoidRootPart.Position
	local direction = (targetPart.Position - origin)
	local raycastParams = RaycastParams.new()
	raycastParams.FilterType = Enum.RaycastFilterType.Exclude
	raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
	
	local result = workspace:Raycast(origin, direction, raycastParams)
	if result then
		local hitInstance = result.Instance
		if hitInstance:IsDescendantOf(targetPart.Parent) then
			return true
		end
	end
	return false
end

local function getPlayerRole(player)
	local character = player.Character
	if not character then return "Innocent" end
	
	if character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
		return "Murderer"
	elseif character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") or character:FindFirstChild("Revolver") or player.Backpack:FindFirstChild("Revolver") then
		return "Sheriff"
	else
		return "Innocent"
	end
end

_G.SilentAim = false
_G.AutoFire = false
_G.KillAura = false
_G.AutoKick = false
_G.EspAll = false
_G.EspCoin = false
_G.EspGun = false
_G.ShowName = false
_G.AutoFarm = false
_G.AntiAFK = false
_G.FpsUnlock = false
_G.TpSafeZone = false

if _G.FpsUnlock then
	setfpscap(999)
end

if _G.AntiAFK then
	local vu = game:GetService("VirtualUser")
	LocalPlayer.Idled:Connect(function()
		vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
		task.wait(1)
		vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
	end)
end

local safeZonePosition = Vector3.new(0, 150, 0)

RunService.RenderStepped:Connect(function()
	if _G.TpSafeZone and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(safeZonePosition)
	end

	if _G.AutoFire then
		local myRole = getPlayerRole(LocalPlayer)
		if myRole == "Sheriff" then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and getPlayerRole(player) == "Murderer" then
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						if isVisible(char.HumanoidRootPart) then
							Camera.CFrame = CFrame.new(Camera.CFrame.Position, char.HumanoidRootPart.Position)
							local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
							if tool and (tool.Name == "Gun" or tool.Name == "Revolver") then
								tool:Activate()
							end
						end
					end
				end
			end
		end
	end

	if _G.AutoKick then
		local myRole = getPlayerRole(LocalPlayer)
		if myRole == "Murderer" then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer then
					local char = player.Character
					if char and char:FindFirstChild("HumanoidRootPart") then
						if isVisible(char.HumanoidRootPart) then
							local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
							if tool and tool.Name == "Knife" then
								Camera.CFrame = CFrame.new(Camera.CFrame.Position, char.HumanoidRootPart.Position)
								tool:Activate()
							end
						end
					end
				end
			end
		end
	end

	if _G.KillAura then
		local myRole = getPlayerRole(LocalPlayer)
		if myRole == "Murderer" and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local myRoot = LocalPlayer.Character.HumanoidRootPart
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (myRoot.Position - player.Character.HumanoidRootPart.Position).Magnitude
					if dist < 18 then
						local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
						if tool and tool.Name == "Knife" then
							tool:Activate()
						end
					end
				end
			end
		end
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MM2Gui"
ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "MM2"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 14

local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.Position = UDim2.new(0, 0, 0, 35)
TabContainer.Size = UDim2.new(0, 110, 1, -35)

local function createTabButton(name, posY)
	local btn = Instance.new("TextButton")
	btn.Parent = TabContainer
	btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	btn.BorderSizePixel = 0
	btn.Position = UDim2.new(0, 5, 0, posY)
	btn.Size = UDim2.new(1, -10, 0, 30)
	btn.Font = Enum.Font.GothamSemibold
	btn.Text = name
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 13
	return btn
end

local AimTabBtn = createTabButton("AIM", 10)
local EspTabBtn = createTabButton("ESP", 50)
local MiscTabBtn = createTabButton("MISC", 90)
local DevTabBtn = createTabButton("DEV", 130)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 115, 0, 40)
ContentArea.Size = UDim2.new(1, -120, 1, -45)

local function createSectionFrame()
	local f = Instance.new("ScrollingFrame")
	f.Parent = ContentArea
	f.BackgroundTransparency = 1
	f.Size = UDim2.new(1, 0, 1, 0)
	f.Visible = false
	f.CanvasSize = UDim2.new(0, 0, 1.5, 0)
	f.ScrollBarThickness = 4
	return f
end

local AimSection = createSectionFrame()
local EspSection = createSectionFrame()
local MiscSection = createSectionFrame()
local DevSection = createSectionFrame()

AimSection.Visible = true

local function switchTab(activeSection)
	AimSection.Visible = (AimSection == activeSection)
	EspSection.Visible = (EspSection == activeSection)
	MiscSection.Visible = (MiscSection == activeSection)
	DevSection.Visible = (DevSection == activeSection)
end

AimTabBtn.MouseButton1Click:Connect(function() switchTab(AimSection) end)
EspTabBtn.MouseButton1Click:Connect(function() switchTab(EspSection) end)
MiscTabBtn.MouseButton1Click:Connect(function() switchTab(MiscSection) end)
DevTabBtn.MouseButton1Click:Connect(function() switchTab(DevSection) end)

local sheriffLabel = Instance.new("TextLabel")
sheriffLabel.Parent = AimSection
sheriffLabel.BackgroundTransparency = 1
sheriffLabel.Position = UDim2.new(0, 10, 0, 10)
sheriffLabel.Size = UDim2.new(1, -20, 0, 25)
sheriffLabel.Font = Enum.Font.GothamBold
sheriffLabel.Text = "SHERIFF"
sheriffLabel.TextColor3 = Color3.fromRGB(0, 120, 255)
sheriffLabel.TextSize = 14
sheriffLabel.TextXAlignment = Enum.TextXAlignment.Left

local silentAimBtn = Instance.new("TextButton")
silentAimBtn.Parent = AimSection
silentAimBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
silentAimBtn.Position = UDim2.new(0, 10, 0, 45)
silentAimBtn.Size = UDim2.new(1, -20, 0, 30)
silentAimBtn.Font = Enum.Font.Gotham
silentAimBtn.Text = "AIM SILENT  ●"
silentAimBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
silentAimBtn.TextSize = 12
silentAimBtn.MouseButton1Click:Connect(function()
	_G.SilentAim = not _G.SilentAim
	silentAimBtn.TextColor3 = _G.SilentAim and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

local autoFireBtn = Instance.new("TextButton")
autoFireBtn.Parent = AimSection
autoFireBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoFireBtn.Position = UDim2.new(0, 10, 0, 85)
autoFireBtn.Size = UDim2.new(1, -20, 0, 30)
autoFireBtn.Font = Enum.Font.Gotham
autoFireBtn.Text = "AutoFire (360°)"
autoFireBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoFireBtn.TextSize = 12
autoFireBtn.MouseButton1Click:Connect(function()
	_G.AutoFire = not _G.AutoFire
	autoFireBtn.TextColor3 = _G.AutoFire and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

local murderLabel = Instance.new("TextLabel")
murderLabel.Parent = AimSection
murderLabel.BackgroundTransparency = 1
murderLabel.Position = UDim2.new(0, 10, 0, 130)
murderLabel.Size = UDim2.new(1, -20, 0, 25)
murderLabel.Font = Enum.Font.GothamBold
murderLabel.Text = "MURDER"
murderLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
murderLabel.TextSize = 14
murderLabel.TextXAlignment = Enum.TextXAlignment.Left

local killAuraBtn = Instance.new("TextButton")
killAuraBtn.Parent = AimSection
killAuraBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
killAuraBtn.Position = UDim2.new(0, 10, 0, 165)
killAuraBtn.Size = UDim2.new(1, -20, 0, 30)
killAuraBtn.Font = Enum.Font.Gotham
killAuraBtn.Text = "KillAura"
killAuraBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
killAuraBtn.TextSize = 12
killAuraBtn.MouseButton1Click:Connect(function()
	_G.KillAura = not _G.KillAura
	killAuraBtn.TextColor3 = _G.KillAura and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

local autoKickBtn = Instance.new("TextButton")
autoKickBtn.Parent = AimSection
autoKickBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
autoKickBtn.Position = UDim2.new(0, 10, 0, 205)
autoKickBtn.Size = UDim2.new(1, -20, 0, 30)
autoKickBtn.Font = Enum.Font.Gotham
autoKickBtn.Text = "AutoKick (Auto Knife Throw)"
autoKickBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
autoKickBtn.TextSize = 12
autoKickBtn.MouseButton1Click:Connect(function()
	_G.AutoKick = not _G.AutoKick
	autoKickBtn.TextColor3 = _G.AutoKick and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
end)

local function createToggle(parent, text, yPos, callback)
	local btn = Instance.new("TextButton")
	btn.Parent = parent
	btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	btn.Position = UDim2.new(0, 10, 0, yPos)
	btn.Size = UDim2.new(1, -20, 0, 30)
	btn.Font = Enum.Font.Gotham
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 12
	local state = false
	btn.MouseButton1Click:Connect(function()
		state = not state
		btn.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
		if callback then callback(state) end
	end)
	return btn
end

createToggle(EspSection, "ESP ALL (Murderer: Red, Sheriff: Blue, Innocent: Green)", 10, function(v) _G.EspAll = v end)
createToggle(EspSection, "ESP COIN (Yellow)", 50, function(v) _G.EspCoin = v end)
createToggle(EspSection, "ESP GUN (Orange)", 90, function(v) _G.EspGun = v end)
createToggle(EspSection, "ShowName", 130, function(v) _G.ShowName = v end)

createToggle(MiscSection, "AutoFarm", 10, function(v) _G.AutoFarm = v end)
createToggle(MiscSection, "AntiAFK", 50, function(v) _G.AntiAFK = v end)

local reJoinBtn = Instance.new("TextButton")
reJoinBtn.Parent = MiscSection
reJoinBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
reJoinBtn.Position = UDim2.new(0, 10, 0, 90)
reJoinBtn.Size = UDim2.new(1, -20, 0, 30)
reJoinBtn.Font = Enum.Font.Gotham
reJoinBtn.Text = "ReJoin"
reJoinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
reJoinBtn.TextSize = 12
reJoinBtn.MouseButton1Click:Connect(function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

local serverHopBtn = Instance.new("TextButton")
serverHopBtn.Parent = MiscSection
serverHopBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
serverHopBtn.Position = UDim2.new(0, 10, 0, 130)
serverHopBtn.Size = UDim2.new(1, -20, 0, 30)
serverHopBtn.Font = Enum.Font.Gotham
serverHopBtn.Text = "ServerHop"
serverHopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
serverHopBtn.TextSize = 12
serverHopBtn.MouseButton1Click:Connect(function()
	local HttpService = game:GetService("HttpService")
	local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
	for _, s in ipairs(servers.data) do
		if s.playing < s.maxPlayers then
			game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
			break
		end
	end
end)

local statsLabel = Instance.new("TextLabel")
statsLabel.Parent = MiscSection
statsLabel.BackgroundTransparency = 1
statsLabel.Position = UDim2.new(0, 10, 0, 170)
statsLabel.Size = UDim2.new(1, -20, 0, 25)
statsLabel.Font = Enum.Font.Gotham
statsLabel.Text = "FPS: 60 | PING: 0ms"
statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
statsLabel.TextSize = 12

RunService.RenderStepped:Connect(function()
	local fps = math.round(1 / RunService.RenderStepped:Wait())
	local ping = math.round(LocalPlayer:GetNetworkPing() * 1000)
	statsLabel.Text = "FPS: " .. tostring(fps) .. " | PING: " .. tostring(ping) .. "ms"
end)

createToggle(MiscSection, "FPS Unlock (999fps)", 205, function(v)
	if v then setfpscap(999) else setfpscap(60) end
end)

createToggle(MiscSection, "TP SafeZone", 245, function(v) _G.TpSafeZone = v end)

local centerTitle = Instance.new("TextLabel")
centerTitle.Parent = DevSection
centerTitle.BackgroundTransparency = 1
centerTitle.Position = UDim2.new(0, 0, 0, 30)
centerTitle.Size = UDim2.new(1, 0, 0, 40)
centerTitle.Font = Enum.Font.GothamBold
centerTitle.Text = "<font color='#FF0000'>MM</font><font color='#FFFFFF'>2</font>"
centerTitle.RichText = true
centerTitle.TextSize = 28
centerTitle.TextXAlignment = Enum.TextXAlignment.Center

local tgLabel = Instance.new("TextLabel")
tgLabel.Parent = DevSection
tgLabel.BackgroundTransparency = 1
tgLabel.Position = UDim2.new(0, 0, 0, 90)
tgLabel.Size = UDim2.new(1, 0, 0, 25)
tgLabel.Font = Enum.Font.Gotham
tgLabel.Text = "<font color='#2AABEE'>tg</font> <font color='#FFFFFF'>@sonik_hack</font>"
tgLabel.RichText = true
tgLabel.TextSize = 14
tgLabel.TextXAlignment = Enum.TextXAlignment.Center

local channelLabel = Instance.new("TextLabel")
channelLabel.Parent = DevSection
channelLabel.BackgroundTransparency = 1
channelLabel.Position = UDim2.new(0, 0, 0, 125)
channelLabel.Size = UDim2.new(1, 0, 0, 25)
channelLabel.Font = Enum.Font.Gotham
channelLabel.Text = "<font color='#2AABEE'>Telegram Channel</font> <font color='#FFFFFF'>@dev_sonik</font>"
channelLabel.RichText = true
channelLabel.TextSize = 14
channelLabel.TextXAlignment = Enum.TextXAlignment.Center
