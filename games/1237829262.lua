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

local AutoRebirthCanAfford = AutoRebirth.CreateToggelButton("Auto Rebirth (Can Afford)")
coroutine.wrap(function()
    while wait() do
        if AutoRebirthCanAfford.IsEnabeld() then
            for _,v in pairs(Rebirths) do
                ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(v)
            end
        end
    end
end)()

function ReverseTable(t)
    local reversedTable = {}
    local itemCount = #t
    for k, v in ipairs(t) do
        reversedTable[itemCount + 1 - k] = v
    end
    return reversedTable
end

for _,v in pairs(ReverseTable(Rebirths)) do
    local AutoRebirthButton = AutoRebirth.CreateToggelButton("Auto Rebirth "..tostring(v))
    local Rebirth           = v
    coroutine.wrap(function()
        while wait() do
            if AutoRebirthButton.IsEnabeld() then
                ReplicatedStorage.RebirthEvents.requestRebirth:InvokeServer(Rebirth)
            end
        end
    end)()
end
