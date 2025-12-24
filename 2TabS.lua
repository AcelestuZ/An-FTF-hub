-- Tab Survivors
local STab = _G.HubWindow:CreateTab("Survivors", 4483362458)
local lp = game:GetService("Players").LocalPlayer

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

STab:CreateToggle({
    Name = "Auto-No Seer + TP",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoNoSeer = v
        if v then
            task.spawn(function()
                local remote = game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvent")
                local hasNotified = false
                while _G.AutoNoSeer do
                    local target = nil
                    local minDist = math.huge
                    local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                    
                    if hrp then
                        for _, obj in pairs(workspace:GetDescendants()) do
                            local isValid = false
                            if obj:IsA("Model") then
                                if table.find({"HidingCloset", "HiddenCloset", "Locker", "Loker2", "Locker 2"}, obj.Name) then
                                    isValid = true
                                elseif obj.Name == "Model" then
                                    if obj:FindFirstChild("Union", true) then
                                        isValid = true
                                    elseif obj:FindFirstChildWhichIsA("Model", true) then
                                        local subModel = obj:FindFirstChildWhichIsA("Model", true)
                                        local p = subModel:FindFirstChildWhichIsA("Part", true)
                                        if p and p:FindFirstChildOfClass("Decal") then
                                            isValid = true
                                        end
                                    end
                                end
                            end

                            if isValid then
                                local p = obj:FindFirstChildWhichIsA("BasePart", true) or obj:FindFirstChild("Union", true)
                                if p then
                                    local d = (hrp.Position - p.Position).Magnitude
                                    if d < minDist then
                                        minDist = d
                                        target = obj
                                    end
                                end
                            end
                        end
                    end

                    if target then
                        local tpPart = target:FindFirstChildWhichIsA("BasePart", true) or target:FindFirstChild("Union", true)
                        if tpPart then
                            hrp.CFrame = tpPart.CFrame + Vector3.new(0, 2, 0)
                            task.wait(0.1)
                            remote:FireServer("SetPlayerHiding", true, target)
                        end
                        hasNotified = false
                    elseif not hasNotified then
                        _G.Rayfield:Notify({Title = "Hace HUB", Content = "Non ci sono punti dove nascondersi!", Duration = 5})
                        hasNotified = true
                    end
                    task.wait(0.5)
                end
                local r = game:GetService("ReplicatedStorage"):FindFirstChild("RemoteEvent")
                if r then r:FireServer("SetPlayerHiding", false) end
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
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
    end
})
