if game:GetService("CoreGui"):FindFirstChild("WindUI") then
    return
end

getgenv().ConfigurationTable = {}
getgenv().Settings = {}

local FolderConfiguration = "Venuz Hub"
local FolderSettings = "Venuz Hub/Violence District"
local FolderSlots = "Venuz Hub/Slots"
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local chr = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local hrp = chr:WaitForChild("HumanoidRootPart")
local humanoid = chr:WaitForChild("Humanoid")
local HttpService = game:GetService("HttpService")
local VenuzIcon = "rbxassetid://92691624917972"
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local UserId = LocalPlayer.UserId
local currentTime = os.date("%H:%M:%S")
local VirtualInputManager = game:GetService("VirtualInputManager")

local filenameConfiguration = FolderConfiguration .. "/" .. "Setting" .. ".json"
local filenameSetting = FolderSettings .. "/" .. "Violence_District".. LocalPlayer.Name .. ".json"

--------------------------- Configuration ---------------------------

local DefaultConfiguration = {
    Themes = "Dark",
    Transparent = true,
    AntiAFK = true,
    AutoExecutor = true,
    MinimizeBind = "End",
    Language = "English",
}

local function MergeConfiguration(loaded, defaults)
    for key, defaultValue in pairs(defaults) do
        if type(defaultValue) == "table" then
            loaded[key] = MergeConfiguration(loaded[key] or {}, defaultValue)
        else
            if loaded[key] == nil then
                loaded[key] = defaultValue
            end
        end
    end
    return loaded
end

function LoadConfiguration()
    if readfile and isfile and isfile(filenameConfiguration) then
        local data = readfile(filenameConfiguration)
        local success, decoded = pcall(function()
            return HttpService:JSONDecode(data)
        end)

        if success and type(decoded) == "table" then
            getgenv().ConfigurationTable = MergeConfiguration(decoded, DefaultConfiguration)
        else
            warn("[Configuration] Failed to decode, using default.")
            getgenv().ConfigurationTable = DefaultConfiguration
        end
    else
        getgenv().ConfigurationTable = DefaultConfiguration
    end
end

function SaveConfiguration()
    if writefile and makefolder then
        if not isfolder("Venuz Hub") then makefolder("Venuz Hub") end
        if not isfolder(FolderConfiguration) then makefolder(FolderConfiguration) end

        local json = HttpService:JSONEncode(getgenv().ConfigurationTable)
        writefile(filenameConfiguration, json)
    end
end

LoadConfiguration()

--------------------------- SaveSettings ---------------------------

local DefaultSettings = {
    ["Main"] = {
        ["AutoSkillCheck"] = false,
    },

    ["ESP"] = {
        ["Survivor"] = false,
        ["Killer"] = false,
        ["Generator"] = false,
        ["Pallets"] = false,
        ["Name"] = false,
        ["Distance"] = false,
    },

    ["Lighting"] = {
        "FullBright",
    },

    ["ModifyCharacter"] = {
        ["SpeedBoot"] = false,
        ["SpeedBootValue"] = 1,
    }
}

local function MergeSettings(defaults, loaded)
    for k,v in pairs(defaults) do
        if type(v) == "table" then
            if type(loaded[k]) ~= "table" then
                loaded[k] = v
            else
                MergeSettings(v, loaded[k])
            end
        else
            if loaded[k] == nil then
                loaded[k] = v
            end
        end
    end
end

function LoadSettings()
    if readfile and isfile and isfile(filenameSetting) then
        local loaded = HttpService:JSONDecode(readfile(filenameSetting))
        MergeSettings(DefaultSettings, loaded)
        getgenv().Settings = loaded
    else
        getgenv().Settings = DefaultSettings
    end
end

function SaveSetting()
    if writefile and makefolder then
        if not isfolder("Venuz Hub") then makefolder("Venuz Hub") end
        if not isfolder(FolderSettings) then makefolder(FolderSettings) end
        local json = HttpService:JSONEncode(getgenv().Settings)
        writefile(filenameSetting, json)
    end
end

LoadSettings()

if getgenv().Configuration and next(getgenv().Configuration) then
    for key, value in pairs(getgenv().Configuration) do
        if getgenv().Settings[key] ~= nil then
            getgenv().Settings[key] = value
        end
    end
    SaveSetting()
