## ZProject 项目配置

在项目中配置zproject.xml文件后，将允许使用`haxelib run zygameui -build html5`等平台API，用于便捷编译其他平台所可用的游戏版本。

## Haxedef Define 定义

由引擎提供的宏定义功能列表：

| 定义                          | 描述                                                         |
| :---------------------------- | ------------------------------------------------------------ |
| define:version                | API游戏版本号。                                              |
| haxedef:debug                 | 打开额外的LOG信息。                                          |
| define:REMOTE_PATH            | 配置远程加载地址。                                           |
| define:untrace                | 禁用trace输入功能。                                          |
| haxedef:no_html5_cache_render | 禁止使用`zygame.components.renders.text.HTML5CacheTextFieldBitmapData`。 |
| haxedef:un_scale_label        | 禁止使用字号缩放，当使用1080P分辨率设计游戏时，可禁止该功能提高性能。 |
| haxedef:invalidate            | 启动invalidate每帧自动刷新，部分小游戏渠道需要开启该功能才能正常渲染。 |
| haxedef:minigame              | 小游戏渠道兼容。                                             |
| haxedef:unapi                 | 禁止使用v1/v2/v3所有HTTP API。                               |
| define:gl_stats               | 收集GL的drawcall信息。                                       |
| haxedef:no_spaces             | 缓存文字禁止使用空格。                                       |
| haxedef:un_emoj               | 缓存文字禁止使用Emoj符号。                                   |
| haxedef:use_default_ui        | 使用zygameui-edit-server库时，在不存在任何UI的情况下，可以使用默认UI。 |
| haxedef:smoothing             | 启动平滑处理，默认禁用。                                     |
| haxedef:extsound              | 启动扩展音频API，将引用`zygame.common.Sound`以及`zygame.common.SoundChannel`等自定义音频协议。 |
| haxedef:disable_res           | 禁用R资源引用识别功能。（[资源引用参考](R.md)）              |



