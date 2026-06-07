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
	Elements:Label("PlaceId: " .. currentPlaceId, container)

	local moduleUrl = getgitpath("games") .. currentPlaceId .. ".lua"

	Elements:Label("Loading module:", container)
	Elements:Label(moduleUrl, container)

	local code = getgenv().XYZHubLoad(moduleUrl)

	if not code then
		Elements:Label("No module found for this game.", container)
		return
	end

	local success, gameModule = pcall(function()
		return loadstring(code)()
	end)

	if not success then
		Elements:Label("Module load error.", container)
		warn("[XYZ - HUB] Module load error:", gameModule)
		return
	end

	if typeof(gameModule) ~= "function" then
		Elements:Label("Module did not return a function.", container)
		return
	end

	local runSuccess, runErr = pcall(function()
		gameModule(container, context)
	end)

	if not runSuccess then
		Elements:Label("Module runtime error.")
		warn("[XYZ - HUB] Module runtime error:", runErr)
	end
end

return GamePage
