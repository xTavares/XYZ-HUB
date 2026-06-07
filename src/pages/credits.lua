local CreditsPage = {}

function CreditsPage:Render(context)
	local container = context.Sections.Credits.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Credits = context.Credits

	Utils:Clear(container)

	for role, people in pairs(Credits) do
		Elements:CredHead(container, role)

		for _, person in ipairs(people) do
			Elements:CredPerson(container, person)
		end
	end
end

return CreditsPage
