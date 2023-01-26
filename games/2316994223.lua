-- Pet Simulator X
local Page = MagmaHub:addPage("Pet Simulator X")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Auto Collect
local AutoCollect = Page:addToggle("Auto Collect")

Threads:Add(function()
    while wait() do
        if AutoCollect:IsEnabeld() then
            for _, v in pairs(workspace["__THINGS"].Orbs:children()) do
                v.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        end
    end
end)

-- Auto Farm
local AutoFarm = Page:addToggle("Auto Farm")
local Framework = require((ReplicatedStorage:WaitForChild("Framework")):WaitForChild("Library"))

local function FindNearestCoin()
    local found
    local last = math.huge

    for _, Coin in pairs(workspace["__THINGS"].Coins:children()) do
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
            local last_count
            repeat
                last_count = #Coin.Pets:GetChildren()
                Framework.Signal.Fire("Select Coin", Coin)
                wait(0.1)
            until (#Coin:GetChildren() == 0 or last_count > #Coin.Pets:GetChildren())
            for _ = 1, last_count do
                if #Coin:GetChildren() ~= 0 then
                    Framework.Signal.Fire("Select Coin", Coin)
                    wait(0.1)
                end
            end
            while #Coin:GetChildren() ~= 0 do
                wait()
            end
        end
    end
end)
