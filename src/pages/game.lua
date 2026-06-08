local GamePage = {}

function GamePage:Render(context)
	local container = context.Sections.Game.Container
	local Elements = context.Elements
	local Utils = context.Utils

	Utils:Clear(container)

	Elements:Hero(container, "Game Page Test", "If you see this, game.lua is loading.")
	Elements:StatCard(container, "PlaceId", tostring(game.PlaceId), "🧩")
	Elements:StatCard(container, "Status", "Page render working", "🟢")
end

return GamePage
