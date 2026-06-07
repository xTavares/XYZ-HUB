-- sail for brainrots - VERSÃO CORRIGIDA (simples)

return function(section)
    local elements = loadstring(game:HttpGet(getgitpath("src").."elements.lua"))()
    getgenv().Farming = false
    getgenv().Selling = false
    getgenv().ChosenZone = nil
    getgenv().MaxPrice = 0

    local player = game:GetService("Players").LocalPlayer
    local zonesFold = workspace.Zones

    local function parseValue(str)
        local suffixes = {
            K = 1e3,
            M = 1e6,
            B = 1e9,
            T = 1e12,
            Q = 1e15,
        }
        
        local num, suffix = str:match("^([%d%.]+)([A-Za-z]*)")
        
        if not num then return 0 end
        
        num = tonumber(num) or 0
        suffix = suffix:upper()
        
        if suffixes[suffix] then
            return num * suffixes[suffix]
        end
        
        return num
    end


    elements:Textbox("Farm Zone (1-13)", section, function(v)
        getgenv().ChosenZone = zonesFold["Zone" .. v]
        if getgenv().ChosenZone then
            print("✓ Zona: Zone" .. v)
        end
    end)

    elements:Toggle("AutoFarm", section, function(v)
        if v then
            getgenv().Farming = true

            while getgenv().Farming do
                local char = player.Character
                if not char then 
                    task.wait(0.5)
                    continue 
                end

                -- ⭐ CHECAR SE A ZONA EXISTE
                if not getgenv().ChosenZone or not getgenv().ChosenZone.Parent then
                    task.wait(0.5)
                    continue
                end

                local objects = getgenv().ChosenZone:FindFirstChild("Objects")
                if not objects then
                    task.wait(0.5)
                    continue
                end

                for _, brainrot in pairs(objects:GetChildren()) do
                    if not getgenv().Farming then return end

                    -- ⭐ VERIFICAR SE OBJETO AINDA EXISTE
                    if not brainrot or brainrot.Parent ~= objects then continue end
                    
                    if not brainrot:FindFirstChild("PrimaryPart") then continue end

                    print("📍 Indo para: " .. brainrot.Name)

                    char:MoveTo(brainrot.PrimaryPart.Position)
                    task.wait(0.5) -- ⭐ ESPERAR CHEGAR
                    
                    repeat
                        if not getgenv().Farming then break end
                        if not brainrot or brainrot.Parent ~= objects then break end
                        
                        local prompt = brainrot:FindFirstChild("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                        end
                        task.wait(0.1)
                    until brainrot == nil or brainrot.Parent ~= objects

                    char:MoveTo(workspace.Bases[player.Name].Root.Position)
                    task.wait(0.5)
                end

                task.wait(1)
            end
        else
            getgenv().Farming = false
        end
    end)

    elements:Textbox("Max Price", section, function(v)
        getgenv().MaxPrice = tonumber(v)
    end)

    elements:Toggle("Auto Sell", section, function(v)
        if v then
            getgenv().Selling = true

            while getgenv().Selling do
                local char = player.Character
                if not char then 
                    task.wait(1)
                    continue 
                end

                for _, brainrot in pairs(player.Backpack:GetChildren()) do
                    if brainrot.Name == "Bat" then continue end
                    spawn(function()
                        pcall(function()
                            if parseValue(brainrot.Handle.ObjectInfo.Value.ValueLabel.Text) <= getgenv().MaxPrice then
                                local Event = game:GetService("ReplicatedStorage").Shared.Classes.RemoteFunction.Remotes.EntityShared_SellEntity
                                Event:InvokeServer(brainrot.Name)
                            end
                        end)
                    end)
                end

                task.wait(3)
            end
        else
            getgenv().Selling = false
        end
    end)

    elements:Button("Redeem Codes", section, function()
        local codes = {"Stop Looking", "TommysHouse", "Phew", "GoldStatue", "FreeSpin"}

        for i, v in pairs(codes) do
            local Event = game:GetService("ReplicatedStorage").Shared.Classes.RemoteFunction.Remotes.CodeShared_Redeem
            Event:InvokeServer(v)
            task.wait(0.2)
        end
    end)
end
