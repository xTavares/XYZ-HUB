-- Sail for Brainrots - Optimized & Professional

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))()
    
    -- ==================== CONFIG ====================
    local CONFIG = {
        Farming = false,
        Selling = false,
        ChosenZone = nil,
        MaxPrice = 0,
    }
    
    -- Sync with global environment
    for key, value in pairs(CONFIG) do
        getgenv()[key] = value
    end
    
    -- ==================== SERVICES ====================
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local zonesFold = workspace.Zones
    
    -- ==================== CONSTANTS ====================
    local REDEEM_CODES = { "Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin" }
    local EXCLUDED_ITEMS = { "Bat" }
    
    local VALUE_SUFFIXES = {
        K = 1e3,
        M = 1e6,
        B = 1e9,
        T = 1e12,
        Q = 1e15,
    }
    
    -- ==================== UTILITY FUNCTIONS ====================
    
    --- Parse numeric value with suffixes (K, M, B, T, Q)
    local function parseValue(str)
        local num, suffix = str:match("^([%d%.]+)([A-Za-z]*)")
        if not num then return 0 end
        
        num = tonumber(num) or 0
        suffix = suffix:upper()
        
        return VALUE_SUFFIXES[suffix] and (num * VALUE_SUFFIXES[suffix]) or num
    end
    
    --- Check if item should be excluded
    local function isExcluded(itemName)
        for _, excluded in ipairs(EXCLUDED_ITEMS) do
            if itemName == excluded then return true end
        end
        return false
    end
    
    --- Get valid character
    local function getCharacter()
        local char = player.Character
        return (char and char:FindFirstChild("HumanoidRootPart")) and char or nil
    end
    
    --- Safe remote invocation
    local function invokeRemote(remotePath, ...)
        local success, result = pcall(function()
            local remote = ReplicatedStorage
            for _, part in ipairs(remotePath) do
                remote = remote[part]
            end
            return remote:InvokeServer(...)
        end)
        
        if not success then
            warn("Remote call failed: " .. table.concat(remotePath, ".") .. " - " .. tostring(result))
        end
        
        return success, result
    end
    
    -- ==================== UI ELEMENTS ====================
    
    elements:Textbox("Farm Zone (1-13)", section, function(value)
        local zoneNum = tonumber(value)
        if zoneNum and zoneNum >= 1 and zoneNum <= 13 then
            CONFIG.ChosenZone = zonesFold["Zone" .. zoneNum]
            getgenv().ChosenZone = CONFIG.ChosenZone
            print("✓ Zone " .. zoneNum .. " selected")
        else
            warn("⚠ Invalid zone number. Must be 1-13")
        end
    end)
    
    elements:Toggle("Autofarm", section, function(enabled)
        CONFIG.Farming = enabled
        getgenv().Farming = enabled
        
        if not enabled then return end
        
        task.spawn(function()
            while CONFIG.Farming do
                local char = getCharacter()
                
                if not char or not CONFIG.ChosenZone then
                    task.wait(1)
                    continue
                end
                
                local zoneObjects = CONFIG.ChosenZone:FindFirstChild("Objects")
                if not zoneObjects then
                    task.wait(1)
                    continue
                end
                
                local baseRoot = workspace.Bases[player.Name]
                if not baseRoot or not baseRoot:FindFirstChild("Root") then
                    task.wait(1)
                    continue
                end
                
                for _, brainrot in ipairs(zoneObjects:GetChildren()) do
                    if not CONFIG.Farming or not brainrot.Parent then break end
                    
                    pcall(function()
                        local primaryPart = brainrot:FindFirstChild("PrimaryPart")
                        local proximityPrompt = brainrot:FindFirstChild("ProximityPrompt")
                        
                        if primaryPart and proximityPrompt then
                            char:MoveTo(primaryPart.Position)
                            
                            repeat
                                if brainrot and brainrot.Parent then
                                    fireproximityprompt(proximityPrompt)
                                end
                                task.wait()
                            until not brainrot or brainrot.Parent ~= zoneObjects
                            
                            char:MoveTo(baseRoot.Root.Position)
                            task.wait(0.5)
                        end
                    end)
                end
                
                task.wait(1)
            end
        end)
    end)
    
    elements:Textbox("Max price", section, function(value)
        CONFIG.MaxPrice = tonumber(value) or 0
        getgenv().MaxPrice = CONFIG.MaxPrice
        print("✓ Max price set to: " .. CONFIG.MaxPrice)
    end)
    
    elements:Toggle("Auto Sell", section, function(enabled)
        CONFIG.Selling = enabled
        getgenv().Selling = enabled
        
        if not enabled then return end
        
        task.spawn(function()
            while CONFIG.Selling do
                local char = getCharacter()
                
                if not char then
                    task.wait(1)
                    continue
                end
                
                for _, item in ipairs(player.Backpack:GetChildren()) do
                    if not isExcluded(item.Name) then
                        task.spawn(function()
                            pcall(function()
                                local handle = item:FindFirstChild("Handle")
                                if handle then
                                    local objectInfo = handle:FindFirstChild("ObjectInfo")
                                    if objectInfo then
                                        local value = objectInfo:FindFirstChild("Value")
                                        if value then
                                            local valueLabel = value:FindFirstChild("ValueLabel")
                                            if valueLabel then
                                                local price = parseValue(valueLabel.Text)
                                                if price <= CONFIG.MaxPrice then
                                                    invokeRemote(
                                                        { "Shared", "Classes", "RemoteFunction", "Remotes", "EntityShared_SellEntity" },
                                                        item.Name
                                                    )
                                                end
                                            end
                                        end
                                    end
                                end
                            end)
                        end)
                    end
                end
                
                task.wait(3)
            end
        end)
    end)
    
    elements:Button("Redeem Codes", section, function()
        task.spawn(function()
            for _, code in ipairs(REDEEM_CODES) do
                invokeRemote(
                    { "Shared", "Classes", "RemoteFunction", "Remotes", "CodeShared_Redeem" },
                    code
                )
                print("✓ Redeemed: " .. code)
                task.wait(0.3)
            end
        end)
    end)
end
