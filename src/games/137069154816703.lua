-- Hack Vault for Brainrots

return function(section, context)
	local elements = context.Elements

	local Players = game:GetService("Players")
	local plr = Players.LocalPlayer

	local running = false

	local TARGET_ZONE = 22
	local DEPOSIT_POSITION = Vector3.new(77, 4, -729)

	local function getCharacter()
		local char = plr.Character or plr.CharacterAdded:Wait()
		local root = char:FindFirstChild("HumanoidRootPart")
		return char, root
	end

	local function moveTo(position, delayTime)
		local char = getCharacter()

		if char then
			char:MoveTo(position)
		end

		task.wait(delayTime or 0.7)
	end

	local function getZonePart(zone)
		local zones = workspace:FindFirstChild("Zones")
		if not zones then return nil end

		local zoneObj = zones:FindFirstChild(tostring(zone)) or zones:FindFirstChild("Zone" .. tostring(zone))
		if not zoneObj then return nil end

		if zoneObj:IsA("BasePart") then
			return zoneObj
		end

		return zoneObj:FindFirstChildWhichIsA("BasePart", true)
	end

	local function loadZone22()
		for zone = 1, TARGET_ZONE do
			if not running then return false end

			local zonePart = getZonePart(zone)

			if zonePart then
				moveTo(zonePart.Position + Vector3.new(0, 4, 0), 0.45)
			end

			local zone22 = getZonePart(TARGET_ZONE)
			if zone22 then
				moveTo(zone22.Position + Vector3.new(0, 4, 0), 0.8)
				return true
			end
		end

		return getZonePart(TARGET_ZONE) ~= nil
	end

	local function getPrompt(model)
		for _, obj in ipairs(model:GetDescendants()) do
			if obj:IsA("ProximityPrompt") and obj.Name == "TakeBrainrotPrompt" then
				return obj
			end
		end

		return nil
	end

	local function getBrainrots()
		local folder = workspace:FindFirstChild("EntitiesFolder")
		if not folder then
			return {}
		end

		local list = {}

		for _, br in ipairs(folder:GetChildren()) do
			if br:GetAttribute("SpawnZone") == TARGET_ZONE then
				table.insert(list, br)
			end
		end

		return list
	end

	elements:SectionTitle(section, "Hack Vault Modules")

	elements:Toggle("Farm Brainrots", section, function(enabled)
		running = enabled
		getgenv().FarmRots = enabled

		if not enabled then
			return
		end

		task.spawn(function()
			while running do
				local loaded = loadZone22()

				if not loaded then
					warn("[XYZ - HUB] Zone 22 not Loaded Yet")
					task.wait(1)
					continue
				end

				local brainrots = getBrainrots()

				if #brainrots == 0 then
					warn("[XYZ - HUB] No Brainrots Found in Zone 22")
					task.wait(1)
					continue
				end

				for _, br in ipairs(brainrots) do
					if not running then
						break
					end

					local char, root = getCharacter()
					if not char or not root then
						task.wait(1)
						break
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

					moveTo(part.Position + Vector3.new(0, 3, 0), 0.45)

					pcall(function()
						fireproximityprompt(prompt)
					end)

					task.wait(0.35)

					moveTo(DEPOSIT_POSITION, 0.8)
				end

				task.wait(0.2)
			end
		end)
	end)
end
