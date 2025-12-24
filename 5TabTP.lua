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

TPTab:CreateSection("Server-Side Exploits")

local function applyServerBypass()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local args = {...}
        local method = getnamecallmethod()
        if method == "FireServer" and self.Name == "RemoteEvent" then
            if args[1] == "Input" and args[2] == "Trigger" and args[3] == false then
                args[3] = true
                return old(self, unpack(args))
            end
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end

local function forceEscape()
    pcall(function()
        local re = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
        if re then
            re:FireServer("SetPlayerStats", {["Escaped"] = true})
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "InsideArea" then
                    firetouchinterest(lp.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(lp.Character.HumanoidRootPart, v, 1)
                end
            end
        end
    end)
end

TPTab:CreateButton({
    Name = "ACTIVATE SERVER BYPASS (Hook)",
    Callback = function()
        applyServerBypass()
        _G.Rayfield:Notify({Title = "Hace HUB", Content = "Server-Side Bypass Attivo!", Duration = 3})
    end
})

TPTab:CreateButton({
    Name = "INSTANT WIN (Escape)",
    Callback = function()
        forceEscape()
        _G.Rayfield:Notify({Title = "Hace HUB", Content = "Tentativo di fuga inviato!", Duration = 3})
    end
})

TPTab:CreateToggle({
    Name = "Ghost Mode (UI Unlock)",
    CurrentValue = false,
    Callback = function(v)
        _G.GhostLoop = v
        task.spawn(function()
            while _G.GhostLoop do
                pcall(function()
                    local stats = lp:FindFirstChild("TempPlayerStatsModule")
                    if stats then
                        local m = require(stats)
                        m.SetValue("IsCheckingLoadData", false)
                        m.SetValue("Health", 100)
                    end
                    local gui = lp.PlayerGui:FindFirstChild("ScreenGui")
                    if gui and gui:FindFirstChild("SpectatorFrame") then
                        gui.SpectatorFrame.Visible = false
                        gui.ActionBox.Visible = true
                    end
                end)
                task.wait(1)
            end
        end)
    end
})

TPTab:CreateSection("Self-Rescue & Survival")

TPTab:CreateButton({
    Name = "SELF RESCUE (Instant Escape Pod)",
    Callback = function()
        local stats = lp:FindFirstChild("TempPlayerStatsModule")
        if stats then
            local m = require(stats)
            m.SetValue("StruggleProgress", 100)
            m.SetValue("IsFrozen", false)
            m.SetValue("Health", 100)
        end
        local re = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
        if re then
            re:FireServer("Input", "Struggle", true)
            re:FireServer("Input", "Struggle", false)
        end
        if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            lp.Character.HumanoidRootPart.Anchored = false
        end
    end
})

TPTab:CreateToggle({
    Name = "Anti-Ragdoll (No Stun)",
    CurrentValue = false,
    Callback = function(v)
        _G.AntiStun = v
        task.spawn(function()
            local stats = lp:FindFirstChild("TempPlayerStatsModule")
            if not stats then return end
            local m = require(stats)
            while _G.AntiStun do
                if m.GetValue("IsStunned") or m.GetValue("IsDown") then
                    m.SetValue("IsStunned", false)
                    m.SetValue("IsDown", false)
                    m.SetValue("Health", 100)
                    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
                        lp.Character.Humanoid.PlatformStand = false
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

TPTab:CreateButton({
    Name = "Invisible to Beast (Ghost State)",
    Callback = function()
        local stats = lp:FindFirstChild("TempPlayerStatsModule")
        if stats then
            local m = require(stats)
            m.SetValue("IsHidden", true)
            m.SetValue("IsCheckingLoadData", false)
        end
    end
})

TPTab:CreateButton({
    Name = "ANTY-TIRE (Instant Untie)",
    Callback = function()
        pcall(function()
            local stats = lp:FindFirstChild("TempPlayerStatsModule")
            local re = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
            if stats then
                local m = require(stats)
                m.SetValue("IsDown", false)
                m.SetValue("IsStunned", false)
                m.SetValue("StruggleProgress", 100)
                m.SetValue("Health", 100)
            end
            if re then
                re:FireServer("Input", "Struggle", true)
            end
            if lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("RopeConstraint") or v.Name == "Tire" or v.Name == "Cords" then
                        v:Destroy()
                    end
                end
                if lp.Character:FindFirstChild("Humanoid") then
                    lp.Character.Humanoid.PlatformStand = false
                end
            end
        end)
    end
})
