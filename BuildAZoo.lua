if game:GetService("CoreGui").RobloxGui:FindFirstChild("WindUI") then
    return
end

getgenv().ConfigurationTable = {}
getgenv().Settings = {}

local FolderConfiguration = "Venuz Hub"
local FolderSettings = "Venuz Hub/Build_A_Zoo"
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

local filenameConfiguration = FolderConfiguration .. "/" .. "Setting" .. ".json"
local filenameSetting = FolderSettings .. "/" .. "Build_A_Zoo".. LocalPlayer.Name .. ".json"

--------------------------- Configuration ---------------------------

local DefaultConfiguration = {
    ["Themes"] = "Crimson",
    ["Transparent"] = true,
    ["AntiAFK"] = true,
    ["AutoRejoin"] = false,
    ["AutoExecutor"] = true,
    ["MinimizeBind"] = "End",
    ["Language"] = "English (US)",
    ["FPSValue"] = 144,
    ["LockFPS"] = false,
    ["WhileScreen"] = false,
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
    ["AutoCollect"] = {
        ["AutoCollect"] = false,
        ["Delay"] = 20,
        ["Value"] = 0
    },

    ["AutoBuyEgg"] = {
        ["AutoBuyEgg"] = false,
        ["SelectEgg"] = {},
        ["SelectMutation"] = {},
        ["AutoBuyEggwithmutation"] = false,
        ["SelectEventSnow"] = {},
        ["SelectEggsWithMutation"] = {},
        ["AutoBuyEggwithEventSnow"] = false,
        ["infactionSnow"] = false,
    },

    ["AutoPlace"] = {
        ["SelectEgg"] = {},
        ["AutoEquipEgg"] = false,
        ["AutoPlacePet"] = false,
        ["AutoPlaceOcean"] = false,
        ["AutoHatch"] = false,
    },

    ["Shop"] = {
        ["Fruits"] = {},
        ["AutoBuyFruits"] = false,
    },
    
    ["Feed"] = {
        ["SelectFruit"] = nil,
        ["AutoEquip"] = false,
        ["Mutation"] = {},
        ["AutoFeed"] = false,
        ["SelectPet"] = {},
    },

    ["Quest"] = {
        ["AutoSnowQuest"] = false,
        ["AutoClaimEgg"] = false,
    },

    ["Webhook"] = {
        ["WebhookUrl"] = "",
        ["CheckAllEgg"] = false,
        ["AutoBuyEgg"] = false,
        ["AutoBuyFood"] = false,
        ["Ping"] = false,
    },

    ["Fish"] = {
        ["SelectBait"] = nil,
        ["AutoFish"] = false,
    },

    ["Misc"] = {
        ["DisableAnimationPet"] = false,
        ["DisableEffectGetMoney"] = false,
        ["AutoLikeHopServer"] = false,
        ["DelayAutoLike"] = 15,
        ["SelectPlayers"] = {},
        ["AutoLike"] = false,
        ["DelayAutoLikeAFK"] = 30,
    },

    ["Premium"] = {
        ["PositionFish"] = nil,
        ["SelectBait"] = nil,
        ["AutoFish"] = false,
        ["HopServer"] = false,
        ["HopServerEvent"] = false,
        ["HopServerList"] = "Snow",
        ["Method"] = "Status",
        ["AutoTrade"] = false,
        ["Earns"] = 0,
        ["AutoClaimKitsune"] = false,
        ["AutoPlacePetBest"] = false,
        ["AutoPlaceOceanBest"] = false,
        ["MinValue"] = 0,
        ["MaxValue"] = 0,
        ["AutoEquipTrade"] = false,
    },

    ["Gift"] = {
        ["Teleport"] = false,
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
            ["Automatic"] = "เก็บเงินกับสัตว์ออโต้",
            ["Eggs"] = "ซื้อไข่ออโต้",
            ["Place"] = "วางกับเปิดไข่ออโต้",
            ["Shop"] = "ร้านค้า",
            ["Feed"] = "ให้อาหารสัตว์ใหญ่ออโต้",
            ["Quest"] = "รับเควสออโต้",
            ["Fish"] = "ตกปลาออโต้",
            ["Gift"] = "ให้ของออโต้",
            ["Webhook"] = "เว็บฮุก",
            ["Misc"] = "อื่นๆ",
            ["Premium"] = "พรีเมี่ยม",
            ["Configuration"] = "การตั้งค่า",
            -- Auto Collect --
            ["AutoCollectTab"] = "เก็บเงินออโต้",
            ["AutoCollect"] = "เก็บเงินออโต้",
            ["DelayCollect"] = "ล่าช้า",
            ["AutoCollectDesc"] = "เก็บเงินจากสัตว์ของคุณออโต้",
            ["QuickTab"] = "ทันที",
            ["QuickCollect"] = "เก็บเงินทันที",
            ["QuickCollectDesc"] = "เก็บเงินทั้งหมดในครั้งเดียว",
            ["CollectPet"] = "เก็บสัตว์ออโต้",
            ["Eard"] = "ได้รับเงิน/ต่อวินาที",
            ["CollectAllPetEarn"] = "เก็บสัตว์ ได้รับเงิน/ต่อวินาที",
            ["CollectAllPet"] = "เก็บสัตว์ทั้งหมดในฟาร์ม",
            -- Auto Buy Egg --
            ["AutoBuyEggTab"] = "ซื้อไข่ออโต้",
            ["SelectEggs"] = "เลือกไข่",
            ["AutoBuyEgg"] = "ซื้อไข่ออโต้",
            ["AutoBuyEggDesc"] = "ซื้อไข่ของคุณออโต้บนสายพาน",
            ["AutoBuyEggwithmutationTab"] = "ซื้อไข่ออโต้เมื่อติดกลายพันธุ์",
            ["SelectEggsWith"] = "เลือกไข่",
            ["SelectMutation"] = "เลือกกลายพันธุ์",
            ["AutoBuyEggwithmutation"] = "ซื้อไข่ออโต้เมื่อติดกลายพันธุ์",
            ["AutoBuyEggwithmutationDesc"] = "ซื้อไข่ออโต้บนสายพานของคุณ",
            ["AutoBuyEggwithEventSnowTab"] = "ซื้อไข่ออโต้ของอีเว้น",
            ["SelectEggevent"] = "เลือกไข่",
            ["SnowMutatuion"] = "ซื้อเฉพาะไข่ที่ติดหิมะ",
            ["AutoBuyEggwithEventSnow"] = "ซื้อไข่ออโต้อีเว้นหิมะ",
            ["AutoBuyEggwithEventSnowDesc"] = "ซื้อไข่ออโต้เมื่อไข่อีเว้นหิมะ",
            -- Auto Place & Hatch --
            ["AutoEquipEggTabs"] = "สวมใส่ไข่ออโต้",
            ["SelectEggPlace"] = "เลือกไข่หรือสัตว์",
            ["Refresh"] = "รีเฟรช",
            ["AutoEquipEgg"] = "สวมใส่ออโต้",
            ["AutoEquipEggDesc"] = "สวมใส่ไข่ของคุณออโต้",
            ["AutoPlaceTab"] = "วางออโต้",
            ["AutoPlacePet"] = "วางไข่กับสัตว์ออโต้",
            ["AutoPlaceOcean"] = "วางไข่กับปลาออโต้",
            ["AutoHatchTab"] = "เปิดไข่ออโต้",
            ["AutoHatch"] = "เปิดไข่ออโต้",
            -- Shop --
            ["FruitTab"] = "คลังสินค้าของอาหาร",
            ["SelectFruitShop"] = "เลือกอาหาร",
            ["AutoBuyFruits"] = "ซื้ออาหารออโต้",
            ["AutoBuyFruitsDesc"] = "ซื้ออาหารออโต้เมื่ออาหารมาขาย",
            -- Auto Feed --
            ["AutoEquipFruit"] = "สวมใส่อาหารออโต้",
            ["SelectFruit"] = "เลือกอาหาร",
            ["AutoEquip"] = "สวมใส่อาหารออโต้",
            ["AutoFeedTab"] = "ให้อาหารออโต้",
            ["SettingsFeedTab"] = "ตั้งค่าไม่ให้อาหาร",
            ["SelectPet"] = "เลือกสัตว์ใหญ่",
            ["AutoFeed"] = "ให้อาหารสัตว์ใหญ่ออโต้",
            ["AutoFeedDesc"] = "ให้อาหารสัตว์ใหญ่ของคุณออโต้",
            -- Quest --
            ["QuestTab"] = "รับเควส ฮาโลวีน",
            ["AutoSnowTask"] = "รับเควสฮาโลวีนออโต้",
            ["AutoClaim"] = "รับไข่ออโต้ (ออนไลน์ 30 นาที)",
            -- Fish --
            ["FishTab"] = "ตกปลาออโต้",
            ["SelectBaitNormal"] = "เลือกเหยื่อ",
            ["AutoFish"] = "ตกปลาออโต้",
            -- Gift --
            ["Infomation"] = "ข้อมูล",
            ["InfomationDesc"] = "โปรดเลือก ไอเท็ม...",
            ["PetName"] = "ชื่อสัตว์",
            ["Mutation"] = "กลายพันธุ์",
            ["PetHave"] = "จำนวนสัตว์ที่มี",
            ["Nofound"] = "ไม่พบ Item ที่ตรงกับ HoldUID",
            ["TabsGift"] = "กิ๊ฟ",
            ["SelectedPlayer"] = "เลือกผู้เล่น",
            ["Amout"] = "จำนวน",
            ["SendGift"] = "ส่งของ",
            -- Webhook --
            ["TabsWebhook"] = "ตั้งค่า เว็บฮุก",
            ["WebhookUrl"] = "ลิ้ง",
            ["WebhookPing"] = "แท็ก | @everyone",
            ["TestWebhook"] = "ทดสอบ เว็บฮุก",
            ["EggTabsWebhook"] = "ไข่",
            ["CheckAllEgg"] = "เช็คไข่ในกระเป๋า",
            ["AutoBuyEggNotify"] = "ซื้อไขออโต้ (แจ้งเตือน)",
            ["AutoBuyFoodNotify"] = "ซื้ออาหารออโต้ (แจ้งเตือน)",
            -- Misc --
            ["MiscTabs"] = "อื่นๆ",
            ["DisableAnimation"] = "ปิดใช้งานอนิเมชั่น (สัตว์)",
            ["DisableMoney"] = "ปิดใช้งานเอฟเฟค เก็บเงิน",
            ["LikeTabs"] = "กดไลค์ออโต้ (อีเว้น)",
            ["AutolikeServerHop"] = "กดไลค์ออโต้ (ย้ายเซิฟ)",
            ["DelayAutoLike"] = "ล่าช้า",
            ["AutoLikeTabs1"] = "กดไลค์ออโต้ (AFK)",
            ["SelectPlayers_AutoLike"] = "เลือกผู้เล่น",
            ["AutolikeAFK"] = "กดไลค์ออโต้ (AFK)",
            ["AutolikeDelay"] = "ล่าช้า",
            ["RedeemAllCodes"] = "ใส่โค้ดทั้งหมดในเกม",
            ["UnlockBigPet2"] = "ปลดล็อคสัตว์ใหญ่ตัวที่ 2 (เสี่ยง)",
            -- Premium --
            ["FishPosition"] = "ตำแหน่งตกปลา",
            ["PositionFish"] = "ตำแหน่ง",
            ["SavePosition"] = "เซฟ ตำแหน่ง",
            ["SelectBait"] = "เลือกเหยื่อ",
            ["AutoFishPremiumTabs"] = "ตกปลา",
            ["AutoFishPremium"] = "ตกปลาออโต้ (เฉพาะตอนอีเว้นมา)",
            ["ServerHopFindEvent"] = "ย้านเซิฟหาอีเว้น",
            ["Weather"] = "สภาพอากาศ",
            ["InfoWeather"] = "ข้อมูล",
            ["InfoWeatherDesc"] = "ไม่มี ข้อมูล",
            ["ServerHopFindEventSnow"] = "เลือก อีเว้น",
            ["ServerHopFindEventHalloween"] = "ย้ายหาเซิฟที่มีอีเว้น",
            ["TradeSection"] = "เทรด",
            ["ShowStatus"] = "สถานะ",
            ["ShowStatusDesc"] = "สถานะปัจจุบัน",
            ["Method"] = "วิธีการทำงาน",
            ["AutoTrade"] = "เทรดออโต้",
            ["Earns"] = "ได้รับเงิน/ต่อวินาที",
            ["KitsuneTabs"] = "หาจิ้งจอกออโต้",
            ["AutoClaimKitsune"] = "รับจิ้งจอกออโต้",
            ["PlaceBest"] = "วางสัตว์ที่ดีที่สุด",
            ["AutoPlacePetBest"] = "วางสัตว์ที่ดีที่สุดออโต้",
            ["AutoPlaceOceanBest"] = "วางปลาที่ดีที่สุดออโต้",
            ["AutoEquipTrade"] = "ถือสัตว์ออโต้",
            ["MinValue"] = "เงินต่ำสุด",
            ["MaxValue"] = "เงินเยอะที่สุด",
            ["AutoEquipPet"] = "สวมใส่สัตว์ออโต้",
            -- Settings
            ["Interface"] = "การตั้งค่า",
            ["themeDropdown"] = "เลือก ธีม",
            ["ToggleTransparency"] = "UI โปรพื้นหลังโปร่งใส่",
            ["AntiAFK"] = "ป้องกันหลุดออกจากเกม (Anti-AFK)",
            ["AutoRejoin"] = "เข้าร่วมเกมอัตโนมัติเมื่อหลุด (AutoRejoin)",
            ["AutoExecutor"] = "รันโปรออโต้เมื่อย้ายเซิฟ (AutoExecutor)",
            ["MinimizeBind"] = "ปุ่มที่จะใช้เปิดปิดโปร",
            ["FPSIS"] = "FPS",
            ["FPSVALUE"] = "FPS",
            ["FPSLOCK"] = "ล็อค FPS",
            ["WhiteScreen"] = "จอขาว",
            ["LanguageTab"] = "ภาษา",
            ["Language"] = "เลือกภาษา",
            ["ChangedLanguage"] = "เปลี่ยนภาษา",
        },
        ["English (US)"] = {
            -- Tabs --
            ["Automatic"] = "Auto Collect & Pet",
            ["Eggs"] = "Auto BuyEggs",
            ["Place"] = "Auto Place & Hatch",
            ["Shop"] = "Shop",
            ["Feed"] = "Auto Feed",
            ["Quest"] = "Quest",
            ["Fish"] = "Fish",
            ["Gift"] = "Gift",
            ["Webhook"] = "Webhook",
            ["Misc"] = "Misc",
            ["Premium"] = "Premium",
            ["Configuration"] = "Configuration",
            -- Auto Collect --
            ["AutoCollectTab"] = "Auto Collect Money",
            ["AutoCollect"] = "Auto Collect Money",
            ["AutoCollectDesc"] = "Automatic Collect your pets.",
            ["DelayCollect"] = "Delay",
            ["QuickTab"] = "Quick",
            ["QuickCollect"] = "Quick Collect",
            ["QuickCollectDesc"] = "Collect all at once.",
            ["CollectPet"] = "Auto Collect Pet",
            ["Eard"] = "Earn/s",
            ["CollectAllPetEarn"] = "Collect Pet Earn/s",
            ["CollectAllPet"] = "Collect All Pet",
            -- Auto Buy Eggs --
            ["AutoBuyEggTab"] = "Auto Buy Eggs",
            ["SelectEggs"] = "Select Eggs",
            ["AutoBuyEgg"] = "Auto Buy Eggs",
            ["AutoBuyEggDesc"] = "Automatic BuyEggs your on conveyor.",
            ["AutoBuyEggwithmutationTab"] = "Auto Buy Eggs With Mutation",
            ["SelectEggsWith"] = "Select Eggs",
            ["SelectMutation"] = "Select Mutatation",
            ["AutoBuyEggwithmutation"] = "Auto Buy Eggs With Mutation",
            ["AutoBuyEggwithmutationDesc"] = "Automatic buyegg with mutation your on conveyor.",
            ["AutoBuyEggwithEventSnowTab"] = "Auto Buy Eggs Event",
            ["SelectEggevent"] = "Select Eggs",
            ["SnowMutatuion"] = "Mutation Snow Only",
            ["AutoBuyEggwithEventSnow"] = "Auto Buy Egg Event Snow",
            ["AutoBuyEggwithEventSnowDesc"] = "Automatic BuyEgg with Event Snow your conveyor.",
            -- Auto Place & Hatch --
            ["AutoEquipEggTabs"] = "Auto Equip Egg",
            ["SelectEggPlace"] = "Select Egg or Pet",
            ["Refresh"] = "Refresh",
            ["AutoEquipEgg"] = "Auto Equip Egg",
            ["AutoEquipEggDesc"] = "Automatic Equip your egg.",
            ["AutoPlaceTab"] = "Auto Place",
            ["AutoPlacePet"] = "Auto Place Egg & Pet",
            ["AutoPlaceOcean"] = "Auto Place Egg & Fish",
            ["AutoHatchTab"] = "Auto Hatch",
            ["AutoHatch"] = "Auto Hatch",
            -- Shop --
            ["FruitTab"] = "Foods Stock",
            ["SelectFruitShop"] = "Select Foods",
            ["AutoBuyFruits"] = "Auto Buy Foods",
            ["AutoBuyFruitsDesc"] = "Automatic Buy Foods when Food is come",
            -- Auto Feed --
            ["AutoEquipFruit"] = "Auto Equip Food",
            ["SelectFruit"] = "Select Food",
            ["AutoEquip"] = "Auto Equip",
            ["AutoFeedTab"] = "Auto Feed",
            ["SettingsFeedTab"] = "Do Not Feed",
            ["SelectPet"] = "Select Big Pet",
            ["AutoFeed"] = "Auto Feed",
            ["AutoFeedDesc"] = "Automatic Feed your big pets.",
            -- Quest --
            ["QuestTab"] = "Halloween Tasks",
            ["AutoSnowTask"] = "Auto Claim Reward",
            ["AutoClaim"] = "Auto ClaimEgg (Online 30 minutes)",
            -- Fish --
            ["FishTab"] = "Auto Fish",
            ["SelectBaitNormal"] = "Select Bait",
            ["AutoFish"] = "Auto Fish",
            -- Gift --
            ["Infomation"] = "Infomation",
            ["InfomationDesc"] = "select item...",
            ["PetName"] = "PetName",
            ["Mutation"] = "Mutation",
            ["PetHave"] = "PetHave",
            ["Nofound"] = "Not found item matching HoldUID",
            ["TabsGift"] = "Gift",
            ["SelectedPlayer"] = "Select Player",
            ["Amout"] = "Amount",
            ["SendGift"] = "Send Gift",
            -- Webhook --
            ["TabsWebhook"] = "Setup Webhook",
            ["WebhookUrl"] = "Url",
            ["WebhookPing"] = "Ping | @everyone",
            ["TestWebhook"] = "Test Webhook",
            ["EggTabsWebhook"] = "Eggs",
            ["CheckAllEgg"] = "Check All Egg",
            ["AutoBuyEggNotify"] = "Auto Buy Egg (Notification)",
            ["AutoBuyFoodNotify"] = "Auto Buy Food (Notification)",
            -- Misc --
            ["MiscTabs"] = "Misc",
            ["DisableAnimation"] = "Disable Animation (Pet)",
            ["DisableMoney"] = "Disable Effect (Get Money)",
            ["LikeTabs"] = "Auto Like (Event)",
            ["AutolikeServerHop"] = "Auto Like (HopServer)",
            ["DelayAutoLike"] = "Delay",
            ["AutoLikeTabs1"] = "Auto Like (AFK)",
            ["SelectPlayers_AutoLike"] = "Select Players",
            ["AutolikeAFK"] = "Auto Like (AFK)",
            ["AutolikeDelay"] = "Delay",
            ["UnlockBigPet2"] = "Unlock Big Pet 2 (risky)",
            -- Premium --
            ["FishPosition"] = "Fish Position",
            ["PositionFish"] = "Position",
            ["SavePosition"] = "Save Position",
            ["SelectBait"] = "Select Bait",
            ["AutoFishPremiumTabs"] = "Auto Fish",
            ["AutoFishPremium"] = "Auto Fish (Event Only)",
            ["ServerHopFindEvent"] = "Server Hop Find Event",
            ["Weather"] = "Weather",
            ["InfoWeather"] = "Info",
            ["InfoWeatherDesc"] = "No Information",
            ["ServerHopFindEventSnow"] = "Select Event",
            ["ServerHopFindEventHalloween"] = "Server Hop Find Event",
            ["TradeSection"] = "Trade",
            ["ShowStatus"] = "Status",
            ["ShowStatusDesc"] = "Current Status",
            ["Method"] = "Method",
            ["AutoTrade"] = "Auto Trade",
            ["Earns"] = "Earn/s",
            ["KitsuneTabs"] = "Auto Find Kitsune",
            ["AutoClaimKitsune"] = "Auto Claim Kitsune",
            ["PlaceBest"] = "Auto Place Best Pet",
            ["AutoPlacePetBest"] = "Auto Place Best Pet",
            ["AutoPlaceOceanBest"] = "Auto Place Best Fish",
            ["RedeemAllCodes"] = "Redeem All Codes",
            ["AutoEquipTrade"] = "Auto Equip Trade Pet",
            ["MinValue"] = "Earn/s Min",
            ["MaxValue"] = "Earn/s Max",
            ["AutoEquipPet"] = "Auto Equip Pet",
            -- Settings
            ["Interface"] = "Interface Settings",
            ["themeDropdown"] = "Select Theme",
            ["ToggleTransparency"] = "Toggle Window Transparency",
            ["AntiAFK"] = "Anti-AFK",
            ["AutoRejoin"] = "AutoRejoin",
            ["AutoExecutor"] = "AutoExecutor",
            ["MinimizeBind"] = "Minimize Bind",
            ["FPSIS"] = "FPS",
            ["FPSVALUE"] = "FPS",
            ["FPSLOCK"] = "FPS Lock",
            ["WhiteScreen"] = "White Screen",
            ["LanguageTab"] = "LanguageTab",
            ["Language"] = "Select Language",
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
    Title = "Update Latest 11/13/2025",
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
    Automatic = Window:Tab({ Title = "tr:Automatic", Icon = "code-xml", ShowTabTitle = true }),
    Eggs = Window:Tab({ Title = "tr:Eggs", Icon = "egg", ShowTabTitle = true }),
    Place = Window:Tab({ Title = "tr:Place", Icon = "hammer", ShowTabTitle = true }),
    Shop = Window:Tab({ Title = "tr:Shop", Icon = "shopping-basket", ShowTabTitle = true }),
    Feed = Window:Tab({ Title = "tr:Feed", Icon = "signpost-big", ShowTabTitle = true }),
    Quest = Window:Tab({ Title = "tr:Quest", Icon = "newspaper", ShowTabTitle = true }),
    Fish = Window:Tab({ Title = "tr:Fish", Icon = "fish", ShowTabTitle = true }),
    Gift = Window:Tab({ Title = "tr:Gift", Icon = "gift", ShowTabTitle = true}),
    Webhook = Window:Tab({ Title = "tr:Webhook", Icon = "send", ShowTabTitle = true}),
    Misc = Window:Tab({ Title = "tr:Misc", Icon = "menu", ShowTabTitle = true}),
    Premium = Window:Tab({ Title = "tr:Premium", Icon = "diamond-plus", ShowTabTitle = true, Locked = getgenv().Premium}),
    divider1 = Window:Divider(),
    Configuration = Window:Tab({ Title = "tr:Configuration", Icon = "settings", Desc = "Manage window settings and themes.", ShowTabTitle = true}),
}

-------------------------------- Function --------------------------------
local function SendDiscordEmbed(url, embed)
    local http = game:GetService("HttpService")
    local headers = {
        ["Content-Type"] = "application/json"
    }
    local data = {
        ["content"] = embed.content,
        ["embeds"] = {
            {
                ["title"] = embed.title,
                ["description"] = embed.description,
                ["color"] = embed.color,
                ["fields"] = embed.fields,
                ["image"] = embed.image,
            }
        }
    }
    local body = http:JSONEncode(data)
    local response = request({
        Url = url,
        Method = "POST",
        Headers = headers,
        Body = body
    })
end

-------------------------------- Auto Collect --------------------------------

local AutoCollectTab = Tabs.Automatic:Section({ Title = "tr:AutoCollectTab", Icon = "hand-grab"})

local AutoCollect = Tabs.Automatic:Toggle({
    Title = "tr:AutoCollect",
    Desc = "tr:AutoCollectDesc",
    Value = getgenv().Settings.AutoCollect.AutoCollect,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.AutoCollect.AutoCollect = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.AutoCollect.AutoCollect do
                        for i,v in pairs(workspace.Pets:GetChildren()) do
                            if v:GetAttribute("UserId") == game.Players.LocalPlayer.UserId then
                                local args = {
                                    "Claim",
                                    bit32.bxor(game.Players.LocalPlayer.UserId, game:GetService("ReplicatedStorage").Time:GetAttribute("s"), game:GetService("ReplicatedStorage").Time.Value)
                                }
                                workspace:WaitForChild("Pets"):WaitForChild(v.Name):WaitForChild("RE"):FireServer(unpack(args))
                            end
                        end
                        task.wait(getgenv().Settings.AutoCollect.Delay)
                    end
                end)
            end)
        end
    end
})