end

--------------------------- CheckingRole ---------------------------

local KeyFile = "Venuz Hub/KeySystem".."/".."VenuzKey"..".txt"

local res = http.request({
    Url = "https://pandadevelopment.net/v2_validation?key=".. readfile(KeyFile).."&service=venuzhub&hwid=venuzontop",
    Method = "GET",
    Headers = {
        ["Content-Type"] = "application/json"
    },
}).Body

local sucess, data = pcall(function()
    return HttpService:JSONDecode(res)
end)

if sucess then
    if data["Key_Information"].Premium_Mode == true then
        getgenv().Premium = false
        getgenv().IsPremium = "Premium Access"
    else
        getgenv().Premium = true
        getgenv().IsPremium = "Standard"
    end
end

local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Kotaro/API/refs/heads/main/test.lua"))()

local Device
if UserInputService.TouchEnabled then
    Device = UDim2.fromOffset(450, 300)
else
    Device = UDim2.fromOffset(650, 520)
end

WindUI:Localization({
    Enabled = true,
    Prefix = "tr:",
    DefaultLanguage = getgenv().ConfigurationTable.Language,
    Translations = {
        ["Thai"] = {
            -- Tabs --
            ["Main"] = "หน้าหลัก",
            ["Visual"] = "ภาพและแสง",
            ["Modify"] = "ปรับแต่ง",
            ["Configuration"] = "ตั้งค่า",

            -- Main --
            ["MainTabs1"] = "↪ หน้าหลัก",
            ["AutoSkillCheck"] = "ตรวจเช็กสกิลอัตโนมัติ",
            ["FindGenerator"] = "ค้นหาเครื่องปั่นไฟ",

            -- ESP --
            ["ESPSettings"] = "ตั้งค่ามองทะลุ (ESP)",
            ["SurvivorName"] = "แสดงชื่อผู้รอดชีวิต",
            ["SurvivorDistance"] = "แสดงระยะทางผู้รอดชีวิต",
            ["ESPMain"] = "↪ ผู้รอดชีวิต & ฆาตกร",
            ["SurvivorESP"] = "มองทะลุผู้รอดชีวิต",
            ["KillerESP"] = "มองทะลุฆาตกร",
            ["ESPMain2"] = "↪ เครื่องปั่นไฟ & พาเลต",
            ["GeneratorToggle"] = "มองทะลุเครื่องปั่นไฟ",
            ["PalletToggle"] = "มองทะลุสิ่งของที่ใช้ขวางทาง (Pallet)",
            ["ESPMain3"] = "↪ แสงสว่าง",
            ["FullBrightTab"] = "เปิดความสว่างสูงสุด",
            ["ModifyCharacter"] = "↪ ปรับแต่งตัวละคร",
            ["SpeedBoost"] = "เพิ่มความเร็ว",
            ["SpeedValue"] = "ระดับความเร็ว",

            -- Configuration --
            ["themeDropdown"] = "เลือกธีม",
            ["ToggleTransparency"] = "เปิด/ปิดความโปร่งใสหน้าต่าง",
            ["AntiAFK"] = "ป้องกันการหลุด (Anti-AFK)",
            ["AutoExecutor"] = "รันอัตโนมัติ (Auto Executor)",
            ["MinimizeBind"] = "ปุ่มย่อหน้าต่าง",
            ["LanguageTab"] = "↪ ภาษา",
            ["Interface"] = "↪ ตั้งค่าอินเทอร์เฟส",
            ["CreditLanguageTab"] = "แปลโดย : Spy (spypath)",
            ["Language"] = "ภาษา",
            ["ChangedLanguage"] = "เปลี่ยนภาษา",
        },
        ["English (US)"] = {
            -- Tabs --
            ["Main"] = "Main",
            ["Visual"] = "Visual",
            ["Modify"] = "Modify",
            ["Configuration"] = "Configuration",

            -- Main --
            ["MainTabs1"] = "Main",
            ["AutoSkillCheck"] = "Auto Skill Check",
            ["FindGenerator"] = "Find Generator",

            -- ESP --
            ["ESPSettings"] = "ESP Settings",
            ["SurvivorName"] = "Show Name",
            ["SurvivorDistance"] = "Show Distance",
            ["ESPMain"] = "Survivor & Killer",
            ["SurvivorESP"] = "Survivor ESP",
            ["KillerESP"] = "Killer ESP",
            ["ESPMain2"] = "Generator & Pallet",
            ["GeneratorToggle"] = "Generator ESP",
            ["PalletToggle"] = "Pallet ESP (Objects to block path)",
            ["ESPMain3"] = "Lighting",
            ["FullBrightTab"] = "Full Bright",
            ["ModifyCharacter"] = "Modify Character",
            ["SpeedBoost"] = "Speed Boost",
            ["SpeedValue"] = "Speed",

            -- Configuration --
            ["themeDropdown"] = "Select Theme",
            ["ToggleTransparency"] = "Toggle Window Transparency",
            ["AntiAFK"] = "Anti-AFK",
            ["AutoExecutor"] = "Auto Executor",
            ["MinimizeBind"] = "Minimize Bind",
            ["LanguageTab"] = "↪ Language",
            ["Interface"] = "↪ Interface Settings",
            ["CreditLanguageTab"] = "Translated by: Spy (spypath)",
            ["Language"] = "Language",
            ["ChangedLanguage"] = "Change Language",
        },
    }
})

