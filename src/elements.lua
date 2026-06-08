local TweenService = game:GetService("TweenService")

local UI = {}

local function getTheme()
	local theme = getgenv().XYZHubTheme

	return theme or {
		Accent = Color3.fromRGB(126, 87, 255),
		Card = Color3.fromRGB(30, 31, 48),
		Hover = Color3.fromRGB(42, 44, 68),
		Text = Color3.fromRGB(242, 244, 255),
		Muted = Color3.fromRGB(150, 155, 185)
	}
end

local function corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = obj
end

local function stroke(obj)
	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(65, 68, 100)
	s.Thickness = 1
	s.Transparency = 0.4
	s.Parent = obj
end

local function tween(obj, props, duration)
	TweenService:Create(
		obj,
		TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	):Play()
end

local function safe(callback, ...)
	if typeof(callback) == "function" then
		local ok, err = pcall(callback, ...)
		if not ok then
			warn("[XYZ - HUB] Callback error:", err)
		end
	end
end

local function ensureLayout(parent)
	local layout = parent:FindFirstChildOfClass("UIListLayout")

	if not layout then
		layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0, 10)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent = parent
	end

	if not parent:FindFirstChildOfClass("UIPadding") then
		local padding = Instance.new("UIPadding")
		padding.PaddingTop = UDim.new(0, 16)
		padding.PaddingLeft = UDim.new(0, 16)
		padding.PaddingRight = UDim.new(0, 16)
		padding.PaddingBottom = UDim.new(0, 16)
		padding.Parent = parent
	end

	if parent:IsA("ScrollingFrame") then
		parent.ScrollingEnabled = true
		parent.ScrollBarThickness = 5
		parent.ScrollingDirection = Enum.ScrollingDirection.Y
		parent.AutomaticCanvasSize = Enum.AutomaticSize.None

		local function update()
			task.defer(function()
				parent.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 42)
			end)
		end

		update()
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(update)
		parent.ChildAdded:Connect(update)
		parent.ChildRemoved:Connect(update)
	end
end

function UI:Hero(parent, title, subtitle)
	ensureLayout(parent)
	local theme = getTheme()

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -4, 0, 84)
	card.BackgroundColor3 = theme.Card
	card.BorderSizePixel = 0
	card.Parent = parent
	corner(card, 14)
	stroke(card)

	local bar = Instance.new("Frame")
	bar.Size = UDim2.fromOffset(5, 50)
	bar.Position = UDim2.fromOffset(14, 17)
	bar.BackgroundColor3 = theme.Accent
	bar.BorderSizePixel = 0
	bar.Parent = card
	corner(bar, 8)

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -50, 0, 32)
	titleLabel.Position = UDim2.fromOffset(30, 14)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = tostring(title or "")
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextSize = 20
	titleLabel.TextColor3 = theme.Text
	titleLabel.TextXAlignment = Enum.TextXAlignment.Left
	titleLabel.Parent = card

	local subLabel = Instance.new("TextLabel")
	subLabel.Size = UDim2.new(1, -50, 0, 24)
	subLabel.Position = UDim2.fromOffset(31, 45)
	subLabel.BackgroundTransparency = 1
	subLabel.Text = tostring(subtitle or "")
	subLabel.Font = Enum.Font.Gotham
	subLabel.TextSize = 13
	subLabel.TextColor3 = theme.Muted
	subLabel.TextXAlignment = Enum.TextXAlignment.Left
	subLabel.Parent = card

	return card
end

function UI:SectionTitle(parent, text)
	ensureLayout(parent)
	local theme = getTheme()

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -4, 0, 30)
	label.BackgroundTransparency = 1
	label.Text = tostring(text or "Section")
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextColor3 = theme.Accent
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	return label
end

function UI:Label(text, parent)
	ensureLayout(parent)
	local theme = getTheme()

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -4, 0, 38)
	label.BackgroundColor3 = theme.Card
	label.BorderSizePixel = 0
	label.Text = tostring(text or "")
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = theme.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextWrapped = true
	label.Parent = parent
	corner(label, 11)
	stroke(label)

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)
	pad.Parent = label

	return label
end

function UI:Button(text, parent, callback)
	ensureLayout(parent)
	local theme = getTheme()

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -4, 0, 46)
	button.BackgroundColor3 = theme.Card
	button.Text = tostring(text or "Button")
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 14
	button.TextColor3 = theme.Text
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Parent = parent
	corner(button, 11)
	stroke(button)

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)
	pad.Parent = button

	button.MouseEnter:Connect(function()
		tween(button, {BackgroundColor3 = theme.Hover})
	end)

	button.MouseLeave:Connect(function()
		tween(button, {BackgroundColor3 = theme.Card})
	end)

	button.MouseButton1Click:Connect(function()
		safe(callback)
	end)

	return button
