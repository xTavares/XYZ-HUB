local RunService = game:GetService("RunService")

local SettingsPage = {}

function SettingsPage:Render(context)
	local container = context.Sections.Settings.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Hub = context.Hub
	local Theme = context.Theme

	Utils:Clear(container)

	Elements:Hero(container, "Settings", "Customize visuals and performance")

	Elements:SectionTitle(container, "Themes")

	for themeName in pairs(Theme.Presets) do
		Elements:Button((Theme.Current == themeName and "✓ " or "") .. themeName, container, function()
			Theme:Set(themeName)
			SettingsPage:Render(context)
		end)
	end

	Elements:SectionTitle(container, "Performance")

	Elements:Toggle("Disable 3D Rendering", container, function(enabled)
		RunService:Set3dRenderingEnabled(not enabled)
	end)

	Elements:Toggle("Low Performance Mode", container, function(enabled)
		settings().Rendering.QualityLevel = enabled and Enum.QualityLevel.Level01 or Enum.QualityLevel.Automatic
	end)

	Elements:SectionTitle(container, "Automation")

	Elements:Toggle("Auto Rejoin", container, function(enabled)
		Hub.AutoRejoin = enabled
	end)

	Elements:StatCard(container, "Current Theme", Theme.Current, "🎨")
end

return SettingsPage
