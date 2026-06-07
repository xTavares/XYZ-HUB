local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local env = getgenv()
local Hub = env.XYZHub

local function getParentGui()
	local hiddenGui = gethui or get_hidden_gui
	return hiddenGui and hiddenGui() or CoreGui
end

local function loadModule(path)
	local code = env.XYZHubLoad(path)
	if not code then return nil end

	local success, result = pcall(function()
		return loadstring(code)()
	end)

	if success then
		return result
	end

	warn("[XYZ - HUB] Module error:", path, result)
	return nil
end

local function corner(obj, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = obj
end

local function stroke(obj, color, transparency)
	local s = Instance.new("UIStroke")
	s.Color = color or Color3.fromRGB(75, 78, 115)
	s.Thickness = 1
	s.Transparency = transparency or 0.35
	s.Parent = obj
end

local function tween(obj, props, duration)
	TweenService:Create(
		obj,
		TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		props
	):Play()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XYZ_Hub_Interface"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = getParentGui()

local MainFrame = Instance.new("Frame")
MainFrame.Name = "Frame"
MainFrame.Size = UDim2.fromOffset(720, 430)
MainFrame.Position = UDim2.new(0.5, -360, 0.5, -215)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 13, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui
corner(MainFrame, 16)
stroke(MainFrame, Color3.fromRGB(105, 80, 255), 0.15)

local Topbar = Instance.new("Frame")
Topbar.Name = "TopBar"
Topbar.Size = UDim2.new(1, 0, 0, 58)
Topbar.BackgroundColor3 = Color3.fromRGB(17, 18, 29)
Topbar.BorderSizePixel = 0
Topbar.Parent = MainFrame
corner(Topbar, 16)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -160, 0, 30)
Title.Position = UDim2.fromOffset(22, 7)
Title.BackgroundTransparency = 1
Title.Text = "XYZ - HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 21
Title.TextColor3 = Color3.fromRGB(245, 246, 255)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Topbar

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -160, 0, 20)
Subtitle.Position = UDim2.fromOffset(23, 33)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Modern Roblox Interface"
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextSize = 13
Subtitle.TextColor3 = Color3.fromRGB(145, 150, 180)
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Topbar

local HideButton = Instance.new("TextButton")
HideButton.Name = "hidebtn"
HideButton.Size = UDim2.fromOffset(86, 32)
HideButton.Position = UDim2.new(1, -106, 0.5, -16)
HideButton.BackgroundColor3 = Color3.fromRGB(32, 34, 52)
HideButton.Text = "Hide"
HideButton.Font = Enum.Font.GothamMedium
HideButton.TextSize = 13
HideButton.TextColor3 = Color3.fromRGB(235, 237, 255)
HideButton.BorderSizePixel = 0
HideButton.AutoButtonColor = false
HideButton.Parent = Topbar
corner(HideButton, 10)

local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "togglebtn"
ToggleButton.Size = UDim2.fromOffset(118, 40)
ToggleButton.Position = UDim2.new(0, 24, 0.5, -20)
ToggleButton.BackgroundColor3 = Color3.fromRGB(105, 80, 255)
ToggleButton.Text = "XYZ - HUB"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 14
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BorderSizePixel = 0
ToggleButton.AutoButtonColor = false
ToggleButton.Visible = false
ToggleButton.Active = true
ToggleButton.Draggable = false
ToggleButton.Parent = ScreenGui
corner(ToggleButton, 12)
stroke(ToggleButton, Color3.fromRGB(145, 125, 255), 0.15)

local TabList = Instance.new("Frame")
TabList.Name = "tablist"
TabList.Size = UDim2.fromOffset(178, 348)
TabList.Position = UDim2.fromOffset(14, 70)
TabList.BackgroundColor3 = Color3.fromRGB(18, 20, 31)
TabList.BorderSizePixel = 0
TabList.Parent = MainFrame
corner(TabList, 14)
stroke(TabList, Color3.fromRGB(55, 58, 88), 0.45)

local TabLayout = Instance.new("UIListLayout")
TabLayout.Padding = UDim.new(0, 10)
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Parent = TabList

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 14)
TabPadding.PaddingLeft = UDim.new(0, 12)
TabPadding.PaddingRight = UDim.new(0, 12)
TabPadding.Parent = TabList

local SectionContainers = Instance.new("Frame")
SectionContainers.Name = "sectionContainers"
SectionContainers.Size = UDim2.fromOffset(500, 348)
SectionContainers.Position = UDim2.fromOffset(206, 70)
SectionContainers.BackgroundColor3 = Color3.fromRGB(18, 20, 31)
SectionContainers.BorderSizePixel = 0
SectionContainers.ClipsDescendants = true
SectionContainers.Parent = MainFrame
corner(SectionContainers, 14)
stroke(SectionContainers, Color3.fromRGB(55, 58, 88), 0.45)

