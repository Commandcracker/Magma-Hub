-- Cash Grab Simulator
local Page = MagmaHub:addPage("Cash Grab Simulator")

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Variables
local LocalPlayer = Players.LocalPlayer
local bindCustomer = ReplicatedStorage.remotes.bindCustomer
local depositZone = workspace.zones.depositZone

-- Functions
local function hasMaxCustomers()
    local a, b = LocalPlayer.PlayerGui.screenGui.customerList.header.textLabel.Text:match('(%d+)/(%d+)')
    return a == b
end

local function isBackpackIsFull()
    return LocalPlayer.PlayerGui.screenGui.backpackIndicator.Visible
end

-- Auto Farm
local AutoFarmButton = Page:addToggle("Auto Farm")

Threads:Add(function()
    while task.wait(1 / 15) do
        if AutoFarmButton:IsEnabeld() then
            if isBackpackIsFull() then
                if firetouchinterest then
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, depositZone, 0)
                    task.wait()
                    firetouchinterest(LocalPlayer.Character.HumanoidRootPart, depositZone, 1)
                else
                    local oldCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                    LocalPlayer.Character.HumanoidRootPart.CFrame = depositZone.CFrame
                    task.wait(1 / 20)
                    LocalPlayer.Character.HumanoidRootPart.CFrame = oldCFrame
                end
            end
        end
    end
end)

Threads:Add(function()
    while task.wait(.5) do
        if AutoFarmButton:IsEnabeld() then
            if not hasMaxCustomers() then
                for _, Customer in ipairs(workspace.customers:children()) do
                    if Customer:FindFirstChild('properties') and Customer.properties:FindFirstChild('owner') and
                        not Customer.properties.owner.Value and not hasMaxCustomers() and
                        (LocalPlayer.Character.HumanoidRootPart.CFrame.Position -
                            Customer.HumanoidRootPart.CFrame.Position).magnitude < 100 then
                        bindCustomer:FireServer(Customer)
                        task.wait(.5)
                    end
                end
            end
        end
    end
end)
