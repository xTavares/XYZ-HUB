local Tabs = {}

function Tabs:Create(sections, utils)
	local controller = {}
	controller.CurrentSection = nil

	function controller:Switch(section)
		if self.CurrentSection == section then return end

		if self.CurrentSection then
			self.CurrentSection.TabBtn.BackgroundTransparency = 1
			utils:Tween(self.CurrentSection.Container, {
				Position = UDim2.new(0.5, 0, 1, 0)
			}, 0.18)
		end

		section.Container.Visible = true
		section.TabBtn.BackgroundTransparency = 0

		utils:Tween(section.Container, {
			Position = UDim2.new(0.5, 0, 0, 0)
		}, 0.18)

		self.CurrentSection = section
	end

	function controller:Init(defaultSection)
		for _, section in pairs(sections) do
			section.TabBtn.BackgroundTransparency = 1
			section.Container.Visible = false
			section.Container.Position = UDim2.new(0.5, 0, 1, 0)

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
