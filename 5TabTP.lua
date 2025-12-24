-- Teleport Tab
local TPTab = _G.HubWindow:CreateTab("Teleport", 4483362458)
local lp = game:GetService("Players").LocalPlayer
local function SafeTeleport(cframe, check)
    if check and not workspace:FindFirstChild(check, true) then return end
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        lp.Character.HumanoidRootPart.CFrame = cframe
    end
end
TPTab:CreateButton({
    Name = "TP Nuclear Plant (Secret)",
    Callback = function() SafeTeleport(CFrame.new(98, 24, -1), "ComputerTable") end
})
TPTab:CreateButton({
    Name = "TP Lobby (Secret)",
    Callback = function() SafeTeleport(CFrame.new(108, -7, -429)) end
})
TPTab:CreateButton({
    Name = "TP Lobby Main",
    Callback = function() SafeTeleport(CFrame.new(157, 4, -344)) end
})
TPTab:CreateButton({
    Name = "TP Beast Cave",
    Callback = function() SafeTeleport(CFrame.new(-240, 7, -223), "ComputerTable") end
})
TPTab:CreateButton({
    Name = "TP Map Center",
    Callback = function() SafeTeleport(CFrame.new(154, 13, 175), "ComputerTable") end
})
