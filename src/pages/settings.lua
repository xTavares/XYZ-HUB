local RunService = game:GetService("RunService")

local SettingsPage = {}

function SettingsPage:Render(context)
	local container = context.Sections.Settings.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Hub = context.Hub
	local Theme = context.Theme
	local Settings = context.Settings

	Utils:Clear(container)

	Elements:Hero(container, "Settings", "Customize XYZ - HUB behavior and visuals")

	Elements:SectionTitle(container, "Themes")

	for themeName in pairs(Theme.Presets) do
		Elements:Button((Theme.Current == themeName and "✓ " or "") .. themeName, container, function()
			Theme:Set(themeName)
			Settings.Theme = themeName
			context.SettingsStore:Save(Settings)
			SettingsPage:Render(context)
		end)
	end

	Elements:SectionTitle(container, "UI Scale")

	for _, scaleName in ipairs({"Small", "Medium", "Large"}) do
		Elements:Button((Settings.UIScale == scaleName and "✓ " or "") .. scaleName, container, function()
			Settings.UIScale = scaleName
			context.SettingsStore:Save(Settings)

			local scale = context.MainFrame:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
			scale.Parent = context.MainFrame
			scale.Scale = scaleName == "Small" and 0.9 or scaleName == "Large" and 1.1 or 1
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

	Elements:SectionTitle(container, "Saved Data")

	Elements:Button("Save Current UI Position", container, function()
		Settings.HubPosition = {
			XScale = context.MainFrame.Position.X.Scale,
			XOffset = context.MainFrame.Position.X.Offset,
			YScale = context.MainFrame.Position.Y.Scale,
			YOffset = context.MainFrame.Position.Y.Offset
		}

		Settings.TogglePosition = {
			XScale = context.ToggleButton.Position.X.Scale,
			XOffset = context.ToggleButton.Position.X.Offset,
			YScale = context.ToggleButton.Position.Y.Scale,
			YOffset = context.ToggleButton.Position.Y.Offset
		}

		context.SettingsStore:Save(Settings)
	end)

	Elements:Button("Reset Saved Settings", container, function()
		context.SettingsStore:Save(context.SettingsStore.Default)
	end)

	Elements:StatCard(container, "Current Theme", Theme.Current, "🎨")
	Elements:StatCard(container, "UI Scale", Settings.UIScale, "📐")
end

return SettingsPage
