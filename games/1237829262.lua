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
local AutoCollectCoins = Category.CreateToggelButton("Auto Collect Coins (Equip Your Magnet)")

coroutine.wrap(function()
    while wait() do
        if AutoCollectCoins.IsEnabeld() then
            ReplicatedStorage.Events.MagnetEvents.requestGrab:FireServer("6080000000", LocalPlayer.Character:FindFirstChildOfClass("Tool"))
        end
    end
end)()
