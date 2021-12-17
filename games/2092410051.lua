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

    -- Sellables
    local Sellables = {}

    for _,Sellable in pairs(ReplicatedStorage.Sellables:getChildren()) do
        Sellables[Sellable.Name] = Sellable.Name
    
        for _,Variant in pairs(Sellable.Variants:getChildren()) do
            Sellables[Variant.Name] = Sellable.Name
        end
       
    end

    -- Auto Buy
    local AutoBuy = Page:addToggle("Auto Buy (Enable Auto Delivery and Auto Restock)")

    Threads:Add(function()
        while wait() do
            if AutoBuy:IsEnabeld() then
                local Plot = GetPlot()
                if Plot ~= nil then
                    for _,Descendant in pairs(Plot.Objects:GetDescendants()) do
                        if Descendant.Name == "Shelves" and Descendant:FindFirstChild("Base") then
                            local Amount = string.split(Descendant.Base.StockLabel.Panel.Frame.Amount.Text, "/")
                            if #Amount == 2 then
                                local buyAmount = tonumber(Amount[2])-tonumber(Amount[1])

                                if buyAmount ~= 0 then
                                    print("Buy "..tostring(buyAmount)..' x "'..Sellables[Descendant.Sellable.Value]..'"')
                                    ReplicatedStorage.Remotes.BuyStorage:InvokeServer(Sellables[Descendant.Sellable.Value], buyAmount, false)
                                end

                            end
                        end
                    end
                    wait(30)
                end
            end
        end
    end)

    -- Auto Delivery
    local AutoDelivery = Page:addToggle("Auto Delivery (Spawn you'r Car)")

    Threads:Add(function()
        while wait() do
            if AutoDelivery:IsEnabeld() then
                local Car   = GetCar()
                local Plot  = GetPlot()

                if Car ~= nil and Plot ~= nil then
                    
                    if getrenv()._G.Data.DockCurrentStorage > 0 and getrenv()._G.Data.VehicleMaxStorage ~= getrenv()._G.Data.VehicleCurrentStorage then
                        -- Tp to Loading Dock
                        TeleportCar(GetLoadingDock().ParkingArea.Floor.CFrame * CFrame.Angles(0,math.rad(-90),0) + Vector3.new(0,5,0))
                        wait(1)

                        -- LoadVehicle
                        local Storage, MaxStorage, CurrentStorage, VehicleStorage, VehicleMaxStorage, VehicleCurrentStorage, DockStorage, DockCurrentStorage = ReplicatedStorage.Remotes.LoadVehicle:InvokeServer()

                        if Storage ~= nil then
                            getrenv()._G.Data.Storage               = Storage
                            getrenv()._G.Data.MaxStorage            = MaxStorage
                            getrenv()._G.Data.CurrentStorage        = CurrentStorage
                            getrenv()._G.Data.VehicleStorage        = VehicleStorage
                            getrenv()._G.Data.VehicleMaxStorage     = VehicleMaxStorage
                            getrenv()._G.Data.VehicleCurrentStorage = VehicleCurrentStorage
                            getrenv()._G.Data.DockStorage           = DockStorage
                            getrenv()._G.Data.DockCurrentStorage    = DockCurrentStorage
                        end

                        wait(1)
                    end

                    if getrenv()._G.Data.VehicleCurrentStorage > 0 then
                        -- Tp to Unloading Dock
                        for _,Descendant in pairs(Plot.Walls:GetDescendants()) do
                            if string.find(Descendant.Name,"Door") then
                                if Descendant:FindFirstChild("Base") and Descendant:FindFirstChild("Handle") then
                                    Descendant.Base.CanCollide      = false
                                    Descendant.Handle.CanCollide    = false
                                    TeleportCar(Descendant.Parent.Base.CFrame * CFrame.Angles(0,0,0) + Vector3.new(1,2,1))
                                    break
                                end
                            end
                        end
                        wait(1)

                        -- UnloadVehicle
                        local Storage, MaxStorage, CurrentStorage, VehicleStorage, VehicleMaxStorage, VehicleCurrentStorage, DockStorage, DockCurrentStorage = ReplicatedStorage.Remotes.UnloadVehicle:InvokeServer()
                        
                        if Storage ~= nil then
                            getrenv()._G.Data.Storage               = Storage
                            getrenv()._G.Data.MaxStorage            = MaxStorage
                            getrenv()._G.Data.CurrentStorage        = CurrentStorage
                            getrenv()._G.Data.VehicleStorage        = VehicleStorage
                            getrenv()._G.Data.VehicleMaxStorage     = VehicleMaxStorage
                            getrenv()._G.Data.VehicleCurrentStorage = VehicleCurrentStorage
                            getrenv()._G.Data.DockStorage           = DockStorage
                            getrenv()._G.Data.DockCurrentStorage    = DockCurrentStorage
                        end

                        wait(1)

                        if getrenv()._G.Data.DockCurrentStorage <= 0 and getrenv()._G.Data.VehicleCurrentStorage <= 0 then
                            -- Waiting Spot (Plot)
                            TeleportCar(Plot.RoadModule.Center.CFrame * CFrame.Angles(0,math.rad(180),0) + Vector3.new(0,10,0))
                        end
                    end
                end
            end
        end
    end)

    -- Car Teleports
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
    LocalPlayer.Character.PrimaryPart.CFrame = workspace.Map.Landmarks["Loading Dock"].MicrokSpawn.CFrame + Vector3.new(-5,0,0)
end)

-- Car
Teleports:addButton("Car", function ()
    local Car = GetCar()
    if Car ~= nil then
        LocalPlayer.Character.PrimaryPart.CFrame = Car:GetPrimaryPartCFrame() + Vector3.new(0,20,0)
    end
end)

-- Vehicle Store
Teleports:addButton("Vehicle Store", function ()
    LocalPlayer.Character.PrimaryPart.CFrame = workspace.Map.Landmarks["Vehicle Store"].MainFloor.CFrame
end)
