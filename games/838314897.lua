-- Shouting Simulator 2
local Category = HUB_API.CreateCategory("Shouting Simulator 2")

local AutoShout = Category.CreateToggelButton("Auto Shout")

coroutine.wrap(function()
    while wait() do
        if AutoShout.IsEnabeld() then
            game:GetService("ReplicatedStorage").Remotes.Shout:InvokeServer()
        end
    end
end)()
