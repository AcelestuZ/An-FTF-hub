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

local lp = game:GetService("Players").LocalPlayer
local re = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

local function universalRescue()
    pcall(function()
        local stats = lp:FindFirstChild("TempPlayerStatsModule")
        if stats then
            local m = require(stats)
            m.SetValue("StruggleProgress", 100)
            m.SetValue("IsFrozen", false)
            m.SetValue("IsDown", false)
            m.SetValue("Health", 100)
        end
        re:FireServer("Input", "Struggle", true)
        local char = lp.Character
        if char then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("RopeConstraint") or v:IsA("Weld") or v:IsA("WeldConstraint") or v:IsA("NoCollisionConstraint") then
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
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 5, 0)
            end
        end
    end)
end

TPTab:CreateSection("Server-Side & Ghost")

TPTab:CreateButton({
    Name = "ACTIVATE SERVER BYPASS (Hook)",
    Callback = function()
        pcall(function()
            local mt = getrawmetatable(game)
            local old = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local args = {...}
                if getnamecallmethod() == "FireServer" and self.Name == "RemoteEvent" then
                    if args[1] == "Input" and args[2] == "Trigger" and args[3] == false then
                        args[3] = true
                        return old(self, unpack(args))
                    end
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end)
    end
})

TPTab:CreateToggle({
    Name = "AUTO-ESCAPE LOOP (Release Pod/Tire)",
    CurrentValue = false,
    Callback = function(v)
        _G.UniversalLoop = v
        task.spawn(function()
            while _G.UniversalLoop do
                pcall(function()
                    local stats = lp:FindFirstChild("TempPlayerStatsModule")
                    if stats then
                        local m = require(stats)
                        if m.GetValue("IsFrozen") or m.GetValue("IsDown") or m.GetValue("IsStunned") then
                            universalRescue()
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
