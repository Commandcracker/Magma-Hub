-- Prison Life
local Page = MagmaHub:addPage("Prison Life")

-- Services
local Players = game:GetService("Players")

-- Variables
local LocalPlayer       = Players.LocalPlayer
local ItemHandlerEvent  = workspace.Remote.ItemHandler
local ItemGiver         = workspace["Prison_ITEMS"].giver

-- Give Remington 870
Page:addButton("Give Remington 870", function()
    ItemHandlerEvent:InvokeServer(ItemGiver["Remington 870"].ITEMPICKUP)
end)

-- Give M9
Page:addButton("Give M9", function()
    ItemHandlerEvent:InvokeServer(ItemGiver.M9.ITEMPICKUP)
end)

-- Give AK-47
Page:addButton("Give AK-47", function()
    ItemHandlerEvent:InvokeServer(ItemGiver["AK-47"].ITEMPICKUP)
end)

-- Auto Reload
local AutoReload = Page:addToggle("Auto Reload")

Threads:Add(function()
    while wait() do
        if AutoReload:IsEnabeld() then
            local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if Tool ~= nil then
                local GunStates = require(Tool:FindFirstChildOfClass("ModuleScript"))
                if GunStates.CurrentAmmo < GunStates.MaxAmmo then
                    game:GetService("ReplicatedStorage").ReloadEvent:FireServer(Tool)
                    wait(GunStates.ReloadTime)
                    GunStates.CurrentAmmo = GunStates.MaxAmmo
                end
            end
        end
    end
end)