local function createTab(name, order)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(1, 0, 0, 43)
	btn.BackgroundColor3 = Color3.fromRGB(27, 29, 44)
	btn.BackgroundTransparency = 1
	btn.Text = ""
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.LayoutOrder = order
	btn.Parent = TabList
	corner(btn, 11)

	local bar = Instance.new("Frame")
	bar.Name = "InnerShadow"
	bar.Size = UDim2.fromOffset(4, 22)
	bar.Position = UDim2.fromOffset(0, 10)
	bar.BackgroundColor3 = Color3.fromRGB(105, 80, 255)
	bar.BorderSizePixel = 0
	bar.Transparency = 1
	bar.Parent = btn
	corner(bar, 8)

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, -20, 1, 0)
	label.Position = UDim2.fromOffset(16, 0)
	label.BackgroundTransparency = 1
	label.Text = name:gsub("Tab", "")
	label.Font = Enum.Font.GothamMedium
	label.TextSize = 14
	label.TextColor3 = Color3.fromRGB(225, 228, 245)
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = btn

	return btn
end

local function createContainer(name)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = name
	scroll.Size = UDim2.new(1, 0, 1, 0)
	scroll.Position = UDim2.new(0.5, 0, 1, 0)
	scroll.AnchorPoint = Vector2.new(0.5, 0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.Visible = false
	scroll.ClipsDescendants = true
	scroll.ScrollingEnabled = true
	scroll.ScrollBarThickness = 5
	scroll.ScrollBarImageColor3 = Color3.fromRGB(105, 80, 255)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.None
	scroll.ScrollingDirection = Enum.ScrollingDirection.Y
	scroll.Parent = SectionContainers

	return scroll
end

local HomeTab = createTab("HomeTab", 1)
local GameTab = createTab("GameTab", 2)
local GameslistTab = createTab("GameslistTab", 3)
local SettingsTab = createTab("SettingsTab", 4)
local CreditsTab = createTab("CreditsTab", 5)

local homeframe = createContainer("homeframe")
local gameFrame = createContainer("gameFrame")
local gamelistFrame = createContainer("gamelistFrame")
local settingsFrame = createContainer("settingsFrame")
local creditsFrame = createContainer("creditsFrame")

local Elements = loadModule(getgitpath("src") .. "elements.lua")
local Utils = loadModule(getgitpath("modules") .. "utils.lua")
local Dragging = loadModule(getgitpath("modules") .. "dragging.lua")
local TabsModule = loadModule(getgitpath("modules") .. "tabs.lua")

local Games = loadModule(getgitpath("data") .. "games.lua")
local Credits = loadModule(getgitpath("data") .. "credits.lua")

local HomePage = loadModule(getgitpath("pages") .. "home.lua")
local GamePage = loadModule(getgitpath("pages") .. "game.lua")
local GameListPage = loadModule(getgitpath("pages") .. "gamelist.lua")
local SettingsPage = loadModule(getgitpath("pages") .. "settings.lua")
local CreditsPage = loadModule(getgitpath("pages") .. "credits.lua")

local Theme = loadModule(getgitpath("modules") .. "theme.lua")

if not Elements or not Utils or not Dragging or not TabsModule or not Theme then
	warn("[XYZ - HUB] Core modules failed.")
	return
end

local Sections = {
	Home = { TabBtn = HomeTab, Container = homeframe },
	Game = { TabBtn = GameTab, Container = gameFrame },
	GamesList = { TabBtn = GameslistTab, Container = gamelistFrame },
	Settings = { TabBtn = SettingsTab, Container = settingsFrame },
	Credits = { TabBtn = CreditsTab, Container = creditsFrame }
}

local Tabs = TabsModule:Create(Sections, Utils)

local context = {
	Hub = Hub,
	UI = ScreenGui,
	MainFrame = MainFrame,
	ToggleButton = ToggleButton,
	Sections = Sections,
	Elements = Elements,
	Utils = Utils,
	Tabs = Tabs,
	Theme = Theme,
	Games = Games or {},
	Credits = Credits or {}
}

HideButton.MouseEnter:Connect(function()
	tween(HideButton, {BackgroundColor3 = Color3.fromRGB(45, 47, 70)})
end)

HideButton.MouseLeave:Connect(function()
	tween(HideButton, {BackgroundColor3 = Color3.fromRGB(32, 34, 52)})
end)

HideButton.MouseButton1Click:Connect(function()
	MainFrame.Visible = false
	ToggleButton.Visible = true
	ToggleButton.ZIndex = 999
end)

ToggleButton.MouseButton1Click:Connect(function()
	if ToggleWasDragged and ToggleWasDragged() then
		return
	end

	MainFrame.Visible = true
	ToggleButton.Visible = false
end)

Dragging:MakeDraggable(MainFrame)
local ToggleWasDragged = Dragging:MakeDraggable(ToggleButton)

HomePage:Render(context)
GamePage:Render(context)
GameListPage:Render(context)
SettingsPage:Render(context)
CreditsPage:Render(context)

Tabs:Init(Sections.Home)
