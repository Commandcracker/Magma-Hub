--[[
    Magma Hub
    © Commandcracker

    https://github.com/Commandcracker/Magma-Hub
]]

-- Services
local UserInputService  = game:GetService("UserInputService")
local VirtualUser       = game:GetService("VirtualUser")
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local HttpService       = game:GetService("HttpService")
local TeleportService   = game:GetService("TeleportService")
local Camera            = game:GetService("Workspace").CurrentCamera
local TestService       = game:GetService("TestService")
local TweenService 		= game:GetService("TweenService")

-- Variables
local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- Anti Kick Hook
if hookmetamethod ~= nil and getnamecallmethod ~= nil then
    local OldNameCall = nil

    OldNameCall = hookmetamethod(game, "__namecall", function(Self, n, ...)
        local NameCallMethod = getnamecallmethod()

        if tostring(string.lower(NameCallMethod)) == "kick" then
            if n == nil then
                game.StarterGui:SetCore("SendNotification", {Title="Magma Hub"; Text="Kick prevented."; Duration=2;})
                print("[Magma Hub] Kick prevented.")
            else
                game.StarterGui:SetCore("SendNotification", {Title="Magma Hub"; Text="Kick "..'"'.. n ..'"'.." prevented."; Duration=2;})
                print("[Magma Hub] Kick "..'"'.. n ..'"'.." prevented.")
            end
            return nil
        end

        return OldNameCall(Self, n, ...)
    end)
end

-- Thrad Manager
local function kill(thread: thread, f)
	local env = getfenv(f)
	function env:__index(k)
		if type(env[k]) == "function" and coroutine.running() == thread then
			return function()
				coroutine.yield()
			end
		else
			return env[k]
		end
	end
	setfenv(f, setmetatable({}, env))
	coroutine.resume(thread)
end

local TM 	= {}
TM.__index 	= TM

function TM.new()
	return setmetatable({
		threads = {}
	}, TM)
end

function TM:Add(Function)
	local thread = coroutine.create(Function)
	table.insert(self.threads, {thread, Function})
	coroutine.resume(thread)
end

function TM:Cleanup()
	for _,v in pairs(self.threads) do
		kill(v[1], v[2])
	end
end

Threads = TM.new()

-- Better Local Player
BLP = {}

function BLP.Respawn()
	local char = LocalPlayer.Character
	if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
	char:ClearAllChildren()
	local newChar 	= Instance.new("Model")
	newChar.Parent 	= workspace
	LocalPlayer.Character = newChar
	wait()
	LocalPlayer.Character = char
	newChar:Destroy()
end

function BLP.Refresh()
	local Human = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid", true)
	local pos 	= Human and Human.RootPart and Human.RootPart.CFrame
	local pos1 	= workspace.CurrentCamera.CFrame
	BLP.Respawn()
	task.spawn(function()
		LocalPlayer.CharacterAdded:Wait():WaitForChild("Humanoid").RootPart.CFrame, workspace.CurrentCamera.CFrame = pos, wait() and pos1
	end)
end

function BLP.Teleport(x: number | Vector3 | CFrame, y: number | Vector3, z: number, ...: number)
	if typeof(x) == "CFrame" then
		LocalPlayer.Character.HumanoidRootPart.CFrame = x
	elseif typeof(x) == "Vector3" then
		if typeof(y) == "Vector3" then
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y)
		else
			LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x)
		end
	else
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z, ...)
	end
end

-- Better Table
Btable = {}

function Btable.Reverse(Table: table)
	local reversedTable = {}
	local itemCount = #Table
	for k, v in ipairs(Table) do
		reversedTable[itemCount + 1 - k] = v
	end
	return reversedTable
end

function Btable.Contains(Table: table, Item)
	for _, value in pairs(Table) do
		if value == Item then return true end
	end
	return false
end

function Btable.Print(Table: table)
    local function getPointer(...)
        return string.split(tostring(...), " ")[2]
    end

    local function TableToString(Table: table, space: number)
        local out   = "{\n"

        if space == nil then
            space = 1
        end

        for key,value in pairs(Table) do
            local keyString
            keyString = "['"..tostring(key).."']"
    
            local valueString
            if type(value) == "function" then
                valueString = "'".."function_"..getPointer(value).."'"
            elseif type(value) == "string" then
                valueString = "'"..tostring(value).."'"
            elseif type(value) == "table" then
                valueString = TableToString(value, space+1)
            else
                valueString = tostring(value)
            end

            for _=1,space*4 do
                out=out.." "
            end

            out=out..keyString.." = "..valueString..',\n'
        end
        for _=1,(space-1)*4 do
            out=out.." "
        end
        return out.."}"
    end

    local out = "local table_"..getPointer(Table).." = "..TableToString(Table).."\n"
    if rconsoleclear ~= nil then rconsoleclear() end
    if rconsoleprint ~= nil then
        rconsoleprint(out)
    else
        print(out)
    end
end

-- UI util
local UIutil = {}

function UIutil:DraggingEnabled(frame, parent)
    parent = parent or frame

    local dragging = false
    local dragInput, mousePos, framePos

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            mousePos = input.Position
            framePos = parent.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta     = input.Position - mousePos
            parent.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- Magma UI
local MagmaUI = {}
local Page    = {}

MagmaUI.__index  = MagmaUI
Page.__index     = Page

function MagmaUI.new()
    local GUI
    if pcall(function()return game.CoreGui.Name end) then
        GUI = Instance.new("ScreenGui", game.CoreGui)
    else
        GUI = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    end

    GUI.ResetOnSpawn = false
    GUI.AutoLocalize = false
    GUI.DisplayOrder = 999999999

    local MainFrame             = Instance.new("Frame", GUI)
    MainFrame.BackgroundColor3  = Color3.fromRGB(24, 24, 24)
    MainFrame.Size              = UDim2.new(0, 500, 0, 320)
    MainFrame.Position          = UDim2.new(0.5, -250, 0, -356)
    MainFrame.BorderSizePixel   = 0

    local RGBBar                = Instance.new("Frame", MainFrame)
    RGBBar.BorderSizePixel      = 0
    RGBBar.Size                 = UDim2.new(1, 0, 0, 4)
    RGBBar.BackgroundColor3     = Color3.fromRGB(255, 78, 1)
    RGBBar.ZIndex               = 2

    --[[
    Threads:Add(function()
        local function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
        local counter = 0

        while wait(.1) do
            RGBBar.BackgroundColor3 = Color3.fromHSV(zigzag(counter),1,1)
            counter = counter + .01
        end
    end)
    ]]

    local TopBar            = Instance.new("Frame", MainFrame)
    TopBar.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    TopBar.Size             = UDim2.new(1,0,0,35)
    TopBar.BorderSizePixel  = 0

    local Title                     = Instance.new("TextLabel", TopBar)
    Title.Size                      = UDim2.new(0.5, 0, 1, 0)
    Title.Position                  = UDim2.new(0, 10, 0, 0)
    Title.Font                      = Enum.Font.GothamBold
    Title.Text                      = "Magma Hub"
    Title.TextSize                  = 14
    Title.TextXAlignment            = Enum.TextXAlignment.Left
    Title.BackgroundTransparency    = 1
    Title.TextColor3                = Color3.fromRGB(255, 255, 255)

    local ExitButton                    = Instance.new("TextButton", TopBar)
    ExitButton.Text                     = 'X'
    ExitButton.BorderSizePixel          = 0
    ExitButton.Size                     = UDim2.new(0, 35, 0, 35)
    ExitButton.Position                 = UDim2.new(1, -35, 0, 0)
    ExitButton.BackgroundColor3         = Color3.fromRGB(10, 10, 10)
    ExitButton.TextColor3               = Color3.fromRGB(255, 255, 255)
    ExitButton.Font                     = Enum.Font.GothamBold
    ExitButton.TextSize                 = 14
    ExitButton.MouseButton1Click:Connect(function()
        MainFrame:TweenPosition(UDim2.new(MainFrame.Position.X.Scale,MainFrame.Position.X.Offset,1,0), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 1)
        wait(1)
        GUI:Destroy()
        warn('[Magma Hub] Terminating Threads (ignore errors like "attempt to call a nil value")')
        Threads:Cleanup()
        script:Destroy()
    end)

    --[[
    local MinimizeButton                    = Instance.new("TextButton", TopBar)
    MinimizeButton.Text                     = "─"
    MinimizeButton.BorderSizePixel          = 0
    MinimizeButton.Size                     = UDim2.new(0,35,0,35)
    MinimizeButton.Position                 = UDim2.new(1, -70, 0, 0)
    MinimizeButton.BackgroundColor3         = Color3.fromRGB(10, 10, 10)
    MinimizeButton.TextColor3               = Color3.fromRGB(255, 255, 255)
    MinimizeButton.Font                     = Enum.Font.GothamBold
    MinimizeButton.TextSize                 = 14
    ]]

    local PageFrame                     = Instance.new("ScrollingFrame", MainFrame)
    PageFrame.Size                      = UDim2.new(0, 100, 1, -35)
    PageFrame.Position                  = UDim2.new(0, 0, 0, 35)
    PageFrame.BorderSizePixel           = 0
    PageFrame.ScrollBarThickness        = 5
    PageFrame.BackgroundColor3          = Color3.fromRGB(14, 14, 14)
    PageFrame.ScrollBarImageColor3      = Color3.fromRGB(4, 4, 4)
    PageFrame.AutomaticCanvasSize       = Enum.AutomaticSize.Y

    local PageFrame_UIListLayout    = Instance.new("UIListLayout", PageFrame)
    PageFrame_UIListLayout.Padding  = UDim.new(0, 5)

    return setmetatable({
        MainFrame = MainFrame,
        PageFrame = PageFrame
    }, MagmaUI)
