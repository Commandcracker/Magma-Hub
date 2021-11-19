-- Dashing Simulator
local DashingSimulatorCategory = HUB_API.CreateCategory("Dashing Simulator")

local AddSpeedButton = DashingSimulatorCategory.CreateToggelButton("AddSpeed")

coroutine.wrap(function()
    while wait() do
        if AddSpeedButton.IsEnabeld() then
            game.ReplicatedStorage.Events.AddSpeed:InvokeServer()
        end
    end
end)()

local AutoRebirthButton = DashingSimulatorCategory.CreateToggelButton("Auto Rebirth")

coroutine.wrap(function()
    while wait() do
        if AutoRebirthButton.IsEnabeld() then
            game.ReplicatedStorage.Events.Rebirth:InvokeServer()
        end
    end
end)()

local AutoCollectOrbsButton = DashingSimulatorCategory.CreateToggelButton("Auto Collect Orbs")

coroutine.wrap(function()
    local CollectableOrbs = workspace.CollectableOrbs:GetChildren()

    while wait() do
        if AutoCollectOrbsButton.IsEnabeld() then
            for _,V in pairs(CollectableOrbs) do
                if V.Name == "35" and V.Small.Transparency == 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = V.Small.CFrame
                    wait(2)
                    if AutoCollectOrbsButton.IsEnabeld() == false then break end
                end
            end
        end
    end
end)()

local AutoCollectFlowersButton = DashingSimulatorCategory.CreateToggelButton("Auto Collect Flowers")

coroutine.wrap(function()
    local Flowers = workspace.Flowers:GetChildren()

    while wait() do
        if AutoCollectFlowersButton.IsEnabeld() then
            for _,V in pairs(Flowers) do
                if V.Name == "30" and V.Main.Transparency == 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = V.Main.CFrame
                    wait(2)
                    if AutoCollectFlowersButton.IsEnabeld() == false then break end
                end
            end
        end
    end
end)()

DashingSimulatorCategory.CreateButton("Claim Chests", function()
    local Chests = workspace.Chests:GetChildren()
    local Pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame

    for _,Chest in pairs(Chests) do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=Chest.Toucher.CFrame
        wait(.5)
    end

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=Pos
end)

DashingSimulatorCategory.CreateButton("Win Race", function()
    local RaceTrack = workspace.RaceTrack:GetChildren()

    wait(2.5)

    for _,V in pairs(RaceTrack) do
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame=V.Finish.CFrame
    end
end)

DashingSimulatorCategory.CreateButton("Discover Lands", function()
    local Discoveries = workspace.Discoveries:GetChildren()
    for _,Land in pairs(Discoveries) do
        game.ReplicatedStorage.Events.Discover:InvokeServer(Land.Name)
    end
end)

local DashingSimulatorTeleportsCategory = HUB_API.CreateCategory("Teleports")

DashingSimulatorTeleportsCategory.CreateButton("Spawn", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(55, 6 , -58)
end)

DashingSimulatorTeleportsCategory.CreateButton("Elite Island", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(252, 6 , -3300)
end)

DashingSimulatorTeleportsCategory.CreateButton("Dessert Chest", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7870, 6 , 39)
end)

DashingSimulatorTeleportsCategory.CreateButton("Golden Chest", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(471, 17 , -27)
end)

DashingSimulatorTeleportsCategory.CreateButton("Cloud Land", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(442, 17 , 2)
end)

DashingSimulatorTeleportsCategory.CreateButton("Ice Land", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(3085, 6 , -49)
end)

DashingSimulatorTeleportsCategory.CreateButton("Farm Ville", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1414, 6 , -41)
end)

DashingSimulatorTeleportsCategory.CreateButton("Sand Land", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-7925, 6 , -6)
end)

DashingSimulatorTeleportsCategory.CreateButton("Moon", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-322, 1879 , 3217)
end)

DashingSimulatorTeleportsCategory.CreateButton("Magma", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1281, 1867 , 7342)
end)

DashingSimulatorTeleportsCategory.CreateButton("100 Rebirths", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-4664, 2221 , 7802)
end)