local DelayCollect = Tabs.Automatic:Slider({
    Title = "tr:DelayCollect",
    Value = {
        Min = 20,
        Max = 120,
        Default = getgenv().Settings.AutoCollect.Delay,
    },
    Callback = function(Value)
        getgenv().Settings.AutoCollect.Delay = Value
        SaveSetting()
    end
})

local QuickTab = Tabs.Automatic:Section({ Title = "tr:QuickTab", Icon = "fast-forward"})

local QuickCollect = Tabs.Automatic:Button({
    Title = "tr:QuickCollect",
    Desc = "tr:QuickCollectDesc",
    Callback = function()
        for i,v in pairs(workspace.Pets:GetChildren()) do
            if v:GetAttribute("UserId") == game.Players.LocalPlayer.UserId then
                local args = {
                    "Claim",
                    bit32.bxor(game.Players.LocalPlayer.UserId, game:GetService("ReplicatedStorage").Time:GetAttribute("s"), game:GetService("ReplicatedStorage").Time.Value)
                }
                workspace:WaitForChild("Pets"):WaitForChild(v.Name):WaitForChild("RE"):FireServer(unpack(args))
            end
        end
    end
})

local CollectPet = Tabs.Automatic:Section({ Title = "tr:CollectPet", Icon = "cat"})

local Eard = Tabs.Automatic:Input({
    Title = "tr:Eard",
    Value = getgenv().Settings.AutoCollect.Value,
    Callback = function(Value)
        getgenv().Settings.AutoCollect.Value = tonumber(Value)
        SaveSetting()
    end
})

local CollectAllPetEarn = Tabs.Automatic:Button({
    Title = "tr:CollectAllPetEarn",
    Callback = function()
        for i,v in pairs(workspace.Pets:GetChildren()) do
            if v:GetAttribute("UserId") == UserId then
                if not v:GetAttribute("BigPetType") then 
                    if v:GetAttribute("ProduceSpeed") < getgenv().Settings.AutoCollect.Value then
                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack({"Del",v.Parent.Name,bit32.bxor(game.Players.LocalPlayer.UserId, game:GetService("ReplicatedStorage").Time:GetAttribute("s"), game:GetService("ReplicatedStorage").Time.Value)}))
                    end
                end
            end
        end
    end
})

