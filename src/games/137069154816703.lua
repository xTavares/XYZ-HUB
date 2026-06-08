-- Hack Vault for Brainrots - Modern & Optimized

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))()
    
    -- ==================== CONFIG ====================
    local CONFIG = {
        FarmRots = false,
    }
    
    -- ==================== SERVICES ====================
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    -- ==================== CONSTANTS ====================
    local SPAWN_ZONE_ID = 22
    local VAULT_POSITION = Vector3.new(-2494, 4, -726)
    local DEPOSIT_POSITION = Vector3.new(77, 4, -729)
    
    -- ==================== MAIN LOOP ====================
    
    elements:Toggle("Farm Brainrots", section, function(enabled)
        CONFIG.FarmRots = enabled
        getgenv().FarmRots = enabled
        
        if not enabled then return end
        
        task.spawn(function()
            while CONFIG.FarmRots do
                local char = player.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then
                    task.wait(1)
                    continue
                end
                
                -- Move to vault
                char:MoveTo(VAULT_POSITION)
                task.wait(0.5)
                
                -- Process entities
                for _, brainrot in ipairs(workspace.EntitiesFolder:GetChildren()) do
                    if not CONFIG.FarmRots then break end
                    
                    -- Check spawn zone
                    if brainrot:GetAttribute("SpawnZone") ~= SPAWN_ZONE_ID then
                        continue
                    end
                    
                    local primaryPart = brainrot:FindFirstChild("PrimaryPart")
                    if not primaryPart then
                        continue
                    end
                    
                    pcall(function()
                        -- Move to brainrot
                        char:MoveTo(primaryPart.Position)
                        task.wait()
                        
                        -- Interact with prompt
                        local prompt = primaryPart:FindFirstChild("TakeBrainrotPrompt")
                        if prompt then
                            repeat
                                fireproximityprompt(prompt)
                                task.wait()
                            until not primaryPart or primaryPart:FindFirstChild("Attachment")
                        end
                        
                        -- Return to deposit
                        char:MoveTo(DEPOSIT_POSITION)
                        task.wait(1)
                    end)
                end
                
                task.wait()
            end
        end)
    end)
end
