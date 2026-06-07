local GamePage = {}

function GamePage:Render(context)
	local container = context.Sections.Game.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games
	local Tabs = context.Tabs
	local Sections = context.Sections

	Utils:Clear(container)

	local currentGame = nil

	for _, gameData in ipairs(Games) do
		if tonumber(gameData.placeId) == game.PlaceId then
			currentGame = gameData
			break
		end
	end

	if currentGame then
		Elements:Label("🟢 Game Supported", container)
		Elements:Label("Game: " .. currentGame.name, container)
		Elements:Label("PlaceId: " .. tostring(currentGame.placeId), container)
	else
		Elements:Unsupported(container, function()
			Tabs:Switch(Sections.GamesList)
		end)
	end
end

return GamePage
