local TweenService = game:GetService("TweenService")

local env = getgenv()
local hub = env.XYZHub

local UI = {}

local COLORS = {
	Bg = Color3.fromRGB(18, 19, 29),
	Card = Color3.fromRGB(30, 31, 48),
	CardHover = Color3.fromRGB(42, 44, 68),
	Text = Color3.fromRGB(240, 242, 255),
	Muted = Color3.fromRGB(160, 165, 190),
	Accent = Color3.fromRGB(126, 87, 255),
	Green = Color3.fromRGB(90, 220, 120),
	Red = Color3.fromRGB(220, 80, 80)
}

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
		parent.ScrollBarImageColor3 = Color3.fromRGB(105, 80, 255)
		parent.ScrollingDirection = Enum.ScrollingDirection.Y
		parent.AutomaticCanvasSize = Enum.AutomaticSize.None

		local function updateCanvas()
			task.defer(function()
				parent.CanvasSize = UDim2.new(
					0,
					0,
					0,
					layout.AbsoluteContentSize.Y + 40
				)
			end)
		end

		updateCanvas()
		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
		parent.ChildAdded:Connect(updateCanvas)
		parent.ChildRemoved:Connect(updateCanvas)
	end
end

local function corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = obj
end

local function stroke(obj)
	local s = Instance.new("UIStroke")
	s.Color = Color3.fromRGB(55, 57, 84)
	s.Thickness = 1
	s.Transparency = 0.35
	s.Parent = obj
end

local function tween(obj, props, time)
	TweenService:Create(
		obj,
		TweenInfo.new(time or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
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

function UI:Label(text, parent)
	ensureLayout(parent)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -4, 0, 34)
	label.BackgroundColor3 = COLORS.Card
	label.Text = tostring(text or "")
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = COLORS.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextYAlignment = Enum.TextYAlignment.Center
	label.TextWrapped = true
	label.BorderSizePixel = 0
	label.Parent = parent

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 14)
	pad.PaddingRight = UDim.new(0, 14)
	pad.Parent = label

	corner(label, 10)
	stroke(label)

	return label
end

function UI:Button(text, parent, callback)
	ensureLayout(parent)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -4, 0, 46)
	button.BackgroundColor3 = COLORS.Card
	button.Text = tostring(text or "Button")
	button.Font = Enum.Font.GothamMedium
	button.TextSize = 14
	button.TextColor3 = COLORS.Text
	button.TextXAlignment = Enum.TextXAlignment.Left
	button.AutoButtonColor = false
	button.Parent = parent

	local pad = Instance.new("UIPadding")
	pad.PaddingLeft = UDim.new(0, 14)
	pad.Parent = button

	corner(button, 10)
	stroke(button)

	button.MouseEnter:Connect(function()
		tween(button, {BackgroundColor3 = COLORS.CardHover})
	end)

	button.MouseLeave:Connect(function()
		tween(button, {BackgroundColor3 = COLORS.Card})
	end)

	button.MouseButton1Click:Connect(function()
		safe(callback)
	end)

	return button
end

function UI:Toggle(text, parent, callback, default)
	ensureLayout(parent)

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -4, 0, 48)
	button.BackgroundColor3 = COLORS.Card
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = parent

	corner(button, 10)
	stroke(button)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.fromOffset(14, 0)
	title.BackgroundTransparency = 1
	title.Text = tostring(text or "Toggle")
	title.Font = Enum.Font.GothamMedium
	title.TextSize = 14
	title.TextColor3 = COLORS.Text
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = button

	local bg = Instance.new("Frame")
	bg.Size = UDim2.fromOffset(44, 22)
	bg.Position = UDim2.new(1, -58, 0.5, -11)
	bg.BackgroundColor3 = COLORS.Red
	bg.Parent = button
	corner(bg, 20)

	local dot = Instance.new("Frame")
	dot.Size = UDim2.fromOffset(18, 18)
	dot.Position = UDim2.fromOffset(2, 2)
	dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	dot.Parent = bg
	corner(dot, 20)

	local enabled = default == true

	local function update()
		tween(bg, {
			BackgroundColor3 = enabled and COLORS.Green or COLORS.Red
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

function UI:Textbox(text, parent, callback, placeholder)
	ensureLayout(parent)

	local box = Instance.new("Frame")
	box.Size = UDim2.new(1, -4, 0, 58)
	box.BackgroundColor3 = COLORS.Card
	box.Parent = parent
	corner(box, 10)
	stroke(box)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 0, 22)
	label.Position = UDim2.fromOffset(12, 4)
	label.BackgroundTransparency = 1
	label.Text = tostring(text or "Textbox")
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 13
	label.TextColor3 = COLORS.Muted
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = box

	local input = Instance.new("TextBox")
	input.Size = UDim2.new(1, -24, 0, 24)
	input.Position = UDim2.fromOffset(12, 28)
	input.BackgroundTransparency = 1
	input.PlaceholderText = tostring(placeholder or "Enter value...")
	input.Text = ""
	input.Font = Enum.Font.Gotham
	input.TextSize = 14
	input.TextColor3 = COLORS.Text
	input.TextXAlignment = Enum.TextXAlignment.Left
	input.Parent = box

	input.FocusLost:Connect(function(enterPressed)
		safe(callback, input.Text, enterPressed)
	end)

	return box
end

function UI:Unsupported(parent, callback)
	ensureLayout(parent)

	self:Label("🔴 This game is not supported.", parent)
	self:Label("Current game is not listed in XYZ - HUB.", parent)

	self:Button("Copy Discord Invite", parent, function()
		if setclipboard then
			setclipboard(hub.Discord)
		end
	end)

	self:Button("Open Games List", parent, callback)
end

function UI:CredHead(parent, text)
	ensureLayout(parent)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -4, 0, 34)
	label.BackgroundTransparency = 1
	label.Text = "> " .. tostring(text or "Credits")
	label.Font = Enum.Font.GothamBold
	label.TextSize = 15
	label.TextColor3 = COLORS.Accent
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	return label
end

function UI:CredPerson(parent, text)
	ensureLayout(parent)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -4, 0, 26)
	label.BackgroundTransparency = 1
	label.Text = "   + " .. tostring(text or "Unknown")
	label.Font = Enum.Font.Gotham
	label.TextSize = 14
	label.TextColor3 = COLORS.Text
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = parent

	return label
end

return UI
