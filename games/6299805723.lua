-- Anime Fighters Simulator

local Category = HUB_API.CreateCategory("Anime Fighters Simulator")

local AutoClicker = Category.CreateToggelButton("Auto Clicker")

coroutine.wrap(function()
    while wait() do
        if AutoClicker.IsEnabeld() then
            local Event = game:GetService("ReplicatedStorage").Remote.ClickerDamage
            Event:FireServer()
        end
    end
end)()

local AutoCollectCoins = Category.CreateToggelButton("Auto Collect Coins")

coroutine.wrap(function()
    while wait() do
        if AutoCollectCoins.IsEnabeld() then
            for i,v in pairs(game:GetService("Workspace").Effects:GetDescendants()) do
                if v.Name == "Base" then
                    v.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,0,0)
                end
            end
        end
    end
end)()