local CollectAllPet = Tabs.Automatic:Button({
    Title = "tr:CollectAllPet",
    Callback = function()
        for i,v in pairs(workspace.Pets:GetChildren()) do
            if not v:GetAttribute("BigPetType") then
                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack({"Del",v.Name,bit32.bxor(game.Players.LocalPlayer.UserId, game:GetService("ReplicatedStorage").Time:GetAttribute("s"), game:GetService("ReplicatedStorage").Time.Value)}))
            end
        end
    end
})

-------------------------------- Auto BuyEgg --------------------------------

local myIsland

function TeleportToWaypoint(Position)
    hrp.CFrame = Position
end

repeat task.wait(.1) for i,v in pairs(workspace.Art:GetChildren()) do
    if v:GetAttribute("OccupyingPlayerId") == UserId then
        myIsland = v
        getgenv().MyIsland = v.Name
        break
    end
end
until myIsland

local conveyorFolder
repeat
    task.wait(0.1)
    if myIsland:FindFirstChild("ENV") and myIsland.ENV:FindFirstChild("Conveyor") then
        conveyorFolder = myIsland.ENV.Conveyor
    end
until conveyorFolder

for i,v in pairs(workspace.Art[getgenv().MyIsland].ENV.Conveyor:GetChildren()) do
    if v:IsA("Model") then
        getgenv().Conveyor = v.Name
    end
end

workspace.Art[getgenv().MyIsland].ENV.Conveyor.ChildRemoved:Connect(function(child)
	getgenv().Conveyor = child.Name
end)

repeat task.wait(1) until LocalPlayer:FindFirstChild("PlayerGui") and LocalPlayer.PlayerGui:FindFirstChild("Data")

local EggsTable = {}
local EggsValueMap = {}
local RealNameMap = {}
local NameMap = {
    ["BiteForceSharkEgg"] = "Axe Shark Egg",
    ["MetroGiraffeEgg"] = "Sly Fox Egg"
}

local ConveyorPool = game:GetService("ReplicatedStorage").ConveyorPool
local ConveyorFolder = workspace.Art[getgenv().MyIsland].ENV.Conveyor

local AutoBuyEggTab = Tabs.Eggs:Section({ Title = "tr:AutoBuyEggTab", Icon = "egg" })

repeat task.wait() until getgenv().Conveyor ~= nil

function Updated()
    EggsTable = {}
    EggsValueMap = {}
    RealNameMap = {}
    
    for _, v in pairs(game:GetService("ReplicatedStorage").ConveyorPool:GetChildren()) do
        if v.Name == getgenv().Conveyor then
            for attrName, _ in pairs(v:GetAttributes()) do
                local displayName = NameMap[attrName] or attrName
                
                if not table.find(EggsTable, displayName) then
                    table.insert(EggsTable, displayName)
                    EggsValueMap[displayName] = attrName
                    RealNameMap[attrName] = displayName
                end
            end
            
            for i = #EggsTable, 1, -1 do
                local realName = EggsValueMap[EggsTable[i]]
                if v:GetAttribute(realName) == nil then
                    local displayName = EggsTable[i]
                    EggsValueMap[displayName] = nil
                    RealNameMap[realName] = nil
                    table.remove(EggsTable, i)
                end
            end
        end
    end
end

Updated()

function GetDisplayNamesFromSettings()
    local savedRealNames = getgenv().Settings.AutoBuyEgg.SelectEgg or {}
    local displayNames = {}
    
    for _, realName in pairs(savedRealNames) do
        local displayName = RealNameMap[realName] or realName
        table.insert(displayNames, displayName)
    end
    
    return displayNames
end

function GetDisplayNamesFromSettings1()
    local savedRealNames = getgenv().Settings.AutoBuyEgg.SelectEggsWithMutation or {}
    local displayNames = {}
    
    for _, realName in pairs(savedRealNames) do
        local displayName = RealNameMap[realName] or realName
        table.insert(displayNames, displayName)
    end
    
    return displayNames
end

local initialDisplayNames = GetDisplayNamesFromSettings()
local initialDisplayNames1 = GetDisplayNamesFromSettings1()

local SelectEggs = Tabs.Eggs:Dropdown({
    Title = "tr:SelectEggs",
    Multi = true,
    AllowNone = false,
    Value = initialDisplayNames,
    Values = EggsTable,
    Callback = function(Value)
        local realNames = {}
        for _, displayName in pairs(Value) do
            local realName = EggsValueMap[displayName]
            if realName then
                table.insert(realNames, realName)
            end
        end
        
        getgenv().Settings.AutoBuyEgg.SelectEgg = realNames
        SaveSetting()
    end
})

local AutoBuyEgg = Tabs.Eggs:Toggle({
    Title = "tr:AutoBuyEgg",
    Desc = "tr:AutoBuyEggDesc",
    Value = getgenv().Settings.AutoBuyEgg.AutoBuyEgg,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.AutoBuyEgg.AutoBuyEgg = Value
        SaveSetting()
        task.spawn(function()
            pcall(function()
                while getgenv().Settings.AutoBuyEgg.AutoBuyEgg do task.wait(1)
                    for i,v in pairs(game:GetService("ReplicatedStorage").Eggs[getgenv().MyIsland]:GetChildren()) do
                        if table.find(getgenv().Settings.AutoBuyEgg.SelectEgg, v:GetAttribute("T")) then
                            game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("BuyEgg", v.Name)
                        end
                    end
                end
            end)
        end)
    end
})

local AutoBuyEggwithmutationTab = Tabs.Eggs:Section({ Title = "tr:AutoBuyEggwithmutationTab", Icon = "radiation"})

local SelectEggsWith = Tabs.Eggs:Dropdown({
    Title = "tr:SelectEggsWith",
    Values = EggsTable,
    Value = initialDisplayNames1,
    Multi = true,
    AllowNone = false,
    Callback = function(Value)
        local realNames = {}
        for _, displayName in pairs(Value) do
            local realName = EggsValueMap[displayName]
            if realName then
                table.insert(realNames, realName)
            end
        end
        
        getgenv().Settings.AutoBuyEgg.SelectEggsWithMutation = realNames
        SaveSetting()
    end
})

local SelectMutation = Tabs.Eggs:Dropdown({
    Title = "tr:SelectMutation",
    Values = {"Golden", "Diamond", "Electirc", "Fire", "Dino", "Snow", "Halloween", "Sand", "Aurora", "Thanksgiving"},
    Value = getgenv().Settings.AutoBuyEgg.SelectMutation,
    Multi = true,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.AutoBuyEgg.SelectMutation = Value
        SaveSetting()
    end
})

