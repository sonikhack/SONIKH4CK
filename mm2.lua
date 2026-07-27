local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local _G = _G
_G.EspAll = false
_G.EspCoin = false
_G.EspGun = false
_G.AutoFarm = false
_G.AntiAfk = false
_G.FpsPing = false
_G.ServerHop = false
_G.SafeZone = false
_G.KillAura = false
_G.GrabGun = false

local function getRole(player)
	local char = player.Character
	if not char then return "Innocent" end
	if char:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
		return "Murderer"
	elseif char:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") or char:FindFirstChild("Revolver") or player.Backpack:FindFirstChild("Revolver") then
		return "Sheriff"
	else
		return "Innocent"
	end
end

local function applyEsp(char, color)
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			if not part:FindFirstChild("EspBox") then
				local box = Instance.new("BoxHandleAdornment")
				box.Name = "EspBox"
				box.Adornee = part
				box.AlwaysOnTop = true
				box.ZIndex = 10
				box.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
				box.Color3 = color
				box.Transparency = 0.4
				box.Parent = part
			else
				part.EspBox.Color3 = color
				part.EspBox.Visible = _G.EspAll
			end
		end
	end
end

local function removeEsp(char)
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
		if part:FindFirstChild("EspBox") then
			part.EspBox:Destroy()
		end
	end
end

RunService.RenderStepped:Connect(function()
	if _G.EspAll then
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local role = getRole(player)
				local col = Color3.fromRGB(0, 255, 0)
				if role == "Murderer" then
					col = Color3.fromRGB(255, 0, 0)
				elseif role == "Sheriff" then
					col = Color3.fromRGB(0, 120, 255)
				end
				applyEsp(player.Character, col)
			end
		end
	else
		for _, player in ipairs(Players:GetPlayers()) do
			if player.Character then
				removeEsp(player.Character)
			end
		end
	end

	if _G.EspCoin then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "Coin_Server" or obj.Name:lower():find("coin") then
				if obj:IsA("BasePart") and not obj:FindFirstChild("CoinEsp") then
					local b = Instance.new("BoxHandleAdornment")
					b.Name = "CoinEsp"
					b.Adornee = obj
					b.AlwaysOnTop = true
					b.Size = obj.Size + Vector3.new(0.2, 0.2, 0.2)
					b.Color3 = Color3.fromRGB(255, 255, 0)
					b.Transparency = 0.3
					b.Parent = obj
				end
			end
		end
	else
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj:FindFirstChild("CoinEsp") then
				obj.CoinEsp:Destroy()
			end
		end
	end

	if _G.EspGun then
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "GunDrop" or obj.Name == "Gun" then
				if obj:IsA("BasePart") and not obj:FindFirstChild("GunText") then
					local bb = Instance.new("BillboardGui")
					bb.Name = "GunText"
					bb.Size = UDim2.new(0, 100, 0, 50)
					bb.AlwaysOnTop = true
					bb.Adornee = obj
					local tl = Instance.new("TextLabel")
					tl.Parent = bb
					tl.Size = UDim2.new(1, 0, 1, 0)
					tl.BackgroundTransparency = 1
					tl.Text = "GUN"
					tl.TextColor3 = Color3.fromRGB(255, 140, 0)
					tl.TextScaled = true
					tl.Font = Enum.Font.GothamBold
					bb.Parent = obj
				end
			end
		end
	else
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj:IsA("BasePart") and obj:FindFirstChild("GunText") then
				obj.GunText:Destroy()
			end
		end
	end

	if _G.AutoFarm then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			for _, obj in ipairs(workspace:GetDescendants()) do
				if (obj.Name == "Coin_Server" or obj.Name:lower():find("coin")) and obj:IsA("BasePart") then
					char.HumanoidRootPart.CFrame = obj.CFrame
					task.wait(0.1)
					break
				end
			end
		end
	end

	if _G.KillAura then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") and getRole(LocalPlayer) == "Murderer" then
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local dist = (char.HumanoidRootPart.Position - p.Character.HumanoidRootPart.Position).Magnitude
					if dist < 18 then
						local knife = char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
						if knife and knife:IsA("Tool") then
							knife.Parent = char
							knife:Activate()
						end
					end
				end
			end
		end
	end

	if _G.GrabGun then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			for _, obj in ipairs(workspace:GetDescendants()) do
				if obj.Name == "GunDrop" and obj:IsA("BasePart") then
					char.HumanoidRootPart.CFrame = obj.CFrame
				end
			end
		end
	end

	if _G.SafeZone then
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			for _, spawn in ipairs(workspace:GetDescendants()) do
				if spawn.Name:lower():find("spawn") and spawn:IsA("BasePart") then
					char.HumanoidRootPart.CFrame = spawn.CFrame + Vector3.new(0, 3, 0)
					break
				end
			end
		end
	end

	if _G.AntiAfk then
		local vu = game:GetService("VirtualUser")
		LocalPlayer.Idled:Connect(function()
			vu:Button2Down(Vector2.new(0,0), Camera.CFrame)
			task.wait(1)
			vu:Button2Up(Vector2.new(0,0), Camera.CFrame)
		end)
	end
end)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SonikHackMM2"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
MainFrame.Size = UDim2.new(0, 400, 0, 240)
MainFrame.Active = true
MainFrame.Draggable = true

