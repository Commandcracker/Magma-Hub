-- Pet Simulator X
local Page = MagmaHub:addPage("Pet Simulator X")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Auto Collect Orbs
local AutoCollectOrbs = Page:addToggle("Auto Collect Orbs")

Threads:Add(function()
    while wait() do
        if AutoCollectOrbs:IsEnabeld() then
            for _, v in pairs(workspace["__THINGS"].Orbs:GetChildren()) do
                v.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Auto Collect Lootbags
local AutoCollectLootbags = Page:addToggle("Auto Collect Lootbags")

Threads:Add(function()
    while wait() do
        if AutoCollectLootbags:IsEnabeld() then
            for _, v in pairs(workspace["__THINGS"].Lootbags:GetChildren()) do
                v.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Auto Collect Gifts
local AutoCollectGifts = Page:addToggle("Auto Collect Gifts")

Threads:Add(function()
    while wait() do
        if AutoCollectGifts:IsEnabeld() then
            for _, v in pairs(ReplicatedStorage:GetChildren()) do
                if v.Name == "RemoteFunction" then
                    for i = 1, 12 do
                        pcall(function()
                            v:InvokeServer(i)
                        end)
                    end
                end
            end
            wait(1)
        end
    end
end)

-- Auto Farm
local AutoFarm = Page:addToggle("Auto Farm")
local Framework = require((ReplicatedStorage:WaitForChild("Framework")):WaitForChild("Library"))

local function FindNearestCoin()
    local found
    local last = math.huge

    for _, Coin in pairs(workspace["__THINGS"].Coins:GetChildren()) do
        local distance = LocalPlayer:DistanceFromCharacter(Coin.POS.Position)
        if distance < last then
            found = Coin
            last = distance
        end
    end
    return found
end

Threads:Add(function()
    while wait() do
        if AutoFarm:IsEnabeld() then
            local Coin = FindNearestCoin()
            local pets = tonumber(LocalPlayer.PlayerGui.Main.Bottom.Inventory.Equipped.Text:split("/")[1])

            for _ = 1, pets do
                Framework.Signal.Fire("Select Coin", Coin)
                wait(0.1)
            end

            while #Coin:GetChildren() ~= 0 and AutoFarm:IsEnabeld() do
                wait()
            end
        end
    end
end)