end

function Page.new(lib, title: string)
    local ModuleList                    = Instance.new("ScrollingFrame", lib.MainFrame)
    ModuleList.Size                     = UDim2.new(1, -105, 1, -40)
    ModuleList.Position                 = UDim2.new(0, 105, 0, 40)
    ModuleList.BorderSizePixel          = 0
    ModuleList.ScrollBarThickness       = 5
    ModuleList.BackgroundTransparency   = 1
    ModuleList.ScrollBarImageColor3     = Color3.fromRGB(4, 4, 4)
    ModuleList.Visible                  = false
    ModuleList.AutomaticCanvasSize      = Enum.AutomaticSize.Y

    local ModuleList_UIListLayout      = Instance.new("UIListLayout", ModuleList)
    ModuleList_UIListLayout.Padding    = UDim.new(0, 5)

    local Button                = Instance.new("TextButton", lib.PageFrame)
    Button.Size                 = UDim2.new(1, 0, 0, 35)
    Button.Font                 = Enum.Font.Gotham
    Button.Text                 = title
    Button.TextSize             = 14
    Button.TextColor3           = Color3.fromRGB(255, 255, 255)
    Button.TextWrapped          = true
    Button.BackgroundColor3     = Color3.fromRGB(14, 14, 14)
    Button.BorderSizePixel      = 0
    Button.TextTransparency     = 0.65

    return setmetatable({
        lib         = lib,
        ModuleList  = ModuleList,
        Button      = Button
    }, Page)
end

function Page:Hide()
    self.ModuleList.Visible         = false
    self.Button.Font                = Enum.Font.Gotham
    self.Button.TextTransparency    = 0.65
end

function Page:Show()
    if self.lib.CurrentPage ~= nil then
        self.lib.CurrentPage:Hide()
    end

    self.ModuleList.Visible         = true
    self.lib.CurrentPage            = self
    self.Button.Font                = Enum.Font.GothamSemibold
    self.Button.TextTransparency    = 0
end

function Page:addButton(title: string, callback)
    local Button = {}

    Button.Frame                    = Instance.new("Frame", self.ModuleList)
    Button.Frame.BorderSizePixel    = 0
    Button.Frame.BackgroundColor3   = Color3.fromRGB(14, 14, 14)
    Button.Frame.Size               = UDim2.new(1, -10, 0, 30)

    Button.TextLabel                            = Instance.new("TextLabel", Button.Frame)
    Button.TextLabel.TextColor3                 = Color3.new(1,1,1)
    Button.TextLabel.Text                       = title
    Button.TextLabel.TextWrapped                = true
    Button.TextLabel.Font                       = Enum.Font.Gotham
    Button.TextLabel.BackgroundTransparency     = 1
    Button.TextLabel.Position                   = UDim2.new(0.02, 0, 0, 0)
    Button.TextLabel.TextXAlignment             = Enum.TextXAlignment.Left
    Button.TextLabel.Size                       = UDim2.new(0, 313, 1, 0)
    Button.TextLabel.TextSize                   = 12

    Button.Button                   = Instance.new("TextButton", Button.Frame)
    Button.Button.TextColor3        = Color3.new(1,1,1)
    Button.Button.Text              = "Run"
    Button.Button.Font              = Enum.Font.Gotham
    Button.Button.Position          = UDim2.new(0.89, 0, 0.25, -2)
    Button.Button.TextSize          = 12
    Button.Button.Size              = UDim2.new(0, 35, 1, -10)
    Button.Button.BorderColor3		= Color3.fromRGB(100, 100, 100)
    Button.Button.BackgroundColor3  = Color3.fromRGB(20, 20, 20)

    function Button:connect(callback)
        Button.Button.MouseButton1Click:Connect(callback)
    end

    local hovering  = false
    local tweenTime = 0.125
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    Button.Button.MouseEnter:Connect(function()
        hovering = true

        local borderFadeIn = TweenService:Create(Button.Button, tweenInfo, {BorderColor3 = Color3.fromRGB(255, 255, 255)})
        borderFadeIn:Play()

		repeat wait() until not hovering

        local borderFadeOut = TweenService:Create(Button.Button, tweenInfo, {BorderColor3 = Color3.fromRGB(100, 100, 100)})
		borderFadeOut:Play()
    end)

	Button.Button.MouseLeave:Connect(function()
        hovering = false
    end)

    if callback then
        Button.Button.MouseButton1Click:Connect(callback)
    end

    return Button
end

function Page:addToggle(title: string, EnableFunction, DisableFunction)
    local Button        = self:addButton(title)
    Button.connect      = nil
    Button.Button.Text  = "Off"

    local Toggel = false

    Button.Button.MouseButton1Click:Connect(function()
        if Toggel then
            Toggel = false
            Button.Button.Text = "Off"
            if DisableFunction ~= nil then
                DisableFunction()
            end
        else
            Toggel = true
            Button.Button.Text = "On"
            if EnableFunction ~= nil then
                EnableFunction()
            end
        end
    end)

    function Button:IsEnabeld()
        return Toggel
    end

    function Button:SetEnableFunction(Function)
        EnableFunction = Function
    end

    function Button:SetDisableFunction(Function)
        DisableFunction = Function
    end

    return Button
end

function Page:addInput(title: string, Function)
    local Button = self:addButton(title)

    Button.TextLabel.Size = UDim2.new(0, 231, 1, 0)

    Button.TextBox                     = Instance.new("TextBox", Button.Frame)
    Button.TextBox.TextColor3          = Color3.new(1,1,1)
    Button.TextBox.Text                = ""
    Button.TextBox.Font                = Enum.Font.Gotham
    Button.TextBox.Position            = UDim2.new(1, -125, 0.25, -2)
    Button.TextBox.Size                = UDim2.new(0, 75, 1, -10)
    Button.TextBox.TextSize            = 12
    Button.TextBox.BorderColor3		   = Color3.fromRGB(100, 100, 100)
    Button.TextBox.BackgroundColor3    = Color3.fromRGB(20, 20, 20)

    local hovering  = false
    local tweenTime = 0.125
	local tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    Button.TextBox.MouseEnter:Connect(function()
        hovering = true

        local borderFadeIn = TweenService:Create(Button.TextBox, tweenInfo, {BorderColor3 = Color3.fromRGB(255, 255, 255)})
        borderFadeIn:Play()

		repeat wait() until not hovering and not Button.TextBox:IsFocused()

        local borderFadeOut = TweenService:Create(Button.TextBox, tweenInfo, {BorderColor3 = Color3.fromRGB(100, 100, 100)})
		borderFadeOut:Play()
    end)

	Button.TextBox.MouseLeave:Connect(function()
        hovering = false
    end)

    Button.Button.MouseButton1Click:Connect(function()
        if Function ~= nil then
            Function(Button.TextBox.Text)
        end
    end)

    return Button
end

function MagmaUI:addPage(title: string)
    local page = Page.new(self,title)
    page.Button.MouseButton1Click:Connect(function()
        page:Show()
    end)
    return page
end

function MagmaUI:load()
    UIutil:DraggingEnabled(self.MainFrame)
    self.MainFrame:TweenPosition(UDim2.new(0.5, -250, 0.5, -196), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 1)
end

function MagmaUI:Notify(text: string, mode: number)
    if mode == nil or mode == 0 then
        print("[Magma Hub] "..text)
    elseif mode == 1 then
        warn("[Magma Hub] "..text)
    end
    game.StarterGui:SetCore("SendNotification",{
        Title="Magma Hub",
        Text=text,
        Duration=2
    })
end

-- Init
MagmaHub = MagmaUI.new()

-- Local Player Page
local LocalPlayerPage = MagmaHub:addPage("Local Player")
LocalPlayerPage:Show()

