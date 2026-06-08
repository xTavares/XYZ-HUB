local TweenService = game:GetService("TweenService")

local Utils = {}

function Utils:Tween(object, properties, duration)
	TweenService:Create(
		object,
		TweenInfo.new(duration or 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		properties
	):Play()
end

function Utils:Clear(container)
	for _, child in ipairs(container:GetChildren()) do
		if child:IsA("GuiObject") then
			child:Destroy()
		end
	end
end

function Utils:SafeCall(callback, ...)
	if typeof(callback) == "function" then
		local success, err = pcall(callback, ...)

		if not success then
			warn("[XYZ - HUB] Callback Error:", err)
		end
	end
end

return Utils
