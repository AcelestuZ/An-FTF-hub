-- teleport tab
local TPTab = _G.HubWindow:CreateTab("Teleport & Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local re = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

local function SafeTeleport(cframe)
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end

local function getActiveComputerTrigger()
    local targetTrigger = nil
    local shortestDist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "ComputerTrigger" and v:IsA("BasePart") then
            local pcModel = v.Parent
            local screen = pcModel and pcModel:FindFirstChild("Screen")
            if screen and screen.BrickColor ~= BrickColor.new("Dark green") then
                local dist = (lp.Character.HumanoidRootPart.Position - v.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    targetTrigger = v
                end
            end
        end
    end
    return targetTrigger
end

local function getFreePod()
    local bestPod = nil
    local shortestDist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "PodTrigger" and v:FindFirstChild("Event") then
            local podModel = v.Parent
            local isOccupied = false
            local station = podModel:FindFirstChild("PlayerStation")
            if station then
                for _, child in pairs(station:GetChildren()) do
                    if child:IsA("Model") and child:FindFirstChild("Humanoid") then
                        isOccupied = true
                        break
                    end
                end
            end
            if not isOccupied then
                local dist = (lp.Character.HumanoidRootPart.Position - v.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    bestPod = v
                end
            end
        end
    end
    return bestPod
end

local function fullKillSequence(target)
    pcall(function()
        local hammer = lp.Character:FindFirstChild("Hammer")
        local hEvent = hammer and hammer:FindFirstChild("HammerEvent")
        if not hEvent or not target.Character or not target.Character:FindFirstChild("Torso") then return end
        local tTorso = target.Character.Torso
        SafeTeleport(tTorso.CFrame * CFrame.new(0, 0, 3))
        task.wait(0.3)
        hEvent:FireServer("HammerClick", true)
        hEvent:FireServer("HammerHit", target.Character:FindFirstChild("Right Arm") or tTorso)
        hEvent:FireServer("HammerTieUp", tTorso, tTorso.Position)
        task.wait(0.4)
        local pod = getFreePod()
        if pod then
            SafeTeleport(pod.CFrame * CFrame.new(0, 0, 2))
            task.wait(0.3)
            re:FireServer("Input", "Trigger", true, pod.Event)
            re:FireServer("Input", "Action", true)
            task.wait(0.2)
            re:FireServer("Input", "Action", false)
            re:FireServer("Input", "Trigger", false, pod.Event)
        end
    end)
end

TPTab:CreateSection("Survivor Auto-Farm (Trigger Focus)")

TPTab:CreateButton({
    Name = "TP TO PC TRIGGER",
    Callback = function()
        local trigger = getActiveComputerTrigger()
        if trigger then
            SafeTeleport(trigger.CFrame)
        end
    end
})

TPTab:CreateToggle({
    Name = "GOD-FINGER (Event Fix)",
    CurrentValue = false,
    Callback = function(v)
        _G.AntiError = v
        task.spawn(function()
            while _G.AntiError do
                pcall(function()
                    local stats = lp:FindFirstChild("TempPlayerStatsModule")
                    if stats and require(stats).GetValue("IsHacking") then
                        local currentPC = nil
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj.Name == "ComputerTrigger" and (lp.Character.HumanoidRootPart.Position - obj.Position).Magnitude < 10 then
                                currentPC = obj.Parent
                                break
                            end
                        end
                        if currentPC and currentPC:FindFirstChild("Event") then
                            re:FireServer("Input", "Trigger", true, currentPC.Event)
                        end
                    end
                end)
                task.wait(0.1)
            end
        end)
    end
})

TPTab:CreateSection("Beast Master (Kill All TP)")

TPTab:CreateButton({
    Name = "EXECUTE ALL SURVIVORS",
    Callback = function()
        for _, p in pairs(game:GetService("Players"):GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character.Humanoid.Health > 0 then
                local isBeast = false
                pcall(function()
                    local stats = p:FindFirstChild("TempPlayerStatsModule")
                    if stats and require(stats).GetValue("IsBeast") then isBeast = true end
                end)
                if not isBeast then
                    fullKillSequence(p)
                    task.wait(0.6)
                end
            end
        end
    end
})

TPTab:CreateSection("Classic Teleports")

TPTab:CreateButton({Name = "TP Nuclear Plant", Callback = function() SafeTeleport(CFrame.new(98, 24, -1)) end})
TPTab:CreateButton({Name = "TP Lobby Main", Callback = function() SafeTeleport(CFrame.new(157, 4, -344)) end})
TPTab:CreateButton({Name = "TP Beast Cave", Callback = function() SafeTeleport(CFrame.new(-240, 7, -223)) end})
TPTab:CreateButton({Name = "TP to map", Callback = function() local pad = workspace:FindFirstChild("OBSpawnPad", true) if pad then SafeTeleport(pad.CFrame + Vector3.new(0, 3, 0)) end end})
