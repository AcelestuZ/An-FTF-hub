-- Beast Tab
local BeastTab = _G.HubWindow:CreateTab("Beast", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local re = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")

BeastTab:CreateToggle({
    Name = "Custom Beast Crawl (Safe Vent)",
    CurrentValue = false,
    Callback = function(state)
        _G.BeastCrawl = state
        local char = lp.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if state then
            if not _G.cTrack then
                local a = Instance.new("Animation")
                a.AnimationId = "rbxassetid://961932719"
                _G.cTrack = hum:LoadAnimation(a)
                _G.cTrack.Priority = Enum.AnimationPriority.Action
            end

            task.spawn(function()
                re:FireServer("Input", "Crawl", true)
                hum.HipHeight = -2
                
                while _G.BeastCrawl do
                    if char and hum then
                        if not _G.cTrack.IsPlaying then 
                            _G.cTrack:Play(0.1, 1, 1) 
                        end
                        
                        -- Gestione velocità animazione in base al movimento
                        _G.cTrack:AdjustSpeed(hum.MoveDirection.Magnitude > 0 and 1.5 or 0)

                        for _, p in pairs(char:GetChildren()) do
                            if p:IsA("BasePart") and (p.Name == "Head" or p.Name:find("Arm") or p.Name:find("Hand")) then
                                p.CanCollide = false
                            end
                        end
                    end
                    task.wait(0.1)
                end
                
                -- Reset quando disattivato
                if _G.cTrack then _G.cTrack:Stop() end
                re:FireServer("Input", "Crawl", false)
                hum.HipHeight = 0
                if char then
                    for _, p in pairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.CanCollide = true end
                    end
                end
            end)
        else
            _G.BeastCrawl = false
            if _G.cTrack then _G.cTrack:Stop() end
            re:FireServer("Input", "Crawl", false)
            if hum then hum.HipHeight = 0 end
        end
    end
})

BeastTab:CreateToggle({
    Name = "Anti-Jump Slowdown (Beast)",
    CurrentValue = false,
    Callback = function(state)
        _G.AntiJumpSlow = state
        if state then
            task.spawn(function()
                while _G.AntiJumpSlow do
                    local char = lp.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    
                    if hum then
                        local state = hum:GetState()
                        if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                            repeat task.wait() until hum:GetState() == Enum.HumanoidStateType.Landed
                            -- Invia il segnale Jumped per resettare il cooldown della velocità della Bestia
                            local bPowers = char:FindFirstChild("BeastPowers")
                            local pEvent = bPowers and bPowers:FindFirstChild("PowersEvent")
                            if pEvent then
                                pEvent:FireServer("Jumped")
                            end
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end
                    task.wait(0.1)
                end
            end)
        end
    end
})
