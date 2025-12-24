-- Teleport Tab
local TPTab = _G.HubWindow:CreateTab("Teleport", 4483362458)
local lp = game:GetService("Players").LocalPlayer

local function SafeTeleport(cframe, loc, check)
    if check and not workspace:FindFirstChild(check, true) then
        _G.Rayfield:Notify({Title = "Map Error", Content = loc .. " is not loaded!", Duration = 3})
        return
    end
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
        _G.Rayfield:Notify({Title = "Teleport", Content = "Arrived at " .. loc, Duration = 2})
    end
end

TPTab:CreateButton({
    Name = "TP Nuclear Plant (Secret)",
    Callback = function()
        SafeTeleport(CFrame.new(98, 24, -1), "Nuclear Plant", "ComputerTable")
    end
})

TPTab:CreateButton({
    Name = "TP Lobby (Secret Room)",
    Callback = function()
        SafeTeleport(CFrame.new(108, -7, -429), "Lobby Secret")
    end
})

TPTab:CreateButton({
    Name = "TP Lobby Main",
    Callback = function()
        SafeTeleport(CFrame.new(157, 4, -344), "Lobby Main")
    end
})

TPTab:CreateButton({
    Name = "TP Beast Cave",
    Callback = function()
        SafeTeleport(CFrame.new(-240, 7, -223), "Beast Cave", "ComputerTable")
    end
})

TPTab:CreateButton({
    Name = "TP Map Center",
    Callback = function()
        SafeTeleport(CFrame.new(154, 13, 175), "Map Center", "ComputerTable")
    end
})
