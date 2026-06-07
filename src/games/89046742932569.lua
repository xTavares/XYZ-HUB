-- sail for brainrots - VERSÃO CORRIGIDA

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    
    local player = game:GetService("Players").LocalPlayer
    local zonesFold = workspace.Zones
    local repStorage = game:GetService("ReplicatedStorage")
    
    -- ============ CONFIG ============
    local CONFIG = {
        FARM_COOLDOWN = 0.1,
        RETURN_COOLDOWN = 0.5,
        SELL_CHECK_INTERVAL = 3,
        MOVEMENT_TIMEOUT = 15,
        PROMPT_RETRY = 5,
        PROXIMITY_OFFSET = Vector3.new(0, 3, 0),
        CODES = {"Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin"}
    }
    
    getgenv().Farming = false
    getgenv().Selling = false
    getgenv().ChosenZone = nil
    getgenv().MaxPrice = 0
    
    -- ============ PARSE VALUE ============
    local function parseValue(str)
        if not str or type(str) ~= "string" then return 0 end
        
        local suffixes = {K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15}
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
    
    -- ============ FARMING - VERSÃO CORRIGIDA ============
    elements:Textbox("Farm Zone (1-13)", section, function(v)
        local zoneNum = tonumber(v)
        if not zoneNum or zoneNum < 1 or zoneNum > 13 then
            warn("Zona inválida! Use 1-13")
            return
        end
        
        getgenv().ChosenZone = zonesFold["Zone" .. zoneNum]
        print("✓ Zona selecionada: Zone" .. zoneNum)
    end)
    
    elements:Toggle("AutoFarm", section, function(v)
        if v then
            if not getgenv().ChosenZone then
                warn("Selecione uma zona primeiro!")
                return
            end
            
            getgenv().Farming = true
            print("🌾 Farm iniciado!")
            
            task.spawn(function()
                while getgenv().Farming do
                    local char = player.Character
                    if not char or not char:FindFirstChild("HumanoidRootPart") then
                        task.wait(0.5)
                        continue
                    end
                    
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if not humanoid or humanoid.Health <= 0 then
                        task.wait(0.5)
                        continue
                    end
                    
                    local objects = getgenv().ChosenZone:FindFirstChild("Objects")
                    if not objects then
                        task.wait(1)
                        continue
                    end
                    
                    -- ⭐ LOOP CORRETO PARA CADA OBJETO
                    for _, brainrot in pairs(objects:GetChildren()) do
                        if not getgenv().Farming then break end
                        if brainrot.Parent ~= objects then continue end
                        
                        local prompt = brainrot:FindFirstChild("ProximityPrompt")
                        if not prompt then continue end
                        
                        pcall(function()
                            local targetPos = brainrot.PrimaryPart.Position + CONFIG.PROXIMITY_OFFSET
                            
                            -- Mover para o objeto
                            humanoid:MoveTo(targetPos)
                            
                            -- ⭐ AGUARDAR CHEGADA OU TIMEOUT
                            local startTime = tick()
                            local reached = false
                            
                            local connection
                            connection = humanoid.MoveToFinished:Connect(function(completed)
                                if completed then
                                    reached = true
                                end
                                connection:Disconnect()
                            end)
                            
                            -- Timeout de 15s
                            while not reached and (tick() - startTime) < CONFIG.MOVEMENT_TIMEOUT do
                                if not getgenv().Farming or brainrot.Parent ~= objects then break end
                                task.wait(0.1)
                            end
                            
                            if connection and connection.Connected then
                                connection:Disconnect()
                            end
                            
                            -- ⭐ DISPARAR PROMPT MÚLTIPLAS VEZES
                            if brainrot.Parent == objects then
                                for retry = 1, CONFIG.PROMPT_RETRY do
                                    if brainrot.Parent ~= objects or not getgenv().Farming then break end
                                    
                                    pcall(function()
                                        fireproximityprompt(prompt)
                                    end)
                                    
                                    task.wait(0.15)
                                end
                            end
                        end)
                        
                        task.wait(CONFIG.FARM_COOLDOWN)
                    end
                    
                    -- Retornar à base
                    if getgenv().Farming then
                        local baseRoot = getPlayerBase()
                        if baseRoot then
                            humanoid:MoveTo(baseRoot.Position)
                            task.wait(CONFIG.RETURN_COOLDOWN)
                        end
                    end
                    
                    task.wait(0.5)
                end
                
                print("✓ Farm finalizado")
            end)
        else
            getgenv().Farming = false
        end
    end)
    
    -- ============ SELLING ============
    elements:Textbox("Max Price", section, function(v)
        local price = tonumber(v)
        getgenv().MaxPrice = price or 0
    end)
    
    elements:Toggle("Auto Sell", section, function(v)
        if v then
            if getgenv().MaxPrice == 0 then
                warn("Defina um preço máximo!")
                return
            end
            
            getgenv().Selling = true
            
            task.spawn(function()
                while getgenv().Selling do
                    local char = player.Character
                    if not char then
                        task.wait(1)
                        continue
                    end
                    
                    for _, item in pairs(player.Backpack:GetChildren()) do
                        if item.Name == "Bat" then continue end
                        
                        pcall(function()
                            local handle = item:FindFirstChild("Handle")
                            if handle then
                                local objectInfo = handle:FindFirstChild("ObjectInfo")
                                if objectInfo and objectInfo:FindFirstChild("Value") then
                                    local valueLabel = objectInfo.Value:FindFirstChild("ValueLabel")
                                    if valueLabel then
                                        local price = parseValue(valueLabel.Text)
                                        if price <= getgenv().MaxPrice then
                                            local Event = repStorage.Shared.Classes.RemoteFunction.Remotes.EntityShared_SellEntity
                                            Event:InvokeServer(item.Name)
                                        end
                                    end
                                end
                            end
                        end)
                    end
                    
                    task.wait(CONFIG.SELL_CHECK_INTERVAL)
                end
            end)
        else
            getgenv().Selling = false
        end
    end)
    
    -- ============ REDEEM CODES ============
    elements:Button("Redeem Codes", section, function()
        local Event = repStorage.Shared.Classes.RemoteFunction.Remotes.CodeShared_Redeem
        
        for _, code in pairs(CONFIG.CODES) do
            pcall(function()
                Event:InvokeServer(code)
                print("✓ Regatado: " .. code)
            end)
            task.wait(0.2)
        end
    end)
    
    -- ============ CLEANUP ============
    player:GetPropertyChangedSignal("Parent"):Connect(function()
        if not player.Parent then
            getgenv().Farming = false
            getgenv().Selling = false
        end
    end)
end
