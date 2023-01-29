-- Vehicle Simulator
local Page = MagmaHub:addPage("Vehicle Simulator")

-- Services
local Players = game:GetService("Players")

-- Variables
local LocalPlayer = Players.LocalPlayer

-- Functions
local function GetVehicle()
    local Vehicles = workspace.Vehicles:getChildren()
    for i = 1, #Vehicles do
        if Vehicles[i]:findFirstChild("owner") then
            if Vehicles[i].owner.Value == LocalPlayer.Name then
                return Vehicles[i]
            end
        end
    end
end

-- Teleport To Vehicle
Page:addButton("Teleport To Vehicle", function()
    local Vehicle = GetVehicle()
    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
        Vehicle.Chassis.VehicleSeat.Position + Vehicle.Chassis.VehicleSeat.SeatOffset.Value)
end)

-- Give All Perks
Page:addButton("Give All Perks", function()
    LocalPlayer.UserId = 1099580
end)

-- TP to Crates
Page:addButton("TP to Crates", function()
    local crates = workspace:getChildren()
    for i = 1, #crates do
        if crates[i].ClassName == "Model" then
            local crates2 = crates[i]:getChildren()
            for i = 1, #crates2 do
                if crates2[i].ClassName == "Model" then
                    local crates3 = crates2[i]:getChildren()
                    for i = 1, #crates3 do
                        if crates3[i].ClassName == "MeshPart" then
                            if crates3[i]:findFirstChild("Smoke") then
                                LocalPlayer.Character:MoveTo(
                                    Vector3.new(crates3[i].Position.X + 30, crates3[i].Position.Y + 5,
                                        crates3[i].Position.Z))
                                wait()
                                LocalPlayer.Character.Humanoid:MoveTo(
                                    Vector3.new(crates3[i].Position.X, crates3[i].Position.Y, crates3[i].Position.Z))
                                wait(4)
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Crate ESP
Page:addButton("Crate ESP", function()
    local crates = workspace:getChildren()
    for i = 1, #crates do
        if crates[i].ClassName == "Model" then
            local crates2 = crates[i]:getChildren()
            for i = 1, #crates2 do
                if crates2[i].ClassName == "Model" then
                    local crates3 = crates2[i]:getChildren()
                    for i = 1, #crates3 do
                        if crates3[i].ClassName == "MeshPart" then
                            if crates3[i]:findFirstChild("Smoke") then
                                if crates3[i]:findFirstChild("BoxHandleAdornment") then
                                    crates3[i]:findFirstChild("BoxHandleAdornment"):Remove()
                                else
                                    local a = Instance.new("BoxHandleAdornment", crates3[i])
                                    a.Size = Vector3.new(10, 500, 6)
                                    a.SizeRelativeOffset = Vector3.new(0, 135, 0)
                                    a.Color3 = Color3.fromRGB(0, 255, 0)
                                    a.Transparency = 0.5
                                    a.AlwaysOnTop = true
                                    a.Adornee = crates3[i]
                                    a.ZIndex = 1

                                    local b = Instance.new("BoxHandleAdornment", crates3[i])
                                    b.Size = Vector3.new(10, 4, 6)
                                    b.Color3 = Color3.fromRGB(0, 0, 255)
                                    b.Transparency = 0.3
                                    b.AlwaysOnTop = true
                                    b.Adornee = crates3[i]
                                    b.ZIndex = 1
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Auto Farm
local AutoFarm = Page:addToggle("Auto Farm")

Threads:Add(function()
    while wait() do
        if AutoFarm:IsEnabeld() then
            local Vehicle = GetVehicle()

            Vehicle.PrimaryPart = Vehicle.Chassis.VehicleSeat
            Vehicle:SetPrimaryPartCFrame(CFrame.new(3026, 233, -20)) -- Teleports vehicle to highway

            local speed = 0

            pcall(function()
                speed = LocalPlayer.PlayerGui.CarGui.LocalScript.Variables.Speed.Value
            end)

            if speed <= 450 then
                for i = 1, 100 do
                    Vehicle.Chassis.Axles.FL.MotorMaxTorque = 2500 * 2
                    Vehicle.Chassis.Axles.FR.MotorMaxTorque = 2500 * 2
                    Vehicle.Chassis.Axles.BR.MotorMaxTorque = 10560 * 2
                    Vehicle.Chassis.Axles.BL.MotorMaxTorque = 10560 * 2
                    wait()
                end
            else
                wait(4)
            end

            wait(.1)
        end
    end
end)

-- Super Car
Page:addButton("Super Car", function()
    local Vehicle = GetVehicle()
    Vehicle.Handling.MaxSpeed.Value = 10000
    Vehicle.Handling.Torque.Value = 40000
    Vehicle.Handling.SteeringRadiusConstant.Value = 15000
    Vehicle.Handling.FrictionRoad.Value = 250
    Vehicle.Handling.Nitro.NitroSpeed.Value = 500
    Vehicle.Handling.Nitro.NitroForce.Value = 5000
    Vehicle.Handling.TurboJump.TurboJumpHeight.Value = 250
end)

-- Max Speed
Page:addInput("Max Speed", function(Input)
    local Vehicle = GetVehicle()
    Vehicle.Handling.MaxSpeed.Value = Input
    Vehicle.Handling.SteeringRadiusConstant.Value = 1500000
end)

-- Torque
Page:addInput("Torque", function(Input)
    GetVehicle().Handling.Torque.Value = Input
end)

-- Nitro Speed
Page:addInput("Nitro Speed", function(Input)
    GetVehicle().Handling.Nitro.NitroSpeed.Value = Input
end)

-- Nitro Force
Page:addInput("Nitro Force", function(Input)
    GetVehicle().Handling.Nitro.NitroForce.Value = Input
end)

-- Turbo Jump Height
Page:addInput("Turbo Jump Height", function(Input)
    GetVehicle().Handling.TurboJump.TurboJumpHeight.Value = Input
end)

-- Steering Force
Page:addInput("Steering Force", function(Input)
    GetVehicle().Handling.SteeringRadiusConstant.Value = Input
end)