-- WalkSpeed
LocalPlayerPage:addInput("WalkSpeed", function(input)
    LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = input
end)

-- JumpPower
LocalPlayerPage:addInput("JumpPower", function(input)
    local Humanoid          = LocalPlayer.Character:WaitForChild("Humanoid")
    Humanoid.UseJumpPower   = true
    Humanoid.JumpPower      = input
end)

-- Teleport To Player
LocalPlayerPage:addInput("Teleport To Player", function(input)
    for _,player in pairs(Players:GetPlayers()) do
        if input == string.sub(player.Name,1,#input) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, -1)
        end
    end
end)

-- Fullbright
LocalPlayerPage:addButton("Fullbright", function()
    local Light = game:GetService("Lighting")

    local function dofullbright()
        Light.Ambient           = Color3.new(1, 1, 1)
        Light.ColorShift_Bottom = Color3.new(1, 1, 1)
        Light.ColorShift_Top    = Color3.new(1, 1, 1)
        Light.FogEnd            = 100000
        Light.FogStart          = 0
        Light.ClockTime         = 14
        Light.Brightness        = 2
        Light.GlobalShadows     = true
    end

    dofullbright()
    Light.LightingChanged:Connect(dofullbright)
end)

-- Noclip
local NoclipButton = LocalPlayerPage:addToggle("Noclip")

Threads:Add(function()
    while game:GetService("RunService").Stepped:Wait() do
        if NoclipButton:IsEnabeld() then
            for _,v in pairs(LocalPlayer.Character:GetChildren()) do
                pcall(function()
                    if v.ClassName == "Part" then
                        v.CanCollide = false
                    end
                end)
            end
        end
    end
end)

-- Infinity Jump
local InfinityJumpButton = LocalPlayerPage:addToggle("Infinity Jump")

UserInputService.JumpRequest:Connect(function()
    if InfinityJumpButton:IsEnabeld() then
        LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)

-- Suicid
LocalPlayerPage:addButton("Suicid", function()
    LocalPlayer.Character:WaitForChild("Humanoid").Health = 0
end)

-- Fly
local FlyButton = LocalPlayerPage:addToggle("Fly")
local ctrl      = {f = 0, b = 0, l = 0, r = 0}
local lastctrl  = {f = 0, b = 0, l = 0, r = 0}
local maxspeed  = 50
local speed     = 0
local bg        = nil
local bv        = nil

function Fly()
    local Torso = LocalPlayer.Character:FindFirstChild("Torso")

    if Torso == nil then
        Torso = LocalPlayer.Character:FindFirstChild("LowerTorso")
    end

    if Torso == nil then
        Torso = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end

    bg              = Instance.new("BodyGyro", Torso)
    bg.P            = 9e4
    bg.maxTorque    = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe       = Torso.CFrame

    bv          = Instance.new("BodyVelocity", Torso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)

    repeat wait()
        LocalPlayer.Character.Humanoid.PlatformStand = true
        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = speed+.5+(speed/maxspeed)
            if speed > maxspeed then
                speed = maxspeed
            end
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = speed-1
            if speed < 0 then
                speed = 0
            end
        end
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (ctrl.f+ctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(ctrl.l+ctrl.r,(ctrl.f+ctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            bv.velocity = ((game.Workspace.CurrentCamera.CoordinateFrame.lookVector * (lastctrl.f+lastctrl.b)) + ((game.Workspace.CurrentCamera.CoordinateFrame * CFrame.new(lastctrl.l+lastctrl.r,(lastctrl.f+lastctrl.b)*.2,0).p) - game.Workspace.CurrentCamera.CoordinateFrame.p))*speed
        else
            bv.velocity = Vector3.new(0,0.1,0)
        end
        bg.cframe = game.Workspace.CurrentCamera.CoordinateFrame * CFrame.Angles(-math.rad((ctrl.f+ctrl.b)*50*speed/maxspeed),0,0)
    until not FlyButton:IsEnabeld()
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    bg:Destroy()
    bg = nil
    bv:Destroy()
    bv = nil
    LocalPlayer.Character.Humanoid.PlatformStand = false
end

Mouse.KeyDown:Connect(function(key)
    if key:lower() == "w" then
        ctrl.f = 1
    elseif key:lower() == "s" then
        ctrl.b = -1
    elseif key:lower() == "a" then
        ctrl.l = -1
    elseif key:lower() == "d" then
        ctrl.r = 1
    end
end)

Mouse.KeyUp:Connect(function(key)
    if key:lower() == "w" then
        ctrl.f = 0
    elseif key:lower() == "s" then
        ctrl.b = 0
    elseif key:lower() == "a" then
        ctrl.l = 0
    elseif key:lower() == "d" then
        ctrl.r = 0
    end
end)

FlyButton:SetEnableFunction(function()
    Fly()
end)

-- Zoom Distance
LocalPlayerPage:addInput("Zoom Distance",function (input)
    LocalPlayer.CameraMaxZoomDistance = input
end)

-- Universal Page
local UniversalPage = MagmaHub:addPage("Universal")

-- Secure Dex
UniversalPage:addButton("Secure Dark Dex V3", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Babyhamsta/RBLX_Scripts/main/Universal/BypassedDarkDexV3.lua", true))()
end)

-- merge Magma Dex with Secure dex
-- Magma Dex
UniversalPage:addButton("Magma Dex", function()
    local Dex = rawget(game:GetObjects("rbxassetid://8126316565"), 0X1)
    if type(syn) == "table" and type(syn.protect_gui) == "function" then
        xpcall(syn.protect_gui, warn, Dex)
    end
    Dex.Name, Dex.Parent = "Magma Dex", game:GetService("CoreGui")
    local function Load(x)
        if x:IsA("Script") then
            xpcall(coroutine.wrap(function()
                local Fenv, FenvMt, RealFenv, Func = {}, {}, {
                    script = x
                }, loadstring(x.Source, "=" .. x:GetFullName())
                FenvMt.__index = function(a, b)
                    if RealFenv[b] == nil then
                        return getfenv()[b]
                    else
                        return RealFenv[b]
                    end
                end
                FenvMt.__newindex = function(a, b, c)
                    if RealFenv[b] == nil then
                        getfenv()[b] = c
                    else
                        RealFenv[b] = c
                    end
                end
                setmetatable(Fenv, FenvMt)
                setfenv(Func, Fenv)
                return Func()
            end), warn)
        end
        for _, v in pairs(x:GetChildren()) do
            xpcall(Load, warn, v)
        end
    end
    xpcall(Load, warn, Dex)
end)

-- CMD-X
UniversalPage:addButton("CMD-X", function()
    --[[----------------------------------------------------------------
    |                ▄▀▄▄▄▄   ▄▀▀▄ ▄▀▄  ▄▀▀█▄▄   ▄▀▀▄  ▄▀▄             |
    |               █ █    ▌ █  █ ▀  █ █ ▄▀   █ █    █   █             |
    |              ▐ █      ▐  █    █ ▐ █    █ ▐     ▀▄▀               |
    |                █        █    █    █    █      ▄▀ █               |
    |               ▄▀▄▄▄▄▀ ▄▀   ▄▀    ▄▀▄▄▄▄▀     █  ▄▀               |
    |              █     ▐  █    █    █     ▐    ▄▀  ▄▀                |
    |              ▐        ▐    ▐    ▐         █    ▐                 |
    |               ▐        ▐    ▐    ▐         █    ▐                |
    |------------------------------------------------------------------|
    |    Credits:    | Binds & Info:                                   |
    |    pigeon#1818 | U                         Open and close output |
    |        hz#4777 | RShift                          Fill suggestion |
    |     Curvn#2646 | ;                               Focus on CMDBar |
    | -------------- | Q                                Open and close |
    |                | LShift+Bksp                        Clear CMDbar |
    |                |                                                 |
    |                | .cmds                             List commands |
    ----------------------------------------------------------------]]--
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))()
end)

-- Infinite Yield
UniversalPage:addButton("Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

-- Hydroxide
UniversalPage:addButton("Hydroxide", function()
    local owner = "Upbolt"
    local branch = "revision"
    
    local function webImport(file)
        return loadstring(game:HttpGetAsync(("https://raw.githubusercontent.com/%s/Hydroxide/%s/%s.lua"):format(owner, branch, file)), file .. '.lua')()
    end
    
    webImport("init")
    webImport("ui/main")
end)

-- SimpleSpy
UniversalPage:addButton("SimpleSpy", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua'))()
end)

-- F3X
UniversalPage:addButton("F3X", function()
    loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
end)

-- Btools
UniversalPage:addButton("Btools", function()
    local hammer        = Instance.new("HopperBin")
    hammer.Name         = "Hammer"
    hammer.BinType      = 4
    hammer.Parent       = LocalPlayer.Backpack

    local cloneTool     = Instance.new("HopperBin")
    cloneTool.Name      = "Clone"
    cloneTool.BinType   = 3
    cloneTool.Parent    = LocalPlayer.Backpack

    local grabTool      = Instance.new("HopperBin")
    grabTool.Name       = "Grab"
    grabTool.BinType    = 2
    grabTool.Parent     = LocalPlayer.Backpack
end)

-- Anti AFK
local AntiAFKButton = UniversalPage:addToggle("Anti AFK")

LocalPlayer.Idled:Connect(function()
    if AntiAFKButton:IsEnabeld() then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        MagmaHub:Notify("Reflected idle Kick")
    end
end)

-- ESP
local ESPButton = UniversalPage:addToggle("ESP")

local function HighlightModel(Model)
    if ESPButton:IsEnabeld() then
        for _,v in pairs(Model:children())do
            if Model.Name ~= LocalPlayer.Name then
                if v:IsA'BasePart'and v.Name~='HumanoidRootPart'then
                    local bHA           = Instance.new('BoxHandleAdornment',v)
                    bHA.Adornee         = v
                    bHA.Size            = v.Name=='Head' and Vector3.new(1.25,1.25,1.25)    or v.Size
                    bHA.Color3          = v.Name=='Head' and Color3.new(1,0,0)              or v.Name=='Torso' and Color3.new(0,1,0) or Color3.new(0,0,1)
                    bHA.Transparency    = .5
                    bHA.ZIndex		    = 1
                    bHA.AlwaysOnTop	    = true
                end
                if #v:children()>0 then
                    HighlightModel(v)
                end
            end
        end
    end
end

local function UnHighlightModel(Model)
    for _,v in pairs(Model:children())do
        if v:IsA'BasePart' and v:findFirstChild'BoxHandleAdornment' then
            v.BoxHandleAdornment:Destroy()
        end
        if #v:children() > 0 then
            UnHighlightModel(v)
        end
    end
end

for _,player in pairs(Players:GetPlayers())do
    player.Changed:Connect(function()
        if player ~= nil and player.Character ~= nil  then
            RunService.Stepped:Wait()
            HighlightModel(player.Character)
        end
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.Changed:Connect(function()
        if player ~= nil and player.Character ~= nil then
            RunService.Stepped:Wait()
            HighlightModel(player.Character)
        end
    end)
end)

ESPButton.SetDisableFunction(function()
    for _,player in pairs(Players:GetPlayers())do
        UnHighlightModel(player.Character)
    end
end)

ESPButton.SetEnableFunction(function()
    for _,player in pairs(Players:GetPlayers())do
        HighlightModel(player.Character)
    end
end)

-- Aimbot GUI
UniversalPage:addButton("Aimbot GUI", function()
    local CC = game.Workspace.CurrentCamera

    local ENABLED      = false
    local ESP_ENABLED  = false

    _G.FREE_FOR_ALL = true

    _G.ESP_BIND    = 52
    _G.CHANGE_AIM  = 'q'

    _G.AIM_AT = 'Head'

    wait(1)

    local function GetNearestPlayerToMouse()
        local PLAYERS      = {}
        local PLAYER_HOLD  = {}
        local DISTANCES    = {}
        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= LocalPlayer then
                table.insert(PLAYERS, v)
            end
        end
        for i, v in pairs(PLAYERS) do
            if _G.FREE_FOR_ALL == false then
                if v and (v.Character) ~= nil and v.TeamColor ~= LocalPlayer.TeamColor then
                    local AIM = v.Character:FindFirstChild(_G.AIM_AT)
                    if AIM ~= nil then
                        local DISTANCE                 = (AIM.Position - game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude
                        local RAY                      = Ray.new(game.Workspace.CurrentCamera.CoordinateFrame.p, (Mouse.Hit.p - CC.CoordinateFrame.p).unit * DISTANCE)
                        local HIT,POS                  = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                        local DIFF                     = math.floor((POS - AIM.Position).magnitude)
                        PLAYER_HOLD[v.Name .. i]       = {}
                        PLAYER_HOLD[v.Name .. i].dist  = DISTANCE
                        PLAYER_HOLD[v.Name .. i].plr   = v
                        PLAYER_HOLD[v.Name .. i].diff  = DIFF
                        table.insert(DISTANCES, DIFF)
                    end
                end
            elseif _G.FREE_FOR_ALL == true then
                local AIM = v.Character:FindFirstChild(_G.AIM_AT)
                if AIM ~= nil then
                    local DISTANCE                 = (AIM.Position - game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude
                    local RAY                      = Ray.new(game.Workspace.CurrentCamera.CoordinateFrame.p, (Mouse.Hit.p - CC.CoordinateFrame.p).unit * DISTANCE)
                    local HIT,POS                  = game.Workspace:FindPartOnRay(RAY, game.Workspace)
                    local DIFF                     = math.floor((POS - AIM.Position).magnitude)
                    PLAYER_HOLD[v.Name .. i]       = {}
                    PLAYER_HOLD[v.Name .. i].dist  = DISTANCE
                    PLAYER_HOLD[v.Name .. i].plr   = v
                    PLAYER_HOLD[v.Name .. i].diff  = DIFF
                    table.insert(DISTANCES, DIFF)
                end
            end
        end

        if unpack(DISTANCES) == nil then
            return false
        end

        local L_DISTANCE = math.floor(math.min(unpack(DISTANCES)))
        if L_DISTANCE > 20 then
            return false
        end

        for i, v in pairs(PLAYER_HOLD) do
            if v.diff == L_DISTANCE then
                return v.plr
            end
        end
        return false
    end

    local GUI_MAIN                           = Instance.new('ScreenGui', game.CoreGui)
    local GUI_TARGET                         = Instance.new('TextLabel', GUI_MAIN)
    local GUI_AIM_AT                         = Instance.new('TextLabel', GUI_MAIN)

    GUI_MAIN.Name                      = 'AIMBOT'

    GUI_TARGET.Size                    = UDim2.new(0,200,0,30)
    GUI_TARGET.BackgroundTransparency  = 0.5
    GUI_TARGET.BackgroundColor         = BrickColor.new('Fossil')
    GUI_TARGET.BorderSizePixel         = 0
    GUI_TARGET.Position                = UDim2.new(0.5,-100,0,0)
    GUI_TARGET.Text                    = 'AIMBOT : OFF'
    GUI_TARGET.TextColor3              = Color3.new(1,1,1)
    GUI_TARGET.TextStrokeTransparency  = 1
    GUI_TARGET.TextWrapped             = true
    GUI_TARGET.FontSize                = 'Size24'
    GUI_TARGET.Font                    = 'SourceSansBold'

    GUI_AIM_AT.Size                    = UDim2.new(0,200,0,20)
    GUI_AIM_AT.BackgroundTransparency  = 0.5
    GUI_AIM_AT.BackgroundColor         = BrickColor.new('Fossil')
    GUI_AIM_AT.BorderSizePixel         = 0
    GUI_AIM_AT.Position                = UDim2.new(0.5,-100,0,30)
    GUI_AIM_AT.Text                    = 'AIMING : HEAD'
    GUI_AIM_AT.TextColor3              = Color3.new(1,1,1)
    GUI_AIM_AT.TextStrokeTransparency  = 1
    GUI_AIM_AT.TextWrapped             = true
    GUI_AIM_AT.FontSize                = 'Size18'
    GUI_AIM_AT.Font                    = 'SourceSansBold'

    local TRACK = false

    local function CREATE(BASE, TEAM)
        local ESP_MAIN                   = Instance.new('BillboardGui', LocalPlayer.PlayerGui)
        local ESP_DOT                    = Instance.new('Frame', ESP_MAIN)
        local ESP_NAME                   = Instance.new('TextLabel', ESP_MAIN)
        
        ESP_MAIN.Name                    = 'ESP'
        ESP_MAIN.Adornee                 = BASE
        ESP_MAIN.AlwaysOnTop             = true
        ESP_MAIN.ExtentsOffset           = Vector3.new(0, 1, 0)
        ESP_MAIN.Size                    = UDim2.new(0, 5, 0, 5)
        
        ESP_DOT.Name                     = 'DOT'
        ESP_DOT.BackgroundColor          = BrickColor.new('Bright red')
        ESP_DOT.BackgroundTransparency   = 0.3
        ESP_DOT.BorderSizePixel          = 0
        ESP_DOT.Position                 = UDim2.new(-0.5, 0, -0.5, 0)
        ESP_DOT.Size                     = UDim2.new(2, 0, 2, 0)
        ESP_DOT.Visible                  = true
        ESP_DOT.ZIndex                   = 10
        
        ESP_NAME.Name                    = 'NAME'
        ESP_NAME.BackgroundColor3        = Color3.new(255, 255, 255)
        ESP_NAME.BackgroundTransparency  = 1
        ESP_NAME.BorderSizePixel         = 0
        ESP_NAME.Position                = UDim2.new(0, 0, 0, -40)
        ESP_NAME.Size                    = UDim2.new(1, 0, 10, 0)
        ESP_NAME.Visible                 = true
        ESP_NAME.ZIndex                  = 10
        ESP_NAME.Font                    = 'ArialBold'
        ESP_NAME.FontSize                = 'Size14'
        ESP_NAME.Text                    = BASE.Parent.Name:upper()
        ESP_NAME.TextColor               = BrickColor.new('Bright red')
    end

    local function CLEAR()
        for _,v in pairs(LocalPlayer.PlayerGui:children()) do
            if v.Name == 'ESP' and v:IsA('BillboardGui') then
                v:Destroy()
            end
        end
    end

    local function FIND()
        CLEAR()
        TRACK = true
        spawn(function()
            while wait() do
                if TRACK then
                    CLEAR()
                    for i,v in pairs(game.Players:GetChildren()) do
                        if v.Character and v.Character:FindFirstChild('Head') then
                            if _G.FREE_FOR_ALL == false then
                                if v.TeamColor ~= LocalPlayer.TeamColor then
                                    if v.Character:FindFirstChild('Head') then
                                        CREATE(v.Character.Head, true)
                                    end
                                end
                            else
                                if v.Character:FindFirstChild('Head') then
                                    CREATE(v.Character.Head, true)
                                end
                            end
                        end
                    end
                end
            end
            wait(1)
        end)
    end

    Mouse.Button2Down:connect(function()
        ENABLED = true
    end)

    Mouse.Button2Up:connect(function()
        ENABLED = false
    end)

    Mouse.KeyDown:connect(function(KEY)
        KEY = KEY:lower():byte()
        if KEY == _G.ESP_BIND then
            if ESP_ENABLED == false then
                FIND()
                ESP_ENABLED = true
                print('ESP : ON')
            elseif ESP_ENABLED == true then
                wait()
                CLEAR()
                TRACK = false
                ESP_ENABLED = false
                print('ESP : OFF')
            end
        end
    end)

    Mouse.KeyDown:Connect(function(KEY)
        if KEY == _G.CHANGE_AIM then
            if _G.AIM_AT == 'Head' then
                _G.AIM_AT = 'Torso'
                GUI_AIM_AT.Text = 'AIMING : TORSO'
            elseif _G.AIM_AT == 'Torso' then
                _G.AIM_AT = 'Head'
                GUI_AIM_AT.Text = 'AIMING : HEAD'
            end
        end
    end)

    RunService.RenderStepped:Connect(function()
        if ENABLED then
            local TARGET = GetNearestPlayerToMouse()
            if (TARGET ~= false) then
                local AIM = TARGET.Character:FindFirstChild(_G.AIM_AT)
                if AIM then
                    CC.CoordinateFrame = CFrame.new(CC.CoordinateFrame.p, AIM.CFrame.p)
                end
                GUI_TARGET.Text = 'AIMBOT : '.. TARGET.Name:sub(1, 5)
            else
                GUI_TARGET.Text = 'AIMBOT : OFF'
            end
        end
    end)

    repeat
        wait()
        if ESP_ENABLED == true then
            FIND()
        end
    until ESP_ENABLED == false
end)

-- FE Invisible
local FEInvisible = UniversalPage:addToggle("FE Invisible")

local touched 		= false
local box           = nil
local loc

LocalPlayer.CharacterAdded:Connect(function(character)
    if FEInvisible:IsEnabeld() then
        repeat wait() until character.HumanoidRootPart
        loc = character.HumanoidRootPart.Position
        character:MoveTo(box.Position + Vector3.new(0,.5,0))
    end
end)

FEInvisible:SetEnableFunction(function()
    if box == nil then
        box 		    = Instance.new('Part',workspace)
        box.Anchored 	= true
        box.CanCollide 	= true
        box.Size 		= Vector3.new(10,1,10)
        box.Position 	= Vector3.new(0,10000,0)
        box.Touched:Connect(function(part)
            if (part.Parent.Name == LocalPlayer.Name) then
                if touched == false then
                    touched = true
                    if LocalPlayer.Character and FEInvisible:IsEnabeld() then
                        local no = LocalPlayer.Character.HumanoidRootPart:Clone()
                        wait(.25)
                        LocalPlayer.Character.HumanoidRootPart:Destroy()
                        no.Parent = LocalPlayer.Character
                        LocalPlayer.Character:MoveTo(loc)
                        touched = false
                    end
                end
            end
        end)
    end

    repeat wait() until LocalPlayer.Character
    loc = LocalPlayer.Character.HumanoidRootPart.Position
    LocalPlayer.Character:MoveTo(box.Position + Vector3.new(0,.5,0))
end)

FEInvisible:SetDisableFunction(function()
    if LocalPlayer.Character ~= nil then
        BLP.Refresh()
    end
end)

-- Rejoin-Game
UniversalPage:addButton("Rejoin-Game", function()
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end)

-- Coppy
if setclipboard ~= nil then
    local CoppyPage = MagmaHub:addPage("Coppy")

    CoppyPage:addButton("GameId / UniverseId", function()
        setclipboard(tostring(game.GameId))
    end)

    CoppyPage:addButton("Position", function()
        local pos = LocalPlayer.Character.HumanoidRootPart.CFrame.Position
        setclipboard(math.floor(pos.X)..", "..math.floor(pos.Y)..", "..math.floor(pos.Z))
    end)

    CoppyPage:addButton("PlaceId", function()
        setclipboard(tostring(game.PlaceId))
    end)
end

if Drawing ~= nil then
-- Visuals from https://github.com/Exunys
local Visuals = MagmaHub:addPage("Visuals")

-- Tracers
Visuals:addButton("Tracers", function()
    local Typing = false

    _G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
    _G.DefaultSettings = false   -- If set to true then the tracer script would run with default settings regardless of any changes you made.

    _G.TeamCheck = false   -- If set to true then the script would create tracers only for the enemy team members.

    --[!]-- ONLY ONE OF THESE VALUES SHOULD BE SET TO TRUE TO NOT ERROR THE SCRIPT --[!]--

    _G.FromMouse = false   -- If set to true, the tracers will come from the position of your mouse curson on your screen.
    _G.FromCenter = false   -- If set to true, the tracers will come from the center of your screen.
    _G.FromBottom = true   -- If set to true, the tracers will come from the bottom of your screen.

    _G.TracersVisible = true   -- If set to true then the tracers will be visible and vice versa.
    _G.TracerColor = Color3.fromRGB(255, 80, 10)   -- The color that the tracers would appear as.
    _G.TracerThickness = 1   -- The thickness of the tracers.
    _G.TracerTransparency = 0.7   -- The transparency of the tracers.

    _G.ModeSkipKey = Enum.KeyCode.E   -- The key that changes between modes that indicate where will the tracers come from.
    _G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the tracers.

    local function CreateTracers()
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= game.Players.LocalPlayer.Name then
                local TracerLine = Drawing.new("Line")
        
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                        local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                        
                        TracerLine.Thickness = _G.TracerThickness
                        TracerLine.Transparency = _G.TracerTransparency
                        TracerLine.Color = _G.TracerColor

                        if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                        elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                        elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                            TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                        end

                        if OnScreen == true  then
                            TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    TracerLine.Visible = _G.TracersVisible
                                else
                                    TracerLine.Visible = false
                                end
                            else
                                TracerLine.Visible = _G.TracersVisible
                            end
                        else
                            TracerLine.Visible = false
                        end
                    else
                        TracerLine.Visible = false
                    end
                end)

                Players.PlayerRemoving:Connect(function()
                    TracerLine.Visible = false
                end)
            end
        end

        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function(v)
                if v.Name ~= game.Players.LocalPlayer.Name then
                    local TracerLine = Drawing.new("Line")
            
                    RunService.RenderStepped:Connect(function()
                        if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                            local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * 1
                            local Vector, OnScreen = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(0, -HumanoidRootPart_Size.Y, 0).p)
                            
                            TracerLine.Thickness = _G.TracerThickness
                            TracerLine.Transparency = _G.TracerTransparency
                            TracerLine.Color = _G.TracerColor

                            if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false then
                                TracerLine.From = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
                            elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false then
                                TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                            elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true then
                                TracerLine.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                            end

                            if OnScreen == true  then
                                TracerLine.To = Vector2.new(Vector.X, Vector.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        TracerLine.Visible = _G.TracersVisible
                                    else
                                        TracerLine.Visible = false
                                    end
                                else
                                    TracerLine.Visible = _G.TracersVisible
                                end
                            else
                                TracerLine.Visible = false
                            end
                        else
                            TracerLine.Visible = false
                        end
                    end)

                    Players.PlayerRemoving:Connect(function()
                        TracerLine.Visible = false
                    end)
                end
            end)
        end)
    end

    UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)

    UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)

    UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == _G.ModeSkipKey and Typing == false then
            if _G.FromMouse == true and _G.FromCenter == false and _G.FromBottom == false and _G.TracersVisible == true then
                _G.FromCenter = false
                _G.FromBottom = true
                _G.FromMouse = false

                if _G.SendNotifications == true then
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Exunys Developer";
                        Text = "Tracers will be now coming from the bottom of your screen (Mode 1)";
                        Duration = 5;
                    })
                end
            elseif _G.FromMouse == false and _G.FromCenter == false and _G.FromBottom == true and _G.TracersVisible == true then
                _G.FromCenter = true
                _G.FromBottom = false
                _G.FromMouse = false

                if _G.SendNotifications == true then
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Exunys Developer";
                        Text = "Tracers will be now coming from the center of your screen (Mode 2)";
                        Duration = 5;
                    })
                end
            elseif _G.FromMouse == false and _G.FromCenter == true and _G.FromBottom == false and _G.TracersVisible == true then
                _G.FromCenter = false
                _G.FromBottom = false
                _G.FromMouse = true

                if _G.SendNotifications == true then
                    game:GetService("StarterGui"):SetCore("SendNotification",{
                        Title = "Exunys Developer";
                        Text = "Tracers will be now coming from the position of your mouse cursor on your screen (Mode 3)";
                        Duration = 5;
                    })
                end
            end
        elseif Input.KeyCode == _G.DisableKey and Typing == false then
            _G.TracersVisible = not _G.TracersVisible
            
            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "The tracers' visibility is now set to "..tostring(_G.TracersVisible)..".";
                    Duration = 5;
                })
            end
        end
    end)

    if _G.DefaultSettings == true then
        _G.TeamCheck = false
        _G.FromMouse = false
        _G.FromCenter = false
        _G.FromBottom = true
        _G.TracersVisible = true
        _G.TracerColor = Color3.fromRGB(40, 90, 255)
        _G.TracerThickness = 1
        _G.TracerTransparency = 0.5
        _G.ModeSkipKey = Enum.KeyCode.E
        _G.DisableKey = Enum.KeyCode.Q
    end

    local Success, Errored = pcall(function()
        CreateTracers()
    end)

    if Success and not Errored then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "Tracer script has successfully loaded.";
                Duration = 5;
            })
        end
    elseif Errored and not Success then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "Tracer script has errored while loading, please check the developer console! (F9)";
                Duration = 5;
            })
        end
        TestService:Message("The tracer script has errored, please notify Exunys with the following information :")
        warn(Errored)
        print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
    end
