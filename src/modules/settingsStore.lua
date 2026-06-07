local HttpService = game:GetService("HttpService")

local Store = {}

Store.File = "XYZHub/settings.json"

Store.Default = {
	Theme = "Purple",
	UIScale = "Medium",
	Animations = true,
	Transparency = 0,
	TogglePosition = nil,
	HubPosition = nil
}

function Store:Load()
	if not isfile or not readfile then
		return table.clone(self.Default)
	end

	if not isfile(self.File) then
		return table.clone(self.Default)
	end

	local success, data = pcall(function()
		return HttpService:JSONDecode(readfile(self.File))
	end)

	if success and type(data) == "table" then
		for key, value in pairs(self.Default) do
			if data[key] == nil then
				data[key] = value
			end
		end

		return data
	end

	return table.clone(self.Default)
end

function Store:Save(data)
	if not writefile then
		return
	end

	local success, encoded = pcall(function()
		return HttpService:JSONEncode(data)
	end)

	if success then
		writefile(self.File, encoded)
	end
end

return Store