local CurrentLanguage = getgenv().ConfigurationTable.Language

if CurrentLanguage == "English (US)" then
    WindUI:SetLanguage("English (US)")
else
    WindUI:SetLanguage("Thai")
end

local Window = WindUI:CreateWindow({
    Title = "Venuz Hub",
    Icon = VenuzIcon,
    Author = "by Phoenix",
    Size = Device,
    Transparent = getgenv().ConfigurationTable.Transparent,
    Theme = getgenv().ConfigurationTable.Themes,
    SideBarWidth = 200,
    HasOutline = true,
    ScrollBarEnabled = true,
    Resizable = false,
})

Window:Tag({
    Title = getgenv().IsPremium,
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13,
})

Window:Tag({
    Title = "Update Latest 11/08/2025",
    Color = Color3.fromHex("#f4fc02"),
    Radius = 13,
})

Window:EditOpenButton({
    Title = "Venuz Hub",
    Icon = VenuzIcon,
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = true,
    Enabled = true,
    Draggable = true,
})

local Tabs = {
    Main = Window:Tab({ Title = "tr:Main", Icon = "house", ShowTabTitle = true}),
    Visual = Window:Tab({ Title = "tr:Visual", Icon = "eye", ShowTabTitle = true}),
    Modify = Window:Tab({ Title = "tr:Modify", Icon = "user", ShowTabTitle = true}),
    divider1 = Window:Divider(),
    Configuration = Window:Tab({ Title = "tr:Configuration", Icon = "settings", Desc = "Manage window settings and themes.", ShowTabTitle = true}),
}

-------------------------------- Main --------------------------------

