local GameListPage = {}

function GameListPage:Render(context)
	local container = context.Sections.GamesList.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games

	Utils:Clear(container)

	for _, gameData in ipairs(Games) do
		Elements:Button(gameData.status .. "  " .. gameData.name, container, function()
			warn("[XYZ - HUB] Selected Game:", gameData.name)
		end)
	end
end

return GameListPage
