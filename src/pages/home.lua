local Home = {}

function Home:Render(context)
	local container = context.Sections.Home.Container
	local Elements = context.Elements
	local Utils = context.Utils
	local Hub = context.Hub
	local Games = context.Games

	Utils:Clear(container)

	Elements:Hero(container, "XYZ - HUB", "Professional Roblox Hub Interface")

	Elements:StatCard(container, "Supported Games", tostring(#Games), "🟢")
	Elements:StatCard(container, "Status", "Online", "⚡")
	Elements:StatCard(container, "Discord", Hub.Discord, "💬")

	local executorName = "Roblox"

	if identifyexecutor then
		local success, result = pcall(identifyexecutor)
		if success and result then
			executorName = result
		end
	end

	Elements:StatCard(container, "Client", executorName, "🖥️")
end

return Home
