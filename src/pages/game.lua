local GamePage = {}

function GamePage:Render(context)
	local container = context.Sections.Game.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games
	local Tabs = context.Tabs
	local Sections = context.Sections

	Utils:Clear(container)

	local currentPlaceId = tostring(game.PlaceId)
	local currentGame = nil

	for _, gameData in ipairs(Games) do
		if tostring(gameData.placeId) == currentPlaceId then
			currentGame = gameData
			break
		end
	end

	if not currentGame then
		Elements:Hero(container, "Unsupported Game", "This Game is not Listed in XYZ - HUB.")
		Elements:StatCard(container, "Current PlaceId", currentPlaceId, "🔴")

		Elements:Button("Open Game List", container, function()
			Tabs:Switch(Sections.GamesList)
		end)

		Elements:Button("Copy Discord", container, function()
			if setclipboard then
				setclipboard(context.Hub.Discord)
			end
		end)

		return
	end

	Elements:Hero(container, currentGame.name, "Game Module Loaded Successfully")
	Elements:StatCard(container, "Support Status", currentGame.status .. " Supported", "🎮")
	Elements:StatCard(container, "PlaceId", currentPlaceId, "🧩")

	local moduleUrl = getgitpath("games") .. currentPlaceId .. ".lua"
	local code = getgenv().XYZHubLoad(moduleUrl)

	if not code then
		Elements:StatCard(container, "Module", "No Module Found", "⚠️")
		return
	end

	local success, gameModule = pcall(function()
		return loadstring(code)()
	end)

	if not success or typeof(gameModule) ~= "function" then
		Elements:StatCard(container, "Module", "Load error", "🔴")
		return
	end

	local runSuccess, runError = pcall(function()
		gameModule(container, context)
	end)

	if not runSuccess then
		Elements:StatCard(container, "Runtime Error", tostring(runError), "🔴")
	end
end

return GamePage
