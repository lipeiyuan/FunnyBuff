# FunnyBuff

一个用于魔兽世界团队框架的buff/debuff显示增强插件。

## 功能特点

- 突出显示可驱散的debuff
- 自动调整可驱散debuff的图标大小
- 显示可驱散debuff的剩余时间
- 支持自定义显示效果

## 安装方法

1. 下载最新版本的插件
2. 将解压后的 `FunnyBuff` 文件夹复制到魔兽世界的插件目录：
   - 国服：`World of Warcraft\_retail_\Interface\AddOns\`
   - 美服：`World of Warcraft\_retail_\Interface\AddOns\`
3. 启动游戏，在角色选择界面确保插件已启用

## 配置选项

插件提供了以下可配置选项：

- `DISPELLABLE_DEBUFF_ICON_SCALE`: 可驱散debuff图标缩放比例（默认：1.4）
- `DISPELLABLE_DEBUFF_FONT_SCALE`: 可驱散debuff倒计时字体缩放比例（默认：1.0）
- `DISPELLABLE_DEBUFF_MIN_SECOND`: 可驱散debuff最小剩余时间阈值（默认：0）

## 依赖项

- LibStub
- LibDispel-1.0

## 许可证

本项目采用 MIT 许可证。详见 [LICENSE](https://github.com/lipeiyuan/FunnyBuff?tab=MIT-1-ov-file) 文件。

## 作者

- 爱吃猫的鱼

## 贡献

欢迎提交 Issue 和 Pull Request！

## 更新日志

### v1.0
- 初始版本发布
- 实现基本的debuff显示增强功能 