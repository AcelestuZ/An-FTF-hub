-- main
local GUI_NAME = "Rayfield"

local function resetGuiPosition()
    local coreGui = game:GetService("CoreGui")
    local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    
    local target = coreGui:FindFirstChild(GUI_NAME) or playerGui:FindFirstChild(GUI_NAME)
    
    if target then
        local mainFrame = target:FindFirstChild("Main", true)
        if mainFrame and mainFrame:IsA("Frame") then
            mainFrame.Position = UDim2.new(0.5, -mainFrame.Size.X.Offset / 2, 0.5, -mainFrame.Size.Y.Offset / 2)
            _G.Rayfield:Notify({Title = "Hace HUB", Content = "GUI Position reset to center!", Duration = 3})
            return true
        end
    end
    return false
end

if _G.HubWindow then
    if resetGuiPosition() then
        return 
    end
end

_G.Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
local Window = _G.Rayfield:CreateWindow({
   Name = "Hace HUB | FtF 🏃🏢",
   LoadingTitle = "Loading Hace HUB...",
   LoadingSubtitle = "By AcelestuZ",
   ConfigurationSaving = { Enabled = true, FolderName = "HaceHub_FTF" },
   KeySystem = false
})

_G.HubWindow = Window

_G.ESP_Highlights, _G.ESP_Names, _G.ESP_Outlines = false, false, true
_G.NoPCError, _G.FullBrightEnabled, _G.NoFogEnabled = false, false, false
_G.ESP_PC, _G.ESP_Exit, _G.ESP_Pod = false, false, false
_G.Show_BadgeIcons, _G.Show_BeastChance = false, false

local baseUrl = "https://raw.githubusercontent.com/AcelestuZ/An-FTF-hub/main/"

local function loadTab(file)
    local url = baseUrl .. file
    local success, content = pcall(function() return game:HttpGet(url) end)
    if success then
        local func, err = loadstring(content)
        if func then
            pcall(func)
        else
            warn("Syntax error in " .. file .. ": " .. tostring(err))
        end
    else
        warn("Could not download " .. file)
    end
end

loadTab("TabM.lua")
loadTab("2TabS.lua")
loadTab("3TabB.lua")
loadTab("4TabESP.lua")
loadTab("5TabTP.lua")

_G.Rayfield:Notify({Title = "Hace HUB", Content = "Script loaded successfully!", Duration = 3})