local MainTabs1 = Tabs.Main:Section({ Title = "tr:Main" })

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local AutoSkillCheck = Tabs.Main:Toggle({
    Title = "tr:AutoSkillCheck",
    Value = getgenv().Settings.Main.AutoSkillCheck,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Main.AutoSkillCheck = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                if Value then
                    while getgenv().Settings.Main.AutoSkillCheck do 
                        task.wait()

                        local player = game.Players.LocalPlayer
                        local char = player.Character or player.CharacterAdded:Wait()
                        local root = char:WaitForChild("HumanoidRootPart")
                        local skillGui = player:WaitForChild("PlayerGui"):WaitForChild("SkillCheckPromptGui")
                        local check = skillGui:FindFirstChild("Check")

                        if check and check.Visible == true then
                                local Line = check:FindFirstChild("Line")
                                local Goal = check:FindFirstChild("Goal")
                                if Line and Goal then
                                    Goal.Rotation = Line.Rotation - 110
                                end

                            -- ========== Generator SkillCheck ==========
                            local closestGen, closestGenDist = nil, math.huge
                            for _, v in pairs(workspace.Map:GetDescendants()) do
                                if v:IsA("Model") and v.Name == "Generator" then
                                    local genPart = v.PrimaryPart or v:FindFirstChildWhichIsA("BasePart")
                                    if genPart then
                                        local distance = (root.Position - genPart.Position).Magnitude
                                        if distance < closestGenDist then
                                            closestGenDist = distance
                                            closestGen = v
                                        end
                                    end
                                end
                            end

                            if closestGen then
                                for _, point in pairs(closestGen:GetDescendants()) do
                                    if point:IsA("BasePart") and point.Name:lower():find("generatorpoint") then
                                        if UserInputService.KeyboardEnabled then
                                            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                            task.wait(0.05)
                                            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                        else
                                            game:GetService("ReplicatedStorage").Remotes.Generator.SkillCheckResultEvent:FireServer(
                                                "success",
                                                1,
                                                closestGen,
                                                point
                                            )
                                        end
                                        break
                                    end
                                end
                            end

                            -- ========== Healing SkillCheck ==========
                            local closestPlayer, closestPlayerDist = nil, math.huge
                            for _, otherPlayer in pairs(game.Players:GetPlayers()) do
                                if otherPlayer ~= player and otherPlayer.Character then
                                    local otherRoot = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
                                    if otherRoot then
                                        local distance = (root.Position - otherRoot.Position).Magnitude
                                        if distance < closestPlayerDist and distance < 10 then -- ระยะ 10 studs
                                            closestPlayerDist = distance
                                            closestPlayer = otherPlayer
                                        end
                                    end
                                end
                            end

                            if closestPlayer and closestPlayer.Character then
                                if UserInputService.KeyboardEnabled then
                                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                                    task.wait(0.05)
                                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                                else
                                    game:GetService("ReplicatedStorage").Remotes.Healing.SkillCheckResultEvent:FireServer(
                                        "success",
                                        1,
                                        closestPlayer.Character
                                    )
                                end
                            end
                            
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end)
    end
})

local FindGenerator = Tabs.Main:Button({
    Title = "tr:FindGenerator",
    Callback = function(Callback)
        for i,v in pairs(workspace.Map:GetDescendants()) do
            if v.Name == "Generator" then
                if v:GetAttribute("RepairProgress") ~= 100 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HitBox.CFrame * CFrame.new(-5,0,0)
                end
            end
        end
    end
})

-------------------------------- ESP --------------------------------

local ESPSettings = Tabs.Visual:Section({ Title = "tr:ESPSettings" })

local SurvivorName = Tabs.Visual:Toggle({
    Title = "tr:SurvivorName",
    Value = getgenv().Settings.ESP.Name,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ESP.Name = Value
        SaveSetting()
    end
})

local SurvivorDistance = Tabs.Visual:Toggle({
    Title = "tr:SurvivorDistance",
    Value = getgenv().Settings.ESP.Distance,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ESP.Distance = Value
        SaveSetting()
    end
})

local ESPMain = Tabs.Visual:Section({ Title = "tr:ESPMain" })

local SurvivorESP = Tabs.Visual:Toggle({
    Title = "tr:SurvivorESP",
    Value = getgenv().Settings.ESP.Survivor,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ESP.Survivor = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                local localPlayer = game.Players.LocalPlayer

                while getgenv().Settings.ESP.Survivor do task.wait()

                    local localChar = localPlayer.Character
                    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")

                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Team and v.Team.Name == "Survivors" then
                            local head = v.Character.Head
                            local esp = head:FindFirstChild("ESP_Venuz")
                            local highlight = v.Character:FindFirstChild("Venuz_Hightlight")

                            if not esp then
                                local BillboardGui = Instance.new("BillboardGui")
                                local TextLabel = Instance.new("TextLabel")
                                local Highlight = Instance.new("Highlight")

                                BillboardGui.Parent = head
                                BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                                BillboardGui.AlwaysOnTop = true
                                BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                                BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                                BillboardGui.Name = "ESP_Venuz"

                                TextLabel.Parent = BillboardGui
                                TextLabel.BackgroundTransparency = 1
                                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                                TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                TextLabel.TextSize = 14
                                TextLabel.TextWrapped = true
                                TextLabel.Name = "ESP_Text"

                                Highlight.Parent = v.Character
                                Highlight.FillColor = Color3.fromRGB(85, 255, 0)
                                Highlight.FillTransparency = 0.5
                                Highlight.Name = "Venuz_Hightlight"
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                Highlight.OutlineTransparency = 1
                            end

                            if localHRP and v.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = math.floor((localHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                                local textLabel = head.ESP_Venuz:FindFirstChild("ESP_Text")

                                if textLabel then
                                    local showName = getgenv().Settings.ESP.Name
                                    local showDist = getgenv().Settings.ESP.Distance
                                    local nameText = showName and v.Name or ""
                                    local distText = showDist and (" [ " .. distance .. "m ]") or ""

                                    textLabel.Text = nameText .. distText
                                end
                            end

                            if not getgenv().Settings.ESP.Survivor then
                                if esp then esp.Enabled = false end
                                if highlight then highlight.Enabled = false end
                            else
                                if esp then esp.Enabled = true end
                                if highlight then highlight.Enabled = true end
                            end
                        end
                    end
                end

                for _, v in pairs(game.Players:GetPlayers()) do
                    if v.Character then
                        local esp = v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("ESP_Venuz")
                        local highlight = v.Character:FindFirstChild("Venuz_Hightlight")
                        if esp then esp:Destroy() end
                        if highlight then highlight:Destroy() end
                    end
                end
            end)
        end)
    end
})