local IconBtn = Instance.new("TextButton")
IconBtn.Parent = ScreenGui
IconBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
IconBtn.BorderColor3 = Color3.fromRGB(40, 40, 40)
IconBtn.Position = UDim2.new(0, 50, 0, 50)
IconBtn.Size = UDim2.new(0, 45, 0, 45)
IconBtn.Font = Enum.Font.GothamBold
IconBtn.Text = "S"
IconBtn.TextColor3 = Color3.fromRGB(0, 120, 255)
IconBtn.TextSize = 18
IconBtn.Active = true
IconBtn.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(1, 0)
corner.Parent = IconBtn

IconBtn.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Parent = MainFrame
TitleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TitleLabel.BorderSizePixel = 0
TitleLabel.Size = UDim2.new(1, 0, 0, 30)
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.RichText = true
TitleLabel.Text = "<font color='#0078FF'>SONIK</font> HACK | <font color='#FF0000'>MM</font><font color='#FF0000'>2</font>"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 13

local TabContainer = Instance.new("Frame")
TabContainer.Parent = MainFrame
TabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.Size = UDim2.new(0, 100, 1, -30)

local function makeTabBtn(name, y)
	local b = Instance.new("TextButton")
	b.Parent = TabContainer
	b.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	b.BorderSizePixel = 0
	b.Position = UDim2.new(0, 5, 0, y)
	b.Size = UDim2.new(1, -10, 0, 25)
	b.Font = Enum.Font.GothamSemibold
	b.Text = name
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.TextSize = 12
	return b
end

local CombatBtn = makeTabBtn("COMBAT", 8)
local EspBtn = makeTabBtn("ESP", 38)
local MiscBtn = makeTabBtn("MISC", 68)
local DevBtn = makeTabBtn("DEV", 98)

local ContentArea = Instance.new("Frame")
ContentArea.Parent = MainFrame
ContentArea.BackgroundTransparency = 1
ContentArea.Position = UDim2.new(0, 100, 0, 30)
ContentArea.Size = UDim2.new(1, -100, 1, -30)

local function makeSec()
	local f = Instance.new("Frame")
	f.Parent = ContentArea
	f.BackgroundTransparency = 1
	f.Size = UDim2.new(1, 0, 1, 0)
	f.Visible = false
	return f
end

local CombatSec = makeSec()
local EspSec = makeSec()
local MiscSec = makeSec()
local DevSec = makeSec()

CombatSec.Visible = true

local function switch(sec)
	CombatSec.Visible = (CombatSec == sec)
	EspSec.Visible = (EspSec == sec)
	MiscSec.Visible = (MiscSec == sec)
	DevSec.Visible = (DevSec == sec)
end

CombatBtn.MouseButton1Click:Connect(function() switch(CombatSec) end)
EspBtn.MouseButton1Click:Connect(function() switch(EspSec) end)
MiscBtn.MouseButton1Click:Connect(function() switch(MiscSec) end)
DevBtn.MouseButton1Click:Connect(function() switch(DevSec) end)

local function makeLbl(p, text, color, y)
	local l = Instance.new("TextLabel")
	l.Parent = p
	l.BackgroundTransparency = 1
	l.Position = UDim2.new(0, 8, 0, y)
	l.Size = UDim2.new(1, -16, 0, 20)
	l.Font = Enum.Font.GothamBold
	l.Text = text
	l.TextColor3 = color
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	return l
end

local function makeBtn(p, text, y, cb)
	local b = Instance.new("TextButton")
	b.Parent = p
	b.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
	b.Position = UDim2.new(0, 8, 0, y)
	b.Size = UDim2.new(1, -16, 0, 25)
	b.Font = Enum.Font.Gotham
	b.Text = text
	b.TextColor3 = Color3.fromRGB(255, 255, 255)
	b.TextSize = 11
	local state = false
	b.MouseButton1Click:Connect(function()
		state = not state
		b.TextColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
		if cb then cb(state) end
	end)
	return b
end

makeLbl(CombatSec, "SHERIFF", Color3.fromRGB(0, 120, 255), 5)
local shootBoxBtn = Instance.new("TextButton")
shootBoxBtn.Parent = CombatSec
shootBoxBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
shootBoxBtn.Position = UDim2.new(0, 8, 0, 28)
shootBoxBtn.Size = UDim2.new(0, 60, 0, 25)
shootBoxBtn.Font = Enum.Font.GothamBold
shootBoxBtn.Text = "SHOOT"
shootBoxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
shootBoxBtn.TextSize = 10
shootBoxBtn.MouseButton1Click:Connect(function()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and getRole(p) == "Murderer" and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, p.Character.HumanoidRootPart.Position)
			local gun = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
			if gun and gun:IsA("Tool") then
				gun.Parent = LocalPlayer.Character
				gun:Activate()
			end
		end
	end
