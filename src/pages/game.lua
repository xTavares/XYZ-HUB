local GamePage = {}

function GamePage:Render(context)
	local container = context.Sections.Game.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games or {}

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
		Elements:Hero(container, "Unsupported Game", "This Game is not Registered in XYZ - HUB.")
		Elements:StatCard(container, "Current PlaceId", currentPlaceId, "🔴")
		Elements:StatCard(container, "Games Loaded", tostring(#Games), "📋")
		return
	end

	Elements:Hero(container, currentGame.name, "Premium Module Interface")
	Elements:StatCard(container, "Status", (currentGame.status or "🟢") .. " Supported", "🎮")
	Elements:StatCard(container, "PlaceId", currentPlaceId, "🧩")

	local moduleUrl = getgitpath("games") .. currentPlaceId .. ".lua"
	local code = getgenv().XYZHubLoad(moduleUrl)

	if not code then
		Elements:StatCard(container, "Module", "No Module Found", "⚠️")
		Elements:Label("Expected file: src/games/" .. currentPlaceId .. ".lua", container)
		return
	end

local success, gameModule = pcall(function()
	local loaded = loadstring(code)

	if typeof(loaded) ~= "function" then
		return nil
	end

	return loaded()
end)

if not success then
	Elements:StatCard(container, "Module Error", tostring(gameModule), "🔴")
	Elements:Label("URL: " .. moduleUrl, container)
	return
end

if typeof(gameModule) ~= "function" then
	Elements:StatCard(container, "Module", "Did not Return Function", "🔴")
	Elements:Label("Returned type: " .. typeof(gameModule), container)
	Elements:Label("URL: " .. moduleUrl, container)
	return
end

	if not success then
		Elements:StatCard(container, "Module Error", tostring(gameModule), "🔴")
		return
	end

	if typeof(gameModule) ~= "function" then
		Elements:StatCard(container, "Module", "Did not Return Function", "🔴")
		return
	end

	Elements:SectionTitle(container, "Modules")

	local runSuccess, runError = pcall(function()
		gameModule(container, context)
	end)

	if not runSuccess then
		Elements:StatCard(container, "Runtime Error", tostring(runError), "🔴")
	end
end

return GamePage
