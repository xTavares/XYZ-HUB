local Home = {}

function Home:Render(context)
	local container = context.Sections.Home.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Hub = context.Hub

	Utils:Clear(container)

	Elements:Label("XYZ - HUB", container)
	Elements:Label("Welcome to the Official XYZ Hub Interface.", container)
	Elements:Label("Discord: " .. Hub.Discord, container)
	Elements:Label("Status: 🟢 Online", container)

	local executorName = "Roblox"

	if identifyexecutor then
		local success, result = pcall(identifyexecutor)

		if success and result then
			executorName = result
		end
	end

	Elements:Label("Client: " .. executorName, container)
end

return Home
