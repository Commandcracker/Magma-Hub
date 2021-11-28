-- Shouting Simulator 2
local Page = MagmaHub:addPage("Shouting Simulator 2")

local AutoShout = Page:addToggle("Auto Shout")

Threads:Add(function()
    while wait() do
        if AutoShout:IsEnabeld() then
            game:GetService("ReplicatedStorage").Remotes.Shout:InvokeServer()
        end
    end
end)
