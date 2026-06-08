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
		Muted = Color3.fromRGB(150, 155, 185)
	},
	Midnight = {
		Accent = Color3.fromRGB(80, 120, 255),
		Bg = Color3.fromRGB(7, 10, 18),
		Panel = Color3.fromRGB(12, 17, 30),
		Card = Color3.fromRGB(20, 28, 46),
		Hover = Color3.fromRGB(30, 42, 68),
		Text = Color3.fromRGB(235, 242, 255),
		Muted = Color3.fromRGB(135, 150, 180)
	},
	Ocean = {
		Accent = Color3.fromRGB(65, 185, 255),
		Bg = Color3.fromRGB(7, 15, 22),
		Panel = Color3.fromRGB(12, 24, 34),
		Card = Color3.fromRGB(20, 38, 52),
		Hover = Color3.fromRGB(28, 55, 74),
		Text = Color3.fromRGB(235, 250, 255),
		Muted = Color3.fromRGB(135, 175, 195)
	},
	Emerald = {
		Accent = Color3.fromRGB(80, 220, 145),
		Bg = Color3.fromRGB(8, 18, 14),
		Panel = Color3.fromRGB(13, 28, 22),
		Card = Color3.fromRGB(22, 45, 36),
		Hover = Color3.fromRGB(32, 66, 52),
		Text = Color3.fromRGB(238, 255, 247),
		Muted = Color3.fromRGB(140, 190, 165)
	},
	Rose = {
		Accent = Color3.fromRGB(255, 90, 160),
		Bg = Color3.fromRGB(20, 10, 18),
		Panel = Color3.fromRGB(32, 16, 28),
		Card = Color3.fromRGB(50, 26, 43),
		Hover = Color3.fromRGB(72, 36, 60),
		Text = Color3.fromRGB(255, 240, 248),
		Muted = Color3.fromRGB(198, 145, 175)
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

Theme:Set("Purple")

return Theme
