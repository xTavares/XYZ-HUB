-- Hack Vault for Brainrots

return function(section, context)
	local elements = context.Elements
	local Players = game:GetService("Players")
	local plr = Players.LocalPlayer

	getgenv().FarmRots = false

	local VAULT_POSITION = Vector3.new(-2494, 4, -726)
	local DEPOSIT_POSITION = Vector3.new(77, 4, -729)

	local function getPrompt(model)
		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("ProximityPrompt") and obj.Name == "TakeBrainrotPrompt" then
				return obj
			end
		end
	end

	elements:SectionTitle(section, "Hack Vault Modules")

	elements:Toggle("Farm Brainrots", section, function(enabled)
		getgenv().FarmRots = enabled

		if not enabled then
			return
		end

		task.spawn(function()
			while getgenv().FarmRots do
				local char = plr.Character
				if not char then
					task.wait(1)
					continue
				end

				local folder = workspace:FindFirstChild("EntitiesFolder")
				if not folder then
					warn("[XYZ - HUB] EntitiesFolder not Found")
					task.wait(1)
					continue
				end

				for _, br in ipairs(folder:GetChildren()) do
					if not getgenv().FarmRots then
						break
					end

					if br:GetAttribute("SpawnZone") ~= 22 then
						continue
					end

					local part = br.PrimaryPart or br:FindFirstChildWhichIsA("BasePart", true)
					if not part then
						continue
					end

					local prompt = getPrompt(br)
					if not prompt then
						warn("[XYZ - HUB] Prompt not Found:", br.Name)
						continue
					end

					char:MoveTo(VAULT_POSITION)
					task.wait(0.5)

					char:MoveTo(part.Position)
					task.wait(0.4)

					pcall(function()
						fireproximityprompt(prompt)
					end)

					task.wait(0.5)

					char:MoveTo(DEPOSIT_POSITION)
					task.wait(1)
				end

				task.wait(0.2)
			end
		end)
	end)
end
