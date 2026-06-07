local UserInputService = game:GetService("UserInputService")

local Dragging = {}

function Dragging:MakeDraggable(guiObject)
	local dragging = false
	local moved = false
	local dragInput
	local startMouse
	local startPosition

	guiObject.Active = true

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			moved = false
			startMouse = input.Position
			startPosition = guiObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
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
		if dragging and input == dragInput then
			local delta = input.Position - startMouse

			if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
				moved = true
			end

			guiObject.Position = UDim2.new(
				startPosition.X.Scale,
				startPosition.X.Offset + delta.X,
				startPosition.Y.Scale,
				startPosition.Y.Offset + delta.Y
			)
		end
	end)

	function guiObject:GetAttribute()
	end

	return function()
		return moved
	end
end

return Dragging
