-- Tapping Legends X
local Page = MagmaHub:addPage("Tapping Legends X")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Auto Tap
local AutoTap = Page:addToggle("Auto Tap")

Threads:Add(function()
    while wait() do
        if AutoTap:IsEnabeld() then
            ReplicatedStorage.Remotes.Tap:FireServer()
        end
    end
end)

-- Auto Rebirth
local AutoRebirth = Page:addToggle("Auto Rebirth")

Threads:Add(function()
    while wait() do
        if AutoRebirth:IsEnabeld() then
            ReplicatedStorage.Remotes.Rebirth:FireServer(1)
        end
    end
end)
