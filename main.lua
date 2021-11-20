--[[
    Magma Hub
    © Commandcracker

    https://github.com/Commandcracker/Magma-Hub
]]

-- Variables
local LocalPlayer = game.Players.LocalPlayer

-- Services
local UserInputService = game:GetService("UserInputService")

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

local CategoryFrame                     = Instance.new("ScrollingFrame", MainFrame)
CategoryFrame.Size                      = UDim2.new(0, 100, 1, -35)
CategoryFrame.Position                  = UDim2.new(0, 0, 0, 35)
CategoryFrame.BorderSizePixel           = 0
CategoryFrame.ScrollBarThickness        = 5
CategoryFrame.BackgroundColor3          = Color3.fromRGB(14, 14, 14)
CategoryFrame.ScrollBarImageColor3      = Color3.fromRGB(4, 4, 4)

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

if firesignal ~= nil then
    local AntiAFKButton = UniversalCategory.CreateToggelButton("Anti AFK")
    local UserInputService: UserInputService = game:GetService("UserInputService")
    local RunService: RunService = game:GetService("RunService")
    UserInputService.WindowFocusReleased:Connect(function()
        if AntiAFKButton.IsEnabeld() then
            RunService.Stepped:Wait()
            pcall(firesignal, UserInputService.WindowFocused)
        end
    end)
end

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
