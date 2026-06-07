return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src") .. "elements.lua"))()
    
    local CONFIG = {
        Farming = false,
        Selling = false,
        ChosenZone = nil,
        MaxPrice = 0,
    }
    
    for key, value in pairs(CONFIG) do
        getgenv()[key] = value
    end
    
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local player = Players.LocalPlayer
    local zonesFold = workspace.Zones
    
    local function parseValue(str)
        if type(str) ~= "string" then return 0 end
        
        local suffixes = { K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15 }
        local num, suffix = str:match("^([%d%.]+)([A-Za-z]*)")
        
        if not num then return 0 end
        num = tonumber(num) or 0
        suffix = suffix:upper()
        
        return suffixes[suffix] and (num * suffixes[suffix]) or num
    end
    
    local function getCharacter()
        local char = player.Character
        return (char and char:FindFirstChild("HumanoidRootPart")) and char or nil
    end
    
    -- ✅ Função segura para obter Remotes
    local function getRemote(path)
        local current = ReplicatedStorage
        for _, part in ipairs(path) do
            if not current then return nil end
            current = current:FindFirstChild(part)
        end
        return current
    end
    
    -- ==================== FARMING ====================
    
    elements:Textbox("Farm Zone (1-13)", section, function(value)
        local zoneNum = tonumber(value)
        if zoneNum and zoneNum >= 1 and zoneNum <= 13 then
            CONFIG.ChosenZone = zonesFold:FindFirstChild("Zone" .. zoneNum)
            getgenv().ChosenZone = CONFIG.ChosenZone
        end
    end)
    
    elements:Toggle("Autofarm", section, function(enabled)
        CONFIG.Farming = enabled
        getgenv().Farming = enabled
        
        if not enabled then return end
        
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
            
            for _, brainrot in pairs(CONFIG.ChosenZone.Objects:GetChildren()) do
                if not CONFIG.Farming or not brainrot.Parent then break end
                
                pcall(function()
                    if brainrot:FindFirstChild("PrimaryPart") then
                        char:MoveTo(brainrot.PrimaryPart.Position)
                    end
                    
                    repeat
                        if brainrot and brainrot.Parent and brainrot:FindFirstChild("ProximityPrompt") then
                            fireproximityprompt(brainrot.ProximityPrompt)
                        end
                        task.wait(0.1)
                    until not brainrot or not brainrot.Parent or brainrot.Parent ~= CONFIG.ChosenZone.Objects
                    
                    char:MoveTo(baseRoot.Root.Position)
                    task.wait(0.5)
                end)
            end
            
            task.wait(1)
        end
    end)
    
    -- ==================== SELLING ====================
    
    elements:Textbox("Max price", section, function(value)
        CONFIG.MaxPrice = tonumber(value) or 0
        getgenv().MaxPrice = CONFIG.MaxPrice
    end)
    
    elements:Toggle("Auto Sell", section, function(enabled)
        CONFIG.Selling = enabled
        getgenv().Selling = enabled
        
        if not enabled then return end
        
        while CONFIG.Selling do
            local char = getCharacter()
            if not char then
                task.wait(1)
                continue
            end
            
            for _, brainrot in pairs(player.Backpack:GetChildren()) do
                if brainrot.Name ~= "Bat" then
                    spawn(function()
                        pcall(function()
                            local valueText = brainrot.Handle.ObjectInfo.Value.ValueLabel.Text
                            if parseValue(valueText) <= CONFIG.MaxPrice then
                                -- ✅ Usando a função segura
                                local remote = getRemote({"Shared", "Classes", "RemoteFunction", "Remotes", "EntityShared_SellEntity"})
                                if remote then
                                    remote:InvokeServer(brainrot.Name)
                                else
                                    warn("Remote EntityShared_SellEntity não encontrada")
                                end
                            end
                        end)
                    end)
                end
            end
            
            task.wait(3)
        end
    end)
    
    -- ==================== REDEMPTION ====================
    
    elements:Button("Redeem Codes", section, function()
        local codes = {"Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin"}
        
        for _, code in pairs(codes) do
            pcall(function()
                -- ✅ Usando a função segura
                local remote = getRemote({"Shared", "Classes", "RemoteFunction", "Remotes", "CodeShared_Redeem"})
                if remote then
                    remote:InvokeServer(code)
                    print("✓ Redeemed: " .. code)
                else
                    warn("Remote CodeShared_Redeem não encontrada")
                end
            end)
            task.wait(0.5)
        end
    end)
end
