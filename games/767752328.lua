-- Super Power Training Simulator
local SuperPowerTrainingSimulator = MagmaHub:addPage("Super Power Training Sim.")

-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer = game.Players.LocalPlayer

-- Auto Respawn
local AutoRespawnButton = SuperPowerTrainingSimulator:addToggle("Auto Respawn")

local function onHealthChanged(health)
    if AutoRespawnButton:IsEnabeld() and health <= 0 then
        ReplicatedStorage.RemoteEvent:FireServer({"Respawn"})
    end
end

local function onCharacterAdded(character)
    local human = character:WaitForChild("Humanoid")
    human.HealthChanged:Connect(onHealthChanged)
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

LocalPlayer.PlayerGui.ScreenGui.Changed:Connect(function()
    if AutoRespawnButton:IsEnabeld() then
        LocalPlayer.PlayerGui.ScreenGui.Enabled = true
    end
end)

LocalPlayer.PlayerGui.IntroGui.Changed:Connect(function()
    if AutoRespawnButton:IsEnabeld() then
        LocalPlayer.PlayerGui.IntroGui.Enabled = false
    end
end)

game.Lighting.Blur.Changed:Connect(function()
    if AutoRespawnButton:IsEnabeld() then
        game.Lighting.Blur.Enabled = false
    end
end)

-- Teleports
local Teleports = MagmaHub:addPage("Teleports")

Teleports:addButton("Safe Zone / Sathopian", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(459.3638, 248.993805, 892.707764)
end)

Teleports:addButton("City Port", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(341.4534, 263.432434, -408.41333)
end)

Teleports:addButton("Ice Mountain", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1577.74976, 256.837982, 2232.5354)
end)

Teleports:addButton("Tornado", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2301.5061, 1003.84021, 1069.53088)
end)

Teleports:addButton("Volcano", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1971.78845, 749.285645, -1904.39258)
end)

Teleports:addButton("Crystal", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2278.21411, 1941.96082, 1017.19659)
end)

Teleports:addButton("Floating Zen Temple", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2600, 5533, -512)
end)

Teleports:addButton("Devil`s Secret Training Area", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-268, 286, 980)
end)

Teleports:addButton("Blue God Star", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1176, 4789, -2295)
end)

Teleports:addButton("Green God Star", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1381, 9274, 1648)
end)

Teleports:addButton("Red God Star", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-369, 15735, -11)
end)

Teleports:addButton("Grim Reaper", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-130, 249, 528)
end)

Teleports:addButton("Ghost Rider", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(160, 249, 1237)
end)

-- FistFarm
local FistFarm = MagmaHub:addPage("Fist Farm")

local FistFarm1 = FistFarm:addToggle("Fist Farm 1")
Threads:Add(function()
    while wait() do
        if FistFarm1:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+FS1"})
        end
    end
end)

local FistFarm2 = FistFarm:addToggle("Fist Farm 2")
Threads:Add(function()
    while wait() do
        if FistFarm2:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+FS2"})
        end
    end
end)

local FistFarm3 = FistFarm:addToggle("Fist Farm 3")
Threads:Add(function()
    while wait() do
        if FistFarm3:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+FS3"})
        end
    end
end)

local FistFarm4 = FistFarm:addToggle("Fist Farm 4")
Threads:Add(function()
    while wait() do
        if FistFarm4:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+FS4"})
        end
    end
end)

local FistFarm5 = FistFarm:addToggle("Fist Farm 5")
Threads:Add(function()
    while wait() do
        if FistFarm5:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+FS5"})
        end
    end
end)

local FistFarm6 = FistFarm:addToggle("Fist Farm 6")
Threads:Add(function()
    while wait() do
        if FistFarm6:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+FS6"})
        end
    end
end)

-- Psychic Farm
local PsychicFarm = MagmaHub:addPage("Psychic Farm")

local PsychicFarm1 = PsychicFarm:addToggle("Psychic Farm 1")
Threads:Add(function()
    while wait() do
        if PsychicFarm1:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+PP1"})
        end
    end
end)

local PsychicFarm2 = PsychicFarm:addToggle("Psychic Farm 2")
Threads:Add(function()
    while wait() do
        if PsychicFarm2:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+PP2"})
        end
    end
end)

local PsychicFarm3 = PsychicFarm:addToggle("Psychic Farm 3")
Threads:Add(function()
    while wait() do
        if PsychicFarm3:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+PP3"})
        end
    end
end)

local PsychicFarm4 = PsychicFarm:addToggle("Psychic Farm 4")
Threads:Add(function()
    while wait() do
        if PsychicFarm4:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+PP4"})
        end
    end
end)

local PsychicFarm5 = PsychicFarm:addToggle("Psychic Farm 5")
Threads:Add(function()
    while wait() do
        if PsychicFarm5:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+PP5"})
        end
    end
end)

local PsychicFarm6 = PsychicFarm:addToggle("Psychic Farm 6")
Threads:Add(function()
    while wait() do
        if PsychicFarm6:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+PP6"})
        end
    end
end)

-- Body Toughness Farm
local BodyToughnessFarm = SuperPowerTrainingSimulator:addToggle("Body Toughness Farm")
Threads:Add(function()
    while wait() do
        if BodyToughnessFarm:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+BT1"})
        end
    end
end)

-- Movement Speed Farm
local MovementSpeedFarm = MagmaHub:addPage("Movement Speed Farm")

local MovementSpeedFarm1 = MovementSpeedFarm:addToggle("Movement Speed Farm 1 (No Weight)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if MovementSpeedFarm1:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+MS1"})
        end
    end
end)

local MovementSpeedFarm2 = MovementSpeedFarm:addToggle("Movement Speed Farm 2 (100LB)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight1"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if MovementSpeedFarm2:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+MS2"})
        end
    end
end)

local MovementSpeedFarm3 = MovementSpeedFarm:addToggle("Movement Speed Farm 3 (1T)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight2"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if MovementSpeedFarm3:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+MS3"})
        end
    end
end)

local MovementSpeedFarm4 = MovementSpeedFarm:addToggle("Movement Speed Farm 4 (10T)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight3"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if MovementSpeedFarm4:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+MS4"})
        end
    end
end)

local MovementSpeedFarm5 = MovementSpeedFarm:addToggle("Movement Speed Farm 5 (100T)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight4"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if MovementSpeedFarm5:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+MS5"})
        end
    end
end)

-- Jump Force Farm
local JumpForceFarm = MagmaHub:addPage("Jump Force Farm")

local JumpForceFarm1 = JumpForceFarm:addToggle("Jump Force Farm 1 (No Weight)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if JumpForceFarm1:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+JF1"})
        end
    end
end)

local JumpForceFarm2 = JumpForceFarm:addToggle("Jump Force Farm 2 (100LB)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight1"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if JumpForceFarm2:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+JF2"})
        end
    end
end)

local JumpForceFarm3 = JumpForceFarm:addToggle("Jump Force Farm 3 (1T)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight2"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if JumpForceFarm3:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+JF3"})
        end
    end
end)

local JumpForceFarm4 = JumpForceFarm:addToggle("Jump Force Farm 4 (10T)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight3"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if JumpForceFarm4:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+JF4"})
        end
    end
end)

local JumpForceFarm5 = JumpForceFarm:addToggle("Jump Force Farm 5 (100T)", function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Weight4"})
end, function()
    ReplicatedStorage.RemoteEvent:FireServer({"Weight", "Unequip"})
end)

Threads:Add(function()
    while wait() do
        if JumpForceFarm5:IsEnabeld() then
            ReplicatedStorage.RemoteEvent:FireServer({"+JF5"})
        end
    end
end)
