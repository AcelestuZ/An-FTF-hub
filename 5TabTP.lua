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

TPTab:CreateSection("Special Exploits")

local function fullUnlock()
    local stats = lp:FindFirstChild("TempPlayerStatsModule")
    local loadVal = lp:FindFirstChild("IsCheckingLoadData")
    
    if loadVal then loadVal.Value = false end
    
    if stats then
        local module = require(stats)
        pcall(function()
            module.SetValue("Health", 100)
            module.SetValue("IsCheckingLoadData", false)
            module.SetValue("ActionProgress", 0)
        end)
    end
    
    local screenGui = lp.PlayerGui:FindFirstChild("ScreenGui")
    if screenGui then
        if screenGui:FindFirstChild("SpectatorFrame") then screenGui.SpectatorFrame.Visible = false end
        if screenGui:FindFirstChild("ActionBox") then screenGui.ActionBox.Visible = true end
    end
    
    _G.Rayfield:Notify({Title = "Exploit", Content = "Full Interaction Unlocked!", Duration = 3})
end

TPTab:CreateButton({
    Name = "FORCE FULL UNLOCK (Hacking, Save, Exit)",
    Callback = fullUnlock
})

TPTab:CreateToggle({
    Name = "God-State Loop (Anti-Death Block)",
    CurrentValue = false,
    Callback = function(v)
        _G.GodStateLoop = v
        task.spawn(function()
            while _G.GodStateLoop do
                pcall(fullUnlock)
                task.wait(2)
            end
        end)
    end
})
