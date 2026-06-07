local Theme = {}

Theme.Current = "Purple"

Theme.Presets = {
	Purple = {
		Accent = Color3.fromRGB(126, 87, 255),
		Bg = Color3.fromRGB(12, 13, 20),
		Panel = Color3.fromRGB(18, 20, 31),
		Card = Color3.fromRGB(30, 31, 48),
		Hover = Color3.fromRGB(42, 44, 68),
		Text = Color3.fromRGB(242, 244, 255),
		Muted = Color3.fromRGB(150, 155, 185),
		Green = Color3.fromRGB(90, 220, 120),
		Red = Color3.fromRGB(230, 80, 90)
	},

	Blue = {
		Accent = Color3.fromRGB(70, 145, 255),
		Bg = Color3.fromRGB(10, 15, 24),
		Panel = Color3.fromRGB(15, 22, 35),
		Card = Color3.fromRGB(24, 35, 54),
		Hover = Color3.fromRGB(32, 48, 76),
		Text = Color3.fromRGB(242, 247, 255),
		Muted = Color3.fromRGB(150, 170, 200),
		Green = Color3.fromRGB(90, 220, 120),
		Red = Color3.fromRGB(230, 80, 90)
	},

	Green = {
		Accent = Color3.fromRGB(80, 220, 135),
		Bg = Color3.fromRGB(10, 18, 15),
		Panel = Color3.fromRGB(15, 27, 22),
		Card = Color3.fromRGB(23, 42, 34),
		Hover = Color3.fromRGB(32, 58, 47),
		Text = Color3.fromRGB(240, 255, 247),
		Muted = Color3.fromRGB(150, 190, 170),
		Green = Color3.fromRGB(90, 220, 120),
		Red = Color3.fromRGB(230, 80, 90)
	},

	Red = {
		Accent = Color3.fromRGB(255, 85, 105),
		Bg = Color3.fromRGB(20, 11, 14),
		Panel = Color3.fromRGB(31, 17, 22),
		Card = Color3.fromRGB(48, 27, 34),
		Hover = Color3.fromRGB(68, 38, 48),
		Text = Color3.fromRGB(255, 242, 245),
		Muted = Color3.fromRGB(190, 150, 160),
		Green = Color3.fromRGB(90, 220, 120),
		Red = Color3.fromRGB(230, 80, 90)
	}
}

function Theme:Get()
	return self.Presets[self.Current] or self.Presets.Purple
end

function Theme:Set(name)
	if self.Presets[name] then
		self.Current = name
	end

	getgenv().XYZHubTheme = self:Get()

	return self:Get()
end

return Theme