local AutoBuyEggwithmutation = Tabs.Eggs:Toggle({
    Title = "tr:AutoBuyEggwithmutation",
    Desc = "tr:AutoBuyEggwithmutationDesc",
    Value = getgenv().Settings.AutoBuyEgg.AutoBuyEggwithmutation,
    Icon = "check",
    Callback = function(Callback)
        getgenv().Settings.AutoBuyEgg.AutoBuyEggwithmutation = Callback
        SaveSetting()

        if Callback then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.AutoBuyEgg.AutoBuyEggwithmutation do task.wait(1)
                        for i, v in pairs(game:GetService("ReplicatedStorage").Eggs[getgenv().MyIsland]:GetChildren()) do
                            if table.find(getgenv().Settings.AutoBuyEgg.SelectEggsWithMutation, v:GetAttribute("T")) then
                                if table.find(getgenv().Settings.AutoBuyEgg.SelectMutation, v:GetAttribute("M")) then
                                    game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("BuyEgg", v.Name)
                                        break
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local AutoBuyEggwithEventSnowTab = Tabs.Eggs:Section({ Title = "tr:AutoBuyEggwithEventSnowTab", Icon = "snowflake"})

local SelectEggevent = Tabs.Eggs:Dropdown({
    Title = "tr:SelectEggevent",
    Values = {"RhinoRockEgg", "DarkGoatyEgg", "SaberCubEgg", "GeneralKongEgg"},
    Value = getgenv().Settings.AutoBuyEgg.SelectEventSnow,
    Multi = true,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.AutoBuyEgg.SelectEventSnow = Value
        SaveSetting()
    end
})

local SnowMutatuion = Tabs.Eggs:Toggle({
    Title = "tr:SnowMutatuion",
    Value = getgenv().Settings.AutoBuyEgg.infactionSnow,
    Icon = "check",
    Callback = function(Snow)
        getgenv().Settings.AutoBuyEgg.infactionSnow = Snow
        SaveSetting()
    end
})

local AutoBuyEggwithEventSnow = Tabs.Eggs:Toggle({
    Title = "tr:AutoBuyEggwithEventSnow",
    Desc = "tr:AutoBuyEggwithEventSnowDesc",
    Value = getgenv().Settings.AutoBuyEgg.AutoBuyEggwithEventSnow,
    Icon = "check",
    Callback = function(Snow)
        getgenv().Settings.AutoBuyEgg.AutoBuyEggwithEventSnow = Snow
        SaveSetting()

        if Snow then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.AutoBuyEgg.AutoBuyEggwithEventSnow do task.wait(3)
                        for i,v in pairs(game:GetService("ReplicatedStorage").Eggs[getgenv().MyIsland]:GetChildren()) do
                            if table.find(getgenv().Settings.AutoBuyEgg.SelectEventSnow, v:GetAttribute("T")) then
                                if getgenv().Settings.AutoBuyEgg.infactionSnow then
                                    if v:GetAttribute("M") == "Snow" then
                                        game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("BuyEgg", v.Name)
                                    end
                                else
                                    game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("BuyEgg", v.Name)
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

ConveyorFolder.ChildRemoved:Connect(function(child)
    if child.Name == getgenv().Conveyor then
        getgenv().Conveyor = nil
    end
    Updated()
    
    SelectEggs:Refresh(EggsTable, true, displayValues)
    SelectEggsWith:Refresh(EggsTable, true, displayValues)
end)

ConveyorFolder.ChildAdded:Connect(function(child)
    if child:IsA("Model") then
        getgenv().Conveyor = child.Name
    end
    Updated()
    
    SelectEggs:Refresh(EggsTable, true, displayValues)
    SelectEggsWith:Refresh(EggsTable, true, displayValues)
end)
-------------------------------- Auto Place & Hatch --------------------------------

local AutoEquipEgg = Tabs.Place:Section({ Title = "tr:AutoEquipEggTabs", Icon = "egg"})

local Items = {}
local SelectEggPlace

function UpdateEgg()
    local EggFolder = game.Players.LocalPlayer.PlayerGui.Data.Egg

    for _, v in pairs(EggFolder:GetChildren()) do
        local T = v:GetAttribute("T")
        if T and not v:FindFirstChild("DI") and not table.find(Items, T) then
            table.insert(Items, T)
        end
    end

    for i = #Items, 1, -1 do
        local found = false
        for _, v in pairs(EggFolder:GetChildren()) do
            if v:GetAttribute("T") == Items[i] and not v:FindFirstChild("DI") then
                found = true
                break
            end
        end
        if not found then
            table.remove(Items, i)
        end
    end
end

UpdateEgg()

SelectEggPlace = Tabs.Place:Dropdown({
    Title = "tr:SelectEggPlace",
    Multi = true,
    AllowNone = false,
    Value = getgenv().Settings.AutoPlace.SelectEgg,
    Values = Items,
    Callback = function(Value)
        getgenv().Settings.AutoPlace.SelectEgg = Value
        SaveSetting()
    end
})

local Refresh = Tabs.Place:Button({
    Title = "tr:Refresh",
    Callback = function()
        UpdateEgg()
        if SelectEggPlace then
            SelectEggPlace:Refresh(Items)
        end
    end
})

local AutoEquipEgg = Tabs.Place:Toggle({
    Title = "tr:AutoEquipEgg",
    Desc = "tr:AutoEquipEggDesc",
    Value = getgenv().Settings.AutoPlace.AutoEquipEgg,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.AutoPlace.AutoEquipEgg = Value
        SaveSetting()
        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.AutoPlace.AutoEquipEgg do task.wait(0.5)
                        if getgenv().Settings.AutoPlace.AutoPlacePet or getgenv().Settings.AutoPlace.AutoPlaceOcean then
                            local equipped = false
                            -- วนเช็คไข่ที่เลือกทีละตัว
                            for _, eggName in ipairs(getgenv().Settings.AutoPlace.SelectEgg) do
                                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Data.Egg:GetChildren()) do
                                    if v:GetAttribute("T") == eggName and not v:FindFirstChild("DI") then
                                        local holdUID = game.Players.LocalPlayer:GetAttribute("HoldUID")
                                        if not chr:FindFirstChild("HandObj") or holdUID ~= v.Name then
                                            game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("Focus", v.Name)
                                            equipped = true
                                            break
                                        end
                                    end
                                end
                                if equipped then break end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local AutoPlaceTab = Tabs.Place:Section({ Title = "tr:AutoPlaceTab", Icon = "layout-template"})

local FarmPet = {}
local WaterPet = {}

function parseFarmName(name)
    local x, y, z = name:match("Farm_split_(%d+)_(%d+)_(%d+)")
    return tonumber(x), tonumber(y), tonumber(z)
end

function parseWaterName(name)
    local x, y, z = name:match("WaterFarm_split_?_(%d+)_(%d+)_(%d+)")
    return tonumber(x), tonumber(y), tonumber(z)
end

function compareFarm(a, b)
    local ax, ay, az = parseFarmName(a.Name)
    local bx, by, bz = parseFarmName(b.Name)

    if ax ~= bx then
        return ax < bx
    elseif ay ~= by then
        return ay < by
    else
        return az < bz
    end
end

function compareWater(a, b)
    local ax, ay, az = parseWaterName(a.Name)
    local bx, by, bz = parseWaterName(b.Name)

    if ax ~= bx then
        return ax < bx
    elseif ay ~= by then
        return ay < by
    else
        return az < bz
    end
end

for _, v in ipairs(workspace.Art[getgenv().MyIsland]:GetChildren()) do
    if v.Name:match("^Farm_split") then
        local inserted = false
        for i = 1, #FarmPet do
            if compareFarm(v, FarmPet[i]) then
                table.insert(FarmPet, i, v)
                inserted = true
                break
            end
        end
        if not inserted then
            table.insert(FarmPet, v)
        end
    end
end

for _, v in ipairs(workspace.Art[getgenv().MyIsland]:GetChildren()) do
    if v.Name:lower():find("^water") then
        local inserted = false
        for i = 1, #WaterPet do
            if compareWater(v, WaterPet[i]) then
                table.insert(WaterPet, i, v)
                inserted = true
                break
            end
        end
        if not inserted then
            table.insert(WaterPet, v)
        end
    end
end

local AutoPlacePet = Tabs.Place:Toggle({
    Title = "tr:AutoPlacePet",
    Value = getgenv().Settings.AutoPlace.AutoPlacePet,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.AutoPlace.AutoPlacePet = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    local index = 1
                    while getgenv().Settings.AutoPlace.AutoPlacePet do task.wait(.1)
                        if #FarmPet > 0 then
                            local pos = FarmPet[index].Position
                            local ohTable2 = {
                                ["DST"] = pos + Vector3.new(0, 10, 0),
                                ["ID"] = game.Players.LocalPlayer:GetAttribute("HoldUID")
                            }

                            game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("Place", ohTable2)

                            index = index + 1
                            if index > #FarmPet then
                                index = 1
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local AutoPlaceOcean = Tabs.Place:Toggle({
    Title = "tr:AutoPlaceOcean",
    Value = getgenv().Settings.AutoPlace.AutoPlaceOcean,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.AutoPlace.AutoPlaceOcean = Value
        SaveSetting()
        if Value then
            task.spawn(function()
                pcall(function()
                    local index = 1
                    while getgenv().Settings.AutoPlace.AutoPlaceOcean do task.wait(.1)
                        if #WaterPet > 0 then
                            local pos = WaterPet[index].Position
                            local ohTable2 = {
                                ["DST"] = pos + Vector3.new(0, 10, 0),
                                ["ID"] = game.Players.LocalPlayer:GetAttribute("HoldUID")
                            }

                            game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("Place", ohTable2)

                            index = index + 1
                            if index > #WaterPet then
                                index = 1
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local AutoHatchTab = Tabs.Place:Section({ Title = "tr:AutoHatchTab", Icon = "sparkles"})

local AutoHatch = Tabs.Place:Toggle({
    Title = "tr:AutoHatch",
    Value = getgenv().Settings.AutoPlace.AutoHatch,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.AutoPlace.AutoHatch = Value
        SaveSetting()
        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.AutoPlace.AutoHatch do task.wait(1)
                        for i,v in pairs(workspace.PlayerBuiltBlocks:GetChildren()) do
                            if v:GetAttribute("UserId") == UserId then
                                if v:IsA("Model") and v:FindFirstChild("ExclamationMark") then
                                    fireproximityprompt(v.RootPart.ProximityPrompt)
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

-------------------------------- Shop --------------------------------

local FruitTab = Tabs.Shop:Section({ Title = "tr:FruitTab", Icon = "apple"})    

local Fruitss = {}
local Fruits = {}
local Stock = {}

for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Data.FoodStore:GetChildren()) do
    local att = v:GetAttributes()
    for i2,v2 in pairs(att) do
        table.insert(Fruitss, {Name = i2, Stock = v2})
    end
end

for i,v in pairs(Fruitss) do
    Fruits[i] = v.Name
    Stock[v] = v.Stock
end

local SelectFruitShop = Tabs.Shop:Dropdown({
    Title = "tr:SelectFruitShop",
    Values = Fruits,
    Multi = true,
    Value = getgenv().Settings.Shop.Fruits,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.Shop.Fruits = Value
        SaveSetting()
    end
})

local AutoBuyFruits = Tabs.Shop:Toggle({
    Title = "tr:AutoBuyFruits",
    Desc = "tr:AutoBuyFruitsDesc",
    Value = getgenv().Settings.Shop.AutoBuyFruits,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Shop.AutoBuyFruits = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                local CollectedFruits = {}
                local Stock = {}
                local Player = game:GetService("Players").LocalPlayer
                local AssetsGui = Player:WaitForChild("PlayerGui"):WaitForChild("Data"):WaitForChild("Asset")
                local lastWebhookTime = tick()

                while getgenv().Settings.Shop.AutoBuyFruits do
                    -- อัปเดต Stock
                    for _, v2 in pairs(Player.PlayerGui.Data.FoodStore:GetChildren()) do
                        local att = v2:GetAttributes()
                        for fruitName, stockAmount in pairs(att) do
                            Stock[fruitName] = stockAmount
                        end
                    end

                    -- ซื้อผลไม้ทุก 0.5 วินาที
                    for _, fruitName in ipairs(getgenv().Settings.Shop.Fruits) do
                        local currentStock = Stock[fruitName] or 0
                        if currentStock > 0 then
                            local beforeAmount = AssetsGui:GetAttribute(fruitName) or 0
                            game:GetService("ReplicatedStorage").Remote.FoodStoreRE:FireServer(fruitName)
                            task.wait(0.5)
                            local afterAmount = AssetsGui:GetAttribute(fruitName) or 0
                            local gained = afterAmount - beforeAmount
                            if gained > 0 then
                                CollectedFruits[fruitName] = (CollectedFruits[fruitName] or 0) + gained
                            end
                        end
                    end

                    if tick() - lastWebhookTime >= 5 and getgenv().Settings.Webhook.AutoBuyFood and next(CollectedFruits) then
                        local eggText = ""
                        for fruit, amount in pairs(CollectedFruits) do
                            eggText = eggText .. fruit .. " x" .. amount .. "\n"
                        end

                        local infoName = (getgenv().ConfigurationTable.Language == "Thai") and "ข้อมูล" or "Info"
                        local resultName = (getgenv().ConfigurationTable.Language == "Thai") and "ผลการซื้อผลไม้" or "Fruits Bought"

                        local embed = {
                            ["title"] = "🍉 Auto Buy Fruits Result",
                            ["color"] = 16777215,
                            ["fields"] = {
                                {
                                    ["name"] = infoName,
                                    ["value"] = "`` 👤 `` : **".. Player.Name .."**\n`` 💻 `` : **"..identifyexecutor().."**\n`` 🕓 `` : **".. os.date("%H:%M:%S") .."**\n`` 🎮 `` : **Game Build A Zoo**",
                                    ["inline"] = false
                                },
                                {
                                    ["name"] = resultName,
                                    ["value"] = "```"..eggText.."```",
                                    ["inline"] = false
                                }
                            },
                            ["image"] = {
                                ["url"] = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
                            }
                        }

                        if getgenv().Settings.Webhook.Ping then
                            embed["content"] = "@everyone"
                        end

                        SendDiscordEmbed(getgenv().Settings.Webhook.WebhookUrl, embed)

                        CollectedFruits = {}
                        lastWebhookTime = tick()
                    end

                    task.wait(0.1)
                end
            end)
        end
    end
})

-------------------------------- Auto Feed --------------------------------

local AutoFeed

local AutoEquipFruit = Tabs.Feed:Section({ Title = "tr:AutoEquipFruit", Icon = "apple"})

local SelectFruit = Tabs.Feed:Dropdown({
    Title = "tr:SelectFruit",
    Values = Fruits,
    Multi = false,
    Value = getgenv().Settings.Feed.SelectFruit,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.Feed.SelectFruit = Value
        SaveSetting()
    end
})

local AutoEquip = Tabs.Feed:Toggle({
    Title = "tr:AutoEquip",
    Value = getgenv().Settings.Feed.AutoEquip,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Feed.AutoEquip = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Feed.AutoEquip do task.wait(0.5)
                        if getgenv().Settings.Feed.AutoFeed then
                            game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer(unpack({[1] = "Focus",[2] = getgenv().Settings.Feed.SelectFruit}))
                        end
                    end
                end)
            end)
        end
    end
})

local SettingsFeedTab = Tabs.Feed:Section({ Title = "tr:SettingsFeedTab", Icon = "cog"})

local SelectMutationBigPet = Tabs.Feed:Dropdown({
    Title = "Select Mutation",
    Value = getgenv().Settings.Feed.Mutation,
    Values = {"Golden", "Diamond", "Electirc", "Fire", "Dino", "Snow", "Halloween", "Sand", "Aurora", "Thanksgiving"},
    Multi = true,
    AllowNone = true,
    Callback = function(Value)
        getgenv().Settings.Feed.Mutation = Value
        SaveSetting()
    end
})

local AutoFeedTab = Tabs.Feed:Section({ Title = "tr:AutoFeedTab", Icon = "utensils-crossed"})

local SelectPet = Tabs.Feed:Dropdown({
    Title = "tr:SelectPet",
    Values = {"Big Pet1","Big Pet2", "Big Fish"},
    Multi = true,
    Value = getgenv().Settings.Feed.SelectPet,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.Feed.SelectPet = Value
        SaveSetting()
    end
})

AutoFeed = Tabs.Feed:Toggle({
    Title = "tr:AutoFeed",
    Desc = "tr:AutoFeedDesc",
    Value = getgenv().Settings.Feed.AutoFeed,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Feed.AutoFeed = Value
        SaveSetting()

        if Value then
            if not getgenv().Settings.Feed.SelectPet or #getgenv().Settings.Feed.SelectPet == 0 then
                WindUI:Notify({
                    Title = "Venuz | Notify",
                    Content = "Please Select at least one Pet Mode.",
                    Icon = VenuzIcon,
                    Duration = 5,
                })
                task.wait(.5)
                AutoFeed:Set(false)
                return
            end
            
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Feed.AutoFeed do 
                        task.wait(0.5)
                        
                        local shortestDistance = 30
                        local selectedPets = getgenv().Settings.Feed.SelectPet
                        
                        local petPositions = {}
                        for _, petName in pairs(selectedPets) do
                            if petName == "Big Pet1" then
                                table.insert(petPositions, workspace.Art[getgenv().MyIsland].ENV.BigPet["1"].Position)
                            elseif petName == "Big Pet2" then
                                table.insert(petPositions, workspace.Art[getgenv().MyIsland].ENV.BigPet["2"].Position)
                            elseif petName == "Big Fish" then
                                table.insert(petPositions, workspace.Art[getgenv().MyIsland].ENV.BigPet["3"].Position)
                            end
                        end
                        
                        for i, v in pairs(workspace.Pets:GetChildren()) do
                            if v:IsA("BasePart") then
                                for _, petPos in pairs(petPositions) do
                                    local distance = (petPos - v.Position).Magnitude
                                    
                                    if distance < shortestDistance then
                                        local shouldFeed = true
                                        if #getgenv().Settings.Feed.Mutation > 0 then
                                            if table.find(getgenv().Settings.Feed.Mutation, v:GetAttribute("Mutate")) then
                                                shouldFeed = false
                                            end
                                        end
                                        
                                        if shouldFeed then
                                            game:GetService("ReplicatedStorage").Remote.PetRE:FireServer("Feed", tostring(v.Name))
                                            break
                                        end
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

--------------------------------Event --------------------------------

local QuestTab = Tabs.Quest:Section({ Title = "tr:QuestTab", Icon = "target"})

local AutoSnowTask = Tabs.Quest:Toggle({
    Title = "tr:AutoSnowTask",
    Value = getgenv().Settings.Quest.AutoSnowQuest,
    Icon = "check",
    Callback = function(Quest)
        getgenv().Settings.Quest.AutoSnowQuest = Quest
        SaveSetting()

        task.spawn(function()
            pcall(function()
                if Quest then
                    while getgenv().Settings.Quest.AutoSnowQuest do task.wait(1)
                        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Data.DinoEventTaskData.Tasks:GetChildren()) do
                            game:GetService("ReplicatedStorage").Remote.DinoEventRE:FireServer({["event"] = "claimreward",["id"] = v:GetAttribute("Id")})
                        end
                    end
                end
            end)
        end)
    end
}) 

local AutoClaim = Tabs.Quest:Toggle({
    Title = "tr:AutoClaim",
    Value = getgenv().Settings.Quest.AutoClaimEgg,
    Icon = "check",
    Callback = function(Quest)
        getgenv().Settings.Quest.AutoClaimEgg = Quest
        SaveSetting()

        if Quest then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Quest.AutoClaimEgg do task.wait(1)
                        game:GetService("ReplicatedStorage").Remote.DinoEventRE:FireServer({["event"] = "onlinepack"})
                    end
                end)
            end)
        end
    end
})
-------------------------------- Fish --------------------------------

local BaitsFree = {
    ["Cheese Bait"] = "FishingBait1",
    ["Fly Bait"] = "FishingBait2",
    ["Fish Bait"] = "FishingBait3"
}

local BaitReverse = {}
for name, value in pairs(BaitsFree) do
    BaitReverse[value] = name
end

local FishTab = Tabs.Fish:Section({ Title = "tr:FishTab", Icon = "fish"})

local SelectBaitNormal = Tabs.Fish:Dropdown({
    Title = "tr:SelectBaitNormal",
    Multi = false,
    AllowNone = true,
    Values = {"Cheese Bait", "Fly Bait", "Fish Bait"},
    Value = BaitReverse[getgenv().Settings.Fish.SelectBait],
    Callback = function(Value)
        getgenv().Settings.Fish.SelectBait = BaitsFree[Value]
        SaveSetting()
    end
})

local AutoFish

AutoFish = Tabs.Fish:Toggle({
    Title = "tr:AutoFish",
    Value = getgenv().Settings.Fish.AutoFish,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Fish.AutoFish = Value
        SaveSetting()

        if Value then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)

            if not getgenv().Settings.Fish.SelectBait then
                WindUI:Notify({Title = "Venuz | Notify",Content = "Please Select Bait",Duration = 5})
                task.wait(.5)
                AutoFish:Set(false)
                return
            end

            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Fish.AutoFish do task.wait()
                        
                        if game.Players.LocalPlayer:GetAttribute("HoldUID") ~= "FishRob" then
                            game.Players.LocalPlayer:SetAttribute("HoldUID", "FishRob")
                        end
                        
                        if not hrp.Anchored then hrp.Anchored = true end
                        TeleportToWaypoint(CFrame.new(333, 378, 103))
                        
                        local AnimFish = game.Players.LocalPlayer.Character:GetAttribute("AnimFish")
                        
                        for i,v in pairs(workspace.FishPoints.FishPoint1:GetChildren()) do
                            if v.Name == "FX_Fish_Special" then
                                if v:FindFirstChild("Scope") then
                                    if AnimFish == "Ready" then
                                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("Throw",{Bait = getgenv().Settings.Fish.SelectBait, Pos = v.Scope.Position})
                                    elseif AnimFish == "Pull" then
                                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("POUT",{SUC = 1})
                                    end
                                end
                            else
                                if AnimFish == "Ready" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("Throw",{Bait = getgenv().Settings.Fish.SelectBait, Pos = vector.create(88.4163818359375, 11, -287.8595886230469)})
                                elseif AnimFish == "Pull" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("POUT",{SUC = 1})
                                end
                            end
                        end
                    end
                end)
            end)
        else
            game.Players.LocalPlayer:SetAttribute("HoldUID", nil)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
})

-------------------------------- Gift --------------------------------
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local DataPets = PlayerGui.Data.Pets
local DataEgg = PlayerGui.Data.Egg
local DataAsset = PlayerGui.Data.Asset
local GiftRE = ReplicatedStorage.Remote.GiftRE
local CharacterRE = ReplicatedStorage.Remote.CharacterRE

local SelectedPlr, SelectedTarget, SelectedMutation, SelectedType = nil, nil, nil, nil
local PlayersTable, playersIndex = {}, {}
local num = 0

local Infomation = Tabs.Gift:Paragraph({
    Title = "tr:Infomation",
    Desc = "tr:InfomationDesc"
})

local SelectedPlayer = Tabs.Gift:Dropdown({
    Title = "tr:SelectedPlayer",
    Values = {},
    Multi = false,
    AllowNone = true,
    Callback = function(Value) SelectedPlr = Value end
})

local Amout = Tabs.Gift:Input({
    Title = "tr:Amout",
    Value = 0,
    Placeholder = "1",
    Callback = function(Value) num = tonumber(Value) end
})

local TeleportEnabled = Tabs.Gift:Toggle{
    Title = "Teleport",
    Value = getgenv().Settings.Gift.Teleport,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Gift.Teleport = Value
        SaveSetting()
    end
}

function updateInfomation()
    if not Infomation or type(Infomation.SetDesc) ~= "function" then return end

    local holdUID = LocalPlayer:GetAttribute("HoldUID")
    if not holdUID then
        Infomation:SetDesc("select item...")
        SelectedTarget, SelectedMutation, SelectedType = nil, nil, nil
        return
    end

    local target, mutation, count, foundType = nil, nil, 0, nil

    for _, v in pairs(DataPets:GetChildren()) do
        if not v:GetAttribute("D") and v.Name == holdUID then
            target = v:GetAttribute("T")
            mutation = v:GetAttribute("M") or "No Mutation"
            foundType = "Pet"
            break
        end
    end

    if not foundType then
        for _, v in pairs(DataEgg:GetChildren()) do
            if not v:FindFirstChild("DI") and v.Name == holdUID then
                target = v:GetAttribute("T")
                mutation = v:GetAttribute("M") or "No Mutation"
                foundType = "Egg"
                break
            end
        end
    end

    if not foundType then
        for i, v in pairs(DataAsset:GetAttributes()) do
            if i == holdUID then
                target, mutation, foundType, count = i, "N/A", "Food", v
                break
            end
        end
    end

    if not target or not foundType then
        Infomation:SetDesc("ไม่พบ Item ที่ตรงกับ HoldUID")
        SelectedTarget, SelectedMutation, SelectedType = nil, nil, nil
        return
    end

    SelectedTarget, SelectedMutation, SelectedType = target, mutation, foundType

    if foundType == "Pet" then
        for _, v in pairs(DataPets:GetChildren()) do
            if not v:GetAttribute("D") and v:GetAttribute("T") == target then
                local vMut = v:GetAttribute("M") or "No Mutation"
                if vMut == mutation then count += 1 end
            end
        end
        Infomation:SetDesc(string.format("PetName : %s\nMutation : %s\nPetHave : %d", target, mutation, count))
    elseif foundType == "Egg" then
        for _, v in pairs(DataEgg:GetChildren()) do
            if not v:FindFirstChild("DI") and v:GetAttribute("T") == target then
                local vMut = v:GetAttribute("M") or "No Mutation"
                if vMut == mutation then count += 1 end
            end
        end
        Infomation:SetDesc(string.format("EggName : %s\nMutation : %s\nEggHave : %d", target, mutation, count))
    else
        Infomation:SetDesc(string.format("FoodName : %s\nAmount : %d", target, count))
    end
end

pcall(function()
    LocalPlayer:GetAttributeChangedSignal("HoldUID"):Connect(updateInfomation)
    updateInfomation()
end)

Tabs.Gift:Button({
    Title = "tr:SendGift",
    Callback = function()
        if not SelectedPlr then
            return WindUI:Notify({
                Title = "Venuz | Notify",
                Content = "No player selected",
                Icon = VenuzIcon,
                Duration = 5,
            })
        end

        local targetPlayer = Players:FindFirstChild(SelectedPlr)
        if not targetPlayer then
            return WindUI:Notify({
                Title = "Venuz | Notify",
                Content = "Selected player not found",
                Icon = VenuzIcon,
                Duration = 5,
            })
        end

        local amount = math.max(1, tonumber(num) or 1)
        
        if not SelectedTarget or not SelectedType then
            return WindUI:Notify({
                Title = "Venuz | Notify",
                Content = "No item selected",
                Icon = VenuzIcon,
                Duration = 5,
            })
        end

        if getgenv().Settings.Gift.Teleport and targetPlayer.Character then
            TeleportToWaypoint(targetPlayer.Character.HumanoidRootPart.CFrame)
            task.wait(3)
        end

        local sent = 0

        if SelectedType == "Food" then
            local foodAmount = DataAsset:GetAttribute(SelectedTarget) or 0
            if foodAmount <= 0 then
                return WindUI:Notify({
                    Title = "Venuz | Notify",
                    Content = "No food available",
                    Icon = VenuzIcon,
                    Duration = 5,
                })
            end

            local sendAmount = math.min(amount, foodAmount)
            for i = 1, sendAmount do
                LocalPlayer:SetAttribute("HoldUID", SelectedTarget)
                task.wait(0.1)
                GiftRE:FireServer(targetPlayer, SelectedTarget)
                sent += 1
                task.wait(2.5)
            end

            return WindUI:Notify({
                Title = "Venuz | Notify",
                Content = string.format("Sent %dx %s to %s", sent, SelectedTarget, targetPlayer.Name),
                Icon = VenuzIcon,
                Duration = 6,
            })
        end

        local folder = SelectedType == "Pet" and DataPets or DataEgg
        local validItems = {}

        for _, v in pairs(folder:GetChildren()) do
            local isDeleted = (SelectedType == "Pet" and v:GetAttribute("D")) or v:FindFirstChild("DI")
            if not isDeleted and v:GetAttribute("T") == SelectedTarget then
                local vMut = v:GetAttribute("M") or "No Mutation"
                if vMut == SelectedMutation then
                    table.insert(validItems, v)
                    if #validItems >= amount then break end
                end
            end
        end

        if #validItems == 0 then
            return WindUI:Notify({
                Title = "Venuz | Notify",
                Content = "No valid items to send",
                Icon = VenuzIcon,
                Duration = 5,
            })
        end

        for _, item in ipairs(validItems) do
            if SelectedType == "Egg" then
                CharacterRE:FireServer("Focus", item.Name)
                task.wait(0.1)
            end
            LocalPlayer:SetAttribute("HoldUID", item.Name)
            GiftRE:FireServer(targetPlayer, item)
            sent += 1
            task.wait(2.5)
        end

        WindUI:Notify({
            Title = "Venuz | Notify",
            Content = sent < amount 
                and string.format("Not enough items (sent %d/%d)", sent, amount)
                or string.format("Sent %d items to %s", sent, targetPlayer.Name),
            Icon = VenuzIcon,
            Duration = 6,
        })
    end
})

function refreshDropdown()
    local names = {}
    for i, entry in ipairs(PlayersTable) do
        names[i] = entry.Name
    end
    SelectedPlayer:Refresh(names)
    if SelectedPlr and not table.find(names, SelectedPlr) then
        SelectedPlr = nil
    end
end

Players.PlayerAdded:Connect(function(player)
    if player == LocalPlayer then return end
    
    local uid = tostring(player.UserId)
    if playersIndex[uid] then
        local idx = playersIndex[uid]
        if PlayersTable[idx].Name ~= player.Name then
            PlayersTable[idx].Name = player.Name
            refreshDropdown()
        end
        return
    end

    table.insert(PlayersTable, { Name = player.Name, UserId = uid })
    playersIndex[uid] = #PlayersTable
    refreshDropdown()

    player:GetPropertyChangedSignal("Name"):Connect(function()
        local idx = playersIndex[uid]
        if idx and PlayersTable[idx] then
            PlayersTable[idx].Name = player.Name
            refreshDropdown()
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    local uid = tostring(player.UserId)
    local idx = playersIndex[uid]
    if not idx then return end

    table.remove(PlayersTable, idx)
    playersIndex[uid] = nil
    
    for i = idx, #PlayersTable do
        playersIndex[PlayersTable[i].UserId] = i
    end
    
    refreshDropdown()
end)

for _, p in ipairs(Players:GetPlayers()) do
    if p ~= LocalPlayer then
        local uid = tostring(p.UserId)
        table.insert(PlayersTable, { Name = p.Name, UserId = uid })
        playersIndex[uid] = #PlayersTable
    end
end
refreshDropdown()

-------------------------------- Webhook --------------------------------

local TabsWebhook = Tabs.Webhook:Section({ Title = "tr:TabsWebhook", Icon = "send"})

local WebhookUrl = Tabs.Webhook:Input({
    Title = "tr:WebhookUrl",
    Value = getgenv().Settings.Webhook.WebhookUrl,
    Placeholder = "https://discord.com/api/webhooks",
    Callback = function(Value)
        getgenv().Settings.Webhook.WebhookUrl = Value
        SaveSetting()
    end
})

local WebhookPing = Tabs.Webhook:Toggle({
    Title = "tr:WebhookPing",
    Value = getgenv().Settings.Webhook.Ping,
    Icon = "check",
    Callback = function(Ping)
        getgenv().Settings.Webhook.Ping = Ping
        SaveSetting()
    end
})

local testembed = {}

if getgenv().ConfigurationTable.Language == "Thai" then
    testembed = {
        title = "Venuz Test",
        content = "",
        color = 16777215,
        fields = {
            {
                name = "ข้อมูล",
                value = "`` 👤 `` : **ชื่อ " .. "||".. game.Players.LocalPlayer.Name.. "||" .. "**\n`` 💻 `` : **ตัวรัน "..identifyexecutor().."**\n`` 🕓 `` : **เวลา ".. currentTime .."**\n`` 🎮 `` : **Build A Zoo**",
                inline = false
            },
            {
                name = "Test Status",
                value = "```🟢```"
            }
        },
        image = {
            url = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
        },
    }
else
    testembed = {
        title = "Venuz Test",
        content = "",
        color = 16777215,
        fields = {
            {
                name = "Info",
                value = "`` 👤 `` : **Name " .. "||".. game.Players.LocalPlayer.Name.. "||" .. "**\n`` 💻 `` : **Executor "..identifyexecutor().."**\n`` 🕓 `` : **Time ".. currentTime .."**\n`` 🎮 `` : **Build A Zoo**",
                inline = false
            },
            {
                name = "Test Status",
                value = "```🟢```"
            }
        },
        image = {
            url = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
        },
    }
end

local TestWebhook = Tabs.Webhook:Button({
    Title = "tr:TestWebhook",
    Callback = function()
        if getgenv().Settings.Webhook.WebhookUrl == "" then
            WindUI:Notify({Title = "Venuz | Notify",Content = "Please Enter Webhook Url.",Icon = VenuzIcon,Duration = 5,})
            return
        end
        if getgenv().Settings.Webhook.Ping then
            testembed["content"] = "@everyone"
        end
        SendDiscordEmbed(getgenv().Settings.Webhook.WebhookUrl, testembed)
        WindUI:Notify({Title = "Venuz | Notify",Content = "Send Webhook Successfully.",Icon = VenuzIcon,Duration = 5,})
    end
})

local EggTabsWebhook = Tabs.Webhook:Section({ Title = "tr:EggTabsWebhook", Icon = "egg"})

local CheckAllEgg = Tabs.Webhook:Button({
    Title = "tr:CheckAllEgg",
    Callback = function(Value)
        local counts = {}

        for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Data.Egg:GetChildren()) do
            if not v:FindFirstChild("DI") then
                local t = v:GetAttribute("T")
                local m = v:GetAttribute("M") or "No Mutation"
                if t then
                    local key = t
                    if m ~= "No Mutation" then
                        key = t .. " (" .. m .. ")"
                    end
                    counts[key] = (counts[key] or 0) + 1
                end
            end
        end

        local keys = {}
        for k in pairs(counts) do table.insert(keys, k) end
        table.sort(keys)

        local eggList = {}
        for _, name in ipairs(keys) do
            table.insert(eggList, name .. " x" .. counts[name])
        end
        local eggText = table.concat(eggList, "\n")

        local embed = {}

        if getgenv().ConfigurationTable.Language == "Thai" then
            embed = {
                ["title"] = "Venuz Test",
                ["content"] = "",
                ["color"] = 16777215,
                ["fields"] = {
                    {
                        ["name"] = "ข้อมูล",
                        ["value"] = "`` 👤 `` : **ชื่อ " .. "||".. game.Players.LocalPlayer.Name.. "||" .. "**\n`` 💻 `` : **ตัวรัน "..identifyexecutor().."**\n`` 🕓 `` : **เวลา ".. os.date("%H:%M:%S") .."**\n`` 🎮 `` : **Game Build A Zoo**",
                        ["inline"] =  false
                    },
                    {
                        ["name"] = "Eggs",
                        ["value"] = "```"..eggText.."```",
                        ["inline"] = false
                    }
                },
                ["image"] = {
                    ["url"] = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
                },
            }
        else
            embed = {
                ["title"] = "Venuz Test",
                ["content"] = "",
                ["color"] = 16777215,
                ["fields"] = {
                    {
                        ["name"] = "ข้อมูล",
                        ["value"] = "`` 👤 `` : **Name " .. "||".. game.Players.LocalPlayer.Name.. "||" .. "**\n`` 💻 `` : **Executor "..identifyexecutor().."**\n`` 🕓 `` : **Time ".. os.date("%H:%M:%S") .."**\n`` 🎮 `` : **Game Build A Zoo**",
                        ["inline"] =  false
                    },
                    {
                        ["name"] = "Eggs",
                        ["value"] = "```"..eggText.."```",
                        ["inline"] = false
                    }
                },
                ["image"] = {
                    ["url"] = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
                },
            }
        end

        if getgenv().Settings.Webhook.Ping then
            embed["content"] = "@everyone"
        end

        SendDiscordEmbed(getgenv().Settings.Webhook.WebhookUrl, embed)
    end
})

local AutoBuyEggNotify = Tabs.Webhook:Toggle({
    Title = "tr:AutoBuyEggNotify",
    Value = getgenv().Settings.Webhook.AutoBuyEgg,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Webhook.AutoBuyEgg = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                if not Value then
                    if _G.conn then
                        _G.conn:Disconnect()
                        _G.conn = nil
                    end
                    return
                end

                if _G.conn then
                    return
                end

                _G.conn = game:GetService("Players").LocalPlayer.PlayerGui.Data.Egg.ChildAdded:Connect(function(child)
                    local Name = child:GetAttribute("T")
                    local Mutation = child:GetAttribute("M") or "No Mutation"
                    
                    local embed
                    if getgenv().ConfigurationTable.Language == "Thai" then
                        embed = {
                            ["title"] = "🐣 Auto BuyEgg Result",
                            ["color"] = 16777215,
                            ["fields"] = {
                                {
                                    ["name"] = "ข้อมูล",
                                    ["value"] = "`` 👤 `` : **ชื่อ " .. "||".. game.Players.LocalPlayer.Name.. "||" .. "**\n`` 💻 `` : **ตัวรัน "..identifyexecutor().."**\n`` 🕓 `` : **เวลา ".. os.date("%H:%M:%S") .."**\n`` 🎮 `` : **Game Build A Zoo**",
                                    ["inline"] = false
                                },
                                {
                                    ["name"] = "ผลการซื้อไข่",
                                    ["value"] = "```"..Name.."( "..Mutation.." )".."```",
                                    ["inline"] = false
                                }
                            },
                            ["image"] = {
                                ["url"] = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
                            },
                        }
                    else
                        embed = {
                            ["title"] = "🐣 Auto BuyEgg Result",
                            ["color"] = 16777215,
                            ["fields"] = {
                                {
                                    ["name"] = "Info",
                                    ["value"] = "`` 👤 `` : **Name " .. "||".. game.Players.LocalPlayer.Name.. "||" .. "**\n`` 💻 `` : **Executor "..identifyexecutor().."**\n`` 🕓 `` : **Time ".. os.date("%H:%M:%S") .."**\n`` 🎮 `` : **Game Build A Zoo**",
                                    ["inline"] = false
                                },
                                {
                                    ["name"] = "Eggs Result",
                                    ["value"] = "```"..Name.."( "..Mutation.." )".."```",
                                    ["inline"] = false
                                }
                            },
                            ["image"] = {
                                ["url"] = "https://tr.rbxcdn.com/180DAY-f212509b8348e6273a1e4784d653ee07/768/432/Image/Webp/noFilter"
                            },
                        }
                    end

                    if getgenv().Settings.Webhook.Ping then
                        embed["content"] = "@everyone"
                    end

                    SendDiscordEmbed(getgenv().Settings.Webhook.WebhookUrl, embed)
                end)
            end)
        end)
    end
})

local AutoBuyFoodNotify = Tabs.Webhook:Toggle({
    Title = "tr:AutoBuyFoodNotify",
    Value = getgenv().Settings.Webhook.AutoBuyFood,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Webhook.AutoBuyFood = Value
        SaveSetting()
    end
})

-------------------------------- Misc --------------------------------

function ServerHop()
    -- HopServer by Phoenix Venuz Hub

    local HTTP = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Player = game.Players.LocalPlayer

    local res = http.request({
        Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
        Method = "GET",
    }).Body

    local success, data = pcall(function()
        return HTTP:JSONDecode(res)
    end)

    if success then
        local servers = {}
        for _, v in ipairs(data.data) do
            if v.id and v.playing > 0 and v.id ~= game.JobId then
                table.insert(servers, v.id)
            end
        end

        if #servers > 0 then
            local randomServer = servers[math.random(1, #servers)]
            print("🛰️ Hopping to server:", randomServer)
            TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, Player)
        end
    end
end

local MiscTabs = Tabs.Misc:Section({ Title = "tr:MiscTabs", Icon = "info"})

local DisableAnimation = Tabs.Misc:Toggle({
    Title = "tr:DisableAnimation",
    Value = getgenv().Settings.Misc.DisableAnimationPet,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Misc.DisableAnimationPet = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                if Value then
                    while getgenv().Settings.Misc.DisableAnimationPet do task.wait()
                        for i, v in pairs(workspace.Pets:GetChildren()) do
                            local Model = v:FindFirstChild("Model")
                            if Model then
                                local AnimationController = Model:FindFirstChild("AnimationController")
                                if AnimationController then
                                local animator = AnimationController:FindFirstChildOfClass("Animator")
                                    if animator then
                                        for _, animObj in pairs(animator:GetChildren()) do
                                            if animObj:IsA("Animation") then
                                                if not getgenv().Settings.Misc.DisableAnimationPet then
                                                    local track = animator:LoadAnimation(animObj)
                                                    track:Play()
                                                else
                                                    for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                                                        track:Stop()
                                                    end
                                                end
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

local DisableMoney = Tabs.Misc:Toggle({
    Title = "tr:DisableMoney",
    Value = getgenv().Settings.Misc.DisableEffectGetMoney,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Misc.DisableEffectGetMoney = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Misc.DisableEffectGetMoney do task.wait()
                        for i,v in pairs(game:GetService("Players")[LocalPlayer.Name].PlayerGui.PopupDrop:GetChildren()) do
                            if v.Name == "WorkItem" then
                                if v.Position == UDim2.new(0.02,0,0.29,0) then
                                    v.Visible = true
                                else
                                    v.Visible = false
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local RedeemAllCodes = Tabs.Misc:Button({
    Title = "tr:RedeemAllCodes",
    Callback = function()
        local CODES = {
            "60KCCU919",
            "4XW5RG4CHRY",
            "N7A68Q82H83",
            "3XKK8Z2WB6G",
            "ZTWPH3WW8SJ",
            "DS5523YSQ3C",
            "subtoZRGZeRoGhost",
            "DelayGift",
            "Nyaa",
            "Halloween1018",
            "druscxlla",
        }

        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local RedemptionCodeRE = ReplicatedStorage.Remote.RedemptionCodeRE 

        for i = 1, 3 do
            for _, code in ipairs(CODES) do
                RedemptionCodeRE:FireServer({
                    event = "usecode",
                    code = code,
                })
                task.wait(0.3)
            end
        end
    end
})

local UnlockBigPet2 = Tabs.Misc:Button({
    Title = "tr:UnlockBigPet2",
    Callback = function()
        game.ReplicatedStorage.Remote.CharacterRE:FireServer("UnlockBP", 2)
    end
})

local LikeTabs = Tabs.Misc:Section({ Title = "tr:LikeTabs", Icon = "heart"})

local AutolikeServerHop = Tabs.Misc:Toggle({
    Title = "tr:AutolikeServerHop",
    Value = getgenv().Settings.Misc.AutoLikeHopServer,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Misc.AutoLikeHopServer = Value
        SaveSetting()

        task.spawn(function()
            pcall(function()
                if Value then
                    while getgenv().Settings.Misc.AutoLikeHopServer do task.wait(1)
                        for i,v in pairs(workspace.Art:GetChildren()) do
                            if v:GetAttribute("OccupyingPlayerId") then
                                if v:GetAttribute("OccupyingPlayerId") ~= game.Players.LocalPlayer.UserId then
                                    game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("GiveLike", v:GetAttribute("OccupyingPlayerId"))
                                    task.wait(.1)
                                end
                            end
                        end
                        task.wait(getgenv().Settings.Misc.DelayAutoLike)
                        if getgenv().Settings.Misc.AutoLikeHopServer then
                        ServerHop()
                        end
                    end
                end
            end)
        end)
    end
})

local DelayAutoLike = Tabs.Misc:Slider({
    Title = "tr:DelayAutoLike",
    Value = {
        Min = 1,
        Max = 30,
        Default = getgenv().Settings.Misc.DelayAutoLike,
    },
    Callback = function(Value)
        getgenv().Settings.Misc.DelayAutoLike = Value
        SaveSetting()
    end
})

local AutoLikeTabs1 = Tabs.Misc:Section({ Title = "tr:AutoLikeTabs1", Icon = "heart"})

local Plrs = {}

for i,v in pairs(game:GetService("Players"):GetChildren()) do
    if v.Name ~= LocalPlayer.Name then
        table.insert(Plrs, v.Name)
    end
end

local SelectPlayers_AutoLike = Tabs.Misc:Dropdown({
    Title = "tr:SelectPlayers_AutoLike",
    Value = {},
    Values = Plrs,
    Multi = true,
    AllowNone = false,
    Callback = function(Plr)

    end
})

local AutolikeAFK = Tabs.Misc:Toggle({
    Title = "tr:AutolikeAFK",
    Value = getgenv().Settings.Misc.AutoLike,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Misc.AutoLike = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Misc.AutoLike do
                        for i,v in pairs(game:GetService("Players"):GetChildren()) do
                            if table.find(Plrs, v.Name) then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer(unpack({"GiveLike",v.UserId}))
                                break
                            end
                        end
                        task.wait(getgenv().Settings.Misc.DelayAutoLikeAFK)
                    end
                end)
            end)
        end
    end
})

local AutolikeDelay = Tabs.Misc:Slider({
    Title = "tr:AutolikeDelay",
    Value = {
        Min = 1,
        Max = 90,
        Default = getgenv().Settings.Misc.DelayAutoLikeAFK
    },
    Callback = function(Value)
        getgenv().Settings.Misc.DelayAutoLikeAFK = Value
        SaveSetting()
    end
})

game:GetService("Players").ChildAdded:Connect(function(Plr)
    if Plr.Name ~= LocalPlayer.Name and not table.find(Plrs, Plr.Name) then
        table.insert(Plrs, Plr.Name)
        SelectPlayers_AutoLike:Refresh(Plrs)
    end
end)

game:GetService("Players").ChildRemoved:Connect(function(Plr)
    local index = table.find(Plrs, Plr.Name)
    if index then
        table.remove(Plrs, index)
        SelectPlayers_AutoLike:Refresh(Plrs)
    end
end)
-------------------------------- Premium --------------------------------

local Baits = {
    ["Cheese Bait"] = "FishingBait1",
    ["Fly Bait"] = "FishingBait2",
    ["Fish Bait"] = "FishingBait3"
}

local BaitReverse = {}
for name, value in pairs(Baits) do
    BaitReverse[value] = name
end

local FishPosition = Tabs.Premium:Section({ Title = "tr:FishPosition", Icon = "locate"})

function GetVectorFromTable(posTable)
    if typeof(posTable) == "table" and #posTable > 0 then
        local posStr = table.concat(posTable, " ")
        local x, y, z = string.match(posStr, "([%-%d%.]+),%s*([%-%d%.]+),%s*([%-%d%.]+)")
        if x and y and z then
            return Vector3.new(tonumber(x), tonumber(y), tonumber(z))
        end
    end
    return nil
end

local PositionFish = Tabs.Premium:Paragraph({
    Title = "tr:PositionFish",
    Desc = "Position : "..(getgenv().Settings.Premium.PositionFish and table.concat(getgenv().Settings.Premium.PositionFish) or " : Not set")
})

local SavePosition = Tabs.Premium:Button({
    Title = "tr:SavePosition",
    Callback = function()
        local pos = hrp.Position
        getgenv().Settings.Premium.PositionFish = {math.round(pos.X) .. ", " .. math.round(pos.Y) .. ", " .. math.round(pos.Z)}
        SaveSetting()
        PositionFish:SetDesc("Position : " .. table.concat(getgenv().Settings.Premium.PositionFish) or "Not set")
    end
})

local AutoFishPremiumTabs = Tabs.Premium:Section({ Title = "tr:AutoFishPremiumTabs", Icon = "fish"})

local SelectBait = Tabs.Premium:Dropdown({
    Title = "tr:SelectBait",
    Multi = false,
    AllowNone = true,
    Values = {"Cheese Bait", "Fly Bait", "Fish Bait"},
    Value = BaitReverse[getgenv().Settings.Premium.SelectBait],
    Callback = function(Value)
        if getgenv().IsPremium == "Premium Access" then
            getgenv().Settings.Premium.SelectBait = Baits[Value]
            SaveSetting()
        end
    end
})

local AutoFishPremium

AutoFishPremium = Tabs.Premium:Toggle({
    Title = "tr:AutoFishPremium",
    Value = getgenv().Settings.Premium.AutoFish,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.AutoFish = Value
        SaveSetting()

        if Value then
            humanoid:ChangeState(Enum.HumanoidStateType.Physics)

            if not getgenv().Settings.Premium.PositionFish then
                WindUI:Notify({Title = "Venuz | Notify",Content = "Please Save Position",Duration = 5})
                task.wait(.5)
                AutoFishPremium:Set(false)
                return
            end

            if not getgenv().Settings.Premium.SelectBait then
                WindUI:Notify({Title = "Venuz | Notify",Content = "Please Select Bait",Duration = 5})
                task.wait(.5)
                AutoFishPremium:Set(false)
                return
            end

            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Premium.AutoFish do 
                        task.wait()
                        
                        if game.Players.LocalPlayer:GetAttribute("HoldUID") ~= "FishRob" then
                            game.Players.LocalPlayer:SetAttribute("HoldUID", "FishRob")
                        end
                        
                        if not hrp.Anchored then hrp.Anchored = true end
                        TeleportToWaypoint(CFrame.new(GetVectorFromTable(getgenv().Settings.Premium.PositionFish)))
                        
                        local AnimFish = game.Players.LocalPlayer.Character:GetAttribute("AnimFish")
                        
                        for i,v in pairs(workspace.FishPoints.FishPoint1:GetChildren()) do
                            if v.Name == "FX_Fish_Special" then
                                if v:FindFirstChild("Scope") then
                                    if AnimFish == "Ready" then
                                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("Throw",{Bait = getgenv().Settings.Premium.SelectBait, Pos = v.Scope.Position})
                                    elseif AnimFish == "Pull" then
                                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("POUT",{SUC = 1})
                                    end
                                end
                            else
                                if AnimFish == "Pull" then
                                    game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("FishingRE"):FireServer("POUT",{SUC = 1})
                                end
                            end
                        end
                    end
                end)
            end)
        else
            game.Players.LocalPlayer:SetAttribute("HoldUID", nil)
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
    end
})

local ServerHopFindEvent = Tabs.Premium:Toggle({
    Title = "tr:ServerHopFindEvent",
    Value = getgenv().Settings.Premium.HopServer,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.HopServer = Value
        SaveSetting()

        if Value then
            spawn(function()
                pcall(function()
                    while getgenv().Settings.Premium.HopServer do task.wait(1)
                        for i,v in pairs(workspace.FishPoints.FishPoint1:GetChildren()) do
                            if v.Name == "FX_Fish_Special_Wait" then
                                ServerHop()
                                break
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local Weather = Tabs.Premium:Section({ Title = "tr:Weather", Icon = "cloud-rain"})

local InfoWeather = Tabs.Premium:Paragraph({
    Title = "tr:InfoWeather",
    Desc = "tr:InfoWeatherDesc"
})

local ServerHopFindEventSnow = Tabs.Premium:Dropdown({
    Title = "tr:ServerHopFindEventSnow",
    Value = getgenv().Settings.Premium.HopServerList,
    Values = {"Snow", "Halloween", "Sand", "Aurora", "Thanksgiving"},
    Multi = false,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.Premium.HopServerList = Value
        SaveSetting()
    end
})

local ServerHopFindEventHalloween = Tabs.Premium:Toggle({
    Title = "tr:ServerHopFindEventHalloween",
    Value = getgenv().Settings.Premium.HopServerHollowen,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.HopServerHollowen = Value
        SaveSetting()

        if Value then
            spawn(function()
                pcall(function()
                    while getgenv().Settings.Premium.HopServerHollowen do task.wait(1)
                        if workspace:GetAttribute("Weather") ~= getgenv().Settings.Premium.HopServerList then
                            ServerHop()
                        end
                    end
                end)
            end)
        end
    end
})

local EquipTradeSection = Tabs.Premium:Section({ Title = "tr:AutoEquipTrade", Icon = "cog"})

local MinValue = Tabs.Premium:Input({
    Title = "tr:MinValue",
    Value = tonumber(getgenv().Settings.Premium.MinValue),
    Placeholder = "1",
    Callback = function(Value)
        getgenv().Settings.Premium.MinValue = tonumber(Value)
        SaveSetting()
    end
})

local MaxValue = Tabs.Premium:Input({
    Title = "tr:MaxValue",
    Value = tonumber(getgenv().Settings.Premium.MaxValue),
    Placeholder = "1",
    Callback = function(Value)
        getgenv().Settings.Premium.MaxValue = tonumber(Value)
        SaveSetting()
    end
})

local AutoEquipTrade = Tabs.Premium:Toggle({
    Title = "tr:AutoEquipTrade",
    Value = getgenv().Settings.Premium.AutoEquipTrade,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.AutoEquipTrade = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Premium.AutoEquipTrade do task.wait(1)
                        local player = game:GetService("Players").LocalPlayer
                        local PetsFolder = player:WaitForChild("PlayerGui"):WaitForChild("Data"):WaitForChild("Pets")

                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local SharedModule = ReplicatedStorage:WaitForChild("Shared")
                        local PetModule = require(SharedModule)("Pet")

                        local function ToPlainNumber(value)
                            if type(value) == "string" then
                                value = value:gsub(",", "")
                                value = tonumber(value)
                            end
                            return math.floor(value or 0)
                        end

                        local deployedPets = {}
                        for _, pet in pairs(workspace:WaitForChild("Pets"):GetChildren()) do
                            deployedPets[pet.Name] = true
                        end

                        for _, petInst in pairs(PetsFolder:GetChildren()) do
                            if not deployedPets[petInst.Name] then
                                local petData = {}
                                for attrName, attrValue in pairs(petInst:GetAttributes()) do
                                    petData[attrName] = attrValue
                                end

                                local success, income = pcall(function()
                                    return PetModule:GetPetProduce(petData, 1)
                                end)

                                if success then
                                    local plainIncome = ToPlainNumber(income)

                                    if plainIncome >= getgenv().Settings.Premium.MinValue and plainIncome <= getgenv().Settings.Premium.MaxValue then
                                        game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer("Focus", petInst.Name)
                                        task.wait(0.2)
                                        break
                                    end
                                end
                            end
                        end
                    end
                end)
            end)
        end
    end
})

local TradeSection = Tabs.Premium:Section({ Title = "tr:TradeSection", Icon = "handshake"})

getgenv().Status = "Waiting"
local ShowStatus
local Earns

function CheckStatus()
    for _, v in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetDescendants()) do
        if v.Name == "SurfaceGui" and v:FindFirstChild("Root") then
            local stateTitle = v.Root:FindFirstChild("TradeBar") and v.Root.TradeBar:FindFirstChild("StateTitle")
            if stateTitle then
                -- ลบ attribute เดิมออกก่อน (ถ้ามี) เพื่อให้สามารถ reconnect ได้
                if stateTitle:GetAttribute("Connected") then
                    stateTitle:SetAttribute("Connected", nil)
                end
                
                stateTitle:SetAttribute("Connected", true)
                stateTitle:GetPropertyChangedSignal("Text"):Connect(function()
                    getgenv().Status = stateTitle.Text
                    ShowStatus:SetDesc("Status : " .. getgenv().Status)
                end)
                getgenv().Status = stateTitle.Text
                ShowStatus:SetDesc("Status : " .. getgenv().Status)
            end
        end
    end
end

ShowStatus = Tabs.Premium:Paragraph({
    Title = "tr:ShowStatus",
    Desc = "Status : " .. getgenv().Status
})

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").ChildAdded:Connect(function(child)
    if child:IsA("SurfaceGui") then
        CheckStatus()
    end
end)

game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui").ChildRemoved:Connect(function(child)
    if child:IsA("SurfaceGui") then
        CheckStatus()
    end
end)

CheckStatus()

local CheckingLocked = false

local Method = Tabs.Premium:Dropdown({
    Title = "tr:Method",
    Value = getgenv().Settings.Premium.Method,
    Values = {"Status", "Earn/s"},
    Multi = false,
    AllowNone = false,
    Callback = function(Value)
        getgenv().Settings.Premium.Method = Value
        SaveSetting()

        if Value == "Status" then
            CheckingLocked = true
            if Earns then
                Earns:Lock()
            end
        else
            CheckingLocked = false
            if Earns then
                Earns:Unlock()
            end
        end
    end
})

if getgenv().Settings.Premium.Method == "Status" then
    CheckingLocked = true
end

Earns = Tabs.Premium:Input({
    Title = "tr:Earns",
    Value = tonumber(getgenv().Settings.Premium.Earns),
    Placeholder = "1",
    Locked = CheckingLocked,
    Callback = function(Value)
        getgenv().Settings.Premium.Earns = tonumber(Value)
        SaveSetting()
    end
})

local AutoTrade = Tabs.Premium:Toggle({
    Title = "tr:AutoTrade",
    Value = getgenv().Settings.Premium.AutoTrade,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.AutoTrade = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    while getgenv().Settings.Premium.AutoTrade do task.wait(3)
                        local Count = workspace.Art[getgenv().MyIsland].ENV.TradeZone.TradeZoneBoard.C.SurfaceGui.Num.Count
                        if getgenv().IsPremium == "Premium Access" then
                            if getgenv().Settings.Premium.Method == "Status" then
                                if game.Players.LocalPlayer:GetAttribute("HoldUID") ~= nil then
                                    if not string.match(Count.Text, "^0/%d+$") then
                                        hrp.CFrame = workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.AddMore.CFrame * CFrame.new(7,2,0)
                                        hrp.CFrame = CFrame.lookAt(hrp.Position, workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.AddMore.Position)
                                    else
                                        hrp.CFrame = workspace.Art[getgenv().MyIsland].ENV.AreaRange.CFrame * CFrame.new(0,20,0)
                                        repeat task.wait(1) until not string.match(workspace.Art[getgenv().MyIsland].ENV.TradeZone.TradeZoneBoard.C.SurfaceGui.Num.Count.Text, "^0/%d+$")
                                    end
                                    task.wait(2)
                                    if not string.match(Count.Text, "^0/%d+$") then
                                        if getgenv().Status == "Fair" or getgenv().Status == "ยุติ" then
                                            fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.Accept.ClickDetector, 25)
                                        elseif getgenv().Status == "Unfair" or getgenv().Status == "ไม่ยุติ" then
                                            fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.AddMore.ClickDetector, 25)
                                            
                                            local myIncome = 0
                                            local theirIncome = 0
                                            
                                            for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.SurfaceGui:GetChildren()) do
                                                if v.Name == "Root" then
                                                    local TradeFrame = v:FindFirstChild("TradeFrame")
                                                    if TradeFrame then
                                                        local Trader = TradeFrame:FindFirstChild("Trader")
                                                        if Trader then
                                                            for _, prefab in pairs(Trader:GetChildren()) do
                                                                if prefab.Name == "TraderPrefab" then
                                                                    local BTN = prefab:FindFirstChild("BTN")
                                                                    if BTN then
                                                                        local Stat = BTN:FindFirstChild("Stat")
                                                                        if Stat then
                                                                            local Price = Stat:FindFirstChild("Price")
                                                                            if Price then
                                                                                local Value = Price:FindFirstChild("Value")
                                                                                if Value then
                                                                                    local number = string.gsub(Value.Text, "[^%d]", "")
                                                                                    local result = tonumber(number) or 0
                                                                                    
                                                                                    if myIncome == 0 then
                                                                                        myIncome = result
                                                                                    else
                                                                                        theirIncome = result
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                end
                                            end
                                            
                                            if theirIncome > myIncome then
                                                fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.Accept.ClickDetector, 25)
                                            else
                                                fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.Decline.ClickDetector, 25)
                                            end
                                            task.wait(0.5)
                                        end
                                    end
                                end
                            elseif getgenv().Settings.Premium.Method == "Earn/s" then
                                if game.Players.LocalPlayer:GetAttribute("HoldUID") ~= nil then
                                    if not string.match(Count.Text, "^0/%d+$") then
                                        hrp.CFrame = workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.AddMore.CFrame * CFrame.new(7,2,0)
                                        hrp.CFrame = CFrame.lookAt(hrp.Position, workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.AddMore.Position)
                                    else
                                        hrp.CFrame = workspace.Art[getgenv().MyIsland].ENV.AreaRange.CFrame * CFrame.new(0,20,0)
                                        repeat task.wait(1) until not string.match(workspace.Art[getgenv().MyIsland].ENV.TradeZone.TradeZoneBoard.C.SurfaceGui.Num.Count.Text, "^0/%d+$")
                                    end
                                    task.wait(2)
                                    if not string.match(Count.Text, "^0/%d+$") then
                                        for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.SurfaceGui:GetChildren()) do
                                            if v.Name == "Root" then
                                                local TradeFrame = v:FindFirstChild("TradeFrame")
                                                local Trader = TradeFrame:FindFirstChild("Trader")
                                                local TraderPrefab = Trader:FindFirstChild("TraderPrefab")
                                                local BTN = TraderPrefab:FindFirstChild("BTN")
                                                local Stat = BTN:FindFirstChild("Stat")
                                                local Price = Stat:FindFirstChild("Price")
                                                local Value = Price:FindFirstChild("Value")
                                                local number = string.gsub(Value.Text, "[^%d]", "")
                                                local result = tonumber(number)
                                                
                                                if result >= getgenv().Settings.Premium.Earns then
                                                    fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.Accept.ClickDetector, 25)
                                                    break
                                                else
                                                    fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.AddMore.ClickDetector, 25)
                                                    task.wait(1)
                                                    
                                                    local myIncome = 0
                                                    local theirIncome = 0
                                                    
                                                    for j, root in pairs(game:GetService("Players").LocalPlayer.PlayerGui.SurfaceGui:GetChildren()) do
                                                        if root.Name == "Root" then
                                                            local TF = root:FindFirstChild("TradeFrame")
                                                            if TF then
                                                                local Trd = TF:FindFirstChild("Trader")
                                                                if Trd then
                                                                    for _, prefab in pairs(Trd:GetChildren()) do
                                                                        if prefab.Name == "TraderPrefab" then
                                                                            local B = prefab:FindFirstChild("BTN")
                                                                            if B then
                                                                                local S = B:FindFirstChild("Stat")
                                                                                if S then
                                                                                    local P = S:FindFirstChild("Price")
                                                                                    if P then
                                                                                        local V = P:FindFirstChild("Value")
                                                                                        if V then
                                                                                            local num = string.gsub(V.Text, "[^%d]", "")
                                                                                            local res = tonumber(num) or 0
                                                                                            
                                                                                            if myIncome == 0 then
                                                                                                myIncome = res
                                                                                            else
                                                                                                theirIncome = res
                                                                                            end
                                                                                        end
                                                                                    end
                                                                                end
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                        end
                                                    end
                                                    
                                                    if theirIncome >= getgenv().Settings.Premium.Earns then
                                                        fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.Accept.ClickDetector, 25)
                                                    else
                                                        fireclickdetector(workspace.Art[getgenv().MyIsland].ENV.TradeZone.Zone.TradeZone5.TradePart.Decline.ClickDetector, 25)
                                                    end
                                                    break
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
    end
})

