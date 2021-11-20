-- RO-Wizard
local function inTable(Table, Item)
    for key, value in pairs(Table) do
        if value == Item then return true end
    end
    return false
end

local A_1   = "TogglePrompter"
local Event = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent

local function UsePrompter(Prompter)
    wait(.1)
    Event:FireServer(A_1, "Down", Prompter)
    wait(.1)
    Event:FireServer(A_1, "Up"  , Prompter)
end

local Category = HUB_API.CreateCategory("RO-Wizard")

Category.CreateButton("Unlock All Spells", function()
    local BookStands = game:GetService("Workspace").BookStands:GetChildren()
    
    for _,BookStand in pairs(BookStands) do
        if BookStand:IsA("Model") then
            local Hitbox = BookStand:FindFirstChild("Hitbox")
            if Hitbox ~= nil then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Hitbox.CFrame
                UsePrompter(BookStand.Prompter)
                wait(.5)
            end
        end
    end
end)

Category.CreateButton("Unlock All Books", function()
    local Books = game:GetService("Workspace").Books:GetChildren()
    
    for _,Book in pairs(Books) do
        if Book:IsA("Model") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Book.Book.Main.CFrame
            UsePrompter(Book.Prompter)
            wait(.5)
        end
    end
end)

local Teleports = HUB_API.CreateCategory("Teleports")

Teleports.CreateButton("Badgers", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Badgers.CFrame
end)

Teleports.CreateButton("Lions", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Lions.CFrame
end)

Teleports.CreateButton("Serpents", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Serpents.CFrame
end)

Teleports.CreateButton("Ravens", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Ravens.CFrame
end)

Category.CreateButton("Collect All Ingredients", function()
    local Ingredients   = game:GetService("Workspace").Ingredients:GetChildren()
    local done          = {}

    for _,Ingredient in pairs(Ingredients) do
        if inTable(done, Ingredient.Name) == false then
            table.insert(done, Ingredient.Name)

            local Prompter = Ingredient:FindFirstChild("Prompter", true)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Prompter.PrompterPart.CFrame

            for i=1, 5 do
                UsePrompter(Prompter)
            end
        end
    end    
end)
