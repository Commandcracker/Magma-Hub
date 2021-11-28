-- STRONGEST PUNCH SIMULATOR
local Page = MagmaHub:addPage("STRONGEST PUNCH SIMULATOR")

-- Auto Punch
local AutoPunch = Page:addToggle("Auto Punch")

Threads:Add(function()
    while wait() do
        if AutoPunch:IsEnabeld() then
            local A_1 = { [1] = "Activate_Punch" }
            local Event = game:GetService("ReplicatedStorage").RemoteEvent
            Event:FireServer(A_1)
        end
    end
end)

-- Auto Collect Boosts
local AutoCollectBoosts = Page:addToggle("Auto Collect Boosts")

Threads:Add(function()
    while wait() do
        if AutoCollectBoosts:IsEnabeld() then
            local World 	= game.Players.LocalPlayer.leaderstats.WORLD.Value
            local Boosts 	= workspace.Map.Stages.Boosts[World]:GetChildren()

            for _,Boost in pairs(Boosts) do
                if Boost ~= nil then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Boost:FindFirstChildOfClass("Part").CFrame
                    wait(.5)
                    if Boost ~= game.Players.LocalPlayer.leaderstats.WORLD.Value then break end
                    if AutoCollectBoosts:IsEnabeld() == false then break end
                end
            end
        end
    end
end)