local TradeSection = Tabs.Premium:Section({ Title = "tr:PlaceBest", Icon = "layout-template"})

local AutoPlacePetBest = Tabs.Premium:Toggle({
    Title = "tr:AutoPlacePetBest",
    Value = getgenv().Settings.Premium.AutoPlacePetBest,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.AutoPlacePetBest = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    local index = 1
                    while getgenv().Settings.Premium.AutoPlacePetBest do task.wait(.5)
                        local OceanPets = {
                            "Swordfish",
                            "Shark",
                            "Dolphin",
                            "AngelFish",
                            "Catfish",
                            "Bighead",
                            "Flounder",
                            "Alligator",
                            "Hairtail",
                            "Butterflyfish",
                            "Needlefish",
                            "ElectricEel",
                            "Manta",
                            "Whale"
                        }

                        local Players = game:GetService("Players")
                        local LocalPlayer = Players.LocalPlayer
                        local playerData = LocalPlayer.PlayerGui:FindFirstChild("Data")
                        local PetsFolder = playerData:FindFirstChild("Pets")

                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local SharedModule = ReplicatedStorage:WaitForChild("Shared")
                        local PetModule = require(SharedModule)("Pet")

                        for _, v in pairs(workspace.PlayerBuiltBlocks:GetChildren()) do
                            local p = tonumber(string.match(v.Name, "%d+"))
                            if p == game.Players.LocalPlayer.UserId then
                                local data = v.Value
                                if typeof(data) == "string" then
                                    local success, decoded = pcall(function()
                                        return HttpService:JSONDecode(data)
                                    end)

                                    if success and typeof(decoded) == "table" and decoded[1] and decoded[1].UID then
                                        local uid = decoded[1].UID
                                        getgenv().E = uid
                                    else
                                        getgenv().E = nil
                                    end
                                end
                            end
                        end

                        function ToPlainNumber(value)
                            if type(value) == "string" then
                                value = value:gsub(",", "")
                                value = tonumber(value)
                            end
                            return math.floor(value or 0)
                        end

                        local oceanSet = {}
                        for _, petName in ipairs(OceanPets) do
                            oceanSet[petName] = true
                        end

                        local deployedPets = {}
                        local workspacePets = workspace:FindFirstChild("Pets")
                        if workspacePets then
                            for _, pet in pairs(workspacePets:GetChildren()) do
                                deployedPets[pet.Name] = true
                            end
                        end

                        local currentHoldUID = LocalPlayer:GetAttribute("HoldUID")
                        if currentHoldUID and deployedPets[currentHoldUID] then
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer("Focus")
                            task.wait(.2)
                        end

                        local maxIncome = 0
                        local bestPet = nil
                        local category = "Mountain"

                        for _, petInst in pairs(PetsFolder:GetChildren()) do

                            local uid = tostring(petInst.Name)
                            if uid == getgenv().E then
                                continue
                            end

                            if not deployedPets[petInst.Name] then
                                local petType = petInst:GetAttribute("T")
                                local isOcean = oceanSet[petType]
                                
                                local isMatch = false
                                if category == "Mountain" then
                                    isMatch = not isOcean
                                elseif category == "Ocean" then
                                    isMatch = isOcean
                                end
                                
                                if isMatch then
                                    local petData = {}
                                    for attrName, attrValue in pairs(petInst:GetAttributes()) do
                                        petData[attrName] = attrValue
                                    end
                                    
                                    local success, income = pcall(function()
                                        return PetModule:GetPetProduce(petData, 1)
                                    end)
                                    
                                    if success then
                                        local plainIncome = ToPlainNumber(income)
                                        if plainIncome > maxIncome then
                                            maxIncome = plainIncome
                                            bestPet = petInst
                                        end
                                    end
                                end
                            end
                        end

                        if bestPet then
                            if LocalPlayer:GetAttribute("HoldUID") == nil then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer("Focus", bestPet.Name)
                            else
                                if #FarmPet > 0 then
                                    local pos = FarmPet[index].Position
                                    local ohTable2 = {
                                        ["DST"] = pos + Vector3.new(0, 10, 0),
                                        ["ID"] = game.Players.LocalPlayer:GetAttribute("HoldUID")
                                    }

                                    game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("Place", ohTable2)

                                    index = index + 1
                                    if index > #FarmPet then
                                        index = 1
                                    end
                                end
                            end
                        else
                            print(string.format("No %s pets available!", category))
                        end
                    end
                end)
            end)
        end
    end
})

