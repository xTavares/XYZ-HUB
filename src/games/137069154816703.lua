-- Hack Vault for Brainrots

return function(section, context)
	local elements = context and context.Elements or loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))()

	local Players = game:GetService("Players")
	local player = Players.LocalPlayer

	local running = false

	local SPAWN_ZONE_ID = 22
	local VAULT_POSITION = Vector3.new(-2494, 4, -726)
	local DEPOSIT_POSITION = Vector3.new(77, 4, -729)

	local function getCharacter()
		local char = player.Character or player.CharacterAdded:Wait()
		local root = char:FindFirstChild("HumanoidRootPart")
		return char, root
	end

	local function getPrompt(model)
		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("ProximityPrompt") and obj.Name == "TakeBrainrotPrompt" then
				return obj
			end
		end
	end

	elements:Toggle("Farm Brainrots", section, function(enabled)
		running = enabled

		if not enabled then
			return
		end

		task.spawn(function()
			while running do
				local char, root = getCharacter()
				if not char or not root then
					task.wait(1)
					continue
				end

				local folder = workspace:FindFirstChild("EntitiesFolder")
				if not folder then
					warn("[XYZ - HUB] EntitiesFolder not found")
					task.wait(2)
					continue
				end

				local found = false

				for _, brainrot in ipairs(folder:GetChildren()) do
					if not running then
						break
					end

					if brainrot:GetAttribute("SpawnZone") ~= SPAWN_ZONE_ID then
						continue
					end

					local part = brainrot.PrimaryPart or brainrot:FindFirstChildWhichIsA("BasePart", true)
					if not part then
						warn("[XYZ - HUB] No part found in:", brainrot.Name)
						continue
					end

					local prompt = getPrompt(brainrot)
					if not prompt then
						warn("[XYZ - HUB] Prompt not found in:", brainrot.Name)
						continue
					end

					found = true

					char:MoveTo(VAULT_POSITION)
					task.wait(0.4)

					char:MoveTo(part.Position)
					task.wait(0.5)

					pcall(function()
						fireproximityprompt(prompt)
					end)

					task.wait(0.5)

					char:MoveTo(DEPOSIT_POSITION)
					task.wait(1)
				end

				if not found then
					warn("[XYZ - HUB] No Valid Brainrots Found")
					task.wait(1)
				else
					task.wait(0.2)
				end
			end
		end)
	end)
end
