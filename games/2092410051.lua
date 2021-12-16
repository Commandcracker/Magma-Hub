-- Retail Tycoon 2
local Page = MagmaHub:addPage("Retail Tycoon 2")

-- Services
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- Functions
local function GetCar()
    return workspace.PlayerVehicles:FindFirstChild("Vehicle_"..LocalPlayer.Name)
end

local function TeleportCar(pos)
    local Car = GetCar()
    if Car ~= nil then
        for _,child in pairs(Car:GetChildren()) do
            if child.ClassName == "MeshPart" or child.ClassName == "Part" then
                child.CFrame = pos
            end
        end
    end
end

local function GetPlot()
    if getrenv ~= nil then
        return getrenv()._G.Plot
    end
end

local function GetPlotID()
    local Plot = GetPlot()
    if Plot ~= nil then
        local name = string.split(Plot.Name,"_")
        return name[#name]
    end
end

local function GetLoadingDock()
    local PlotID = GetPlotID()
    if PlotID ~= nil then
        return workspace.Map.Landmarks["Loading Dock"]["LoadingDock_"..PlotID]
    end
end

-- Collect Presents
if workspace.Map:FindFirstChild("Holiday") ~= nil then
    local CollectPresents = Page:addToggle("Collect Presents")

    Threads:Add(function()
        while wait() do
            if CollectPresents:IsEnabeld() then
                for _,Present in pairs(workspace.Map.Holiday.Items:getChildren()) do
                    if Present.Name == "Present" and Present.Transparency == 0 then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = Present.CFrame
                        wait(0.1)
                        if CollectPresents:IsEnabeld() == false then break end
                    end
                end
            end
        end
    end)
end

-- Rainbow Store
local function zigzag(X) return math.acos(math.cos(X*math.pi))/math.pi end
local counter       = 0
local RainbowStore  = Page:addToggle("Rainbow Store")

Threads:Add(function()
    while wait(.5) do
        if RainbowStore:IsEnabeld() then
            ReplicatedStorage.Remotes.SetStoreColor:FireServer(Color3.fromHSV(zigzag(counter),1,1))
            counter = counter + .01
        end
    end
end)

-- CarMods
local CarPage = MagmaHub:addPage("Car Mod's")

-- Max Speed
CarPage:addInput("Max Speed", function(input)
    local Car = GetCar()
    if Car ~= nil then
        Car.Config.MaxSpeed.Value = input
    end
end)

-- Power
CarPage:addInput("Power", function(input)
    local Car = GetCar()
    if Car ~= nil then
        Car.Config.Power.Value = input
    end
end)

-- Brake Power
CarPage:addInput("Brake Power", function(input)
    local Car = GetCar()
    if Car ~= nil then
        Car.Config.BrakePower.Value = input
    end
end)

-- Max Turn Angle
CarPage:addInput("Max Turn Angle", function(input)
    local Car = GetCar()
    if Car ~= nil then
        Car.Config.MaxTurnAngle.Value = input
    end
end)

-- Low Rider
CarPage:addButton("Low Rider", function ()
    local Car = GetCar()
    if Car ~= nil then
        Car.Config.Suspension.Mid.Value = 1
    end
end)

if getrenv ~= nil then
    -- Auto Restock
    local AutoRestock = Page:addToggle("Auto Restock")

    Threads:Add(function()
        while wait() do
            if AutoRestock:IsEnabeld() then
                local Plot = GetPlot()
                if Plot ~= nil then
                    for _,Descendant in pairs(Plot.Objects:GetDescendants()) do
                        if Descendant.Name == "Shelves" then
                            ReplicatedStorage.Remotes.StockShelfFunction:InvokeServer(Descendant, "Restock")
                        end
                    end
                end
            end
        end
    end)

    local CarTeleports = MagmaHub:addPage("Car Teleports")

    -- Plot
    CarTeleports:addButton("Plot", function ()
        local Plot = GetPlot()
        if Plot ~= nil then
            TeleportCar(Plot.RoadModule.Center.CFrame * CFrame.Angles(0,math.rad(180),0) + Vector3.new(0,10,0))
        end
    end)

    -- Loading Dock
    CarTeleports:addButton("Loading Dock", function ()
        TeleportCar(GetLoadingDock().ParkingArea.Floor.CFrame * CFrame.Angles(0,math.rad(-90),0) + Vector3.new(0,5,0))
    end)

end

-- Teleports
local Teleports = MagmaHub:addPage("Teleports")

-- Car
Teleports:addButton("Car", function ()
    local Car = GetCar()
    if Car ~= nil then
        LocalPlayer.Character.PrimaryPart.CFrame = Car:GetPrimaryPartCFrame() + Vector3.new(0,20,0)
    end
end)

if getrenv ~= nil then
    -- Plot
    Teleports:addButton("Plot", function ()
        local Plot = GetPlot()
        if Plot ~= nil then
            LocalPlayer.Character.PrimaryPart.CFrame = Plot.RoadModule.Center.CFrame + Vector3.new(0,5,0)
        end
    end)
end

-- Loading Dock
Teleports:addButton("Loading Dock", function ()
    local Plot = GetPlot()
    if Plot ~= nil then
        LocalPlayer.Character.PrimaryPart.CFrame = workspace.Map.Landmarks["Loading Dock"].MicrokSpawn.CFrame + Vector3.new(-5,0,0)
    end
end)

if getrenv ~= nil then
    -- Vehicle Store
    Teleports:addButton("Vehicle Store", function ()
        local Plot = GetPlot()
        if Plot ~= nil then
            LocalPlayer.Character.PrimaryPart.CFrame = workspace.Map.Landmarks["Vehicle Store"].MainFloor.CFrame
        end
    end)
end
