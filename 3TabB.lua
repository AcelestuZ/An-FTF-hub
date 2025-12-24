-- Beast Tab
local BeastTab = _G.HubWindow:CreateTab("Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer
BeastTab:CreateToggle({
    Name = "Custom Beast Crawl (Safe Vent)",
    CurrentValue = false,
    Callback = function(state)
        _G.BeastCrawl = state
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local remote = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
        if not hum or not remote then return end
        if state then 
            if not _G.cTrack then 
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://961932719"
                _G.cTrack = hum:LoadAnimation(a)
                _G.cTrack.Priority = Enum.AnimationPriority.Action
            end 
            remote:FireServer("Input", "Crawl", true)
            hum.HipHeight = -2
            hum.WalkSpeed = 10
            task.spawn(function()
                while _G.BeastCrawl do
                    if not _G.cTrack.IsPlaying then _G.cTrack:Play(0.1, 1, 0) end
                    if char then
                        for _, p in pairs(char:GetChildren()) do
                            if p:IsA("BasePart") and (p.Name == "Head" or p.Name:find("Arm") or p.Name:find("Hand")) then
                                p.CanCollide = false
                            end
                        end
                    end
                    _G.cTrack:AdjustSpeed(hum.MoveDirection.Magnitude > 0 and 2 or 0)
                    task.wait(0.1)
                end
                if char then
                    for _, p in pairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.CanCollide = true end
                    end
                end
                _G.cTrack:Stop()
            end)
        else 
            remote:FireServer("Input", "Crawl", false)
            hum.HipHeight = 0
            hum.WalkSpeed = 16
        end
    end
})
BeastTab:CreateToggle({
    Name = "Anti-Jump Slowdown",
    CurrentValue = false,
    Callback = function(state)
        _G.AntiJumpSlow = state
        if state then
            task.spawn(function()
                while _G.AntiJumpSlow do
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local bPowers = char and char:FindFirstChild("BeastPowers")
                    local pEvent = bPowers and bPowers:FindFirstChild("PowersEvent")
                    if hum and pEvent then
                        if hum:GetState() == Enum.HumanoidStateType.Landed then
                            pEvent:FireServer("Jumped")
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
