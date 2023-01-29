-- Every Second You Get +1 Health
local Page = MagmaHub:addPage("Every Second You Get +1 Health")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer

-- Auto Farm
local AutoFarm = Page:addToggle("Auto Farm")

Threads:Add(function()
    while wait() do
        if AutoFarm:IsEnabeld() then
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Wins.Fall, 0)
            wait()
            firetouchinterest(LocalPlayer.Character.HumanoidRootPart, workspace.Wins.Fall, 1)
        end
    end
end)

-- Auto Rebirth
local AutoRebirth = Page:addToggle("Auto Rebirth")

Threads:Add(function()
    while wait() do
        if AutoRebirth:IsEnabeld() then
            ReplicatedStorage.RebirthEvent:FireServer()
        end
    end
end)

-- Win all
Page:addButton("Win all", function()
    for _, v in pairs(workspace.Wins:children()) do
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 0)
        wait()
        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, v, 1)
        wait(5)
    end
end)
