-- Prison Life
local Page = MagmaHub:addPage("Prison Life")

-- Services
local Players = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer
local ItemHandlerEvent = workspace.Remote.ItemHandler
local ItemGiver = workspace["Prison_ITEMS"].giver

-- Give Remington 870
Page:addButton("Give Remington 870", function()
    ItemHandlerEvent:InvokeServer(ItemGiver["Remington 870"].ITEMPICKUP)
end)

-- Give M9
Page:addButton("Give M9", function()
    ItemHandlerEvent:InvokeServer(ItemGiver.M9.ITEMPICKUP)
end)

-- Give AK-47
Page:addButton("Give AK-47", function()
    ItemHandlerEvent:InvokeServer(ItemGiver["AK-47"].ITEMPICKUP)
end)

-- Auto Reload
local AutoReload = Page:addToggle("Auto Reload")

Threads:Add(function()
    while wait() do
        if AutoReload:IsEnabeld() then
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
end)

-- Kill Aura
local KillAura = Page:addToggle("Kill Aura", function()
    workspace.Remote.TeamEvent:FireServer("Bright orange")
end)

Threads:Add(function()
    while wait() do
        if KillAura:IsEnabeld() then
            for _, player in pairs(Players:GetChildren()) do
                if player.Name ~= LocalPlayer.Name then
                    game:GetService("ReplicatedStorage").meleeEvent:FireServer(player)
                end
            end
        end
    end
end)

-- Auto Respawn
local AutoRespawn = Page:addToggle("Auto Respawn")

Threads:Add(function()
    while wait() do
        if AutoRespawn:IsEnabeld() then
            if LocalPlayer.Character and LocalPlayer.Character.Humanoid and LocalPlayer.Character.Humanoid.Health == 0 and
                LocalPlayer.Character.HumanoidRootPart then
                local saved = LocalPlayer.Character.HumanoidRootPart.CFrame
                workspace.Remote.loadchar:InvokeServer("LocalPlayer")
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = saved
            end
        end
    end
end)

-- Spawn Guns
local SpawnGuns_pos
local SpawnGuns = Page:addToggle("Spawn Guns", function()
    workspace.Remote.TeamEvent:FireServer("Bright blue")
    SpawnGuns_pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end)

Threads:Add(function()
    while wait(0.2) do
        if SpawnGuns:IsEnabeld() and LocalPlayer.Character and LocalPlayer.Character.Humanoid and
            LocalPlayer.Character.HumanoidRootPart then
            LocalPlayer.Character.Humanoid.Health = 0
            workspace.Remote.loadchar:InvokeServer("LocalPlayer")
            LocalPlayer.Character.HumanoidRootPart.CFrame = SpawnGuns_pos
        end
    end
end)

-- Kill all
local Killall_pos
local Killall = Page:addToggle("Kill all", function()
    Killall_pos = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
end, function()
    LocalPlayer.Character.HumanoidRootPart.CFrame = Killall_pos
end)

Threads:Add(function()
    while wait() do
        if Killall:IsEnabeld() then
            for _, player in pairs(Players:GetPlayers()) do
                if LocalPlayer.Character and LocalPlayer.Character.HumanoidRootPart and player.Character and
                    player.Character:FindFirstChild("HumanoidRootPart") ~= nil and player.Character.Humanoid and
                    player.Character.Humanoid.Health > 0 and player.Character:FindFirstChildOfClass("ForceField") == nil and
                    player ~= LocalPlayer then
                    LocalPlayer.Character.HumanoidRootPart.CFrame =
                        player.Character.HumanoidRootPart.CFrame + Vector3.new(-2, 0, 0)
                    wait(0.5)
                    if Killall:IsEnabeld() == false then
                        break
                    end
                end
            end
        end
    end
end)

-- Teams
local Teams = MagmaHub:addPage("Teams")

-- Guard
Teams:addButton("Guards", function()
    workspace.Remote.TeamEvent:FireServer("Bright blue")
end)

-- Inmates
Teams:addButton("Inmates", function()
    workspace.Remote.TeamEvent:FireServer("Bright orange")
end)

-- Neutral
Teams:addButton("Neutral", function()
    workspace.Remote.TeamEvent:FireServer("Medium stone grey")
end)

-- Criminals
Teams:addButton("Criminals", function()
    local CriminalsSpawn = game.Workspace["Criminals Spawn"].SpawnLocation
    CriminalsSpawn.CanCollide = false
    CriminalsSpawn.Size = Vector3.new(51.05, 24.12, 54.76)
    CriminalsSpawn.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    CriminalsSpawn.Transparency = 1
    wait(0.1)
    CriminalsSpawn.CFrame = CFrame.new(-920.510803, 92.2271957, 2138.27002, 0, 0, -1, 0, 1, 0, 1, 0, 0)
    CriminalsSpawn.Size = Vector3.new(6, 0.2, 6)
    CriminalsSpawn.Transparency = 0
end)
