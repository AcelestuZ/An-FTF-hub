-- tab1 Main
local MainTab = _G.HubWindow:CreateTab("Main", 4483362458)
MainTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Callback = function(v)
        _G.FullBrightEnabled = v
        task.spawn(function()
            while _G.FullBrightEnabled do
                game:GetService("Lighting").Brightness = 2
                game:GetService("Lighting").ClockTime = 14
                task.wait(0.5)
            end
        end)
    end
})
MainTab:CreateToggle({
    Name = "No Fog",
    CurrentValue = false,
    Callback = function(v)
        _G.NoFogEnabled = v
        task.spawn(function()
            while _G.NoFogEnabled do
                game:GetService("Lighting").FogEnd = 100000
                pcall(function() game:GetService("Lighting").Atmosphere:Destroy() end)
                task.wait(0.5)
            end
        end)
    end
})
MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local lp = game.Players.LocalPlayer
        if lp.Character and lp.Character:FindFirstChild("Humanoid") then
            lp.Character.Humanoid.Health = 0
            task.wait(0.1)
            lp.Character:BreakJoints()
        end
    end
})
MainTab:CreateToggle({
    Name = "Rimuovi Barriere",
    CurrentValue = false,
    Callback = function(v)
        _G.RemoveBarriers = v
        if v then
            local lobbyBox = workspace:FindFirstChild("LobbyCollideBox", true)
            if lobbyBox then
                for _, part in pairs(lobbyBox:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                        part.Transparency = 1
                    end
                end
            end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "Barrier" then
                    obj.CanCollide = false
                    obj.Transparency = 1
                end
            end
            
            _G.Rayfield:Notify({
                Title = "Hace HUB",
                Content = "Barriere rimosse con successo!",
                Duration = 3
            })
        else
            local lobbyBox = workspace:FindFirstChild("LobbyCollideBox", true)
            if lobbyBox then
                for _, part in pairs(lobbyBox:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
            
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Name == "Barrier" then
                    obj.CanCollide = true
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Unlock Camera",
    Callback = function()
        local lp = game.Players.LocalPlayer
        lp.CameraMaxZoomDistance = 1000
        lp.CameraMinZoomDistance = 0.5
        lp.CameraMode = Enum.CameraMode.Classic
    end
})
