-- Tab Survivors
 local STab = _G.HubWindow:CreateTab("Survivors", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local CollectionService = game:GetService("CollectionService")

STab:CreateSection("Utility")

STab:CreateToggle({
    Name = "No PC Error",
    CurrentValue = false,
    Callback = function(v)
        _G.NoPCError = v
        if v then
            task.spawn(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                while _G.NoPCError do
                    pcall(function()
                        remote:FireServer("SetPlayerMinigameResult", true)
                        remote:FireServer("SetMinigameSuccess", true)
                    end)
                    task.wait()
                end
            end)
        end
    end
})

STab:CreateButton({
    Name = "Noclip Doors (Once)",
    Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "SingleDoor" or v.Name == "DoubleDoor" then
                for _, part in pairs(v:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = false end
                end
            end
        end
    end
})

STab:CreateSection("Locker System")

STab:CreateButton({
    Name = "Cycle Anti-Seer TP (Tap to Cycle)",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
        local char = lp.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        if not hrp or not hum then return end

        local foundLockers = CollectionService:GetTagged("LOCKER")
        if #foundLockers > 0 then
            -- Logic: Cycle through the first 4 tagged lockers
            _G.LockerIndex = (_G.LockerIndex or 0) + 1
            if _G.LockerIndex > #foundLockers or _G.LockerIndex > 4 then _G.LockerIndex = 1 end

            local target = foundLockers[_G.LockerIndex]
            local tpPart = target:FindFirstChildWhichIsA("BasePart", true)
            
            if tpPart then
                -- FIX: Stop momentum and anchor to prevent TP glitches while moving
                hrp.AssemblyLinearVelocity = Vector3.new(0,0,0)
                hrp.Anchored = true 
                
                -- Check MUST_CRAWL tag from game files
                local mustCrawl = CollectionService:HasTag(target, "MUST_CRAWL")
                if mustCrawl then
                    remote:FireServer("Input", "Crawl", true)
                    hum.HipHeight = -2
                else
                    remote:FireServer("Input", "Crawl", false)
                    hum.HipHeight = 0
                end

                -- Precise Teleport
                hrp.CFrame = tpPart.CFrame + Vector3.new(0, 2, 0)
                
                -- Tell server we are hiding
                task.wait(0.1)
                remote:FireServer("SetPlayerHiding", true, target)
                
                -- Release player after server registers position
                task.wait(0.1)
                hrp.Anchored = false
                
                _G.Rayfield:Notify({
                    Title = "Hace HUB", 
                    Content = "Teleported to Locker #".._G.LockerIndex, 
                    Duration = 2
                })
            end
        else
            _G.Rayfield:Notify({Title = "Hace HUB", Content = "No Tagged Lockers found!", Duration = 3})
        end
    end
})

STab:CreateButton({
    Name = "Exit Locker / Reset State",
    Callback = function()
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        
        if remote then
            remote:FireServer("SetPlayerHiding", false)
            remote:FireServer("Input", "Crawl", false)
        end
        if hum then hum.HipHeight = 0 end
        _G.Rayfield:Notify({Title = "Hace HUB", Content = "State Reset", Duration = 2})
    end
})


STab:CreateSection("Test Zone")

STab:CreateToggle({
    Name = "Static Proxy Anti-Seer",
    CurrentValue = false,
    Callback = function(v)
        _G.StaticAntiSeer = v
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
        
        if v then
            task.spawn(function()
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                
                -[span_2](start_span)- Find the nearest locker using the official tag[span_2](end_span)
                local lockers = CollectionService:GetTagged("LOCKER")
                local targetLocker = lockers[1]
                if not targetLocker then 
                    _G.Rayfield:Notify({Title = "Test Hub", Content = "No Locker found!", Duration = 3})
                    return 
                end

                _G.Rayfield:Notify({Title = "Test Hub", Content = "Proxy active in Locker #1", Duration = 3})

                while _G.StaticAntiSeer do
                    -- Instead of TPing the player, we only send the server 
                    -[span_3](start_span)[span_4](start_span)- the signal that we are inside the target locker[span_3](end_span)[span_4](end_span)
                    pcall(function()
                        remote:FireServer("SetPlayerHiding", true, targetLocker)
                    end)
                    
                    -[span_5](start_span)- We wait a bit more than the game's heartbeat check (8 frames)[span_5](end_span)
                    task.wait(0.5) 
                end
                
                -- When disabled, tell the server we are out
                remote:FireServer("SetPlayerHiding", false)
            end)
        else
            remote:FireServer("SetPlayerHiding", false)
        end
    end
})

