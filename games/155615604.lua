-- Prison Life
local PrisonLifeCategory = HUB_API.CreateCategory("Prison Life")

PrisonLifeCategory.CreateButton("Give Remington 870", function()
    local A_1   = game:GetService("Workspace")["Prison_ITEMS"].giver["Remington 870"].ITEMPICKUP
    local Event = game:GetService("Workspace").Remote.ItemHandler
    Event:InvokeServer(A_1)
end)

PrisonLifeCategory.CreateButton("Give M9", function()
    local A_1   = game:GetService("Workspace")["Prison_ITEMS"].giver.M9.ITEMPICKUP
    local Event = game:GetService("Workspace").Remote.ItemHandler
    Event:InvokeServer(A_1)
end)

PrisonLifeCategory.CreateButton("Give AK-47", function()
    local A_1   = game:GetService("Workspace")["Prison_ITEMS"].giver["AK-47"].ITEMPICKUP
    local Event = game:GetService("Workspace").Remote.ItemHandler
    Event:InvokeServer(A_1)
end)
