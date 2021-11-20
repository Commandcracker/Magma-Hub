-- Bubble Gum Simulator
local BubbleGumSimulatorCategory = HUB_API.CreateCategory("Bubble Gum Simulator")

local AutoBlowBubbleButton = BubbleGumSimulatorCategory.CreateToggelButton("Auto BlowBubble")

coroutine.wrap(function()
    while wait() do
        if AutoBlowBubbleButton.IsEnabeld() then
            local A_1   = "BlowBubble"
            local Event = game:GetService("ReplicatedStorage").NetworkRemoteEvent
            Event:FireServer(A_1)
        end
    end
end)()

local AutoSellButton = BubbleGumSimulatorCategory.CreateToggelButton("Auto Sell")

coroutine.wrap(function()
    while wait() do
        if AutoSellButton.IsEnabeld() then
            local A_1   = "SellBubble"
            local A_2   = "Sell"
            local Event = game:GetService("ReplicatedStorage").NetworkRemoteEvent
            Event:FireServer(A_1, A_2)
        end
    end
end)()
