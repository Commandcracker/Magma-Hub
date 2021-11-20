-- Swordburst 2
local Category = HUB_API.CreateCategory("Swordburst 2")

local BigHitBox = Category.CreateToggelButton("Big Hit Box",nil,function ()
	for i,v in pairs(game.Workspace.Mobs:children()) do
		if v:FindFirstChild("Head") then
			v.HumanoidRootPart.Transparency = 1
			v.HumanoidRootPart.Size         = Vector3.new(10, 10, 10)
		end
	end
end)

coroutine.wrap(function()
	while wait() do
		if BigHitBox.IsEnabeld() then
			for i,v in pairs(game.Workspace.Mobs:children()) do
				if v ~= nil and v:FindFirstChild("Head") and v:FindFirstChild("HumanoidRootPart") then
					v.HumanoidRootPart.Transparency = 0.25
					v.HumanoidRootPart.Size         = Vector3.new(30, 25, 30)
					if BigHitBox.IsEnabeld() == false then break end
				end
			end
		end
	end
end)()

Category.CreateButton("Reach",function ()
	if game.Players.LocalPlayer.Character then
		for i,p in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
			if p.Name == "RightWeapon" or p.Name == "LeftWeapon" then
				for _,v in pairs(p.Tool:GetChildren()) do
					v.Size = Vector3.new(50, 50, 50)
					v.Transparency = 1
				end
			end
		end
	end
end)

local InfiniteStamina = Category.CreateToggelButton("Infinite Stamina")

coroutine.wrap(function()
	while wait() do
		if InfiniteStamina.IsEnabeld() then
			if game.Players.LocalPlayer.Character then
				game.Players.LocalPlayer.Character:WaitForChild("Entity").Stamina.Value = 100
			end
		end
	end
end)()

Category.CreateButton("Unlock All Gamepasses and AnimPacks",function ()
	local Profile = game.ReplicatedStorage.Profiles[game.Players.LocalPlayer.Name]

	-- Gamepasses
	local CustomClothing    = Instance.new("BoolValue", Profile.Gamepasses)
	CustomClothing.Name     = "CustomClothing"

	-- AnimPacks
	local Berserker = Instance.new("StringValue", Profile.AnimPacks)
	Berserker.Name  = "Berserker"
	Berserker.Value = "2HSword"

	local Ninja = Instance.new("StringValue", Profile.AnimPacks)
	Ninja.Name  = "Ninja"
	Ninja.Value = "Katana"

	local Vigilante = Instance.new("StringValue", Profile.AnimPacks)
	Vigilante.Name  = "Vigilante"
	Vigilante.Value = "DualWield"

	local Noble = Instance.new("StringValue", Profile.AnimPacks)
	Noble.Name  = "Noble"
	Noble.Value = "SingleSword"

	-- Fix AnimPacks Settings
	local AnimPacksSettings = game.Players.LocalPlayer:WaitForChild("PlayerGui").CardinalUI.PlayerUI.MainFrame.TabFrames.Settings.AnimPacks

	AnimPacksSettings.ChildAdded:Connect(function(child)
		if child.Text == "[2HSword]Berserker" then
			child.MouseButton1Click:Connect(function()
				if child.BackgroundColor3 == Color3.new() then
					Profile.AnimSettings["2HSword"].Value = "Berserker"
				else
					Profile.AnimSettings["2HSword"].Value = ""
				end
			end)
		elseif child.Text == "[Katana]Ninja" then
			child.MouseButton1Click:Connect(function()
				if child.BackgroundColor3 == Color3.new() then
					Profile.AnimSettings["Katana"].Value = "Ninja"
				else
					Profile.AnimSettings["Katana"].Value = ""
				end
			end)
		elseif child.Text == "[DualWield]Vigilante" then
			child.MouseButton1Click:Connect(function()
				if child.BackgroundColor3 == Color3.new() then
					Profile.AnimSettings["DualWield"].Value = "Vigilante"
				else
					Profile.AnimSettings["DualWield"].Value = ""
				end
			end)
		elseif child.Text == "[SingleSword]Noble" then
			child.MouseButton1Click:Connect(function()
				if child.BackgroundColor3 == Color3.new() then
					Profile.AnimSettings["SingleSword"].Value = "Noble"
				else
					Profile.AnimSettings["SingleSword"].Value = ""
				end
			end)
		end
	end)
end)

Category.CreateInputButton("Dismantle All", function (inp)
	for _,item in pairs(game.ReplicatedStorage.Profiles[game.Players.LocalPlayer.Name].Inventory:GetChildren()) do
		if item.Name == inp then
			game.ReplicatedStorage.Event:FireServer("Equipment", {"Dismantle", item})
		   	print('Dismantled: "'..inp..'" #'..item.Value)
		end
	end
end)

Category.CreateInputButton("Max Upgrade", function (inp)
	local item = game.ReplicatedStorage.Profiles[game.Players.LocalPlayer.Name].Inventory:FindFirstChild(inp)

	if item then
		for i = 1, 100 do
			game.ReplicatedStorage.Event:FireServer("Equipment", {"Upgrade", item, false})
		end
		print('Max Upgraded: "'..inp..'" #'..item.Value)
	end
end)