local AutoPlaceOceanBest = Tabs.Premium:Toggle({
    Title = "tr:AutoPlaceOceanBest",
    Value = getgenv().Settings.Premium.AutoPlaceOceanBest,
    Icon = "check",
    Callback = function(Value)
        getgenv().Settings.Premium.AutoPlaceOceanBest = Value
        SaveSetting()

        if Value then
            task.spawn(function()
                pcall(function()
                    local index = 1
                    while getgenv().Settings.Premium.AutoPlaceOceanBest do task.wait(.5)
                        local OceanPets = {
                            "Swordfish",
                            "Shark",
                            "Dolphin",
                            "AngelFish",
                            "Catfish",
                            "Bighead",
                            "Flounder",
                            "Alligator",
                            "Hairtail",
                            "Butterflyfish",
                            "Needlefish",
                            "ElectricEel",
                            "Manta",
                            "Whale"
                        }

                        local Players = game:GetService("Players")
                        local LocalPlayer = Players.LocalPlayer
                        local playerData = LocalPlayer.PlayerGui:FindFirstChild("Data")
                        local PetsFolder = playerData:FindFirstChild("Pets")

                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local SharedModule = ReplicatedStorage:WaitForChild("Shared")
                        local PetModule = require(SharedModule)("Pet")

                        for _, v in pairs(workspace.PlayerBuiltBlocks:GetChildren()) do
                            local p = tonumber(string.match(v.Name, "%d+"))
                            if p == game.Players.LocalPlayer.UserId then
                                local data = v.Value
                                if typeof(data) == "string" then
                                    local success, decoded = pcall(function()
                                        return HttpService:JSONDecode(data)
                                    end)

                                    if success and typeof(decoded) == "table" and decoded[1] and decoded[1].UID then
                                        local uid = decoded[1].UID
                                        getgenv().A = uid
                                    else
                                        getgenv().A = nil
                                    end
                                end
                            end
                        end

                        function ToPlainNumber(value)
                            if type(value) == "string" then
                                value = value:gsub(",", "")
                                value = tonumber(value)
                            end
                            return math.floor(value or 0)
                        end

                        local oceanSet = {}
                        for _, petName in ipairs(OceanPets) do
                            oceanSet[petName] = true
                        end

                        local deployedPets = {}
                        local workspacePets = workspace:FindFirstChild("Pets")
                        if workspacePets then
                            for _, pet in pairs(workspacePets:GetChildren()) do
                                deployedPets[pet.Name] = true
                            end
                        end

                        local currentHoldUID = LocalPlayer:GetAttribute("HoldUID")
                        if currentHoldUID and deployedPets[currentHoldUID] then
                            game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer("Focus")
                            task.wait(.2)
                        end

                        local maxIncome = 0
                        local bestPet = nil
                        local category = "Ocean"

                        for _, petInst in pairs(PetsFolder:GetChildren()) do

                            local uid = tostring(petInst.Name)
                            if uid == getgenv().A then
                                continue
                            end

                            if not deployedPets[petInst.Name] then
                                local petType = petInst:GetAttribute("T")
                                local isOcean = oceanSet[petType]
                                
                                local isMatch = false
                                if category == "Mountain" then
                                    isMatch = not isOcean
                                elseif category == "Ocean" then
                                    isMatch = isOcean
                                end
                                
                                if isMatch then
                                    local petData = {}
                                    for attrName, attrValue in pairs(petInst:GetAttributes()) do
                                        petData[attrName] = attrValue
                                    end
                                    
                                    local success, income = pcall(function()
                                        return PetModule:GetPetProduce(petData, 1)
                                    end)
                                    
                                    if success then
                                        local plainIncome = ToPlainNumber(income)
                                        if plainIncome > maxIncome then
                                            maxIncome = plainIncome
                                            bestPet = petInst
                                        end
                                    end
                                end
                            end
                        end

                        if bestPet then
                            if LocalPlayer:GetAttribute("HoldUID") == nil then
                                game:GetService("ReplicatedStorage"):WaitForChild("Remote"):WaitForChild("CharacterRE"):FireServer("Focus", bestPet.Name)
                            else
                                if #WaterPet > 0 then
                                    local pos = WaterPet[index].Position
                                    local ohTable2 = {
                                        ["DST"] = pos + Vector3.new(0, 10, 0),
                                        ["ID"] = game.Players.LocalPlayer:GetAttribute("HoldUID")
                                    }

                                    game:GetService("ReplicatedStorage").Remote.CharacterRE:FireServer("Place", ohTable2)

                                    index = index + 1
                                    if index > #WaterPet then
                                        index = 1
                                    end
                                end
                            end
                        else
                            print(string.format("No %s pets available!", category))
                        end
                    end
                end)
            end)
        end
    end
})

