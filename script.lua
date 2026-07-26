local P,RS,W,UIS,Tween,Teleport,Stats = game:GetService("Players"),game:GetService("RunService"),game:GetService("Workspace"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("TeleportService"),game:GetService("Stats")
local LP,Cam = P.LocalPlayer,W.CurrentCamera
getgenv().ScriptConfig={AimSilent=false,ESP=false,ESPLine=false,ESPColor=Color3.fromRGB(255,50,50),FPS=false,FPSUnlocker=false,AntiAFK=false,FOVSize=45}
local SafeZone=Vector3.new(436.69,156.07,-154.02)
LP.Idled:Connect(function()if ScriptConfig.AntiAFK then local vu=game:GetService("VirtualUser") vu:Button2Down(Vector2.new(0,0),Cam.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0),Cam.CFrame) end end)
local SG=Instance.new("ScreenGui",game.CoreGui) SG.Name,SG.ResetOnSpawn="SonikHack",false
local FOV=Drawing.new("Circle") FOV.Visible,FOV.Transparency,FOV.Thickness,FOV.Color,FOV.NumSides,FOV.Radius,FOV.Filled=false,0.7,1.5,Color3.fromRGB(255,255,255),64,45,false
local MF=Instance.new("Frame",SG) MF.Size,MF.Position,MF.BackgroundColor3,MF.BorderColor3,MF.Active,MF.Draggable,MF.Visible=UDim2.new(0,280,0,185),UDim2.new(0.5,-140,0.5,-92),Color3.fromRGB(0,0,0),Color3.fromRGB(255,255,255),true,true,false
Instance.new("UICorner",MF).CornerRadius=UDim.new(0,12)
local T=Instance.new("TextLabel",MF) T.Size,T.BackgroundTransparency,T.TextColor3,T.TextStrokeTransparency,T.TextStrokeColor3,T.Text,T.TextSize,T.Font=UDim2.new(1,0,0,28),1,Color3.fromRGB(0,0,0),0,Color3.fromRGB(255,255,255),"SONIK HACK",12,Enum.Font.Code
local TG=Instance.new("ScreenGui",game.CoreGui) TG.Name,TG.ResetOnSpawn="SonikHack_Toggle",false
local MB=Instance.new("TextButton",TG) MB.Size,MB.Position,MB.BackgroundColor3,MB.BorderColor3,MB.TextColor3,MB.Text,MB.TextSize,MB.Font,MB.Active,MB.Draggable=UDim2.new(0,42,0,42),UDim2.new(0.5,110,0.5,-92),Color3.fromRGB(0,0,0),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),"♧",24,Enum.Font.Code,true,true
Instance.new("UICorner",MB).CornerRadius=UDim.new(1,0)
local hidden=true
MB.MouseButton1Click:Connect(function()
    hidden=not hidden
    MF.Visible=not hidden
end)
local Tabs={AIM=Instance.new("Folder",MF),ESP=Instance.new("Folder",MF),MISC=Instance.new("Folder",MF),DEV=Instance.new("Folder",MF)}
local function ShowTab(name) for k,f in pairs(Tabs) do for _,v in ipairs(f:GetChildren()) do v.Visible=(k==name) end end end
local TC=Instance.new("Frame",MF) TC.Size,TC.Position,TC.BackgroundTransparency=UDim2.new(0,30,0,145),UDim2.new(0,6,0,32),1
for i,n in ipairs({"AIM","ESP","MISC","DEV"}) do
    local b=Instance.new("TextButton",TC) b.Size,b.Position,b.BackgroundColor3,b.BorderColor3,b.TextColor3,b.Text,b.TextSize,b.Font=UDim2.new(0,30,0,33),UDim2.new(0,0,0,(i-1)*37),Color3.fromRGB(20,20,20),Color3.fromRGB(255,255,255),Color3.fromRGB(255,255,255),n,8,Enum.Font.Code
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,6)
    b.MouseButton1Click:Connect(function() ShowTab(n) end)
end
ShowTab("AIM")
