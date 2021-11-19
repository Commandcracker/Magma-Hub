-- STRONGEST PUNCH SIMULATOR
local Category = HUB_API.CreateCategory("STRONGEST PUNCH SIMULATOR")

local AutoPunch = Category.CreateToggelButton("Auto Punch")

coroutine.wrap(function()
    while wait() do
        if AutoPunch.IsEnabeld() then
            local A_1 = { [1] = "Activate_Punch" }
            local Event = game:GetService("ReplicatedStorage").RemoteEvent
            Event:FireServer(A_1)
        end
    end
end)()

local AutoCollectBoosts = Category.CreateToggelButton("Auto Collect Boosts")

coroutine.wrap(function()
    while wait() do
        if AutoCollectBoosts.IsEnabeld() then
            local World 	= game.Players.LocalPlayer.leaderstats.WORLD.Value
            local Boosts 	= Workspace.Map.Stages.Boosts[World]:GetChildren()
            
            for _,Boost in pairs(Boosts) do
                if Boost ~= nil then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Boost:FindFirstChildOfClass("Part").CFrame
                    wait(.5)
                    if Boost ~= game.Players.LocalPlayer.leaderstats.WORLD.Value then break end
                    if AutoCollectBoosts.IsEnabeld() == false then break end
                end
            end
        end
    end
end)()