task.spawn(function()
    while task.wait(1) do
        if not InfoWeather then
            break
        end

        local CurrentWeather = workspace:GetAttribute("Weather")
        local NextWeather = workspace:GetAttribute("NextWeather")
        local WeatherRemainingTime = workspace:GetAttribute("WeatherRemainingTime")
        local CurrentTranslation = "Current"
        local NextWeatherTranslation = "Next"

        local minutes = math.floor(WeatherRemainingTime / 60)
        local seconds = math.floor(WeatherRemainingTime % 60)
        
        local formattedTime = string.format("%02d:%02d", minutes, seconds)

        local WeatherRemainingTimeTranslation = "Time Left"

        InfoWeather:SetDesc(
        "<font color='#00D9FF'><b>▸".. CurrentTranslation.."</b></font>\n"..
        "<font color='#FFFFFF'>  └─ </font><font color='#7FFF00'><b>"..CurrentWeather.."</b></font>\n"..
        
        "<font color='#FF6B9D'><b>▸".. NextWeatherTranslation.."</b></font>\n"..
        "<font color='#FFFFFF'>  └─ </font><font color='#FFA500'><b>"..NextWeather.."</b></font>\n"..
        
        "<font color='#DA70D6'><b>▸".. WeatherRemainingTimeTranslation.."</b></font>\n"..
        "<font color='#FFFFFF'>  └─ </font><font color='#00FF94'><b>"..formattedTime.."</b></font>")
    end
end)

