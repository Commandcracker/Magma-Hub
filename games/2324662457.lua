-- Anime Fighters Simulator
local Page = MagmaHub:addPage("Anime Fighters Simulator")

-- Auto Clicker
local AutoClicker = Page:addToggle("Auto Clicker")

Threads:Add(function()
    while wait() do
        if AutoClicker:IsEnabeld() then
            local Event = game:GetService("ReplicatedStorage").Remote.ClickerDamage
            Event:FireServer()
        end
    end
end)

-- Auto Collect Coins
local AutoCollectCoins = Page:addToggle("Auto Collect Coins")

Threads:Add(function()
    while wait() do
        if AutoCollectCoins:IsEnabeld() then
            for _, v in pairs(workspace.Effects:GetDescendants()) do
                if v.Name == "Base" then
                    v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, 0, 0)
                end
            end
        end
    end
end)
