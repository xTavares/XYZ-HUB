-- Hack Vault for Brainrots

return function(section, context)
	local elements = context and context.Elements or loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))()

	elements:SectionTitle(section, "Hack Vault for Brainrots")
	elements:Label("Module Loaded Successfully.", section)

	elements:Toggle("Farm Brainrots", section, function(enabled)
		warn("[XYZ - HUB] Farm Brainrots:", enabled)
	end)
end
