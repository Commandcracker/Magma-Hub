--[[
    Magma Hub
    © Commandcracker

    https://github.com/Commandcracker/Magma-Hub
]]

-- Services
local UserInputService  = game:GetService("UserInputService")
local VirtualUser       = game:GetService("VirtualUser")
local Players           = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer

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

-- Utilitys
local util = {}

function util:DraggingEnabled(frame, parent)
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
            local delta = input.Position - mousePos
            parent.Position  = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

-- GUI
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
coroutine.wrap(function()
    local function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
    local counter = 0

    while wait(.1) do
        RGBBar.BackgroundColor3 = Color3.fromHSV(zigzag(counter),1,1)
        counter = counter + .01
    end
end)()
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

local CategoryFrame                = Instance.new("ScrollingFrame", MainFrame)
CategoryFrame.Size                 = UDim2.new(0, 100, 1, -35)
CategoryFrame.Position             = UDim2.new(0, 0, 0, 35)
CategoryFrame.BorderSizePixel      = 0
CategoryFrame.ScrollBarThickness   = 5
CategoryFrame.BackgroundColor3     = Color3.fromRGB(14, 14, 14)
CategoryFrame.ScrollBarImageColor3 = Color3.fromRGB(4, 4, 4)
CategoryFrame.AutomaticCanvasSize  = Enum.AutomaticSize.Y

local CategoryFrame_UIListLayout    = Instance.new("UIListLayout", CategoryFrame)
CategoryFrame_UIListLayout.Padding  = UDim.new(0, 5)

-- Legacy HUB_API
HUB_API = {}
local CurrentCategory = nil

