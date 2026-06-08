-- Hack Vault for Brainrots
-- XYZ - HUB module

return function(section, context)
	local elements = context.Elements
	local Players = game:GetService("Players")
	local plr = Players.LocalPlayer

	getgenv().FarmRots = false

	local VAULT_POSITION = Vector3.new(-2494, 4, -726)
	local DEPOSIT_POSITION = Vector3.new(77, 4, -729)
	local TARGET_ZONE = 22

	local function getCharacter()
		local char = plr.Character or plr.CharacterAdded:Wait()
		local root = char:FindFirstChild("HumanoidRootPart")
		return char, root
	end

	local function getPrompt(br)
		if br.PrimaryPart then
			local prompt = br.PrimaryPart:FindFirstChild("TakeBrainrotPrompt")
			if prompt then
				return prompt
			end
		end

		return br:FindFirstChild("TakeBrainrotPrompt", true)
	end

	elements:SectionTitle(section, "Hack Vault Modules")

	elements:Toggle("Farm Brainrots", section, function(enabled)
		getgenv().FarmRots = enabled

		if not enabled then
			return
		end

		task.spawn(function()
			while getgenv().FarmRots do
				local char, root = getCharacter()
				if not char or not root then
					task.wait(1)
					continue
				end

				local folder = workspace:FindFirstChild("EntitiesFolder")
				if not folder then
					warn("[XYZ - HUB] EntitiesFolder not found")
					task.wait(1)
					continue
				end

				char:MoveTo(VAULT_POSITION)
				task.wait(0.8)

				for _, br in ipairs(folder:GetChildren()) do
					if not getgenv().FarmRots then
						break
					end

					if br:GetAttribute("SpawnZone") ~= TARGET_ZONE then
						continue
					end

					if not br.PrimaryPart then
						continue
					end

					local prompt = getPrompt(br)
					if not prompt then
						warn("[XYZ - HUB] Prompt not found:", br.Name)
						continue
					end

					char:MoveTo(br.PrimaryPart.Position)
					task.wait(0.35)

					for i = 1, 12 do
						if not getgenv().FarmRots then
							break
						end

						pcall(function()
							fireproximityprompt(prompt)
						end)

						task.wait(0.08)
					end

					task.wait(0.25)

					char:MoveTo(DEPOSIT_POSITION)
					task.wait(1)

					break
				end

				task.wait(0.2)
			end
		end)
	end)
end
