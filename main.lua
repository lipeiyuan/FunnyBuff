assert(LibStub, "require LibStub!!!")
local LibDispel = LibStub:GetLibrary("LibDispel-1.0")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetTime = GetTime
local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT

local string = string
local print = print

local __DEBUG_LOG__ = false -- 临时开启调试log输出
local g_frame = nil         -- main frame，没啥用，不用管

-- 全局调试函数，其他文件可以访问
function debug_log(...)
    if not __DEBUG_LOG__ then
        return
    end

    print("|cFF00FF00[FunnyBuff]|r", ...)
end

-- 别问我，我不知道为啥，文档就是这么说的，我也不懂
local function fix_dispel_name(dispel_name, spell_id)
    if dispel_name == nil then
        local bleedList = LibDispel:GetBleedList()
        if bleedList[spell_id] then
            dispel_name = "Bleed"
        else
            dispel_name = "None"
        end
    end

    if dispel_name == "" then
        dispel_name = "Enrage"
    end

    return dispel_name
end

-- local function set_buff(buff_frame, aura)
--     if aura.duration < 61 or aura.expirationTime - GetTime() < 61 then
--         local fontsize = buff_frame:GetHeight() / 1.7
--         buff_frame.cooldown:GetRegions():SetFont(STANDARD_TEXT_FONT, fontsize, nil)
--         buff_frame.cooldown:SetHideCountdownNumbers(false)
--     else
--         buff_frame.cooldown:SetHideCountdownNumbers(true)
--     end
-- end

local function set_debuff(debuff_frame, aura)
    if not debuff_frame or not aura then return end

    local dispel_name = fix_dispel_name(aura.dispelName, aura.spellId)
    local debuffsize = debuff_frame:GetParent():GetHeight() / 5 + 8
    local now = GetTime()

    -- 使用配置系统获取常量值
    local icon_scale = FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_ICON_SCALE")
    local font_scale = FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_FONT_SCALE")
    local min_second = FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_MIN_SECOND")

    if LibDispel:IsDispellableByMe(dispel_name) and aura.expirationTime - now > min_second then
        local font_size = debuff_frame:GetHeight() / font_scale
        local flags = nil -- 控制字体其他外观，比如划线等等，https://warcraft.wiki.gg/wiki/API_FontInstance_SetFont
        debuff_frame.cooldown:GetRegions():SetFont(STANDARD_TEXT_FONT, font_size, flags)
        debuff_frame.cooldown:SetHideCountdownNumbers(false)
        local scale_size = debuffsize * icon_scale
        debuff_frame:SetSize(debuffsize * icon_scale, debuffsize * icon_scale)
        -- debug_log(string.format("resize debuff: %s, spell_id: %s, dispel_name: [%s->%s], resize: %s", aura.name,
        --     aura.spellId,
        --     aura.dispelName, dispel_name, scale_size))
    end
end

local function main()
    debug_log("开始初始化插件...")

    -- 检查FunnyBuff对象是否存在
    if not FunnyBuff then
        debug_log("错误: FunnyBuff对象未定义")
        return
    end

    -- 初始化配置系统
    local success, err = pcall(function()
        FunnyBuff:InitializeConfig()
    end)
    if not success then
        debug_log("配置系统初始化失败:", err)
        return
    end
    debug_log("配置系统初始化成功")

    -- 注册设置面板
    success, err = pcall(function()
        FunnyBuff:RegisterSettings()
    end)
    if not success then
        debug_log("设置面板注册失败:", err)
    else
        debug_log("设置面板注册成功")
    end

    -- 注册聊天命令
    success, err = pcall(function()
        FunnyBuff:RegisterCommands()
    end)
    if not success then
        debug_log("聊天命令注册失败:", err)
    else
        debug_log("聊天命令注册成功")
    end

    if not g_frame then
        g_frame = CreateFrame("Frame")
        debug_log("主框架创建成功")
    end

    -- 云姐：buff用nioro就够了
    -- -- buff
    -- hooksecurefunc('CompactUnitFrame_UtilSetBuff', function(buff_frame, aura)
    --     set_buff(buff_frame, aura)
    -- end)

    -- debuff
    hooksecurefunc('CompactUnitFrame_UtilSetDebuff', function(debuff_frame, aura)
        set_debuff(debuff_frame, aura)
    end)

    debug_log("插件初始化完成")
end

-- 使用ADDON_LOADED事件确保在正确的时机初始化
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "FunnyBuff" then
        debug_log("插件加载事件触发")
        main()
    end
end)