end

function UI:Toggle(text, parent, callback, defaultState)
	ensureLayout(parent)
	local theme = getTheme()

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -4, 0, 50)
	button.BackgroundColor3 = theme.Card
	button.Text = ""
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Parent = parent
	corner(button, 11)
	stroke(button)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -82, 1, 0)
	title.Position = UDim2.fromOffset(14, 0)
	title.BackgroundTransparency = 1
	title.Text = tostring(text or "Toggle")
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 14
	title.TextColor3 = theme.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = button

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromOffset(46, 24)
	bg.Position = UDim2.new(1, -60, 0.5, -12)
	bg.BackgroundColor3 = Color3.fromRGB(190, 65, 75)
	bg.BorderSizePixel = 0
	bg.Parent = button
	corner(bg, 20)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(20, 20)
	dot.Position = UDim2.fromOffset(2, 2)
	dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dot.BorderSizePixel = 0
	dot.Parent = bg
	corner(dot, 20)

	local enabled = defaultState == true

	local function update()
		tween(bg, {
			BackgroundColor3 = enabled and Color3.fromRGB(80, 210, 120) or Color3.fromRGB(190, 65, 75)
		})

		tween(dot, {
			Position = enabled and UDim2.fromOffset(24, 2) or UDim2.fromOffset(2, 2)
		})
	end

	update()

	button.MouseButton1Click:Connect(function()
		enabled = not enabled
		update()
		safe(callback, enabled)
	end)

	return button
end

function UI:StatCard(parent, title, value, icon)
	ensureLayout(parent)
	local theme = getTheme()

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -4, 0, 66)
	card.BackgroundColor3 = theme.Card
	card.BorderSizePixel = 0
	card.Parent = parent
	corner(card, 13)
	stroke(card)

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.fromOffset(42, 42)
	iconLabel.Position = UDim2.fromOffset(12, 12)
	iconLabel.BackgroundColor3 = theme.Accent
	iconLabel.Text = tostring(icon or "•")
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.TextSize = 18
	iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	iconLabel.BorderSizePixel = 0
	iconLabel.Parent = card
	corner(iconLabel, 12)

	local t = Instance.new("TextLabel")
	t.Size = UDim2.new(1, -74, 0, 22)
	t.Position = UDim2.fromOffset(64, 11)
	t.BackgroundTransparency = 1
	t.Text = tostring(title or "")
	t.Font = Enum.Font.GothamMedium
	t.TextSize = 13
	t.TextColor3 = theme.Muted
	t.TextXAlignment = Enum.TextXAlignment.Left
	t.Parent = card

	local v = Instance.new("TextLabel")
	v.Size = UDim2.new(1, -74, 0, 26)
	v.Position = UDim2.fromOffset(64, 32)
	v.BackgroundTransparency = 1
	v.Text = tostring(value or "")
	v.Font = Enum.Font.GothamBold
	v.TextSize = 15
	v.TextColor3 = theme.Text
	v.TextXAlignment = Enum.TextXAlignment.Left
	v.TextTruncate = Enum.TextTruncate.AtEnd
	v.Parent = card

	return card
end

function UI:SearchBox(parent, placeholder, callback)
	ensureLayout(parent)
	local theme = getTheme()

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, -4, 0, 46)
	box.BackgroundColor3 = theme.Card
	box.BorderSizePixel = 0
	box.Parent = parent
	corner(box, 12)
	stroke(box)

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.fromOffset(36, 46)
	icon.BackgroundTransparency = 1
	icon.Text = "🔍"
	icon.Font = Enum.Font.GothamBold
	icon.TextSize = 15
	icon.TextColor3 = theme.Muted
	icon.Parent = box

	local input = Instance.new("TextBox")
	input.Size = UDim2.new(1, -46, 1, 0)
	input.Position = UDim2.fromOffset(38, 0)
	input.BackgroundTransparency = 1
	input.Text = ""
	input.PlaceholderText = placeholder or "Search..."
	input.Font = Enum.Font.GothamMedium
	input.TextSize = 14
	input.TextColor3 = theme.Text
	input.PlaceholderColor3 = theme.Muted
	input.TextXAlignment = Enum.TextXAlignment.Left
	input.Parent = box

	input:GetPropertyChangedSignal("Text"):Connect(function()
		safe(callback, input.Text)
	end)

	return input
end

