-- Magnet Simulator
local Category = HUB_API.CreateCategory("Magnet Simulator")

-- Services
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer       = Players.LocalPlayer

-- Auto Sell
local Sell      = game.Workspace.Rings.Sellx2
local pos       = Sell.CFrame
local AutoSell  = Category.CreateToggelButton("Auto Sell",nil,function()
    if firetouchinterest == nil then
        Sell.CanCollide = true
        Sell.CFrame     = pos
    end
end)

coroutine.wrap(function()
    while wait() do
        if AutoSell.IsEnabeld() then
            if firetouchinterest == nil then
                Sell.CanCollide = false
                Sell.CFrame     = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,math.random(-1,1),0)
            else 
                if LocalPlayer.Character ~= nil and LocalPlayer.Character.HumanoidRootPart ~= nil then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, game.Workspace.Rings.Sellx2, 0)
                    wait()
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, game.Workspace.Rings.Sellx2, 1)
                end                
            end
        end
    end
end)()

LocalPlayer.PlayerGui.GameHUD.FullBackpack.Changed:Connect(function()
    if AutoSell.IsEnabeld() then
        LocalPlayer.PlayerGui.GameHUD.FullBackpack.Visible = false
    end
end)

-- Teleports
local Teleports = HUB_API.CreateCategory("Teleports")

Teleports.CreateButton("Spawn", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(127,14,-81)
end)

Teleports.CreateButton("Magnet Island", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16,580,-273)
end)

-- Auto Collect Coins
local AutoCollectCoins = Category.CreateToggelButton("Auto Collect Coins")

coroutine.wrap(function()
    while wait() do
        if AutoCollectCoins.IsEnabeld() then
            ReplicatedStorage.Events.MagnetEvents.requestGrab:FireServer("6080000000", ReplicatedStorage.Tools["Lucky Long Tri-Magnet"])
        end
    end
end)()

-- Auto Rebirth
local AutoRebirth = HUB_API.CreateCategory("Auto Rebirth")

local AutoRebirthCanAfford = AutoRebirth.CreateToggelButton("Auto Rebirth (Can Afford)")
coroutine.wrap(function()
    while wait() do
        if AutoRebirthCanAfford.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(1000)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(500)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(250)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(100)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(50)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(25)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(5)
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(1)
        end
    end
end)()

local AutoRebirth1 = AutoRebirth.CreateToggelButton("Auto Rebirth 1")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth1.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(1)
        end
    end
end)()

local AutoRebirth5 = AutoRebirth.CreateToggelButton("Auto Rebirth 5")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth5.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(5)
        end
    end
end)()

local AutoRebirth25 = AutoRebirth.CreateToggelButton("Auto Rebirth 25")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth25.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(25)
        end
    end
end)()

local AutoRebirth50 = AutoRebirth.CreateToggelButton("Auto Rebirth 50")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth50.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(50)
        end
    end
end)()

local AutoRebirth100 = AutoRebirth.CreateToggelButton("Auto Rebirth 100")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth100.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(100)
        end
    end
end)()

local AutoRebirth250 = AutoRebirth.CreateToggelButton("Auto Rebirth 250")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth250.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(250)
        end
    end
end)()

local AutoRebirth500 = AutoRebirth.CreateToggelButton("Auto Rebirth 500")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth500.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(500)
        end
    end
end)()

local AutoRebirth1000 = AutoRebirth.CreateToggelButton("Auto Rebirth 1.000")
coroutine.wrap(function()
    while wait() do
        if AutoRebirth1000.IsEnabeld() then
            ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(1000)
        end
    end
end)()
