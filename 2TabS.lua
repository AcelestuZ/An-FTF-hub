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

STab:CreateSection("Locker System")

STab:CreateToggle({
    Name = "Cycle Anti-Seer TP",
    CurrentValue = false,
    Callback = function(v)
        local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        local hum = lp.Character and lp.Character:FindFirstChildOfClass("Humanoid")
        
        if v then
            local foundLockers = CollectionService:GetTagged("LOCKER")
            if #foundLockers > 0 then
                _G.LockerIndex = (_G.LockerIndex or 0) + 1
                if _G.LockerIndex > #foundLockers or _G.LockerIndex > 4 then _G.LockerIndex = 1 end

                local target = foundLockers[_G.LockerIndex]
                local tpPart = target:FindFirstChildWhichIsA("BasePart", true)
                
                if tpPart and hrp then
                    if CollectionService:HasTag(target, "MUST_CRAWL") then
                        remote:FireServer("Input", "Crawl", true)
                        if hum then hum.HipHeight = -2 end
                    end
                    hrp.CFrame = tpPart.CFrame + Vector3.new(0, 2, 0)
                    task.wait(0.1)
                    remote:FireServer("SetPlayerHiding", true, target)
                end
            end
        else
            if remote then 
                remote:FireServer("SetPlayerHiding", false)
                remote:FireServer("Input", "Crawl", false)
            end
            if hum then hum.HipHeight = 0 end
        end
    end
})

STab:CreateSection("Test")

STab:CreateToggle({
    Name = "RootPart Proxy (Anti-Seer)",
    CurrentValue = false,
    Callback = function(v)
        _G.AntiSeerProxy = v
        if v then
            task.spawn(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                local hrp = lp.Character:FindFirstChild("HumanoidRootPart")
                
                while _G.AntiSeerProxy do
                    local lockers = CollectionService:GetTagged("LOCKER")
                    if #lockers > 0 and hrp then
                        local targetLocker = lockers[1] 
                        local lockerPart = targetLocker:FindFirstChildWhichIsA("BasePart", true)
                        
                        if lockerPart then
                            local originalCF = hrp.CFrame
                            
                            hrp.CFrame = lockerPart.CFrame
                            task.wait(0.05)
                            remote:FireServer("SetPlayerHiding", true, targetLocker)
                            
                            task.wait(0.1)
                            hrp.CFrame = originalCF
                            
                            _G.Rayfield:Notify({Title = "Test Hub", Content = "HRP Proxy inviato al Locker!", Duration = 2})
                        end
                    end
                    task.wait(5)
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