local KillerESP = Tabs.Visual:Toggle({
    Title = "tr:KillerESP",
    Value = getgenv().Settings.ESP.Killer,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ESP.Killer = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                local localPlayer = game.Players.LocalPlayer

                while getgenv().Settings.ESP.Killer do task.wait()

                    local localChar = localPlayer.Character
                    local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")

                    for _, v in pairs(game.Players:GetPlayers()) do
                        if v ~= localPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Team and v.Team.Name == "Killer" then
                            local head = v.Character.Head
                            local esp = head:FindFirstChild("ESP_Venuz")
                            local highlight = v.Character:FindFirstChild("Venuz_Hightlight")

                            if not esp then
                                local BillboardGui = Instance.new("BillboardGui")
                                local TextLabel = Instance.new("TextLabel")
                                local Highlight = Instance.new("Highlight")

                                BillboardGui.Parent = head
                                BillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
                                BillboardGui.AlwaysOnTop = true
                                BillboardGui.Size = UDim2.new(0, 200, 0, 50)
                                BillboardGui.StudsOffset = Vector3.new(0, 2.5, 0)
                                BillboardGui.Name = "ESP_Venuz"

                                TextLabel.Parent = BillboardGui
                                TextLabel.BackgroundTransparency = 1
                                TextLabel.Size = UDim2.new(1, 0, 1, 0)
                                TextLabel.FontFace = Font.new("rbxasset://fonts/families/Inconsolata.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                                TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                                TextLabel.TextSize = 14
                                TextLabel.TextWrapped = true
                                TextLabel.Name = "ESP_Text"

                                Highlight.Parent = v.Character
                                Highlight.Adornee = v.Character
                                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                Highlight.FillTransparency = 0.5
                                Highlight.Name = "Venuz_Hightlight"
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                Highlight.OutlineTransparency = 1
                            end

                            if localHRP and v.Character:FindFirstChild("HumanoidRootPart") then
                                local distance = math.floor((localHRP.Position - v.Character.HumanoidRootPart.Position).Magnitude)
                                local textLabel = head.ESP_Venuz:FindFirstChild("ESP_Text")

                                if textLabel then
                                    local showName = getgenv().Settings.ESP.Name
                                    local showDist = getgenv().Settings.ESP.Distance
                                    local nameText = showName and v.Name or ""
                                    local distText = showDist and (" [ " .. distance .. "m ]") or ""

                                    textLabel.Text = nameText .. distText
                                end
                            end

                            if not getgenv().Settings.ESP.Killer then
                                if esp then esp.Enabled = false end
                                if highlight then highlight.Enabled = false end
                            else
                                if esp then esp.Enabled = true end
                                if highlight then highlight.Enabled = true end
                            end
                        end
                    end
                end

                for _, v in pairs(game.Players:GetPlayers()) do
                    if v.Character then
                        local esp = v.Character:FindFirstChild("Head") and v.Character.Head:FindFirstChild("ESP_Venuz")
                        local highlight = v.Character:FindFirstChild("Venuz_Hightlight")
                        if esp then esp:Destroy() end
                        if highlight then highlight:Destroy() end
                    end
                end
            end)
        end)
    end
})

