local CreditsPage = {}

function CreditsPage:Render(context)
	local container = context.Sections.Credits.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Credits = context.Credits

	Utils:Clear(container)

	Elements:Hero(container, "Credits", "People behind XYZ - HUB")

	for role, people in pairs(Credits) do
		Elements:SectionTitle(container, role)

		for _, person in ipairs(people) do
			Elements:ProfileCard(container, person, role)
		end
	end
end

return CreditsPage
