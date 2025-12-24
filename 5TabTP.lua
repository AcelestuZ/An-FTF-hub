-- Teleport Tab
local TPTab = _G.HubWindow:CreateTab("Teleport & Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local re = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

local function SafeTeleport(cframe)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function getPodData()
    local closestPod = nil
    local shortestDist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "PodTrigger" and v:FindFirstChild("Event") then
            local dist = (lp.Character.HumanoidRootPart.Position - v.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closestPod = v
            end
        end
    end
    return closestPod
end

local function fullKillSequence(target)
    pcall(function()
        local hammer = lp.Character:FindFirstChild("Hammer")
        local hEvent = hammer and hammer:FindFirstChild("HammerEvent")
        if not hEvent or not target.Character or not target.Character:FindFirstChild("Torso") then return end
        
        local tTorso = target.Character.Torso
        SafeTeleport(tTorso.CFrame * CFrame.new(0, 0, 3))
        task.wait(0.2)
        
        hEvent:FireServer("HammerClick", true)
        hEvent:FireServer("HammerHit", target.Character:FindFirstChild("Right Arm") or tTorso)
        hEvent:FireServer("HammerTieUp", tTorso, tTorso.Position)
        task.wait(0.3)
        
        local pod = getPodData()
        if pod then
            SafeTeleport(pod.CFrame * CFrame.new(0, 0, 2))
            task.wait(0.2)
            re:FireServer("Input", "Trigger", true, pod.Event)
            re:FireServer("Input", "Action", true)
            task.wait(0.2)
            re:FireServer("Input", "Action", false)
            re:FireServer("Input", "Trigger", false, pod.Event)
        end
    end)
end

TPTab:CreateSection("Beast Master (Kill All TP)")

TPTab:CreateButton({
    Name = "EXECUTE ALL SURVIVORS (TP + Pod)",
    Callback = function()
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") then
                local isBeast = false
                pcall(function()
                    local stats = p:FindFirstChild("TempPlayerStatsModule")
                    if stats and require(stats).GetValue("IsBeast") then isBeast = true end
                end)
                
                if not isBeast and p.Character.Humanoid.Health > 0 then
                    fullKillSequence(p)
                    task.wait(0.5)
                end
            end
        end
    end
})

TPTab:CreateToggle({
    Name = "AUTO-KILL LOOP (Continuous TP)",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoKillLoop = v
        task.spawn(function()
            while _G.AutoKillLoop do
                for _, p in pairs(game:GetService("Players"):GetPlayers()) do
                    if not _G.AutoKillLoop then break end
                    if p ~= lp and p.Character and p.Character:FindFirstChild("Torso") then
                        fullKillSequence(p)
                    end
                end
                task.wait(2)
            end
        end)
    end
})

TPTab:CreateSection("Classic Teleports")

TPTab:CreateButton({Name = "TP Lobby Main", Callback = function() SafeTeleport(CFrame.new(157, 4, -344)) end})
TPTab:CreateButton({Name = "TP to map", Callback = function() local pad = workspace:FindFirstChild("OBSpawnPad", true) if pad then SafeTeleport(pad.CFrame + Vector3.new(0, 3, 0)) end end})

