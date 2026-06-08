local Tabs = {}

function Tabs:Create(sections, utils)
	local controller = {}
	controller.CurrentSection = nil

	local function hideSection(section)
		section.TabBtn.BackgroundTransparency = 1
		section.Container.Visible = false
		section.Container.Position = UDim2.new(0.5, 0, 1, 0)
	end

	local function showSection(section)
		section.Container.Visible = true
		section.Container.Position = UDim2.new(0.5, 0, 0, 0)
		section.TabBtn.BackgroundTransparency = 0
	end

	function controller:Switch(section)
		for _, otherSection in pairs(sections) do
			hideSection(otherSection)
		end

		showSection(section)
		self.CurrentSection = section
	end

	function controller:Init(defaultSection)
		for _, section in pairs(sections) do
			hideSection(section)

			section.TabBtn.MouseButton1Click:Connect(function()
				self:Switch(section)
			end)
		end

		if defaultSection then
			self:Switch(defaultSection)
		end
	end

	return controller
end

return Tabs
