local TweenService = game:GetService("TweenService")

local env = getgenv()
local hub = env.XYZHub

local elements = import("rbxassetid://113037265185555")

local UI = {}

local COLORS = {
	Green = Color3.fromRGB(70, 190, 95),
	Red = Color3.fromRGB(190, 70, 70),
	Button = Color3.fromRGB(35, 36, 52),
	ButtonHover = Color3.fromRGB(48, 50, 72),
	Text = Color3.fromRGB(235, 237, 255)
}

local function safeCallback(callback, ...)
	if typeof(callback) == "function" then
		local success, err = pcall(callback, ...)

		if not success then
			warn("[XYZ - HUB] Callback Error:", err)
		end
	end
end

local function tween(object, properties, duration)
	TweenService:Create(
		object,
		TweenInfo.new(duration or 0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	):Play()
end

local function addHover(button)
	if not button or not button:IsA("GuiButton") then
		return
	end

	local originalColor = button.BackgroundColor3

	button.MouseEnter:Connect(function()
		tween(button, {
			BackgroundColor3 = COLORS.ButtonHover
		}, 0.14)
	end)

	button.MouseLeave:Connect(function()
		tween(button, {
			BackgroundColor3 = originalColor
		}, 0.14)
	end)
end

function UI:Label(text, parent)
	local label = elements.LabelElement:Clone()
	label.Text = tostring(text or "")
	label.TextColor3 = COLORS.Text
	label.Parent = parent

	return label
end

function UI:Button(text, parent, callback)
	local button = elements.ButtonElement:Clone()
	button.TextLabel.Text = tostring(text or "Button")
	button.Parent = parent

	addHover(button)

	button.MouseButton1Click:Connect(function()
		safeCallback(callback)
	end)

	return button
end

function UI:Toggle(text, parent, callback, defaultState)
	local toggle = elements.ToggleElement:Clone()
	toggle.TextLabel.Text = tostring(text or "Toggle")
	toggle.Parent = parent

	local enabled = defaultState == true

	local function updateVisual(state)
		local bgColor = state and COLORS.Green or COLORS.Red
		local anchor = state and Vector2.new(1, 0.5) or Vector2.new(0, 0.5)
		local position = state and UDim2.new(1, 0, 0.5, 0) or UDim2.new(0, 0, 0.5, 0)

		tween(toggle.togglebg, {
			BackgroundColor3 = bgColor
		}, 0.18)

		toggle.togglebg.leftrightlol.AnchorPoint = anchor

		tween(toggle.togglebg.leftrightlol, {
			Position = position
		}, 0.18)
	end

	updateVisual(enabled)

	toggle.MouseButton1Click:Connect(function()
		enabled = not enabled
		updateVisual(enabled)
		safeCallback(callback, enabled)
	end)

	return toggle
end

function UI:Textbox(text, parent, callback, placeholder)
	local textbox = elements.TextboxElement:Clone()
	textbox.TextLabel.Text = tostring(text or "Textbox")
	textbox.Parent = parent

	if textbox:FindFirstChild("tbbg") and textbox.tbbg:FindFirstChild("Inp") then
		textbox.tbbg.Inp.PlaceholderText = tostring(placeholder or "Enter Value...")

		textbox.tbbg.Inp.FocusLost:Connect(function(enterPressed)
			safeCallback(callback, textbox.tbbg.Inp.Text, enterPressed)
		end)
	end

	return textbox
end

function UI:Unsupported(parent, callback)
	local unsupported = elements.unsupportElement:Clone()
	unsupported.Parent = parent

	if unsupported:FindFirstChild("suggestbtn") then
		unsupported.suggestbtn.MouseButton1Click:Connect(function()
			if setclipboard then
				setclipboard(hub.Discord)
			end

			local oldText = unsupported.suggestbtn.Text
			unsupported.suggestbtn.Text = "Copied Discord!"

			task.wait(1)

			unsupported.suggestbtn.Text = oldText or "Suggest Game"
		end)
	end

	if unsupported:FindFirstChild("glbtn") then
		unsupported.glbtn.MouseButton1Click:Connect(function()
			safeCallback(callback)
		end)
	end

	return unsupported
end

function UI:CredHead(parent, text)
	local header = elements.CreditHeader:Clone()
	header.Text = "> " .. tostring(text or "Credits")
	header.Parent = parent

	return header
end

function UI:CredPerson(parent, text)
	local credit = elements.CreditPerson:Clone()
	credit.Text = "      + " .. tostring(text or "Unknown")
	credit.Parent = parent

	return credit
end

return UI
