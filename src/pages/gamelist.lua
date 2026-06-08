local GameListPage = {}

function GameListPage:Render(context)
	local container = context.Sections.GamesList.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Games = context.Games

	Utils:Clear(container)

	Elements:Hero(container, "Game List", "Search Supported Games")
	Elements:StatCard(container, "Total Games", tostring(#Games), "📋")

	Elements:SearchBox(container, "Search Game...", function(query)
		GameListPage:RenderFiltered(context, query)
	end)

	GameListPage:RenderFiltered(context, "")
end

function GameListPage:RenderFiltered(context, query)
	local container = context.Sections.GamesList.Container
	local Elements = context.Elements
	local Games = context.Games

	for _, child in ipairs(container:GetChildren()) do
		if child:GetAttribute("GameCard") then
			child:Destroy()
		end
	end

	query = string.lower(query or "")

	for _, gameData in ipairs(Games) do
		local name = string.lower(gameData.name or "")

		if query == "" or string.find(name, query, 1, true) then
			local card = Elements:GameCard(container, gameData, function()
				warn("[XYZ - HUB] Selected Game:", gameData.name)
			end)

			card:SetAttribute("GameCard", true)
		end
	end
end

return GameListPage
