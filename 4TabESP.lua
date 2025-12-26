-- ESP tab
 local ESPTab = _G.HubWindow:CreateTab("ESP", 4483362458)
local Players = game:GetService("Players")
local lp = Players.LocalPlayer

local function GetBeastChance(p)
    local c = "0"
    local s = p:FindFirstChild("SavedPlayerStatsModule")
    if s then
        local bc = s:FindFirstChild("BeastChance")
        if bc then c = tostring(bc.Value) end
    end
    return c
end

local function UpdateESP(obj, col, txt, en, isP, pObj)
    if not obj then return end
    local hH = obj:FindFirstChild("HubH")
    local hT = obj:FindFirstChild("HubT")

    if _G.ESP_Highlights and en and (pObj ~= lp) then
        local h = hH or Instance.new("Highlight")
        if not hH then h.Name = "HubH"; h.Parent = obj end
        h.FillColor = col
        h.OutlineTransparency = _G.ESP_Outlines and 0 or 1
        h.FillTransparency = isP and 0.2 or 0.85
    elseif hH then hH:Destroy() end
    
    if _G.ESP_Names and en and txt then
        local tag = hT or Instance.new("BillboardGui")
        if not hT then
            tag.Name = "HubT"; tag.Size = UDim2.new(0,200,0,50); tag.AlwaysOnTop = true
            tag.Parent = obj
            local l = Instance.new("TextLabel", tag)
            l.Name = "L"; l.BackgroundTransparency = 1; l.Size = UDim2.new(1,0,1,0)
            l.TextSize = 14; l.Font = Enum.Font.SourceSansBold; l.TextStrokeTransparency = 0
            local cl = Instance.new("TextLabel", tag)
            cl.Name = "C"; cl.BackgroundTransparency = 1; cl.Position = UDim2.new(0,0,0.6,0)
            cl.Size = UDim2.new(1,0,0.4,0); cl.TextSize = 11; cl.Font = Enum.Font.SourceSans
        end
        tag.Adornee = isP and obj:FindFirstChild("Head") or obj:FindFirstChild("Screen", true) or obj:FindFirstChildWhichIsA("BasePart", true)
        tag.ExtentsOffset = Vector3.new(0, isP and 1.2 or 0.8, 0)
        tag.L.Text = txt
        tag.L.TextColor3 = col
        if isP and pObj and _G.Show_BeastChance then
            tag.C.Text = "Chance: " .. GetBeastChance(pObj) .. "%"
            tag.C.Visible = true
            tag.C.TextColor3 = Color3.new(1, 1, 1)
        else
            tag.C.Visible = false
        end
    elseif hT then hT:Destroy() end
end

ESPTab:CreateSection("Settings")
ESPTab:CreateToggle({Name = "Highlights", CurrentValue = false, Callback = function(v) _G.ESP_Highlights = v end})
ESPTab:CreateToggle({Name = "Names", CurrentValue = false, Callback = function(v) _G.ESP_Names = v end})
ESPTab:CreateToggle({Name = "Outlines", CurrentValue = true, Callback = function(v) _G.ESP_Outlines = v end})

ESPTab:CreateSection("Detection")
ESPTab:CreateToggle({Name = "ESP Computers", CurrentValue = false, Callback = function(v) _G.ESP_PC = v end})
ESPTab:CreateToggle({Name = "ESP Freeze Pods", CurrentValue = false, Callback = function(v) _G.ESP_Pod = v end})
ESPTab:CreateToggle({Name = "ESP Exits", CurrentValue = false, Callback = function(v) _G.ESP_Exit = v end})
ESPTab:CreateToggle({Name = "Show Beast Chance", CurrentValue = false, Callback = function(v) _G.Show_BeastChance = v end})

local cachedObjects = {}
task.spawn(function()
    while true do
        local newCache = {}
        for _, v in ipairs(workspace:GetDescendants()) do
            if v.Name == "ComputerTable" or (v.Name == "FreezePod" and v:IsA("Model")) or v.Name == "ExitDoor" or v.Name == "ExitArea" then
                table.insert(newCache, v)
            end
        end
        cachedObjects = newCache
        task.wait(5)
    end
end)

task.spawn(function()
    while task.wait(0.3) do
        local lobby = workspace:FindFirstChild("FTFLobby")
        local compLeft = 0
        pcall(function()
            local stats = lp:FindFirstChild("TempPlayerStatsModule")
            if stats then compLeft = require(stats).GetValue("ComputersLeft") or 0 end
        end)

        for _, p in ipairs(Players:GetPlayers()) do
            local char = p.Character
            if char then
                local color = Color3.new(0,1,0)
                local prefix = "[S] "
                local isBeast = char:FindFirstChild("Hammer") or char:FindFirstChild("BeastPowers")
                if lobby and char:IsDescendantOf(lobby) then color = Color3.new(1,1,1); prefix = "[Lobby] "
                elseif isBeast then color = Color3.new(1,0,0); prefix = "[B] " end
                UpdateESP(char, color, (p == lp and "[YOU] " or prefix) .. p.Name, true, true, p)
            end
        end

        for _, v in ipairs(cachedObjects) do
            if v.Name == "ComputerTable" then 
                local isDone = false
                pcall(function() if v.Screen.BrickColor == BrickColor.new("Dark green") then isDone = true end end)
                
                local pcColor = isDone and Color3.new(0, 1, 0) or Color3.new(0, 1, 1)
                local pcText = isDone and "PC [OK]" or "PC ["..compLeft.."]"
                
                UpdateESP(v, pcColor, pcText, _G.ESP_PC, false)
            elseif v.Name == "FreezePod" then 
                UpdateESP(v, Color3.new(1,0,0), "POD", _G.ESP_Pod, false)
            else
                UpdateESP(v, Color3.new(0,1,0), "EXIT", _G.ESP_Exit, false)
            end
        end
    end
end)
