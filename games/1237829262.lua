-- Magnet Simulator
local Category = HUB_API.CreateCategory("Magnet Simulator")

local Sell      = game.Workspace.Rings.Sellx2
local pos       = Sell.CFrame
local AutoSell  = Category.CreateToggelButton("Auto Sell",nil,function()
    Sell.CanCollide = true
    Sell.CFrame     = pos
end)

coroutine.wrap(function()
    while wait() do
        if AutoSell.IsEnabeld() then
            Sell.CanCollide = false
            Sell.CFrame     = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,math.random(-1,1),0)
        end
    end
end)()

local Teleports = HUB_API.CreateCategory("Teleports")

Teleports.CreateButton("Spawn", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(127,14,-81)
end)

Teleports.CreateButton("Magnet Island", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-16,580,-273)
end)
