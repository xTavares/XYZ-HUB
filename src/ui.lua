local CoreGui = game:GetService("CoreGui")

local env = getgenv()
local Hub = env.XYZHub

local function getParentGui()
	local hiddenGui = gethui or get_hidden_gui

	if hiddenGui then
		return hiddenGui()
	end

	return CoreGui
end

local function loadModule(path)
	local code = env.XYZHubLoad(path)

	if not code then
		return nil
	end

	local success, result = pcall(function()
		return loadstring(code)()
	end)

	if success then
		return result
	end

	warn("[XYZ - HUB] Module Error:", path, result)
	return nil
end

local ui = import("rbxassetid://75281832304062")

if not ui then
	warn("[XYZ - HUB] Failed to Load UI Asset.")
	return
end

ui.Name = "XYZ_Hub_Interface"
ui.Parent = getParentGui()

local ToggleButton = ui:WaitForChild("togglebtn")
local MainFrame = ui:WaitForChild("Frame")

local Topbar = MainFrame:WaitForChild("TopBar")
local SectionContainers = MainFrame:WaitForChild("sectionContainers")
local TabList = MainFrame:WaitForChild("tablist")

local HideButton = Topbar:WaitForChild("hidebtn")

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

if not Elements or not Utils or not Dragging or not TabsModule then
	warn("[XYZ - HUB] Core Modules Failed to Load.")
	return
end

if not Games or not Credits then
	warn("[XYZ - HUB] Data Files Failed to Load.")
	return
end

if not HomePage or not GamePage or not GameListPage or not SettingsPage or not CreditsPage then
	warn("[XYZ - HUB] Page Files Failed to Load.")
	return
end

local Sections = {
	Home = {
		TabBtn = TabList:WaitForChild("HomeTab"),
		Container = SectionContainers:WaitForChild("homeframe")
	},

	Game = {
		TabBtn = TabList:WaitForChild("GameTab"),
		Container = SectionContainers:WaitForChild("gameFrame")
	},

	GamesList = {
		TabBtn = TabList:WaitForChild("GameslistTab"),
		Container = SectionContainers:WaitForChild("gamelistFrame")
	},

	Settings = {
		TabBtn = TabList:WaitForChild("SettingsTab"),
		Container = SectionContainers:WaitForChild("settingsFrame")
	},

	Credits = {
		TabBtn = TabList:WaitForChild("CreditsTab"),
		Container = SectionContainers:WaitForChild("creditsFrame")
	}
}

local Tabs = TabsModule:Create(Sections, Utils)

local context = {
	Hub = Hub,
	UI = ui,
	MainFrame = MainFrame,
	ToggleButton = ToggleButton,
	Sections = Sections,
	Elements = Elements,
	Utils = Utils,
	Tabs = Tabs,
	Games = Games,
	Credits = Credits
}

local function renderAllPages()
	HomePage:Render(context)
	GamePage:Render(context)
	GameListPage:Render(context)
	SettingsPage:Render(context)
	CreditsPage:Render(context)
end

local function setupVisibility()
	ToggleButton.Visible = false
	MainFrame.Visible = true

	HideButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = false
		ToggleButton.Visible = true
	end)

	ToggleButton.MouseButton1Click:Connect(function()
		MainFrame.Visible = true
		ToggleButton.Visible = false
	end)
end

setupVisibility()
Dragging:MakeDraggable(MainFrame)

renderAllPages()

Tabs:Init(Sections.Home)
