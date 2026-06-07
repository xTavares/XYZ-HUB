local RunService = game:GetService("RunService")

local SettingsPage = {}

function SettingsPage:Render(context)
	local container = context.Sections.Settings.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Hub = context.Hub
	local Theme = context.Theme

	Utils:Clear(container)

	Elements:Hero(container, "Settings", "Customize Performance, Visuals and Hub Behavior")

	Elements:SectionTitle(container, "Themes")

	for themeName in pairs(Theme.Presets) do
		Elements:Button("Apply Theme: " .. themeName, container, function()
			Theme:Set(themeName)
			SettingsPage:Render(context)
		end)
	end

	Elements:SectionTitle(container, "Performance")

	Elements:Toggle("Disable 3D Rendering", container, function(enabled)
		RunService:Set3dRenderingEnabled(not enabled)
	end)

	Elements:Toggle("Low Performance Mode", container, function(enabled)
		if enabled then
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		else
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		end
	end)

	Elements:SectionTitle(container, "Automation")

	Elements:Toggle("Auto Rejoin", container, function(enabled)
		Hub.AutoRejoin = enabled
	end)

	Elements:SectionTitle(container, "Information")
	Elements:StatCard(container, "Current Theme", Theme.Current, "🎨")
	Elements:StatCard(container, "Hub Name", Hub.Name, "⭐")
end

return SettingsPage
