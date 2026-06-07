-- Sail for Brainrots - Refactored Version
-- Modern, professional, and maintainable

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))()
    
    -- ==================== CONFIG ====================
    local CONFIG = {
        Farming = false,
        Selling = false,
        ChosenZone = nil,
        MaxPrice = 0,
        SellDelay = 3,
        TaskDelay = 0.5,
        ExcludedItems = { "Bat" },
        RedeemCodes = { "Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin" }
    }
    
    for key, value in pairs(CONFIG) do
        getgenv()[key] = value
    end
    
    -- ==================== SERVICES ====================
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local zonesFold = workspace.Zones
    
    -- ==================== UTILITY FUNCTIONS ====================
    
    --- Parse numeric value with suffixes (K, M, B, T, Q)
    local function parseValue(str)
        if type(str) ~= "string" then return 0 end
        
        local suffixes = {
            K = 1e3, M = 1e6, B = 1e9,
            T = 1e12, Q = 1e15
        }
        
        local num, suffix = str:match("^([%d%.]+)([A-Za-z]*)")
        
        if not num then return 0 end
        
        num = tonumber(num) or 0
        suffix = suffix:upper()
        
        return suffixes[suffix] and (num * suffixes[suffix]) or num
    end
    
    --- Validate player character exists
    local function getCharacter()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            return char
        end
        return nil
    end
    
    --- Check if item is in exclusion list
    local function isExcluded(itemName)
        for _, excluded in ipairs(CONFIG.ExcludedItems) do
            if itemName == excluded then return true end
        end
        return false
    end
    
    --- Get zone by number
    local function getZone(zoneNumber)
        local zone = zonesFold:FindFirstChild("Zone" .. zoneNumber)
        if not zone or not zone:FindFirstChild("Objects") then
            warn("Invalid zone: Zone" .. zoneNumber)
            return nil
        end
        return zone
    end
    
    -- ==================== FARMING ====================
    
    elements:Textbox("Farm Zone (1-13)", section, function(value)
        local zoneNum = tonumber(value)
        if not zoneNum or zoneNum < 1 or zoneNum > 13 then
            warn("Zone must be between 1-13")
            return
        end
        CONFIG.ChosenZone = getZone(zoneNum)
        if CONFIG.ChosenZone then
            getgenv().ChosenZone = CONFIG.ChosenZone
            print("✓ Zone " .. zoneNum .. " selected")
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
                
                local baseRoot = workspace.Bases:FindFirstChild(player.Name)
                if not baseRoot or not baseRoot:FindFirstChild("Root") then
                    task.wait(1)
                    continue
                end
                
                local objects = CONFIG.ChosenZone.Objects:GetChildren()
                
                for _, brainrot in ipairs(objects) do
                    if not CONFIG.Farming or not brainrot.Parent then break end
                    
                    -- Move to object
                    if brainrot:FindFirstChild("PrimaryPart") then
                        char:MoveTo(brainrot.PrimaryPart.Position)
                    end
                    
                    -- Interact with object
                    repeat
                        if brainrot and brainrot:FindFirstChild("ProximityPrompt") then
                            fireproximityprompt(brainrot.ProximityPrompt)
                        end
                        task.wait(0.1)
                    until not brainrot or not brainrot.Parent or brainrot.Parent ~= CONFIG.ChosenZone.Objects
                    
                    -- Return to base
                    char:MoveTo(baseRoot.Root.Position)
                    task.wait(CONFIG.TaskDelay)
                end
                
                task.wait(1)
            end
        end)
    end)
    
    -- ==================== SELLING ====================
    
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
                
                local backpack = player.Backpack:GetChildren()
                
                for _, item in ipairs(backpack) do
                    if isExcluded(item.Name) then continue end
                    
                    task.spawn(function()
                        local success, result = pcall(function()
                            local valueLabel = item:FindFirstChild("Handle")
                            if not valueLabel then return end
                            
                            valueLabel = valueLabel:FindFirstChild("ObjectInfo")
                            if not valueLabel then return end
                            
                            valueLabel = valueLabel:FindFirstChild("Value")
                            if not valueLabel then return end
                            
                            valueLabel = valueLabel:FindFirstChild("ValueLabel")
                            if not valueLabel then return end
                            
                            local price = parseValue(valueLabel.Text)
                            
                            if price <= CONFIG.MaxPrice then
                                local remoteFunc = ReplicatedStorage:FindFirstChild("Shared")
                                if remoteFunc then
                                    remoteFunc = remoteFunc:FindFirstChild("Classes")
                                    if remoteFunc then
                                        remoteFunc = remoteFunc:FindFirstChild("RemoteFunction")
                                        if remoteFunc then
                                            remoteFunc = remoteFunc:FindFirstChild("Remotes")
                                            if remoteFunc then
                                                remoteFunc = remoteFunc:FindFirstChild("EntityShared_SellEntity")
                                                if remoteFunc then
                                                    remoteFunc:InvokeServer(item.Name)
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                        
                        if not success then
                            warn("Error selling item " .. item.Name .. ": " .. tostring(result))
                        end
                    end)
                end
                
                task.wait(CONFIG.SellDelay)
            end
        end)
    end)
    
    -- ==================== REDEMPTION ====================
    
    elements:Button("Redeem Codes", section, function()
        task.spawn(function()
            for _, code in ipairs(CONFIG.RedeemCodes) do
                pcall(function()
                    local remoteFunc = ReplicatedStorage:FindFirstChild("Shared")
                    if remoteFunc then
                        remoteFunc = remoteFunc:FindFirstChild("Classes")
                        if remoteFunc then
                            remoteFunc = remoteFunc:FindFirstChild("RemoteFunction")
                            if remoteFunc then
                                remoteFunc = remoteFunc:FindFirstChild("Remotes")
                                if remoteFunc then
                                    remoteFunc = remoteFunc:FindFirstChild("CodeShared_Redeem")
                                    if remoteFunc then
                                        remoteFunc:InvokeServer(code)
                                        print("✓ Redeemed: " .. code)
                                    end
                                end
                            end
                        end
                    end
                end)
                task.wait(0.5)
            end
        end)
    end)
end
