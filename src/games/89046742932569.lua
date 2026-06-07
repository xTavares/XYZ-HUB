-- sail for brainrots - Versão Ultra Otimizada

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    
    local player = game:GetService("Players").LocalPlayer
    local zonesFold = workspace.Zones
    local repStorage = game:GetService("ReplicatedStorage")
    
    -- ============ CONFIG CENTRALIZADA ============
    local CONFIG = {
        FARM_COOLDOWN = 0.1,
        RETURN_COOLDOWN = 0.5,
        SELL_CHECK_INTERVAL = 3,
        ZONE_CHECK_INTERVAL = 1,
        BAT_TOOL_NAME = "Bat",
        MAX_ZONES = 13,
        CODES = {"Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin"}
    }
    
    -- ============ STATE MANAGEMENT ============
    getgenv().Farming = false
    getgenv().Selling = false
    getgenv().ChosenZone = nil
    getgenv().MaxPrice = 0
    getgenv().FarmingStats = {
        collected = 0,
        sold = 0,
        startTime = 0
    }
    
    -- ============ UTILITY FUNCTIONS ============
    local function parseValue(str)
        if not str or type(str) ~= "string" then return 0 end
        
        local suffixes = {
            K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15
        }
        
        local num, suffix = str:match("^([%d%.]+)([A-Za-z]*)")
        if not num then return 0 end
        
        num = tonumber(num) or 0
        suffix = suffix:upper()
        
        return suffixes[suffix] and (num * suffixes[suffix]) or num
    end
    
    local function getPlayerBase()
        local base = workspace.Bases:FindFirstChild(player.Name)
        return base and base:FindFirstChild("Root")
    end
    
    local function isCharacterValid(char)
        return char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChildOfClass("Humanoid").Health > 0
    end
    
    local function formatTime(seconds)
        local hours = math.floor(seconds / 3600)
        local mins = math.floor((seconds % 3600) / 60)
        local secs = seconds % 60
        return string.format("%02d:%02d:%02d", hours, mins, secs)
    end
    
    -- ============ FARMING FEATURE ============
    elements:Textbox("Farm Zone (1-" .. CONFIG.MAX_ZONES .. ")", section, function(v)
        local zoneNum = tonumber(v)
        if not zoneNum or zoneNum < 1 or zoneNum > CONFIG.MAX_ZONES then
            warn("Zona Inválida! Use 1-" .. CONFIG.MAX_ZONES)
            return
        end
        
        getgenv().ChosenZone = zonesFold["Zone" .. zoneNum]
        if getgenv().ChosenZone then
            print("✓ Zona Selecionada: Zone" .. zoneNum)
        else
            warn("Zona não Encontrada!")
        end
    end)
    
    elements:Toggle("AutoFarm", section, function(v)
        if v then
            if not getgenv().ChosenZone then
                warn("Selecione uma Zona Primeiro!")
                return
            end
            
            getgenv().Farming = true
            getgenv().FarmingStats.collected = 0
            getgenv().FarmingStats.startTime = tick()
            
            task.spawn(function()
                while getgenv().Farming do
                    local char = player.Character
                    if not isCharacterValid(char) then
                        task.wait(CONFIG.ZONE_CHECK_INTERVAL)
                        continue
                    end
                    
                    local baseRoot = getPlayerBase()
                    if not baseRoot then
                        task.wait(CONFIG.ZONE_CHECK_INTERVAL)
                        continue
                    end
                    
                    -- Coletar brainrots
                    local objects = getgenv().ChosenZone:FindFirstChild("Objects")
                    if objects then
                        for _, brainrot in pairs(objects:GetChildren()) do
                            if not getgenv().Farming then break end
                            if not brainrot:FindFirstChild("PrimaryPart") then continue end
                            
                            pcall(function()
                                char:MoveTo(brainrot.PrimaryPart.Position)
                                
                                -- Aguardar chegada
                                local timeout = tick() + 10
                                repeat
                                    if not getgenv().Farming or tick() > timeout then break end
                                    if brainrot.Parent ~= objects then break end
                                    
                                    if brainrot:FindFirstChild("ProximityPrompt") then
                                        fireproximityprompt(brainrot.ProximityPrompt)
                                    end
                                    
                                    task.wait(CONFIG.FARM_COOLDOWN)
                                until brainrot.Parent ~= objects or not getgenv().Farming
                                
                                getgenv().FarmingStats.collected = getgenv().FarmingStats.collected + 1
                            end)
                        end
                    end
                    
                    -- Retornar à base
                    if getgenv().Farming then
                        pcall(function()
                            char:MoveTo(baseRoot.Position)
                        end)
                        task.wait(CONFIG.RETURN_COOLDOWN)
                    end
                    
                    task.wait(CONFIG.ZONE_CHECK_INTERVAL)
                end
                
                local elapsedTime = tick() - getgenv().FarmingStats.startTime
                print(string.format("✓ Farm Concluído | Coletados: %d | Tempo: %s", 
                    getgenv().FarmingStats.collected, formatTime(elapsedTime)))
            end)
        else
            getgenv().Farming = false
        end
    end)
    
    -- ============ SELLING FEATURE ============
    elements:Textbox("Max Price", section, function(v)
        local price = tonumber(v)
        getgenv().MaxPrice = price or 0
        if price then
            print("✓ Preço Máximo Definido: " .. tostring(price))
        end
    end)
    
    elements:Toggle("Auto Sell", section, function(v)
        if v then
            if getgenv().MaxPrice == 0 then
                warn("Defina um Preço Máximo Primeiro!")
                return
            end
            
            getgenv().Selling = true
            getgenv().FarmingStats.sold = 0
            
            task.spawn(function()
                while getgenv().Selling do
                    local char = player.Character
                    if not isCharacterValid(char) then
                        task.wait(CONFIG.SELL_CHECK_INTERVAL)
                        continue
                    end
                    
                    local backpackItems = player.Backpack:GetChildren()
                    local itemsToSell = {}
                    
                    -- Coletar items para vender
                    for _, item in pairs(backpackItems) do
                        if item.Name == CONFIG.BAT_TOOL_NAME then continue end
                        
                        pcall(function()
                            local handle = item:FindFirstChild("Handle")
                            if handle then
                                local objectInfo = handle:FindFirstChild("ObjectInfo")
                                if objectInfo then
                                    local valueLabel = objectInfo.Value:FindFirstChild("ValueLabel")
                                    if valueLabel then
                                        local price = parseValue(valueLabel.Text)
                                        if price <= getgenv().MaxPrice then
                                            table.insert(itemsToSell, item.Name)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    
                    -- Vender em paralelo
                    if #itemsToSell > 0 then
                        local sellEvent = repStorage.Shared.Classes.RemoteFunction.Remotes.EntityShared_SellEntity
                        for _, itemName in pairs(itemsToSell) do
                            task.spawn(function()
                                pcall(function()
                                    sellEvent:InvokeServer(itemName)
                                    getgenv().FarmingStats.sold = getgenv().FarmingStats.sold + 1
                                end)
                            end)
                        end
                    end
                    
                    task.wait(CONFIG.SELL_CHECK_INTERVAL)
                end
                
                print("✓ Auto Sell Desativado | Total Vendido: " .. getgenv().FarmingStats.sold)
            end)
        else
            getgenv().Selling = false
        end
    end)
    
    -- ============ CODE REDEMPTION ============
    elements:Button("Redeem Codes", section, function()
        local redeemEvent = repStorage.Shared.Classes.RemoteFunction.Remotes.CodeShared_Redeem
        local successCount = 0
        
        for i, code in pairs(CONFIG.CODES) do
            task.spawn(function()
                pcall(function()
                    local result = redeemEvent:InvokeServer(code)
                    if result then
                        print("✓ Código resgatado: " .. code)
                        successCount = successCount + 1
                    end
                end)
            end)
            task.wait(0.1)
        end
        
        print("✓ Resgate Concluído | Total: " .. successCount .. "/" .. #CONFIG.CODES)
    end)
    
    -- ============ STATS DISPLAY ============
    elements:Button("Show Stats", section, function()
        local elapsed = tick() - getgenv().FarmingStats.startTime
        print("\n=== FARMING STATS ===")
        print("Coletados: " .. getgenv().FarmingStats.collected)
        print("Vendidos: " .. getgenv().FarmingStats.sold)
        print("Tempo: " .. formatTime(elapsed))
        print("Taxa: " .. string.format("%.2f", getgenv().FarmingStats.collected / math.max(elapsed, 1)) .. " Items/s")
        print("====================\n")
    end)
    
    -- ============ CLEANUP ============
    player:GetPropertyChangedSignal("Parent"):Connect(function()
        if not player.Parent then
            getgenv().Farming = false
            getgenv().Selling = false
        end
    end)
end
