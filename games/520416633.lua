-- Cash Grab Simulator
local Page = MagmaHub:addPage("Cash Grab Simulator")

-- Buttons
local AutoFarmButton = Page:addToggle("Auto Farm")

-- Services
local Services  = setmetatable({},{__index=function(_,i) return game:service(i) end});

-- Variables
local plr       = Services.Players.LocalPlayer;
local rem       = Services.ReplicatedStorage.remotes.bindCustomer;
local dep       = workspace.zones.depositZone;

-- Functions
local function hasMax(getMax)
    local a,b = plr.PlayerGui.screenGui.customerList.header.textLabel.Text:match('(%d+)/(%d+)');
    return getMax and b or (a == b);
end

local function backpackIsFull(leasure)
    if not plr.Character then return false end
    local display = plr.Character:FindFirstChild('backpackDisplay', true)
    if not display then return false end
    a,b = display.holder.textLabel.Text:match('(%d+)/(%d+)');
    return (a == b) or (tonumber(a) > tonumber(b)-(leasure or 0));
end

-- Threads
Threads:Add(function()
    while wait(1/15) do
        if AutoFarmButton:IsEnabeld() then
            if backpackIsFull(tonumber(hasMax(true))/10) then
                local cf = plr.Character.HumanoidRootPart.CFrame;
                plr.Character.HumanoidRootPart.CFrame = dep.CFrame;
                wait(1/20)
                plr.Character.HumanoidRootPart.CFrame = cf;
            end
        end
    end
end)

Threads:Add(function()
    while wait(.5) do
        if AutoFarmButton:IsEnabeld() then
            if not hasMax() then
                for _,v in ipairs(workspace.customers:children()) do
                    if v:FindFirstChild('properties') and v.properties:FindFirstChild('owner') and not v.properties.owner.Value and not hasMax() and (plr.Character.HumanoidRootPart.CFrame.p-v.HumanoidRootPart.CFrame.p).magnitude < 100 then
                        rem:FireServer(v);
                        wait(.5);
                    end
                end
            end
        end
    end
end)
