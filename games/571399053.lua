-- Operation Scorpion
local Page = MagmaHub:addPage("Operation Scorpion")

-- Config
local map = game.Workspace.Map
local terrain = false
local only_move_map = true

-- playerList
local playerList = {}
for _, v in pairs(game.Players:GetPlayers()) do
    table.insert(playerList, v.Name)
end
function Addplayer(player)
    if not Btable.Contains(playerList, player.Name) then
        table.insert(playerList, player.Name)
    end
end
game.Players.PlayerAdded:Connect(Addplayer)
function Removeplayer(player)
    table.remove(playerList, player.Name)
end
game.Players.PlayerRemoving:Connect(Removeplayer)

-- Default variables
local player = game:GetService("Players").LocalPlayer
local Storage = Instance.new("Folder", game:GetService("ReplicatedStorage"))

Page:addToggle("Shoot through walls", function()
    if player.Character.HumanoidRootPart ~= nil then
        player.Character.HumanoidRootPart.Anchored = true
    end

    if terrain then
        workspace.Terrain:CopyRegion(workspace.Terrain.MaxExtents).Parent = Storage
        workspace.Terrain:Clear()
    end

    if only_move_map then
        old_map_parent = map.Parent
        map.Parent = Storage
    else
        for _, v in pairs(workspace:children()) do
            if v:IsA("Terrain") or v:IsA("Camera") or Btable.Contains(playerList, v.Name) then
            else
                v.Parent = Storage
            end
        end
    end
end, function()
    if terrain then
        for _, v in pairs(Storage:children()) do
            if v:IsA("TerrainRegion") then
                workspace.Terrain:PasteRegion(v, workspace.Terrain.MaxExtents.Min, true)
                v:Destroy()
            end
        end
    end

    if only_move_map then
        map.Parent = old_map_parent
    else
        for _, v in pairs(Storage:children()) do
            v.Parent = workspace
        end
    end
    if player.Character.HumanoidRootPart ~= nil then
        player.Character.HumanoidRootPart.Anchored = false
    end
end)