local ESPMain2 = Tabs.Visual:Section({ Title = "tr:ESPMain2" })

local GeneratorToggle = Tabs.Visual:Toggle({
    Title = "tr:GeneratorToggle",
    Value = getgenv().Settings.ESP.Generator,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ESP.Generator = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                if Value then
                    while getgenv().Settings.ESP.Generator do task.wait(0.5)
                        for _, v in pairs(workspace.Map:GetChildren()) do
                            if v.Name == "Generator" then

                                if v:FindFirstChild("Venuz_Hightlight_Generator") then
                                    if not getgenv().Settings.ESP.Generator then
                                        v.Venuz_Hightlight_Generator.Enabled = false
                                        else
                                        v.Venuz_Hightlight_Generator.Enabled = true
                                    end
                                end

                                if v:GetAttribute("RepairProgress") == 100 then
                                    local highlight = v:FindFirstChild("Venuz_Hightlight_Generator")
                                    if highlight then
                                        highlight:Destroy()
                                    end
                                else
                                    if not v:FindFirstChild("Venuz_Hightlight_Generator") then
                                        local Highlight = Instance.new("Highlight")
                                        Highlight.Parent = v
                                        Highlight.FillColor = Color3.fromRGB(0, 150, 255)
                                        Highlight.FillTransparency = 0.5
                                        Highlight.Name = "Venuz_Hightlight_Generator"
                                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                        Highlight.OutlineTransparency = 1
                                    end
                                end

                            elseif v:FindFirstChild("Generator") then
                                for _, v2 in pairs(v:GetChildren()) do
                                    if v2.Name == "Generator" then

                                        if v2:FindFirstChild("Venuz_Hightlight_Generator") then
                                            if not getgenv().Settings.ESP.Generator then
                                                v2.Venuz_Hightlight_Generator.Enabled = false
                                                else
                                                v2.Venuz_Hightlight_Generator.Enabled = true
                                            end
                                        end

                                        if v2:GetAttribute("RepairProgress") == 100 then
                                            local highlight = v2:FindFirstChild("Venuz_Hightlight_Generator")
                                            if highlight then
                                                highlight:Destroy()
                                            end
                                        else
                                            if not v2:FindFirstChild("Venuz_Hightlight_Generator") then
                                                local Highlight = Instance.new("Highlight")
                                                Highlight.Parent = v2
                                                Highlight.FillColor = Color3.fromRGB(0, 150, 255)
                                                Highlight.FillTransparency = 0.5
                                                Highlight.Name = "Venuz_Hightlight_Generator"
                                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end
})

local PalletToggle = Tabs.Visual:Toggle({
    Title = "tr:PalletToggle",
    Value = getgenv().Settings.ESP.Pallets,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ESP.Pallets = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                while getgenv().Settings.ESP.Pallets do task.wait(5)

                    for _, v in pairs(workspace.Map:GetDescendants()) do
                        if v.Name:lower():find("pallet") and v:IsA("Model") and v:FindFirstChild("HumanoidRootPart") then
                            local highlight = v:FindFirstChild("Venuz_Hightlight_Generator")

                            if not highlight then
                                local Highlight = Instance.new("Highlight")
                                Highlight.Name = "Venuz_Hightlight_Generator"
                                Highlight.Parent = v
                                Highlight.FillColor = Color3.fromRGB(255, 234, 0)
                                Highlight.FillTransparency = 0.5
                                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                Highlight.OutlineTransparency = 1
                            end

                            v.Venuz_Hightlight_Generator.Enabled = getgenv().Settings.ESP.Pallets
                        end
                    end
                end

                -- 🔹 ปิด toggle → ลบ highlight ออกทั้งหมด
                for _, v in pairs(workspace.Map:GetDescendants()) do
                    local highlight = v:FindFirstChild("Venuz_Hightlight_Generator")
                    if highlight then
                        highlight:Destroy()
                    end
                end
            end)
        end)
    end
})

local ESPMain3 = Tabs.Visual:Section({ Title = "tr:ESPMain3" })

