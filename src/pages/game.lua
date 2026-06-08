local GamePage = {}

function GamePage:Render(context)
	local container = context.Sections.Game.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games or {}

	Utils:Clear(container)

	local currentPlaceId = tostring(game.PlaceId)
	local currentGame

	for _, gameData in ipairs(Games) do
		if tostring(gameData.placeId) == currentPlaceId then
			currentGame = gameData
			break
		end
	end

	if not currentGame then
		Elements:Hero(container, "Unsupported Game", "This game is not registered in XYZ - HUB.")
		Elements:StatCard(container, "Current PlaceId", currentPlaceId, "🔴")
		Elements:StatCard(container, "Status", "Not Supported", "⚠️")
		return
	end

	Elements:Hero(container, currentGame.name, "Premium module interface")
	Elements:StatCard(container, "Status", (currentGame.status or "🟢") .. " Supported", "🎮")
	Elements:StatCard(container, "PlaceId", currentPlaceId, "🧩")

	Elements:SectionTitle(container, "Modules")

	local moduleUrl = getgitpath("games") .. currentPlaceId .. ".lua"
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

	local runSuccess, runError = pcall(function()
		gameModule(container, context)
	end)

	if not runSuccess then
		Elements:StatCard(container, "Runtime Error", tostring(runError), "🔴")
	end
end

return GamePage