end)

makeLbl(CombatSec, "MURDER", Color3.fromRGB(255, 0, 0), 58)
makeBtn(CombatSec, "Kill Aura", 80, function(v) _G.KillAura = v end)

makeLbl(CombatSec, "INNOCENT", Color3.fromRGB(0, 255, 0), 110)
makeBtn(CombatSec, "Grab Gun", 132, function(v) _G.GrabGun = v end)

makeBtn(EspSec, "ESP ALL", 8, function(v) _G.EspAll = v end)
makeBtn(EspSec, "ESP COIN", 38, function(v) _G.EspCoin = v end)
makeBtn(EspSec, "ESP GUN", 68, function(v) _G.EspGun = v end)

makeBtn(MiscSec, "AutoFarm", 8, function(v) _G.AutoFarm = v end)
makeBtn(MiscSec, "ANTI-AFK", 38, function(v) _G.AntiAfk = v end)

local fpsPingBtn = Instance.new("TextButton")
fpsPingBtn.Parent = MiscSec
fpsPingBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
fpsPingBtn.Position = UDim2.new(0, 8, 0, 68)
fpsPingBtn.Size = UDim2.new(1, -16, 0, 25)
fpsPingBtn.Font = Enum.Font.Gotham
fpsPingBtn.Text = "FPS / PING"
fpsPingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
fpsPingBtn.TextSize = 11

local statDisplay = Instance.new("TextLabel")
statDisplay.Parent = ScreenGui
statDisplay.BackgroundTransparency = 1
statDisplay.Position = UDim2.new(0.5, -150, 1, -30)
statDisplay.Size = UDim2.new(0, 300, 0, 20)
statDisplay.Font = Enum.Font.GothamBold
statDisplay.Text = ""
statDisplay.TextColor3 = Color3.fromRGB(0, 255, 0)
statDisplay.TextSize = 14
statDisplay.Visible = false

fpsPingBtn.MouseButton1Click:Connect(function()
	_G.FpsPing = not _G.FpsPing
	fpsPingBtn.TextColor3 = _G.FpsPing and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 255, 255)
	statDisplay.Visible = _G.FpsPing
end)

RunService.RenderStepped:Connect(function()
	if _G.FpsPing then
		local fps = math.round(1 / RunService.RenderStepped:Wait())
		local ping = math.round(LocalPlayer:GetNetworkPing() * 1000)
		statDisplay.Text = "FPS: " .. tostring(fps) .. " / PING: " .. tostring(ping) .. "ms"
	end
end)

makeBtn(MiscSec, "SERVER HOP", 98, function(v)
	if v then
		local Http = game:GetService("HttpService")
		local srvs = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
		for _, s in ipairs(srvs.data) do
			if s.playing < s.maxPlayers then
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
				break
			end
		end
	end
end)

makeBtn(MiscSec, "SAFE ZONE", 128, function(v) _G.SafeZone = v end)

local devTitle = Instance.new("TextLabel")
devTitle.Parent = DevSec
devTitle.BackgroundTransparency = 1
devTitle.Position = UDim2.new(0, 0, 0, 20)
devTitle.Size = UDim2.new(1, 0, 0, 30)
devTitle.Font = Enum.Font.GothamBold
devTitle.RichText = true
devTitle.Text = "<font color='#FF0000'>MM</font><font color='#FFFFFF'>2</font>"
devTitle.TextSize = 24
devTitle.TextXAlignment = Enum.TextXAlignment.Center

local devTg = Instance.new("TextLabel")
devTg.Parent = DevSec
devTg.BackgroundTransparency = 1
devTg.Position = UDim2.new(0, 0, 0, 65)
devTg.Size = UDim2.new(1, 0, 0, 20)
devTg.Font = Enum.Font.Gotham
devTg.RichText = true
devTg.Text = "<font color='#2AABEE'>tg</font> <font color='#FFFFFF'>@sonik_hack</font>"
devTg.TextSize = 12
devTg.TextXAlignment = Enum.TextXAlignment.Center

local devChan = Instance.new("TextLabel")
devChan.Parent = DevSec
devChan.BackgroundTransparency = 1
devChan.Position = UDim2.new(0, 0, 0, 90)
devChan.Size = UDim2.new(1, 0, 0, 20)
devChan.Font = Enum.Font.Gotham
devChan.RichText = true
devChan.Text = "<font color='#2AABEE'>Telegram Channel</font> <font color='#FFFFFF'>@dev_sonik</font>"
devChan.TextSize = 12
devChan.TextXAlignment = Enum.TextXAlignment.Center
