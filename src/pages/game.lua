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
		Elements:Unsupported(container, function()
			Tabs:Switch(Sections.GamesList)
		end)

		Elements:Label("Current PlaceId: " .. currentPlaceId, container)
		return
	end

	Elements:Label("🟢 Game Supported", container)
	Elements:Label("Game: " .. currentGame.name, container)
	Elements:Label("PlaceId: " .. currentGame.placeId, container)

	local modulePath = getgitpath("games") .. currentPlaceId .. ".lua"
	local code = getgenv().XYZHubLoad(modulePath)

	if not code then
		Elements:Label("No module found for this game.", container)
		return
	end

	local success, gameModule = pcall(function()
		return loadstring(code)()
	end)

	if success and typeof(gameModule) == "function" then
		gameModule(container, context)
	else
		Elements:Label("Failed to load game module.", container)
	end
end

return GamePage
