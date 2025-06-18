-- FunnyBuff 配置系统
local addonName, addon = ...
FunnyBuff = FunnyBuff or {}

-- 默认配置
local defaultConfig = {
    DISPELLABLE_DEBUFF_ICON_SCALE = 1.4,
    DISPELLABLE_DEBUFF_FONT_SCALE = 1.0,
    DISPELLABLE_DEBUFF_MIN_SECOND = 0,
}

-- 初始化配置
function FunnyBuff:InitializeConfig()
    if not FunnyBuffDB then
        FunnyBuffDB = {}
    end

    -- 合并默认配置
    for key, value in pairs(defaultConfig) do
        if FunnyBuffDB[key] == nil then
            FunnyBuffDB[key] = value
        end
    end
end

-- 获取配置值
function FunnyBuff:GetConfig(key)
    return FunnyBuffDB and FunnyBuffDB[key] or defaultConfig[key]
end

-- 设置配置值
function FunnyBuff:SetConfig(key, value)
    if FunnyBuffDB then
        FunnyBuffDB[key] = value
    end
end

-- 重置配置到默认值
function FunnyBuff:ResetConfig()
    FunnyBuffDB = {}
    for key, value in pairs(defaultConfig) do
        FunnyBuffDB[key] = value
    end
end