end)

-- Names
Visuals:addButton("Names", function()

local Typing = false

_G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
_G.DefaultSettings = false   -- If set to true then the ESP script would run with default settings regardless of any changes you made.

_G.TeamCheck = false   -- If set to true then the script would create ESP only for the enemy team members.

_G.ESPVisible = true   -- If set to true then the ESP will be visible and vice versa.
_G.TextColor = Color3.fromRGB(255, 80, 10)   -- The color that the boxes would appear as.
_G.TextSize = 14   -- The size of the text.
_G.Center = true   -- If set to true then the script would be located at the center of the label.
_G.Outline = true   -- If set to true then the text would have an outline.
_G.OutlineColor = Color3.fromRGB(0, 0, 0)   -- The outline color of the text.
_G.TextTransparency = 0.7   -- The transparency of the text.
_G.TextFont = Drawing.Fonts.UI   -- The font of the text. (UI, System, Plex, Monospace) 

_G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the ESP.

local function CreateESP()
    for _, v in next, Players:GetPlayers() do
        if v.Name ~= Players.LocalPlayer.Name then
            local ESP = Drawing.new("Text")

            RunService.RenderStepped:Connect(function()
                if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                    local Vector, OnScreen = Camera:WorldToViewportPoint(workspace[v.Name]:WaitForChild("Head", math.huge).Position)

                    ESP.Size = _G.TextSize
                    ESP.Center = _G.Center
                    ESP.Outline = _G.Outline
                    ESP.OutlineColor = _G.OutlineColor
                    ESP.Color = _G.TextColor
                    ESP.Transparency = _G.TextTransparency
                    ESP.Font = _G.TextFont

                    if OnScreen == true then
                        local Part1 = workspace:WaitForChild(v.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position
                        local Part2 = workspace:WaitForChild(Players.LocalPlayer.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position or 0
                        local Dist = (Part1 - Part2).Magnitude
                        ESP.Position = Vector2.new(Vector.X, Vector.Y - 25)
                        ESP.Text = ("("..tostring(math.floor(tonumber(Dist)))..") "..v.Name.." ["..workspace[v.Name].Humanoid.Health.."]")
                        if _G.TeamCheck == true then 
                            if Players.LocalPlayer.Team ~= v.Team then
                                ESP.Visible = _G.ESPVisible
                            else
                                ESP.Visible = false
                            end
                        else
                            ESP.Visible = _G.ESPVisible
                        end
                    else
                        ESP.Visible = false
                    end
                else
                    ESP.Visible = false
                end
            end)

            Players.PlayerRemoving:Connect(function()
                ESP.Visible = false
            end)
        end
    end

    Players.PlayerAdded:Connect(function(Player)
        Player.CharacterAdded:Connect(function(v)
            if v.Name ~= Players.LocalPlayer.Name then 
                local ESP = Drawing.new("Text")
    
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then
                        local Vector, OnScreen = Camera:WorldToViewportPoint(workspace[v.Name]:WaitForChild("Head", math.huge).Position)
    
                        ESP.Size = _G.TextSize
                        ESP.Center = _G.Center
                        ESP.Outline = _G.Outline
                        ESP.OutlineColor = _G.OutlineColor
                        ESP.Color = _G.TextColor
                        ESP.Transparency = _G.TextTransparency
    
                        if OnScreen == true then
                            local Part1 = workspace:WaitForChild(v.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position
                        local Part2 = workspace:WaitForChild(Players.LocalPlayer.Name, math.huge):WaitForChild("HumanoidRootPart", math.huge).Position or 0
                            local Dist = (Part1 - Part2).Magnitude
                            ESP.Position = Vector2.new(Vector.X, Vector.Y - 25)
                            ESP.Text = ("("..tostring(math.floor(tonumber(Dist)))..") "..v.Name.." ["..workspace[v.Name].Humanoid.Health.."]")
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= Player.Team then
                                    ESP.Visible = _G.ESPVisible
                                else
                                    ESP.Visible = false
                                end
                            else
                                ESP.Visible = _G.ESPVisible
                            end
                        else
                            ESP.Visible = false
                        end
                    else
                        ESP.Visible = false
                    end
                end)
    
                Players.PlayerRemoving:Connect(function()
                    ESP.Visible = false
                end)
            end
        end)
    end)
end

if _G.DefaultSettings == true then
    _G.TeamCheck = false
    _G.ESPVisible = true
    _G.TextColor = Color3.fromRGB(40, 90, 255)
    _G.TextSize = 14
    _G.Center = true
    _G.Outline = false
    _G.OutlineColor = Color3.fromRGB(0, 0, 0)
    _G.DisableKey = Enum.KeyCode.Q
    _G.TextTransparency = 0.75
end

UserInputService.TextBoxFocused:Connect(function()
    Typing = true
end)

UserInputService.TextBoxFocusReleased:Connect(function()
    Typing = false
end)

UserInputService.InputBegan:Connect(function(Input)
    if Input.KeyCode == _G.DisableKey and Typing == false then
        _G.ESPVisible = not _G.ESPVisible
        
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "The ESP's visibility is now set to "..tostring(_G.ESPVisible)..".";
                Duration = 5;
            })
        end
    end
end)

local Success, Errored = pcall(function()
    CreateESP()
end)

if Success and not Errored then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Exunys Developer";
            Text = "ESP script has successfully loaded.";
            Duration = 5;
        })
    end
