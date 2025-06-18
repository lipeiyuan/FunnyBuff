-- FunnyBuff 设置界面
local addonName, addon = ...

-- 全局变量声明
local CreateFrame = CreateFrame

-- 创建设置窗口
function FunnyBuff:CreateSettingsWindow()
    debug_log("开始创建设置窗口...")

    -- 检查是否已经存在设置窗口
    if _G["FunnyBuffSettingsFrame"] then
        _G["FunnyBuffSettingsFrame"]:Show()
        return
    end

    local frame = CreateFrame("Frame", "FunnyBuffSettingsFrame", UIParent, "BasicFrameTemplateWithInset")
    frame:SetSize(450, 500)
    frame:SetPoint("CENTER")
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", frame.StartMoving)
    frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

    -- 标题
    frame.title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    frame.title:SetPoint("CENTER", frame.TitleBg, "CENTER", 0, 0)
    frame.title:SetText("FunnyBuff 设置")

    -- 副标题
    local subtitle = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    subtitle:SetPoint("TOPLEFT", 16, -30)
    subtitle:SetText("自定义团队/小队界面的buff/debuff显示")
    subtitle:SetTextColor(0.7, 0.7, 0.7)

    -- 图标缩放设置
    local iconScaleLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    iconScaleLabel:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -25)
    iconScaleLabel:SetText("可驱散Debuff图标缩放:")

    local iconScaleSlider = CreateFrame("Slider", "FunnyBuffIconScaleSlider", frame, "OptionsSliderTemplate")
    iconScaleSlider:SetPoint("TOPLEFT", iconScaleLabel, "BOTTOMLEFT", 0, -15)
    iconScaleSlider:SetWidth(200)
    iconScaleSlider:SetMinMaxValues(0.1, 3.0)
    iconScaleSlider:SetValueStep(0.1)
    iconScaleSlider:SetValue(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_ICON_SCALE"))
    _G[iconScaleSlider:GetName() .. "Text"]:SetText("")
    _G[iconScaleSlider:GetName() .. "Low"]:SetText("0.1")
    _G[iconScaleSlider:GetName() .. "High"]:SetText("3.0")

    local iconScaleValue = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    iconScaleValue:SetPoint("LEFT", iconScaleSlider, "RIGHT", 10, 0)
    iconScaleValue:SetText(string.format("%.1f", FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_ICON_SCALE")))

    iconScaleSlider:SetScript("OnValueChanged", function(self, value)
        iconScaleValue:SetText(string.format("%.1f", value))
        FunnyBuff:SetConfig("DISPELLABLE_DEBUFF_ICON_SCALE", value)
    end)

    -- 字体缩放设置
    local fontScaleLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontScaleLabel:SetPoint("TOPLEFT", iconScaleSlider, "BOTTOMLEFT", 0, -45)
    fontScaleLabel:SetText("可驱散Debuff倒计时字体缩放:")

    local fontScaleSlider = CreateFrame("Slider", "FunnyBuffFontScaleSlider", frame, "OptionsSliderTemplate")
    fontScaleSlider:SetPoint("TOPLEFT", fontScaleLabel, "BOTTOMLEFT", 0, -15)
    fontScaleSlider:SetWidth(200)
    fontScaleSlider:SetMinMaxValues(0.5, 3.0)
    fontScaleSlider:SetValueStep(0.1)
    fontScaleSlider:SetValue(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_FONT_SCALE"))
    _G[fontScaleSlider:GetName() .. "Text"]:SetText("")
    _G[fontScaleSlider:GetName() .. "Low"]:SetText("0.5")
    _G[fontScaleSlider:GetName() .. "High"]:SetText("3.0")

    local fontScaleValue = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    fontScaleValue:SetPoint("LEFT", fontScaleSlider, "RIGHT", 10, 0)
    fontScaleValue:SetText(string.format("%.1f", FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_FONT_SCALE")))

    fontScaleSlider:SetScript("OnValueChanged", function(self, value)
        fontScaleValue:SetText(string.format("%.1f", value))
        FunnyBuff:SetConfig("DISPELLABLE_DEBUFF_FONT_SCALE", value)
    end)

    -- 最小时间阈值设置
    local minSecondLabel = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    minSecondLabel:SetPoint("TOPLEFT", fontScaleSlider, "BOTTOMLEFT", 0, -45)
    minSecondLabel:SetText("可驱散Debuff最小剩余时间(秒):")

    local minSecondSlider = CreateFrame("Slider", "FunnyBuffMinSecondSlider", frame, "OptionsSliderTemplate")
    minSecondSlider:SetPoint("TOPLEFT", minSecondLabel, "BOTTOMLEFT", 0, -15)
    minSecondSlider:SetWidth(200)
    minSecondSlider:SetMinMaxValues(0, 60)
    minSecondSlider:SetValueStep(1)
    minSecondSlider:SetValue(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_MIN_SECOND"))
    _G[minSecondSlider:GetName() .. "Text"]:SetText("")
    _G[minSecondSlider:GetName() .. "Low"]:SetText("0")
    _G[minSecondSlider:GetName() .. "High"]:SetText("60")

    local minSecondValue = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    minSecondValue:SetPoint("LEFT", minSecondSlider, "RIGHT", 10, 0)
    minSecondValue:SetText(tostring(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_MIN_SECOND")))

    minSecondSlider:SetScript("OnValueChanged", function(self, value)
        -- 确保值为整数
        local intValue = math.floor(value)
        minSecondValue:SetText(tostring(intValue))
        FunnyBuff:SetConfig("DISPELLABLE_DEBUFF_MIN_SECOND", intValue)
    end)

    -- 说明文字
    local description = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    description:SetPoint("TOPLEFT", minSecondSlider, "BOTTOMLEFT", 0, -45)
    description:SetText("说明:")
    description:SetTextColor(1, 1, 0)

    local desc1 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    desc1:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -8)
    desc1:SetText("• 图标缩放: 控制可驱散debuff图标的大小，数值越大图标越大")
    desc1:SetTextColor(0.8, 0.8, 0.8)

    local desc2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    desc2:SetPoint("TOPLEFT", desc1, "BOTTOMLEFT", 0, -5)
    desc2:SetText("• 字体缩放: 控制倒计时数字的大小，数值越大字体越小")
    desc2:SetTextColor(0.8, 0.8, 0.8)

    local desc3 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    desc3:SetPoint("TOPLEFT", desc2, "BOTTOMLEFT", 0, -5)
    desc3:SetText("• 最小时间: 只有剩余时间大于此值的debuff才会放大显示")
    desc3:SetTextColor(0.8, 0.8, 0.8)

    -- 按钮区域
    local buttonFrame = CreateFrame("Frame", nil, frame)
    buttonFrame:SetSize(300, 40)
    buttonFrame:SetPoint("BOTTOM", frame, "BOTTOM", 0, 20)

    -- 重置按钮
    local resetButton = CreateFrame("Button", "FunnyBuffResetButton", buttonFrame, "UIPanelButtonTemplate")
    resetButton:SetPoint("LEFT", buttonFrame, "LEFT", 0, 0)
    resetButton:SetSize(80, 25)
    resetButton:SetText("重置")

    resetButton:SetScript("OnClick", function()
        FunnyBuff:ResetConfig()
        iconScaleSlider:SetValue(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_ICON_SCALE"))
        fontScaleSlider:SetValue(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_FONT_SCALE"))
        minSecondSlider:SetValue(FunnyBuff:GetConfig("DISPELLABLE_DEBUFF_MIN_SECOND"))
        debug_log("设置已重置为默认值")
    end)

    -- 关闭按钮
    local closeButton = CreateFrame("Button", "FunnyBuffCloseButton", buttonFrame, "UIPanelButtonTemplate")
    closeButton:SetPoint("RIGHT", buttonFrame, "RIGHT", 0, 0)
    closeButton:SetSize(80, 25)
    closeButton:SetText("关闭")

    closeButton:SetScript("OnClick", function()
        frame:Hide()
    end)

    debug_log("设置窗口创建完成")
    return frame
end

-- 注册设置面板
function FunnyBuff:RegisterSettings()
    debug_log("开始注册设置系统...")

    -- 创建设置窗口
    local frame = self:CreateSettingsWindow()
    if frame then
        debug_log("设置窗口创建成功")
        -- 初始时隐藏窗口
        frame:Hide()
    else
        debug_log("错误: 无法创建设置窗口")
    end
end

-- 显示设置窗口
function FunnyBuff:ShowSettings()
    local frame = _G["FunnyBuffSettingsFrame"]
    if frame then
        frame:Show()
    else
        debug_log("错误: 设置窗口不存在")
    end
end
