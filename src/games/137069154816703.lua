-- Hack Vault for Brainrots

return function(section, context)
	local elements = context.Elements

	elements:SectionTitle(section, "Hack Vault Modules")

	elements:Toggle("Farm Brainrots", section, function(enabled)
		warn("[XYZ - HUB] Farm Brainrots:", enabled)
	end)

	elements:Button("Test Button", section, function()
		warn("[XYZ - HUB] Test clicked")
	end)
end
