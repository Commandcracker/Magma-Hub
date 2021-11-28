-- Knife Simulator
local Page = MagmaHub:addPage("Knife Simulator")

-- Services
local Players           = game:service("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer   = Players.LocalPlayer
local Mouse         = LocalPlayer:GetMouse()

-- Buttons
local AutoFarm  = Page:addToggle("Auto Farm (you cant use your knife)")
local AimBot    = Page:addToggle("SlientAim / AimBot")
local KillAll   = Page:addToggle("Kill All")

-- Functions
local function IsPlayerKillable(player)
    if player.Character ~= nil and player.Character:FindFirstChildOfClass("ForceField") == nil and player.Character.Humanoid.Health > 0 then
        return true
    else
        return false
    end
end

local function FindNearestKillablePlayer(position)
	local found
	local last = math.huge

	for _,plyr in pairs(Players:GetPlayers()) do
        if plyr ~= LocalPlayer and IsPlayerKillable(plyr) == true then
            local distance = plyr:DistanceFromCharacter(position)
            if distance < last then
                found   = plyr
                last    = distance
            end
        end
	end
	return found
end

local function FindNearestKillablePlayerToMouse()
    local nearestPlayer
    local dist = math.huge

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and IsPlayerKillable(player) == true then
            local pos = player.Character:GetPrimaryPartCFrame().p
            local len = (Mouse.Hit.p - pos).Magnitude
            if len <= dist then
                nearestPlayer   = player
                dist            = len
            end
        end
    end
    return nearestPlayer
end

-- Main
Threads:Add(function()
	while wait() do
        if AutoFarm:IsEnabeld() then
            ReplicatedStorage.forhackers:InvokeServer("hit", {})
            ReplicatedStorage.forhackers:InvokeServer("throw", CFrame.new(
                Vector3.new(-85.16625213623, 100.0666809082, -17.599998474121),
                Vector3.new(-0.62112283706665, -0.2661966085434, -0.7371199131012)
            ))
        end
    end
end)

workspace.CurrentCamera.trash.ChildAdded:connect(function(child)
    if KillAll:IsEnabeld() then
        local player = FindNearestKillablePlayer(LocalPlayer.Character.PrimaryPart.Position)
        if player ~= nil then
            print("Killing: "..player.Name)
            child.CFrame = CFrame.new(player.Character:GetPrimaryPartCFrame().p)
        end
    elseif AimBot:IsEnabeld() then
        local player = FindNearestKillablePlayerToMouse()
        if player ~= nil then
            child.CFrame = CFrame.new(player.Character:GetPrimaryPartCFrame().p)
        end
    end
end)
