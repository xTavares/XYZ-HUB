local UserInputService = game:GetService("UserInputService")

local Dragging = {}

function Dragging:MakeDraggable(guiObject)
	local dragging = false
	local wasDragged = false
	local dragInput = nil
	local startMouse = nil
	local startPosition = nil

	guiObject.Active = true

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			wasDragged = false
			startMouse = input.Position
			startPosition = guiObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					task.delay(0.05, function()
						dragging = false
					end)
				end
			end)
		end
	end)

	guiObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and input == dragInput and startMouse and startPosition then
			local delta = input.Position - startMouse

			if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
				wasDragged = true
			end

			guiObject.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)

	return function()
		return wasDragged
	end
end

return Dragging
