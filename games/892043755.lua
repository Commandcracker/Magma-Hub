-- Bubble Gum Simulator
local Page = MagmaHub:addPage("Bubble Gum Simulator")

local AutoBlowBubbleButton = Page:addToggle("Auto BlowBubble")

Threads:Add(function()
    while wait() do
        if AutoBlowBubbleButton:IsEnabeld() then
            local A_1 = "BlowBubble"
            local Event = game:GetService("ReplicatedStorage").NetworkRemoteEvent
            Event:FireServer(A_1)
        end
    end
end)

local AutoSellButton = Page:addToggle("Auto Sell")

Threads:Add(function()
    while wait() do
        if AutoSellButton:IsEnabeld() then
            local A_1 = "SellBubble"
            local A_2 = "Sell"
            local Event = game:GetService("ReplicatedStorage").NetworkRemoteEvent
            Event:FireServer(A_1, A_2)
        end
    end
end)
