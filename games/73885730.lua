-- Prison Life
local PrisonLifeCategory = HUB_API.CreateCategory("Prison Life")

PrisonLifeCategory.CreateButton("Give Remington 870", function()
    local A_1   = game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP
    local Event = game:GetService("Workspace").Remote.ItemHandler
    Event:InvokeServer(A_1)
end)

PrisonLifeCategory.CreateButton("Give M9", function()
    local A_1   = game:GetService("Workspace")["Prison_ITEMS"].giver.M9.ITEMPICKUP
    local Event = game:GetService("Workspace").Remote.ItemHandler
    Event:InvokeServer(A_1)
end)

PrisonLifeCategory.CreateButton("Give AK-47", function()
    local A_1   = game:GetService("Workspace")["Prison_ITEMS"].giver["AK-47"].ITEMPICKUP
    local Event = game:GetService("Workspace").Remote.ItemHandler
    Event:InvokeServer(A_1)
end)

local AutoReload = PrisonLifeCategory.CreateToggelButton("Auto Reload")

local Players       = game:GetService("Players")
local LocalPlayer   = Players.LocalPlayer

coroutine.wrap(function()
    while wait() do
        if AutoReload.IsEnabeld() then
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
end)()