function UI:GameCard(parent, gameData, callback)
	ensureLayout(parent)
	local theme = getTheme()

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -4, 0, 72)
	button.BackgroundColor3 = theme.Card
	button.Text = ""
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Parent = parent
	corner(button, 14)
	stroke(button)

	local dot = Instance.new("TextLabel")
	dot.Size = UDim2.fromOffset(42, 42)
	dot.Position = UDim2.fromOffset(12, 15)
	dot.BackgroundColor3 = theme.Accent
	dot.Text = gameData.status or "🟢"
	dot.Font = Enum.Font.GothamBold
	dot.TextSize = 18
	dot.TextColor3 = Color3.fromRGB(255, 255, 255)
	dot.BorderSizePixel = 0
	dot.Parent = button
	corner(dot, 12)

	local name = Instance.new("TextLabel")
	name.Size = UDim2.new(1, -130, 0, 26)
	name.Position = UDim2.fromOffset(66, 13)
	name.BackgroundTransparency = 1
	name.Text = tostring(gameData.name)
	name.Font = Enum.Font.GothamBold
	name.TextSize = 15
	name.TextColor3 = theme.Text
	name.TextXAlignment = Enum.TextXAlignment.Left
	name.TextTruncate = Enum.TextTruncate.AtEnd
	name.Parent = button

	local id = Instance.new("TextLabel")
	id.Size = UDim2.new(1, -130, 0, 22)
	id.Position = UDim2.fromOffset(66, 39)
	id.BackgroundTransparency = 1
	id.Text = "PlaceId: " .. tostring(gameData.placeId)
	id.Font = Enum.Font.Gotham
	id.TextSize = 12
	id.TextColor3 = theme.Muted
	id.TextXAlignment = Enum.TextXAlignment.Left
	id.Parent = button

	local badge = Instance.new("TextLabel")
	badge.Size = UDim2.fromOffset(86, 28)
	badge.Position = UDim2.new(1, -100, 0.5, -14)
	badge.BackgroundColor3 = Color3.fromRGB(38, 70, 48)
	badge.Text = "Supported"
	badge.Font = Enum.Font.GothamBold
	badge.TextSize = 12
	badge.TextColor3 = Color3.fromRGB(160, 255, 185)
	badge.BorderSizePixel = 0
	badge.Parent = button
	corner(badge, 20)

	button.MouseEnter:Connect(function()
		tween(button, {BackgroundColor3 = theme.Hover})
	end)

	button.MouseLeave:Connect(function()
		tween(button, {BackgroundColor3 = theme.Card})
	end)

	button.MouseButton1Click:Connect(function()
		safe(callback)
	end)

	return button
end

function UI:ProfileCard(parent, name, role)
	ensureLayout(parent)
	local theme = getTheme()

	local card = Instance.new("Frame")
	card.Size = UDim2.new(1, -4, 0, 58)
	card.BackgroundColor3 = theme.Card
	card.BorderSizePixel = 0
	card.Parent = parent
	corner(card, 13)
	stroke(card)

	local avatar = Instance.new("TextLabel")
	avatar.Size = UDim2.fromOffset(36, 36)
	avatar.Position = UDim2.fromOffset(12, 11)
	avatar.BackgroundColor3 = theme.Accent
	avatar.Text = string.sub(tostring(name), 1, 1):upper()
	avatar.Font = Enum.Font.GothamBold
	avatar.TextSize = 16
	avatar.TextColor3 = Color3.fromRGB(255, 255, 255)
	avatar.BorderSizePixel = 0
	avatar.Parent = card
	corner(avatar, 50)

	local n = Instance.new("TextLabel")
	n.Size = UDim2.new(1, -70, 0, 24)
	n.Position = UDim2.fromOffset(60, 8)
	n.BackgroundTransparency = 1
	n.Text = tostring(name or "Unknown")
	n.Font = Enum.Font.GothamBold
	n.TextSize = 14
	n.TextColor3 = theme.Text
	n.TextXAlignment = Enum.TextXAlignment.Left
	n.Parent = card

	local r = Instance.new("TextLabel")
	r.Size = UDim2.new(1, -70, 0, 20)
	r.Position = UDim2.fromOffset(60, 31)
	r.BackgroundTransparency = 1
	r.Text = tostring(role or "Contributor")
	r.Font = Enum.Font.Gotham
	r.TextSize = 12
	r.TextColor3 = theme.Muted
	r.TextXAlignment = Enum.TextXAlignment.Left
	r.Parent = card

	return card
end

function UI:Unsupported(parent, callback)
	self:Hero(parent, "Unsupported Game", "This game is not registered in XYZ - HUB.")
	self:Button("Open Game List", parent, callback)
end

function UI:CredHead(parent, text)
	return self:SectionTitle(parent, text)
end

function UI:CredPerson(parent, text)
	return self:ProfileCard(parent, text, "Contributor")
end

return UI