local FullBrightTab = Tabs.Visual:Toggle({
    Title = "tr:FullBrightTab",
    Value = getgenv().Settings.Lighting.FullBright,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Lighting.FullBright = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                local lighting = game:GetService("Lighting")

                local oldAmbient = lighting.Ambient
                local oldBrightness = lighting.Brightness

                if Value then
                    while getgenv().Settings.Lighting.FullBright do task.wait(.5)
                        lighting.Ambient = Color3.fromRGB(255, 255, 255)
                        lighting.Brightness = 4
                    end

                    lighting.Ambient = oldAmbient
                    lighting.Brightness = oldBrightness
                end
            end)
        end)
    end
})

local ModifyCharacter = Tabs.Modify:Section({ Title = "tr:ModifyCharacter" })

local currentConnection = nil
local isResetting = false
local lastResetTime = 0
local RESET_COOLDOWN = 5

function SetSpeedAttribute(char, value)
    if not char or not char.Parent then return end
    
    local finalValue = tonumber(string.format("%.2f", value))
    
    if char:GetAttribute("speedboost") == finalValue then
        return
    end
    
    char:SetAttribute("speedboost", nil)
    task.wait(0.05)
    char:SetAttribute("speedboost", finalValue)
end

function ClearConnection()
    if currentConnection then
        currentConnection:Disconnect()
        currentConnection = nil
    end
    isResetting = false
end

function MonitorSpeedBoost(char)
    if not char or not char.Parent then return end
    
    ClearConnection()

    currentConnection = char:GetAttributeChangedSignal("speedboost"):Connect(function()
        if not getgenv().Settings.ModifyCharacter.SpeedBoot then 
            return 
        end

        if isResetting then 
            return 
        end
        
        local currentTime = tick()
        if currentTime - lastResetTime < RESET_COOLDOWN then
            return
        end
        
        local currentSpeed = char:GetAttribute("speedboost")
        local targetSpeed = getgenv().Settings.ModifyCharacter.SpeedBootValue or 1.1

        currentSpeed = tonumber(string.format("%.2f", currentSpeed or 0))
        targetSpeed = tonumber(string.format("%.2f", targetSpeed))

        if math.abs(currentSpeed - targetSpeed) > 0.01 then
            isResetting = true
            lastResetTime = currentTime

            task.wait(math.random(30, 40) / 10)

            if char.Parent and getgenv().Settings.ModifyCharacter.SpeedBoot then
                SetSpeedAttribute(char, targetSpeed)
            end
            
            task.wait(0.5)
            isResetting = false
        end
    end)

    local humanoid = char:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Died:Once(function()
            ClearConnection()
        end)
    end

    char.AncestryChanged:Once(function()
        if not char.Parent then
            ClearConnection()
        end
    end)
end

local SpeedBoost = Tabs.Modify:Toggle({
    Title = "tr:SpeedBoost",
    Value = getgenv().Settings.ModifyCharacter.SpeedBoot,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.ModifyCharacter.SpeedBoot = Value
        SaveSetting()

        local char = LocalPlayer.Character
        if not char then return end

        if Value then
            local targetValue = getgenv().Settings.ModifyCharacter.SpeedBootValue or 1.1
            SetSpeedAttribute(char, targetValue)
            MonitorSpeedBoost(char)
        else
            ClearConnection()
            SetSpeedAttribute(char, 1)
        end
    end
})

local SpeedValue = Tabs.Modify:Slider({
    Title = "tr:SpeedValue",
    Step = 0.1,
    Value = {
        Min = 1.1,
        Max = 2,
        Default = getgenv().Settings.ModifyCharacter.SpeedBootValue,
    },
    Callback = function(Value)
        getgenv().Settings.ModifyCharacter.SpeedBootValue = Value
        SaveSetting()

        local char = LocalPlayer.Character
        if getgenv().Settings.ModifyCharacter.SpeedBoot and char then
            isResetting = true
            SetSpeedAttribute(char, Value)
            task.wait(0.5)
            isResetting = false
        end
    end
})

LocalPlayer.CharacterAdded:Connect(function(char)
    ClearConnection()
    lastResetTime = 0
    
    char:WaitForChild("Humanoid")
    task.wait(1)
    
    if getgenv().Settings.ModifyCharacter.SpeedBoot then
        local targetValue = getgenv().Settings.ModifyCharacter.SpeedBootValue or 1.1
        SetSpeedAttribute(char, targetValue)
        MonitorSpeedBoost(char)
    else
        SetSpeedAttribute(char, 1)
    end
end)