-------------------------------- Configuration --------------------------------

local Interface = Tabs.Configuration:Section({ Title = "tr:Interface", Icon = "settings-2"})

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

local AutoRejoin = Tabs.Configuration:Toggle({
    Title = "tr:AutoRejoin",
    Value = getgenv().ConfigurationTable.AutoRejoin,
    Icon = "check",
    Callback = function(enabled)
        getgenv().ConfigurationTable.AutoRejoin = enabled
        SaveConfiguration()

        if enabled then
            if not enabled then
                if _G.E then
                    _G.E:Disconnect()
                    _G.E = nil
                end
                return
            end

            if _G.E then
                return
            end

            _G.E = game.CoreGui.RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" then
                    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
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

local FPSIS = Tabs.Configuration:Section({ Title = "tr:FPSIS", Icon = "gamepad"})

local FPSVALUE = Tabs.Configuration:Slider({
    Title = "tr:FPSVALUE",
    Value = {
        Min = 1,
        Max = 240,
        Default = getgenv().ConfigurationTable.FPSValue
    },
    Callback = function(Value)
        getgenv().ConfigurationTable.FPSValue = Value
        SaveConfiguration()
    end
})

local FPSLOCK = Tabs.Configuration:Toggle({
    Title = "tr:FPSLOCK",
    Default = getgenv().ConfigurationTable.LockFPS,
    Icon = "check",
    Callback = function(v)
        getgenv().ConfigurationTable.LockFPS = v
        SaveConfiguration()

        if v then
            task.spawn(function()
                pcall(function()
                    while getgenv().ConfigurationTable.LockFPS do task.wait()
                        if getgenv().ConfigurationTable.LockFPS then
                            setfpscap(getgenv().ConfigurationTable.FPSValue)
                        else
                            setfpscap(240)
                        end
                    end
                end)
            end)
        end
    end
})

local WhiteScreen = Tabs.Configuration:Toggle({
    Title = "tr:WhiteScreen",
    Default = getgenv().ConfigurationTable.WhileScreen,
    Icon = "check",
    Callback = function(v)
        getgenv().ConfigurationTable.WhileScreen = v
        SaveConfiguration()

        local playerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
        local screenGui = playerGui:FindFirstChild("Venuz_White")

        if v then
            if not screenGui then
                screenGui = Instance.new("ScreenGui")
                screenGui.Name = "Venuz_White"
                screenGui.Enabled = true
                screenGui.IgnoreGuiInset = true
                screenGui.Parent = playerGui

                local frame = Instance.new("Frame")
                frame.Name = "Venuz_1"
                frame.Position = UDim2.new(0,0,0,0)
                frame.Size = UDim2.new(1,0,1,0)
                frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                frame.Parent = screenGui
            else
                screenGui.Enabled = true
            end
        else
            if screenGui then
                screenGui.Enabled = false
            end
        end
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
