-- Teleport Tab
local TPTab = _G.HubWindow:CreateTab("Teleport", 4483362458)
local lp = game:GetService("Players").LocalPlayer

local function SafeTeleport(cframe, loc, mapPath)
    if mapPath then
        local found = workspace:FindFirstChild(mapPath, true)
        if not found then
            if _G.Rayfield then
                _G.Rayfield:Notify({Title = "Map Error", Content = loc .. " map not loaded!", Duration = 3})
            end
            return
        end
    end
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end

TPTab:CreateButton({
    Name = "TP Nuclear Plant (Secret)",
    Callback = function() 
        SafeTeleport(CFrame.new(98, 24, -1), "Nuclear Plant", "Nuclear Power Plant by D4niel_Foxy, SonicUnkn0wn, and posyonose") 
    end
})

TPTab:CreateButton({
    Name = "TP Lobby (Secret)",
    Callback = function() 
        SafeTeleport(CFrame.new(108, -7, -429), "Lobby", nil) 
    end
})

TPTab:CreateButton({
    Name = "TP Lobby Main",
    Callback = function() 
        SafeTeleport(CFrame.new(157, 4, -344), "Lobby", nil) 
    end
})

TPTab:CreateButton({
    Name = "TP Beast Cave",
    Callback = function() 
        SafeTeleport(CFrame.new(-240, 7, -223), "Beast Cave", "OBSpawnPad") 
    end
})

TPTab:CreateButton({
    Name = "TP to map",
    Callback = function()
        local pad = workspace:FindFirstChild("OBSpawnPad", true)
        if pad then
            SafeTeleport(pad.CFrame + Vector3.new(0, 3, 0), "Map", nil)
        else
            if _G.Rayfield then
                _G.Rayfield:Notify({Title = "Error", Content = "Map not detected!", Duration = 3})
            end
        end
    end
})

TPTab:CreateSection("Self-Rescue & Survival")

local function universalRescue()
    pcall(function()
        local stats = lp:FindFirstChild("TempPlayerStatsModule")
        local re = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
        local char = lp.Character
        
        if stats then
            local m = require(stats)
            m.SetValue("StruggleProgress", 100)
            m.SetValue("IsFrozen", false)
            m.SetValue("IsDown", false)
            m.SetValue("IsStunned", false)
            m.SetValue("Health", 100)
        end

        if re then
            re:FireServer("Input", "Struggle", true)
        end

        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("RopeConstraint") or v:IsA("Weld") or v:IsA("WeldConstraint") or v.Name == "Tire" or v.Name == "Cords" then
                    v:Destroy()
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hum then 
                hum.PlatformStand = false
                hum.Sit = false 
            end
            if hrp then 
                hrp.Anchored = false 
            end
        end
    end)
end

TPTab:CreateButton({
    Name = "INSTANT RELEASE (Tire/Pod/Cords)",
    Callback = universalRescue
})

TPTab:CreateToggle({
    Name = "Auto-Escape Loop",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoRescue = v
        task.spawn(function()
            while _G.AutoRescue do
                local stats = lp:FindFirstChild("TempPlayerStatsModule")
                if stats then
                    local m = require(stats)
                    if m.GetValue("IsFrozen") or m.GetValue("IsDown") or m.GetValue("IsStunned") then
                        universalRescue()
                    end
                end
                task.wait(0.3)
            end
        end)
    end
})
