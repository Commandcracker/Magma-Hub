-- Magnet Simulator
local Page = MagmaHub:addPage("Magnet Simulator")

-- Services
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- Auto Sell
local Sell      = game.Workspace.Rings.Sellx2
local pos       = Sell.CFrame
local AutoSell  = Page:addToggle("Auto Sell",nil,function()
    if firetouchinterest == nil then
        Sell.CanCollide = true
        Sell.CFrame     = pos
    end
end)

Threads:Add(function()
    while wait() do
        if AutoSell:IsEnabeld() then
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
end)

LocalPlayer.PlayerGui.GameHUD.FullBackpack.Changed:Connect(function()
    if AutoSell:IsEnabeld() then
        LocalPlayer.PlayerGui.GameHUD.FullBackpack.Visible = false
    end
end)

-- Teleports
local Teleports = MagmaHub:addPage("Teleports")

-- Spawn
Teleports:addButton("Spawn", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(127,14,-81)
end)

-- Magnet Island
Teleports:addButton("Magnet Island", function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16,580,-273)
end)

-- Auto Collect Coins
local AutoCollectCoins = Page:addToggle("Auto Collect Coins")

Threads:Add(function()
    while wait() do
        if AutoCollectCoins:IsEnabeld() then
            ReplicatedStorage.Events.MagnetEvents.requestGrab:FireServer("6080000000", ReplicatedStorage.Tools["Lucky Long Tri-Magnet"])
        end
    end
end)

-- Auto Rebirth
local AutoRebirth = MagmaHub:addPage("Auto Rebirth")

local Rebirths = {
    200000,
    125000,
    100000,
    75000,
    50000,
    25000,
    10000,
    5000,
    2500,
    1000,
    500,
    250,
    100,
    50,
    25,
    5,
    1
}

local AutoRebirthCanAfford = AutoRebirth:addToggle("Auto Rebirth (Can Afford)")
Threads:Add(function()
    while wait() do
        if AutoRebirthCanAfford:IsEnabeld() then
            for _,v in pairs(Rebirths) do
                ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(v)
            end
        end
    end
end)

for _,v in pairs(Btable.Reverse(Rebirths)) do
    local AutoRebirthButton = AutoRebirth:addToggle("Auto Rebirth "..tostring(v))
    local Rebirth           = v
    Threads:Add(function()
        while wait() do
            if AutoRebirthButton:IsEnabeld() then
                ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(Rebirth)
            end
        end
    end)
end
