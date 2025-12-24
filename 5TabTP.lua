-- Teleport Tab
local TPTab = _G.HubWindow:CreateTab("Teleport", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local re = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

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

local function forceStateUnlock()
    pcall(function()
        local stats = lp:FindFirstChild("TempPlayerStatsModule")
        local m
        if stats then
            m = require(stats)
            m.SetValue("StruggleProgress", 100)
            m.SetValue("IsFrozen", false)
            m.SetValue("IsDown", false)
            m.SetValue("IsStunned", false)
        end
        re:FireServer("Input", "Trigger", true)
        re:FireServer("Input", "Stunned", false)
        re:FireServer("Input", "Struggle", true)
        local char = lp.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.Anchored = false
                if m and (m.GetValue("IsFrozen") or m.GetValue("IsDown")) then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 12, 0)
                end
            end
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("RopeConstraint") or v:IsA("Weld") or v:IsA("WeldConstraint") then
                    v:Destroy()
                end
            end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then 
                hum.PlatformStand = false
                hum.Sit = false 
            end
        end
    end)
end

TPTab:CreateSection("Anti-Capture (Tie/Pod Bypass)")

TPTab:CreateToggle({
    Name = "OVERRIDE TRIGGER (Auto-Escape)",
    CurrentValue = false,
    Callback = function(v)
        _G.ForceUnlock = v
        task.spawn(function()
            while _G.ForceUnlock do
                pcall(function()
                    local stats = lp:FindFirstChild("TempPlayerStatsModule")
                    if stats then
                        local m = require(stats)
                        if m.GetValue("IsFrozen") or m.GetValue("IsDown") or m.GetValue("IsStunned") then
                            for i = 1, 10 do
                                forceStateUnlock()
                            end
                            task.wait(0.05)
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

TPTab:CreateButton({
    Name = "INSTANT WIN (InsideArea Bypass)",
    Callback = function()
        pcall(function()
            re:FireServer("SetPlayerStats", {["Escaped"] = true})
            for _, v in pairs(workspace:GetDescendants()) do
                if v.Name == "InsideArea" then
                    firetouchinterest(lp.Character.HumanoidRootPart, v, 0)
                    firetouchinterest(lp.Character.HumanoidRootPart, v, 1)
                end
            end
        end)
    end
})
