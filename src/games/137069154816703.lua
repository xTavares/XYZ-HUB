-- Hack Vault for Brainrots
-- XYZ - HUB adapted module
-- Zone 20+ filter added

return function(section, context)
	local elements = context.Elements

	local plr = game:GetService("Players").LocalPlayer
	getgenv().FarmRots = false

	elements:Toggle("Farm Brainrots", section, function(v)
		if v then
			getgenv().FarmRots = true

			while getgenv().FarmRots do
				for _, br in pairs(workspace.EntitiesFolder:GetChildren()) do
					plr.Character:MoveTo(Vector3.new(-2494, 4, -726))
					task.wait(0.5)

					-- ✅ FILTER: Apenas zones 20 ou superior
					local spawnZone = br:GetAttribute("SpawnZone")
					if spawnZone and spawnZone >= 20 then
						if not br.PrimaryPart then
							continue
						end

						plr.Character:MoveTo(br.PrimaryPart.Position)
						task.wait()

						repeat
							fireproximityprompt(br.PrimaryPart.TakeBrainrotPrompt)
							task.wait()
						until not br.PrimaryPart or br.PrimaryPart:FindFirstChild("Attachment")

						plr.Character:MoveTo(Vector3.new(77, 4, -729))
						task.wait(1)
					end
				end

				task.wait()
			end
		else
			getgenv().FarmRots = false
		end
	end)
end
