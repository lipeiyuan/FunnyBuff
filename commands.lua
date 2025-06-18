-- FunnyBuff 命令行界面
local addonName, addon = ...

-- 注册聊天命令
function FunnyBuff:RegisterCommands()
    SLASH_FUNNYBUFF1 = "/funnybuff"
    SLASH_FUNNYBUFF2 = "/fb"

    SlashCmdList["FUNNYBUFF"] = function(msg)
        FunnyBuff:HandleCommand(msg)
    end
end

-- 处理聊天命令
function FunnyBuff:HandleCommand(msg)
    -- 直接打开设置界面，忽略所有参数
    debug_log("用户执行命令，打开设置界面")
    FunnyBuff:ShowSettings()
end
