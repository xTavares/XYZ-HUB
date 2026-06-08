local GamePage = {}

function GamePage:Render(context)
	local container = context.Sections.Game.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games or {}

	Utils:Clear(container)

	local currentPlaceId = tostring(game.PlaceId)

	Elements:Hero(container, "Game", "Current game detection")
	Elements:StatCard(container, "Current PlaceId", currentPlaceId, "🧩")
	Elements:StatCard(container, "Games Loaded", tostring(#Games), "📋")

	local currentGame = nil

	for _, gameData in ipairs(Games) do
		if tostring(gameData.placeId) == currentPlaceId then
			currentGame = gameData
			break
		end
	end

	if not currentGame then
		Elements:StatCard(container, "Status", "Unsupported", "🔴")
		return
	end

	Elements:StatCard(container, "Status", (currentGame.status or "🟢") .. " Supported", "🎮")
	Elements:StatCard(container, "Game", currentGame.name, "⭐")

	local moduleUrl = getgitpath("games") .. currentPlaceId .. ".lua"
	Elements:Label("Loading: " .. moduleUrl, container)

	local code = getgenv().XYZHubLoad(moduleUrl)

	if not code then
		Elements:StatCard(container, "Module", "No module found", "⚠️")
		return
	end

	local success, gameModule = pcall(function()
		return loadstring(code)()
	end)

	if not success then
		Elements:StatCard(container, "Module Error", tostring(gameModule), "🔴")
		return
	end

	if typeof(gameModule) ~= "function" then
		Elements:StatCard(container, "Module", "Did not return function", "🔴")
		return
	end

	local ok, err = pcall(function()
		gameModule(container, context)
	end)

	if not ok then
		Elements:StatCard(container, "Runtime Error", tostring(err), "🔴")
	end
end

return GamePage