function HUB_API.CreateCategory(Text)
    local Category = {}

    Category.ModuleList                          = Instance.new("ScrollingFrame", MainFrame)
    Category.ModuleList.Size                     = UDim2.new(1, -105, 1, -40)
    Category.ModuleList.Position                 = UDim2.new(0, 105, 0, 40)
    Category.ModuleList.BorderSizePixel          = 0
    Category.ModuleList.ScrollBarThickness       = 5
    Category.ModuleList.BackgroundTransparency   = 1
    Category.ModuleList.ScrollBarImageColor3     = Color3.fromRGB(4, 4, 4)
    Category.ModuleList.Visible                  = false
    Category.ModuleList.AutomaticCanvasSize      = Enum.AutomaticSize.Y

    Category.ModuleList_UIListLayout            = Instance.new("UIListLayout", Category.ModuleList)
    Category.ModuleList_UIListLayout.Padding    = UDim.new(0, 5)

    Category.Button                      = Instance.new("TextButton", CategoryFrame)
    Category.Button.Size                 = UDim2.new(1, 0, 0, 35)
    Category.Button.Font                 = Enum.Font.Gotham
    Category.Button.Text                 = Text
    Category.Button.TextSize             = 14
    Category.Button.TextColor3           = Color3.fromRGB(255, 255, 255)
    Category.Button.TextWrapped          = true
    Category.Button.BackgroundColor3     = Color3.fromRGB(14, 14, 14)
    Category.Button.BorderSizePixel      = 0
    Category.Button.TextTransparency     = 0.65

    function Category.Hide()
        Category.ModuleList.Visible         = false
        Category.Button.Font                = Enum.Font.Gotham
        Category.Button.TextTransparency    = 0.65
    end

    function Category.Show()
        if CurrentCategory ~= nil then
            CurrentCategory.Hide()
        end

        Category.ModuleList.Visible         = true
        CurrentCategory                     = Category
        Category.Button.Font                = Enum.Font.GothamSemibold
        Category.Button.TextTransparency    = 0
    end

    Category.Button.MouseButton1Click:Connect(function()
        Category.Show()
    end)

    function Category.CreateButton(Text, Function)
        local Module = {}

        Module.Frame                    = Instance.new("Frame", Category.ModuleList)
        Module.Frame.BorderSizePixel    = 0
        Module.Frame.BackgroundColor3   = Color3.fromRGB(14, 14, 14)
        Module.Frame.Size               = UDim2.new(1, -10, 0, 30)

        Module.TextLabel                            = Instance.new("TextLabel", Module.Frame)
        Module.TextLabel.TextColor3                 = Color3.new(1,1,1)
        Module.TextLabel.Text                       = Text
        Module.TextLabel.TextWrapped                = true
        Module.TextLabel.Font                       = Enum.Font.Gotham
        Module.TextLabel.BackgroundTransparency     = 1
        Module.TextLabel.Position                   = UDim2.new(0.02, 0, 0, 0)
        Module.TextLabel.TextXAlignment             = Enum.TextXAlignment.Left
        Module.TextLabel.Size                       = UDim2.new(0, 313, 1, 0)
        Module.TextLabel.TextSize                   = 12

        Module.Button                   = Instance.new("TextButton", Module.Frame)
        Module.Button.TextColor3        = Color3.new(1,1,1)
        Module.Button.Text              = "Run"
        Module.Button.Font              = Enum.Font.Gotham
        Module.Button.Position          = UDim2.new(0.89, 0, 0.25, -2)
        Module.Button.TextSize          = 12
        Module.Button.Size              = UDim2.new(0, 35, 1, -10)
        Module.Button.BorderSizePixel   = 0
        Module.Button.BackgroundColor3  = Color3.fromRGB(20, 20, 20)

        if Function ~= nil then
            Module.Button.MouseButton1Click:Connect(Function)
        end

        return Module
    end

    function Category.CreateToggelButton(Text, EnableFunction, DisableFunction)
        local Module        = Category.CreateButton(Text)
        Module.Button.Text  = "Off"
        local Toggel        = false

        Module.Button.MouseButton1Click:Connect(function()
            if Toggel then
                Toggel = false
                Module.Button.Text = "Off"
                if DisableFunction ~= nil then
                    DisableFunction()
                end
            else
                Toggel = true
                Module.Button.Text = "On"
                if EnableFunction ~= nil then
                    EnableFunction()
                end
            end
        end)

        function Module.IsEnabeld()
            return Toggel
        end

        function Module.SetEnableFunction(Function)
            EnableFunction = Function
        end

        function Module.SetDisableFunction(Function)
            DisableFunction = Function
        end

        return Module
    end

    function Category.CreateInputButton(Text, Function)
        local Module = Category.CreateButton(Text)

        Module.TextLabel.Size = UDim2.new(0, 231, 1, 0)

        Module.TextBox                     = Instance.new("TextBox", Module.Frame)
        Module.TextBox.TextColor3          = Color3.new(1,1,1)
        Module.TextBox.Text                = ""
        Module.TextBox.Font                = Enum.Font.Gotham
        Module.TextBox.Position            = UDim2.new(1, -125, 0.25, -2)
        Module.TextBox.Size                = UDim2.new(0, 75, 1, -10)
        Module.TextBox.TextSize            = 12
        Module.TextBox.BorderSizePixel     = 0
        Module.TextBox.BackgroundColor3    = Color3.fromRGB(20, 20, 20)

        Module.Button.MouseButton1Click:Connect(function()
            Function(Module.TextBox.Text)
        end)

        return Module
    end

    return Category
end

-- Scripts
local LocalPlayerCategory = HUB_API.CreateCategory("Local Player")
LocalPlayerCategory.Show()

LocalPlayerCategory.CreateInputButton("WalkSpeed", function(inp)
    game.Players.LocalPlayer.Character:WaitForChild("Humanoid").WalkSpeed = inp
end)

LocalPlayerCategory.CreateInputButton("JumpPower", function(inp)
    local Humanoid          = LocalPlayer.Character:WaitForChild("Humanoid")
    Humanoid.UseJumpPower   = true
    Humanoid.JumpPower      = inp
end)

