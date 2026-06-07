-- Reel for brainrots - Versão Melhorada

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    
    local repStorage = game:GetService("ReplicatedStorage")
    local plr = game:GetService("Players").LocalPlayer
    local placeEv = repStorage.RemoteHandler.Plot
    
    -- Config centralizada
    local CONFIG = {
        FISHING_COOLDOWN = 0.1,
        DUPE_COOLDOWN = 0.5,
        MAX_PLOTS = 30,
        BRAINROT_ATTRIBUTE = "brainrot"
    }
    
    -- State management
    getgenv().Farming = false
    local farmingConnection = nil
    
    -- ============ FARMING FEATURE ============
    elements:Toggle("Farming", section, function(isOn)
        if isOn then
            getgenv().Farming = true
            
            -- Loop melhorado com melhor controle
            task.spawn(function()
                while getgenv().Farming do
                    if pcall(function()
                        repStorage.RemoteHandler.Fishing:FireServer("Caught", 3)
                    end) then
                        -- Sucesso
                    else
                        warn("Erro ao fazer Fishing")
                    end
                    
                    task.wait(CONFIG.FISHING_COOLDOWN)
                end
                getgenv().Farming = false
            end)
        else
            getgenv().Farming = false
        end
    end)
    
    -- ============ DUPE FEATURE ============
    elements:Button("Dupe Brainrot InHand", section, function()
        local char = plr.Character
        if not char then
            warn("Personagem não Encontrado")
            return
        end
        
        local br = char:FindFirstChildOfClass("Tool")
        
        -- Validações robustas
        if not br then
            warn("Nenhuma Tool em Mãos")
            return
        end
        
        if not br:GetAttribute(CONFIG.BRAINROT_ATTRIBUTE) then
            warn("Tool Não é um Brainrot Válido")
            return
        end
        
        -- Dupe com tratamento de erros
        local successCount = 0
        local failCount = 0
        
        for plotNum = 1, CONFIG.MAX_PLOTS do
            if not getgenv().Farming then -- Permite cancelamento
                if pcall(function()
                    placeEv:FireServer("Add", "Plot" .. plotNum, br.Name)
                    successCount = successCount + 1
                end) then
                    -- Sucesso silencioso
                else
                    failCount = failCount + 1
                    warn("Erro ao duplicar no Plot " .. plotNum)
                end
            end
            
            task.wait(CONFIG.DUPE_COOLDOWN)
        end
        
        print("✓ Dupe concluído - Sucesso: " .. successCount .. " | Falhas: " .. failCount)
    end)
    
    -- ============ CLEANUP ============
    -- Garante que farming para quando o script é desabilitado
    local connection
    connection = plr:GetPropertyChangedSignal("Parent"):Connect(function()
        if not plr.Parent then
            getgenv().Farming = false
            if connection then
                connection:Disconnect()
            end
        end
    end)
end