elseif Errored and not Success then
    if _G.SendNotifications == true then
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title = "Exunys Developer";
            Text = "ESP script has errored while loading, please check the developer console! (F9)";
            Duration = 5;
        })
    end
    TestService:Message("The ESP script has errored, please notify Exunys with the following information :")
    warn(Errored)
    print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
end
end)

-- Heads
Visuals:addButton("Heads", function()
    local Typing = false
    
    _G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
    _G.DefaultSettings = false   -- If set to true then the heads script would run with default settings regardless of any changes you made.
    
    _G.TeamCheck = false   -- If set to true then the script would create head dots only for the enemy team members.
    
    _G.HeadDotsVisible = true   -- If set to true then the head dots will be visible and vice versa.
    _G.DotColor = Color3.fromRGB(255, 80, 10)   -- The color that the head dots would appear as.
    _G.DotSize = 5   -- The size of the head dot.
    _G.DotTransparency = 0.7   -- The transparency of the head dot.
    _G.DotSides = 100   -- How many sides will the dot have.
    _G.DotThickness = 1   -- How thick will the head dot be.
    _G.Filled = true   -- If set to true then the circle would be filled and vice versa.
    
    _G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the head dots.
    
    local function CreateHeadDots()
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= Players.LocalPlayer.Name then
                local HeadDot = Drawing.new("Circle")
    
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("Head") ~= nil then
                        local Vector, OnScreen = Camera:WorldToViewportPoint(workspace:WaitForChild(v.Name, math.huge).Head.Position)
    
                        HeadDot.Color = _G.DotColor
                        HeadDot.Radius = _G.DotSize
                        HeadDot.Transparency = _G.DotTransparency
                        HeadDot.NumSides = _G.DotSides
                        HeadDot.Thickness = _G.DotThickness
                        HeadDot.Filled = _G.Filled
    
                        if OnScreen == true then
                            HeadDot.Position = Vector2.new(Vector.X, Vector.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    HeadDot.Visible = _G.HeadDotsVisible
                                else
                                    HeadDot.Visible = false
                                end
                            else
                                HeadDot.Visible = _G.HeadDotsVisible
                            end
                        else
                            HeadDot.Visible = false
                        end
                    else
                        HeadDot.Visible = false
                    end
                end)
    
                Players.PlayerRemoving:Connect(function()
                    HeadDot.Visible = false
                end)
            end
        end
    
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function(v)
                if v.Name ~= Players.LocalPlayer.Name then
                    local HeadDot = Drawing.new("Circle")
        
                    RunService.RenderStepped:Connect(function()
                        if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("Head") ~= nil then
                            local Vector, OnScreen = Camera:WorldToViewportPoint(workspace:WaitForChild(v.Name, math.huge).Head.Position)
        
                            HeadDot.Color = _G.DotColor
                            HeadDot.Radius = _G.DotSize
                            HeadDot.Transparency = _G.DotTransparency
                            HeadDot.NumSides = _G.DotSides
                            HeadDot.Thickness = _G.DotThickness
                            HeadDot.Filled = _G.Filled
        
                            if OnScreen == true then
                                HeadDot.Position = Vector2.new(Vector.X, Vector.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Players:GetPlayerFromCharacter(v).Team then
                                        HeadDot.Visible = _G.HeadDotsVisible
                                    else
                                        HeadDot.Visible = false
                                    end
                                else
                                    HeadDot.Visible = _G.HeadDotsVisible
                                end
                            else
                                HeadDot.Visible = false
                            end
                        else
                            HeadDot.Visible = false
                        end
                    end)
    
                    Players.PlayerRemoving:Connect(function()
                        HeadDot.Visible = false
                    end)
                end
            end)
        end)
    end
    
    if _G.DefaultSettings == true then
        _G.TeamCheck = false
        _G.HeadDotsVisible = true
        _G.DotColor = Color3.fromRGB(40, 90, 255)
        _G.DotSize = 5
        _G.DotTransparency = 0.65
        _G.DotSides = 100
        _G.DotThickness = 1
        _G.Filled = true
        _G.DisableKey = Enum.KeyCode.Q
    end
    
    UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)
    
    UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)
    
    UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == _G.DisableKey and Typing == false then
            _G.HeadDotsVisible = not _G.HeadDotsVisible
            
            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "The Heads's visibility is now set to "..tostring(_G.HeadDotsVisible)..".";
                    Duration = 5;
                })
            end
        end
    end)
    
    local Success, Errored = pcall(function()
        CreateHeadDots()
    end)
    
    if Success and not Errored then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "Heads script has successfully loaded.";
                Duration = 5;
            })
        end
    elseif Errored and not Success then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "Heads script has errored while loading, please check the developer console! (F9)";
                Duration = 5;
            })
        end
        TestService:Message("The heads script has errored, please notify Exunys with the following information :")
        warn(Errored)
        print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
    end
    
    CreateHeadDots()    