if getgenv then
    getgenv().CleanupSpeedBoost = function()
        ClearConnection()
    end
end
-------------------------------- Configuration --------------------------------

local IS = Tabs.Configuration:Section({ Title = "tr:InterfaceSettings" })


local themeValues = {}
for name, _ in pairs(WindUI:GetThemes()) do
    table.insert(themeValues, name)
end

local themeDropdown = Tabs.Configuration:Dropdown({
    Title = "tr:themeDropdown",
    Multi = false,
    AllowNone = false,
    Value = getgenv().ConfigurationTable.Themes,
    Values = themeValues,
    Callback = function(theme)
        getgenv().ConfigurationTable.Themes = theme
        SaveConfiguration()
        WindUI:SetTheme(theme)
    end
})

themeDropdown:Select(WindUI:GetCurrentTheme())

local ToggleTransparency = Tabs.Configuration:Toggle({
    Title = "tr:ToggleTransparency",
    Value = getgenv().ConfigurationTable.Transparent,
    Icon = "check",
    Callback = function(e)
        getgenv().ConfigurationTable.Transparent = e
        SaveConfiguration()
        Window:ToggleTransparency(e)
    end,
    Value = WindUI:GetTransparency()
})

local AntiAFK = Tabs.Configuration:Toggle({
    Title = "tr:AntiAFK",
    Value = getgenv().ConfigurationTable.AntiAFK,
    Icon = "check",
    Callback = function(enabled)
        getgenv().ConfigurationTable.AntiAFK = enabled
        SaveConfiguration()

        if enabled then
            task.spawn(function()
                while getgenv().ConfigurationTable.AntiAFK do task.wait(500)
                    game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.1)
                    game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                end
            end)
        end
    end
})

local AutoExecutor = Tabs.Configuration:Toggle({
    Title = "tr:AutoExecutor",
    Value = getgenv().ConfigurationTable.AutoExecutor,
    Icon = "check",
    Callback = function(Value)
        getgenv().ConfigurationTable.AutoExecutor = Value
        SaveConfiguration()
    end
})

local MinimizeBind = Tabs.Configuration:Keybind({
    Title = "tr:MinimizeBind",
    Value = getgenv().ConfigurationTable.MinimizeBind,
    Callback = function(v)
        getgenv().ConfigurationTable.MinimizeBind = v
        SaveConfiguration()
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

local LanguageTab =  Tabs.Configuration:Section({ Title = "tr:LanguageTab", Icon = "languages"})

local Language = Tabs.Configuration:Dropdown({
    Title = "tr:Language",
    Multi = false,
    AllowNone = false,
    Values = {"English (US)","Thai"},
    Value = getgenv().ConfigurationTable.Language,
    Callback = function(Callback)
        getgenv().ConfigurationTable.Language = Callback
        SaveConfiguration()
    end
})

local ChangedLanguage = Tabs.Configuration:Button({
    Title = "tr:ChangedLanguage",
    Callback = function()
        if getgenv().ConfigurationTable.Language == "English (US)" then
            WindUI:SetLanguage("English (US)")
        else
            WindUI:SetLanguage("Thai")
        end
        Window:SelectTab(1)
    end
})

local queueteleport = queue_on_teleport
local TeleportCheck = false

while not Players.LocalPlayer do task.wait() end

LocalPlayer.OnTeleport:Connect(function(State)
    pcall(function()
        if getgenv().ConfigurationTable and getgenv().ConfigurationTable.AutoExecutor and (not TeleportCheck) and queueteleport then
            TeleportCheck = true
            queueteleport('loadstring(game:HttpGet("https://raw.githubusercontent.com/x2Kotaro/Venuz-hub/main/Loader.lua"))()')
        end
    end)
end)

Window:SetToggleKey(Enum.KeyCode[getgenv().ConfigurationTable.MinimizeBind])
Window:SelectTab(1)

WindUI:Notify({
    Title = "Script | Loader",
    Content = "Script Loader Successfully",
    Icon = VenuzIcon,
    Duration = 5,
})
