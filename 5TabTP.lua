-- Teleport Tab
local TPTab = _G.HubWindow:CreateTab("Teleport & Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local re = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

local function SafeTeleport(cframe, loc, mapPath)
    if mapPath then
        local found = workspace:FindFirstChild(mapPath, true)
        if not found then
            if _G.Rayfield then _G.Rayfield:Notify({Title = "Map Error", Content = loc .. " map not loaded!", Duration = 3}) end
            return
        end
    end
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function getPodData()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "PodTrigger" and v:FindFirstChild("Event") then
            return v.Event
        end
    end
    return nil
end

local function killPlayer(target)
    pcall(function()
        local hammer = lp.Character:FindFirstChild("Hammer")
        local hEvent = hammer and hammer:FindFirstChild("HammerEvent")
        local podEvent = getPodData()
        if hEvent and target.Character and target.Character:FindFirstChild("Torso") then
            local tTorso = target.Character.Torso
            local tArm = target.Character:FindFirstChild("Right Arm") or tTorso
            hEvent:FireServer("HammerClick", true)
            hEvent:FireServer("HammerHit", tArm)
            hEvent:FireServer("HammerTieUp", tTorso, tTorso.Position)
            if podEvent then
                re:FireServer("Input", "Trigger", true, podEvent)
                re:FireServer("Input", "Action", true)
                task.wait(0.1)
                re:FireServer("Input", "Action", false)
                re:FireServer("Input", "Trigger", false, podEvent)
            end
        end
    end)
end

TPTab:CreateButton({Name = "TP Nuclear Plant (Secret)", Callback = function() SafeTeleport(CFrame.new(98, 24, -1), "Nuclear Plant", "Nuclear Power Plant by D4niel_Foxy, SonicUnkn0wn, and posyonose") end})
TPTab:CreateButton({Name = "TP Lobby (Secret)", Callback = function() SafeTeleport(CFrame.new(108, -7, -429), "Lobby", nil) end})
TPTab:CreateButton({Name = "TP Lobby Main", Callback = function() SafeTeleport(CFrame.new(157, 4, -344), "Lobby", nil) end})
TPTab:CreateButton({Name = "TP Beast Cave", Callback = function() SafeTeleport(CFrame.new(-240, 7, -223), "Beast Cave", "OBSpawnPad") end})
TPTab:CreateButton({Name = "TP to map", Callback = function() local pad = workspace:FindFirstChild("OBSpawnPad", true) if pad then SafeTeleport(pad.CFrame + Vector3.new(0, 3, 0), "Map", nil) end end})

TPTab:CreateSection("Beast Mode (Kill All)")

TPTab:CreateButton({
    Name = "KILL ALL SURVIVORS",
    Callback = function()
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Torso") then
                killPlayer(p)
                task.wait(0.3)
            end
        end
    end
})

TPTab:CreateToggle({
    Name = "AUTO-KILL LOOP",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoKill = v
        task.spawn(function()
            while _G.AutoKill do
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    if p ~= lp and p.Character and p.Character:FindFirstChild("Torso") then
                        killPlayer(p)
                    end
                end
                task.wait(1.5)
            end
        end)
    end
})

TPTab:CreateSection("Bypass Win")

TPTab:CreateButton({
    Name = "INSTANT WIN",
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
