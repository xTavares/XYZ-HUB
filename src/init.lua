local env = getgenv()

local HUB_NAME = "XYZ - HUB"
local HUB_FOLDER = "XYZHub"
local RAW_BASE = "https://raw.githubusercontent.com/xTavares/XYZ-HUB/refs/heads/main/"

env.XYZHub = env.XYZHub or {}
env.XYZHub.Name = HUB_NAME
env.XYZHub.Folder = HUB_FOLDER
env.XYZHub.Discord = "https://discord.gg/3DraReZnUz"
env.XYZHub.RawBase = RAW_BASE
env.XYZHub.AutoRejoin = env.XYZHub.AutoRejoin or false

if not isfolder(HUB_FOLDER) then
	makefolder(HUB_FOLDER)
end

function env.import(assetId)
	local success, objects = pcall(function()
		return game:GetObjects(assetId)
	end)

	if success and objects and objects[1] then
		return objects[1]
	end

	warn("[XYZ - HUB] Failed to import asset:", assetId)
	return nil
end

function env.getgitpath(pathType)
	if pathType == "src" then
		return RAW_BASE .. "src/"
	elseif pathType == "pages" then
		return RAW_BASE .. "src/pages/"
	elseif pathType == "modules" then
		return RAW_BASE .. "src/modules/"
	elseif pathType == "data" then
		return RAW_BASE .. "src/data/"
	elseif pathType == "games" then
		return RAW_BASE .. "src/games/"
	end

	return RAW_BASE
end

function env.XYZHubLoad(path)
	local separator = string.find(path, "?", 1, true) and "&" or "?"
	local finalPath = path .. separator .. "cacheBust=" .. tostring(os.clock()) .. "-" .. tostring(math.random(1, 999999999))

	local success, result = pcall(function()
		return game:HttpGet(finalPath, true)
	end)

	if not success then
		warn("[XYZ - HUB] HTTP error:", finalPath, result)
		return nil
	end

	if not result or result == "" or result == "404: Not Found" then
		warn("[XYZ - HUB] Failed to load:", finalPath)
		return nil
	end

	return result
end

game:GetService("GuiService").ErrorMessageChanged:Connect(function()
	if env.XYZHub.AutoRejoin then
		pcall(function()
			game:GetService("TeleportService"):Teleport(game.PlaceId)
		end)
	end
end)

local uiCode = env.XYZHubLoad(getgitpath("src") .. "ui.lua")

if uiCode then
	local success, err = pcall(function()
		loadstring(uiCode)()
	end)

	if not success then
		warn("[XYZ - HUB] UI error:", err)
	end
end
