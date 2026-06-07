local RunService = game:GetService("RunService")

local SettingsPage = {}

function SettingsPage:Render(context)
	local container = context.Sections.Settings.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Hub = context.Hub

	Utils:Clear(container)

	Elements:Toggle("Disable 3D Rendering", container, function(enabled)
		RunService:Set3dRenderingEnabled(not enabled)
	end)

	Elements:Toggle("Auto Rejoin", container, function(enabled)
		Hub.AutoRejoin = enabled
	end)

	Elements:Toggle("Low Performance Mode", container, function(enabled)
		if enabled then
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		else
			settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
		end
	end)
end

return SettingsPage
