assert(LibStub, "require LibStub!!!")
local LibDispel = LibStub:GetLibrary("LibDispel-1.0")

local CreateFrame = CreateFrame
local hooksecurefunc = hooksecurefunc
local GetTime = GetTime
local STANDARD_TEXT_FONT = STANDARD_TEXT_FONT

local string = string
local print = print

local __DEBUG_LOG__ = false -- 调试log输出开关
local g_frame = nil         -- main frame，没啥用，不用管

local function debug_log(...)
    if not __DEBUG_LOG__ then
        return
    end

    print(...)
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


------------------- debuff常量定义 BEGIN -------------------
local DISPELLABLE_DEBUFF_ICON_SCALE = 1.4 -- 可驱散类型debuff的图标放缩倍率（越大图标越大），需要>0
local DISPELLABLE_DEBUFF_FONT_SCALE = 1.0 -- 可驱散类型debuff的倒计时字体放缩倍率（越大倒计时字体越小），需要>0
local DISPELLABLE_DEBUFF_MIN_SECOND = 0   -- 可驱散类型debuff剩余>多少秒时，才会放大+倒计时(0表示只要没消失都会放大+倒计时)，需要>0
------------------- debuff常量定义 END ---------------------
local function set_debuff(debuff_frame, aura)
    if not debuff_frame or not aura then return end

    local dispel_name = fix_dispel_name(aura.dispelName, aura.spellId)
    local debuffsize = debuff_frame:GetParent():GetHeight() / 5 + 8
    local now = GetTime()
    if LibDispel:IsDispellableByMe(dispel_name) and aura.expirationTime - now > DISPELLABLE_DEBUFF_MIN_SECOND then
        local font_size = debuff_frame:GetHeight() / DISPELLABLE_DEBUFF_FONT_SCALE
        local flags = nil -- 控制字体其他外观，比如划线等等，https://warcraft.wiki.gg/wiki/API_FontInstance_SetFont
        debuff_frame.cooldown:GetRegions():SetFont(STANDARD_TEXT_FONT, font_size, flags)
        debuff_frame.cooldown:SetHideCountdownNumbers(false)
        local scale_size = debuffsize * DISPELLABLE_DEBUFF_ICON_SCALE
        debuff_frame:SetSize(debuffsize * DISPELLABLE_DEBUFF_ICON_SCALE, debuffsize * DISPELLABLE_DEBUFF_ICON_SCALE)
        -- debug_log(string.format("resize debuff: %s, spell_id: %s, dispel_name: [%s->%s], resize: %s", aura.name,
        --     aura.spellId,
        --     aura.dispelName, dispel_name, scale_size))
    end
end

local function main()
    if not g_frame then
        g_frame = CreateFrame("Frame")
        -- debug_log("create frame finish", g_frame)
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
end


main()
