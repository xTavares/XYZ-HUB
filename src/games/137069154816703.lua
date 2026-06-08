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

	elements:SectionTitle(section, "Hack Vault Modules")

	elements:Toggle("Farm Brainrots", section, function(enabled)
		if enabled then
			getgenv().FarmRots = true

			task.spawn(function()
				while getgenv().FarmRots do
					local char = plr.Character

					if not char then
						task.wait(1)
						continue
					end

					local folder = workspace:FindFirstChild("EntitiesFolder")

					if not folder then
						warn("[XYZ - HUB] EntitiesFolder not found")
						task.wait(1)
						continue
					end

					for _, br in pairs(folder:GetChildren()) do
						if not getgenv().FarmRots then
							break
						end

						char:MoveTo(VAULT_POSITION)
						task.wait(0.5)

						if br:GetAttribute("SpawnZone") ~= TARGET_ZONE then
							continue
						end

						if not br.PrimaryPart then
							continue
						end

						local prompt = br.PrimaryPart:FindFirstChild("TakeBrainrotPrompt")

						if not prompt then
							prompt = br:FindFirstChild("TakeBrainrotPrompt", true)
						end

						if not prompt then
							warn("[XYZ - HUB] TakeBrainrotPrompt not found:", br.Name)
							continue
						end

						char:MoveTo(br.PrimaryPart.Position)
						task.wait()

						local attempts = 0

						repeat
							attempts += 1

							pcall(function()
								fireproximityprompt(prompt)
							end)

							task.wait()
						until not getgenv().FarmRots
							or not br
							or not br.Parent
							or not br.PrimaryPart
							or br.PrimaryPart:FindFirstChild("Attachment")
							or attempts >= 30

						char:MoveTo(DEPOSIT_POSITION)
						task.wait(1)
					end

					task.wait()
				end
			end)
		else
			getgenv().FarmRots = false
		end
	end)
end