LocalPlayerCategory.CreateInputButton("Teleport To Player", function(inp)
    for _,player in pairs(game.Players:GetPlayers()) do
        if inp == string.sub(player.Name,1,#inp) then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, -1)
        end
    end
end)

LocalPlayerCategory.CreateButton("Fullbright", function()
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

local NoclipButton = LocalPlayerCategory.CreateToggelButton("Noclip")

coroutine.wrap(function()
    while true do
        if NoclipButton.IsEnabeld() then
            for _,v in pairs(game.Players.LocalPlayer.Character:children()) do
                pcall(function()
                    if v.className == "Part" then
                        v.CanCollide = false
                    end
                end)
            end
        end
        game:service("RunService").Stepped:wait()
    end
end)()

local InfinityJumpButton = LocalPlayerCategory.CreateToggelButton("Infinity Jump")

game:GetService("UserInputService").JumpRequest:connect(function()
    if InfinityJumpButton.IsEnabeld() then
        game.Players.LocalPlayer.Character:FindFirstChildOfClass'Humanoid':ChangeState("Jumping")
    end
end)

LocalPlayerCategory.CreateButton("Suicid", function()
    game.Players.LocalPlayer.Character:WaitForChild("Humanoid").Health = 0
end)

-- Fly
local FlyButton = LocalPlayerCategory.CreateToggelButton("Fly")
local mouse     = game.Players.LocalPlayer:GetMouse()
local plr       = game.Players.LocalPlayer
local ctrl      = {f = 0, b = 0, l = 0, r = 0}
local lastctrl  = {f = 0, b = 0, l = 0, r = 0}
local maxspeed  = 50
local speed     = 0
local bg        = nil
local bv        = nil

function Fly()
    local Torso = plr.Character:FindFirstChild("Torso")

    if Torso == nil then
        Torso = plr.Character:FindFirstChild("LowerTorso")
    end

    if Torso == nil then
        Torso = plr.Character:FindFirstChild("HumanoidRootPart")
    end

    bg = Instance.new("BodyGyro", Torso)
    bg.P = 9e4
    bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    bg.cframe = Torso.CFrame
    bv = Instance.new("BodyVelocity", Torso)
    bv.velocity = Vector3.new(0,0.1,0)
    bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
    repeat wait()
        plr.Character.Humanoid.PlatformStand = true
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
    until not FlyButton.IsEnabeld()
    ctrl = {f = 0, b = 0, l = 0, r = 0}
    lastctrl = {f = 0, b = 0, l = 0, r = 0}
    speed = 0
    bg:Destroy()
    bg = nil
    bv:Destroy()
    bv = nil
    plr.Character.Humanoid.PlatformStand = false
end

--Controls
mouse.KeyDown:connect(function(key)
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

mouse.KeyUp:connect(function(key)
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

FlyButton.SetEnableFunction(function()
    Fly()
end)

LocalPlayerCategory.CreateInputButton("Zoom Distance",function (inp)
    game.Players.LocalPlayer.CameraMaxZoomDistance = inp
end)

-- Universal
local UniversalCategory = HUB_API.CreateCategory("Universal")

UniversalCategory.CreateButton("DexExplorer", function()
    loadstring(game:GetObjects("rbxassetid://418957341")[1].Source)()
end)

UniversalCategory.CreateButton("CMD-X", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/CMD-X/CMD-X/master/Source", true))()
end)

UniversalCategory.CreateButton("Infinite Yield", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
end)

UniversalCategory.CreateButton("SimpleSpy", function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/exxtremestuffs/SimpleSpySource/master/SimpleSpy.lua'))()
end)

UniversalCategory.CreateButton("F3X", function()
    loadstring(game:GetObjects("rbxassetid://4698064966")[1].Source)()
end)

UniversalCategory.CreateButton("Btools", function()
    local backpack = game:GetService("Players").LocalPlayer.Backpack

    local hammer        = Instance.new("HopperBin")
    hammer.Name         = "Hammer"
    hammer.BinType      = 4
    hammer.Parent       = backpack
    
    local cloneTool     = Instance.new("HopperBin")
    cloneTool.Name      = "Clone"
    cloneTool.BinType   = 3
    cloneTool.Parent    = backpack
    
    local grabTool      = Instance.new("HopperBin")
    grabTool.Name       = "Grab"
    grabTool.BinType    = 2
    grabTool.Parent     = backpack
end)

local AntiAFKButton = UniversalCategory.CreateToggelButton("Anti AFK")

LocalPlayer.Idled:connect(function()
    if AntiAFKButton.IsEnabeld() then
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
        print("[Magma Hub] Reflected idle Kick")
        game.StarterGui:SetCore("SendNotification", {Title="Magma Hub"; Text="Reflected idle Kick"; Duration=2;})
    end
end)

--ESP
local ESPButton     = UniversalCategory.CreateToggelButton("ESP")
local localPlayer   = game.Players.LocalPlayer
local RunService    = game:GetService("RunService")

local function HighlightModel(Model)
    if ESPButton.IsEnabeld() then
        for _,v in pairs(Model:children())do
            if Model.Name ~= localPlayer.Name then
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

for _,player in pairs(game.Players:GetPlayers())do
    player.Changed:connect(function()
        if player ~= nil and player.Character ~= nil  then
            RunService.Stepped:wait()
            HighlightModel(player.Character)
        end
    end)
end

game.Players.PlayerAdded:connect(function(player)
    player.Changed:connect(function()
        if player ~= nil and player.Character ~= nil then
            RunService.Stepped:wait()
            HighlightModel(player.Character)
        end
    end)
end)

ESPButton.SetDisableFunction(function()
    for _,player in pairs(game.Players:GetPlayers())do
        UnHighlightModel(player.Character)
    end
end)

ESPButton.SetEnableFunction(function()
    for _,player in pairs(game.Players:GetPlayers())do
        HighlightModel(player.Character)
    end
end)

UniversalCategory.CreateButton("Aimbot GUI", function()
    PLAYER  = game.Players.LocalPlayer
    MOUSE   = PLAYER:GetMouse()
    CC      = game.Workspace.CurrentCamera

    ENABLED      = false
    ESP_ENABLED  = false

    _G.FREE_FOR_ALL = true

    _G.ESP_BIND    = 52
    _G.CHANGE_AIM  = 'q'

    _G.AIM_AT = 'Head'

    wait(1)

    function GetNearestPlayerToMouse()
        local PLAYERS      = {}
        local PLAYER_HOLD  = {}
        local DISTANCES    = {}
        for i, v in pairs(game.Players:GetPlayers()) do
            if v ~= PLAYER then
                table.insert(PLAYERS, v)
            end
        end
        for i, v in pairs(PLAYERS) do
            if _G.FREE_FOR_ALL == false then
                if v and (v.Character) ~= nil and v.TeamColor ~= PLAYER.TeamColor then
                    local AIM = v.Character:FindFirstChild(_G.AIM_AT)
                    if AIM ~= nil then
                        local DISTANCE                 = (AIM.Position - game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude
                        local RAY                      = Ray.new(game.Workspace.CurrentCamera.CoordinateFrame.p, (MOUSE.Hit.p - CC.CoordinateFrame.p).unit * DISTANCE)
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
                    local RAY                      = Ray.new(game.Workspace.CurrentCamera.CoordinateFrame.p, (MOUSE.Hit.p - CC.CoordinateFrame.p).unit * DISTANCE)
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

    GUI_MAIN                           = Instance.new('ScreenGui', game.CoreGui)
    GUI_TARGET                         = Instance.new('TextLabel', GUI_MAIN)
    GUI_AIM_AT                         = Instance.new('TextLabel', GUI_MAIN)

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

    function CREATE(BASE, TEAM)
        local ESP_MAIN                   = Instance.new('BillboardGui', PLAYER.PlayerGui)
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

    function CLEAR()
        for _,v in pairs(PLAYER.PlayerGui:children()) do
            if v.Name == 'ESP' and v:IsA('BillboardGui') then
                v:Destroy()
            end
        end
    end

    function FIND()
        CLEAR()
        TRACK = true
        spawn(function()
            while wait() do
                if TRACK then
                    CLEAR()
                    for i,v in pairs(game.Players:GetChildren()) do
                        if v.Character and v.Character:FindFirstChild('Head') then
                            if _G.FREE_FOR_ALL == false then
                                if v.TeamColor ~= PLAYER.TeamColor then
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

    MOUSE.Button2Down:connect(function()
        ENABLED = true
    end)

    MOUSE.Button2Up:connect(function()
        ENABLED = false
    end)

    MOUSE.KeyDown:connect(function(KEY)
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

    MOUSE.KeyDown:connect(function(KEY)
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

    game:GetService('RunService').RenderStepped:connect(function()
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
local FEInvisible = UniversalCategory.CreateToggelButton("FE Invisible")

local touched 		= false
local box           = nil
local loc

LocalPlayer.CharacterAdded:connect(function(character)
    if FEInvisible.IsEnabeld() then
        repeat wait() until character.HumanoidRootPart
        loc = character.HumanoidRootPart.Position
        character:MoveTo(box.Position + Vector3.new(0,.5,0))
    end
end)

FEInvisible.SetEnableFunction(function()
    if box == nil then
        box 		    = Instance.new('Part',workspace)
        box.Anchored 	= true
        box.CanCollide 	= true
        box.Size 		= Vector3.new(10,1,10)
        box.Position 	= Vector3.new(0,10000,0)
        box.Touched:connect(function(part)
            if (part.Parent.Name == LocalPlayer.Name) then
                if touched == false then
                    touched = true
                    if LocalPlayer.Character and FEInvisible.IsEnabeld() then
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

FEInvisible.SetDisableFunction(function()
    if LocalPlayer.Character ~= nil then

        local function respawn(plr)
            local char = plr.Character
            if char:FindFirstChildOfClass("Humanoid") then char:FindFirstChildOfClass("Humanoid"):ChangeState(15) end
            char:ClearAllChildren()
            local newChar = Instance.new("Model")
            newChar.Parent = workspace
            plr.Character = newChar
            wait()
            plr.Character = char
            newChar:Destroy()
        end

        local function refresh(plr)
            local Human = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid", true)
            local pos = Human and Human.RootPart and Human.RootPart.CFrame
            local pos1 = workspace.CurrentCamera.CFrame
            respawn(plr)
            task.spawn(function()
                plr.CharacterAdded:Wait():WaitForChild("Humanoid").RootPart.CFrame, workspace.CurrentCamera.CFrame = pos, wait() and pos1
            end)
        end

        refresh(LocalPlayer)
    end
end)

-- Coppy
if setclipboard ~= nil then
    local CoppyCategory = HUB_API.CreateCategory("Coppy")

    CoppyCategory.CreateButton("GameId/UniverseId", function()
        setclipboard(tostring(game.GameId))
    end)

    CoppyCategory.CreateButton("Position", function()
        local pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Position
        setclipboard(math.floor(pos.X)..", "..math.floor(pos.Y)..", "..math.floor(pos.Z))
    end)

    CoppyCategory.CreateButton("PlaceId", function()
        setclipboard(tostring(game.PlaceId))
    end)
end

-- Other Games
local successed, errData = pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Commandcracker/Magma-Hub/main/games/"..game.GameId..".lua"))()
end)

if successed then
    --local GameInfo = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    --print("Game: "..GameInfo.Name)
    print("[Magma Hub] Game Supported")
    game.StarterGui:SetCore("SendNotification", {Title="Magma Hub"; Text="Game Supported"; Duration=2;})
elseif errData ~= nil then
    if errData == "HTTP 404 (Not Found)" then
        print("[Magma Hub] Game Not Supported")
        game.StarterGui:SetCore("SendNotification", {Title="Magma Hub"; Text="Game Not Supported"; Duration=2;})
    else
        warn("[Magma Hub] Failed To load game scripts")
        game.StarterGui:SetCore("SendNotification", {Title="Magma Hub"; Text="Failed To load game scripts"; Duration=2;})
        warn(errData)
    end
end

-- Animate GUI in and Enable Dragging
util:DraggingEnabled(MainFrame)
MainFrame:TweenPosition(UDim2.new(0.5, -250, 0.5, -196), Enum.EasingDirection.In, Enum.EasingStyle.Sine, 1)
