-- RO-Wizard
local Page = MagmaHub:addPage("RO-Wizard")

-- Variables
local A_1 = "TogglePrompter"
local Event = game:GetService("ReplicatedStorage").Modules.Network.RemoteEvent

-- Functions
local function UsePrompter(Prompter)
    wait(.1)
    Event:FireServer(A_1, "Down", Prompter)
    wait(.1)
    Event:FireServer(A_1, "Up", Prompter)
end

-- Unlock All Spells
Page:addButton("Unlock All Spells", function()
    local BookStands = game:GetService("Workspace").BookStands:GetChildren()

    for _, BookStand in pairs(BookStands) do
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

-- Unlock All Books
Page:addButton("Unlock All Books", function()
    local Books = game:GetService("Workspace").Books:GetChildren()

    for _, Book in pairs(Books) do
        if Book:IsA("Model") then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Book.Book.Main.CFrame
            UsePrompter(Book.Prompter)
            wait(.5)
        end
    end
end)

-- Teleports
local Teleports = MagmaHub:addPage("Teleports")

-- Badgers
Teleports:addButton("Badgers", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Badgers.CFrame
end)

-- Lions
Teleports:addButton("Lions", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Lions.CFrame
end)

-- Serpents
Teleports:addButton("Serpents", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Serpents.CFrame
end)

-- Ravens
Teleports:addButton("Ravens", function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").Spawns.Ravens.CFrame
end)

-- Collect All Ingredients
Page:addButton("Collect All Ingredients", function()
    local Ingredients = game:GetService("Workspace").Ingredients:GetChildren()
    local done = {}

    for _, Ingredient in pairs(Ingredients) do
        if Btable.Contains(done, Ingredient.Name) == false then
            table.insert(done, Ingredient.Name)

            local Prompter = Ingredient:FindFirstChild("Prompter", true)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Prompter.PrompterPart.CFrame

            for _ = 1, 5 do
                UsePrompter(Prompter)
            end
        end
    end
end)