end)

-- Head
Visuals:addButton("Boxes", function()
    local Typing = false
    
    _G.SendNotifications = true   -- If set to true then the script would notify you frequently on any changes applied and when loaded / errored. (If a game can detect this, it is recommended to set it to false)
    _G.DefaultSettings = false   -- If set to true then the boxes script would run with default settings regardless of any changes you made.
    
    _G.TeamCheck = false   -- If set to true then the script would create boxes only for the enemy team members.
    
    _G.BoxesVisible = true   -- If set to true then the boxes will be visible and vice versa.
    _G.LineColor = Color3.fromRGB(255, 80, 10)   -- The color that the boxes would appear as.
    _G.LineThickness = 1   -- The thickness of the boxes.
    _G.LineTransparency = 0.7   -- The transparency of the boxes.
    _G.SizeIncrease = 1   -- How much the box's size is increased (The size is multiplied by the value of this variable). (1 is default, anything more then 2 is not recommended) <float> / <int>
    
    _G.DisableKey = Enum.KeyCode.Q   -- The key that disables / enables the boxes.
    
    local function CreateBoxes()
        for _, v in next, Players:GetPlayers() do
            if v.Name ~= Players.LocalPlayer.Name then
                local TopLeftLine = Drawing.new("Line")
                local TopRightLine = Drawing.new("Line")
                local BottomLeftLine = Drawing.new("Line")
                local BottomRightLine = Drawing.new("Line")
    
                RunService.RenderStepped:Connect(function()
                    if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then 
                        TopLeftLine.Thickness = _G.LineThickness
                        TopLeftLine.Transparency = _G.LineTransparency
                        TopLeftLine.Color = _G.LineColor
    
                        TopRightLine.Thickness = _G.LineThickness
                        TopRightLine.Transparency = _G.LineTransparency
                        TopRightLine.Color = _G.LineColor
    
                        BottomLeftLine.Thickness = _G.LineThickness
                        BottomLeftLine.Transparency = _G.LineTransparency
                        BottomLeftLine.Color = _G.LineColor
    
                        BottomRightLine.Thickness = _G.LineThickness
                        BottomRightLine.Transparency = _G.LineTransparency
                        BottomRightLine.Color = _G.LineColor
                        
                        local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * _G.SizeIncrease
    
                        local TopLeftPosition, TopLeftVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(HumanoidRootPart_Size.X,  HumanoidRootPart_Size.Y, 0).p)
                        local TopRightPosition, TopRightVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(-HumanoidRootPart_Size.X,  HumanoidRootPart_Size.Y, 0).p)
                        local BottomLeftPosition, BottomLeftVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(HumanoidRootPart_Size.X, -HumanoidRootPart_Size.Y, 0).p)
                        local BottomRightPosition, BottomRightVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(-HumanoidRootPart_Size.X, -HumanoidRootPart_Size.Y, 0).p)
    
                        if TopLeftVisible == true then
                            TopLeftLine.From = Vector2.new(TopLeftPosition.X, TopLeftPosition.Y)
                            TopLeftLine.To = Vector2.new(TopRightPosition.X, TopRightPosition.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    TopLeftLine.Visible = _G.BoxesVisible
                                else
                                    TopLeftLine.Visible = false
                                end
                            else
                                TopLeftLine.Visible = _G.BoxesVisible
                            end
                        else
                            TopLeftLine.Visible = false
                        end
    
                        if TopRightVisible == true and _G.BoxesVisible == true then
                            TopRightLine.From = Vector2.new(TopRightPosition.X, TopRightPosition.Y)
                            TopRightLine.To = Vector2.new(BottomRightPosition.X, BottomRightPosition.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    TopRightLine.Visible = _G.BoxesVisible
                                else
                                    TopRightLine.Visible = false
                                end
                            else
                                TopRightLine.Visible = _G.BoxesVisible
                            end
                        else
                            TopRightLine.Visible = false
                        end
    
                        if BottomLeftVisible == true and _G.BoxesVisible == true then
                            BottomLeftLine.From = Vector2.new(BottomLeftPosition.X, BottomLeftPosition.Y)
                            BottomLeftLine.To = Vector2.new(TopLeftPosition.X, TopLeftPosition.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    BottomLeftLine.Visible = _G.BoxesVisible
                                else
                                    BottomLeftLine.Visible = false
                                end
                            else
                                BottomLeftLine.Visible = _G.BoxesVisible
                            end
                        else
                            BottomLeftLine.Visible = false
                        end
    
                        if BottomRightVisible == true and _G.BoxesVisible == true then
                            BottomRightLine.From = Vector2.new(BottomRightPosition.X, BottomRightPosition.Y)
                            BottomRightLine.To = Vector2.new(BottomLeftPosition.X, BottomLeftPosition.Y)
                            if _G.TeamCheck == true then 
                                if Players.LocalPlayer.Team ~= v.Team then
                                    BottomRightLine.Visible = _G.BoxesVisible
                                else
                                    BottomRightLine.Visible = false
                                end
                            else
                                BottomRightLine.Visible = _G.BoxesVisible
                            end
                        else
                            BottomRightLine.Visible = false
                        end
                    else
                        TopRightLine.Visible = false
                        TopLeftLine.Visible = false
                        BottomLeftLine.Visible = false
                        BottomRightLine.Visible = false
                    end
                end)
    
                Players.PlayerRemoving:Connect(function()
                    TopRightLine.Visible = false
                    TopLeftLine.Visible = false
                    BottomLeftLine.Visible = false
                    BottomRightLine.Visible = false
                end)
            end
        end
    
        Players.PlayerAdded:Connect(function(Player)
            Player.CharacterAdded:Connect(function(v)
                if v.Name ~= Players.LocalPlayer.Name then
                    local TopLeftLine = Drawing.new("Line")
                    local TopRightLine = Drawing.new("Line")
                    local BottomLeftLine = Drawing.new("Line")
                    local BottomRightLine = Drawing.new("Line")
        
                    RunService.RenderStepped:Connect(function()
                        if workspace:FindFirstChild(v.Name) ~= nil and workspace[v.Name]:FindFirstChild("HumanoidRootPart") ~= nil then 
                            TopLeftLine.Thickness = _G.LineThickness
                            TopLeftLine.Transparency = _G.LineTransparency
                            TopLeftLine.Color = _G.LineColor
        
                            TopRightLine.Thickness = _G.LineThickness
                            TopRightLine.Transparency = _G.LineTransparency
                            TopRightLine.Color = _G.LineColor
        
                            BottomLeftLine.Thickness = _G.LineThickness
                            BottomLeftLine.Transparency = _G.LineTransparency
                            BottomLeftLine.Color = _G.LineColor
        
                            BottomRightLine.Thickness = _G.LineThickness
                            BottomRightLine.Transparency = _G.LineTransparency
                            BottomRightLine.Color = _G.LineColor
                            
                            local HumanoidRootPart_Position, HumanoidRootPart_Size = workspace[v.Name].HumanoidRootPart.CFrame, workspace[v.Name].HumanoidRootPart.Size * _G.SizeIncrease
        
                            local TopLeftPosition, TopLeftVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(HumanoidRootPart_Size.X,  HumanoidRootPart_Size.Y, 0).p)
                            local TopRightPosition, TopRightVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(-HumanoidRootPart_Size.X,  HumanoidRootPart_Size.Y, 0).p)
                            local BottomLeftPosition, BottomLeftVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(HumanoidRootPart_Size.X, -HumanoidRootPart_Size.Y, 0).p)
                            local BottomRightPosition, BottomRightVisible = Camera:WorldToViewportPoint(HumanoidRootPart_Position * CFrame.new(-HumanoidRootPart_Size.X, -HumanoidRootPart_Size.Y, 0).p)
        
                            if TopLeftVisible == true then
                                TopLeftLine.From = Vector2.new(TopLeftPosition.X, TopLeftPosition.Y)
                                TopLeftLine.To = Vector2.new(TopRightPosition.X, TopRightPosition.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        TopLeftLine.Visible = _G.BoxesVisible
                                    else
                                        TopLeftLine.Visible = false
                                    end
                                else
                                    TopLeftLine.Visible = _G.BoxesVisible
                                end
                            else
                                TopLeftLine.Visible = false
                            end
        
                            if TopRightVisible == true and _G.BoxesVisible == true then
                                TopRightLine.From = Vector2.new(TopRightPosition.X, TopRightPosition.Y)
                                TopRightLine.To = Vector2.new(BottomRightPosition.X, BottomRightPosition.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        TopRightLine.Visible = _G.BoxesVisible
                                    else
                                        TopRightLine.Visible = false
                                    end
                                else
                                    TopRightLine.Visible = _G.BoxesVisible
                                end
                            else
                                TopRightLine.Visible = false
                            end
        
                            if BottomLeftVisible == true and _G.BoxesVisible == true then
                                BottomLeftLine.From = Vector2.new(BottomLeftPosition.X, BottomLeftPosition.Y)
                                BottomLeftLine.To = Vector2.new(TopLeftPosition.X, TopLeftPosition.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        BottomLeftLine.Visible = _G.BoxesVisible
                                    else
                                        BottomLeftLine.Visible = false
                                    end
                                else
                                    BottomLeftLine.Visible = _G.BoxesVisible
                                end
                            else
                                BottomLeftLine.Visible = false
                            end
        
                            if BottomRightVisible == true and _G.BoxesVisible == true then
                                BottomRightLine.From = Vector2.new(BottomRightPosition.X, BottomRightPosition.Y)
                                BottomRightLine.To = Vector2.new(BottomLeftPosition.X, BottomLeftPosition.Y)
                                if _G.TeamCheck == true then 
                                    if Players.LocalPlayer.Team ~= Player.Team then
                                        BottomRightLine.Visible = _G.BoxesVisible
                                    else
                                        BottomRightLine.Visible = false
                                    end
                                else
                                    BottomRightLine.Visible = _G.BoxesVisible
                                end
                            else
                                BottomRightLine.Visible = false
                            end
                        else
                            TopRightLine.Visible = false
                            TopLeftLine.Visible = false
                            BottomLeftLine.Visible = false
                            BottomRightLine.Visible = false
                        end
                    end)
        
                    Players.PlayerRemoving:Connect(function()
                        TopRightLine.Visible = false
                        TopLeftLine.Visible = false
                        BottomLeftLine.Visible = false
                        BottomRightLine.Visible = false
                    end)
                end
            end)
        end)
    end
    
    if _G.DefaultSettings == true then
        _G.TeamCheck = false
        _G.BoxesVisible = true
        _G.LineColor = Color3.fromRGB(40, 90, 255)
        _G.LineThickness = 1
        _G.LineTransparency = 0.5
        _G.SizeIncrease = 1.5
        _G.DisableKey = Enum.KeyCode.Q
    end
    
    UserInputService.TextBoxFocused:Connect(function()
        Typing = true
    end)
    
    UserInputService.TextBoxFocusReleased:Connect(function()
        Typing = false
    end)
    
    UserInputService.InputBegan:Connect(function(Input)
        if Input.KeyCode == _G.DisableKey and Typing == false then
            _G.BoxesVisible = not _G.BoxesVisible
            
            if _G.SendNotifications == true then
                game:GetService("StarterGui"):SetCore("SendNotification",{
                    Title = "Exunys Developer";
                    Text = "The boxes' visibility is now set to "..tostring(_G.BoxesVisible)..".";
                    Duration = 5;
                })
            end
        end
    end)
    
    local Success, Errored = pcall(function()
        CreateBoxes()
    end)
    
    if Success and not Errored then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "Boxes script has successfully loaded.";
                Duration = 5;
            })
        end
    elseif Errored and not Success then
        if _G.SendNotifications == true then
            game:GetService("StarterGui"):SetCore("SendNotification",{
                Title = "Exunys Developer";
                Text = "Boxes script has errored while loading, please check the developer console! (F9)";
                Duration = 5;
            })
        end
        TestService:Message("The boxes script has errored, please notify Exunys with the following information :")
        warn(Errored)
        print("!! IF THE ERROR IS A FALSE POSITIVE (says that a player cannot be found) THEN DO NOT BOTHER !!")
    end
    
end)

end

-- Games List
pcall(function()
    local games     = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/Commandcracker/Magma-Hub/main/games.json"))
    local GamesPage = MagmaHub:addPage("Games")

    for _,v in pairs(games) do
        GamesPage:addButton(v.Name, function()
            TeleportService:Teleport(v.RootPlace, LocalPlayer)
        end)
    end
end)

-- Other Games
local successed, errData = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Commandcracker/Magma-Hub/main/games/"..game.GameId..".lua"))()
end)

if successed then
    --[[
        local GameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        print("Game: "..GameInfo.Name)
    ]]
    MagmaHub:Notify("Game Supported")
elseif errData ~= nil then
    if errData == "HTTP 404 (Not Found)" then
        MagmaHub:Notify("Game Not Supported")
    else
        MagmaHub:Notify("Failed To load game scripts", 1)
        warn(errData)
    end
end

-- Load
MagmaHub:load()
