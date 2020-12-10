## 引擎支持

经过版本的迭代，引擎相继越来越稳定，并有可视化UI编辑工具支持。

- 容器封装

  - 开发时，可不需要直接使用OpenFL的Sprite，可使用封装好，功能性更高的类型：ZBox、BBox、DisplayObjectContainer等。

- 屏幕适配

  - `zygame.core.Start`稳健的Start类已经提供了通用易用的适配方案，只需要在super接口进行简易配置即可：

  ```haxe
  public function new(){
    super(适配宽度,适配高度,是否显示调试信息);
  }
  ```

- 资源加载

  - 在开发中，我们不能直接使用OpenFL提供的Assets工具类，需要使用`zygame.utils.ZAssets`来管理我们的资源。

- Spine支持

  - Github的openfl-spine库目前内置于当前引擎中。支持三种渲染方式：
    - （1）Sprite渲染，性能良好；仅支持网格功能，不支持透明。
    - （2）Tilemap渲染，性能良好；不支持网格功能，但支持透明，改色。
    - （3）Sprite-native渲染，性能一般；但是支持透明、改色、网格等完整功能。

- Swflite

  - 支持使用Adobe Animate CC工具导出的SWF文件，并提供了zip加载方式。

- 功能组件化

  - 文本、列表、滚动栏等都添加了支持，并优化允许正常在小游戏中使用，参考代码包`zygame.components.*`。

- Tilemap触摸事件化

  - `zygame.display.batch.TouchImageBatchsContainer`直接支持Tilemap的触摸支持，并默认支持穿透点击，与原生OpenFL渲染层搭配使用。

- 精灵图

  - 支持使用精灵图，可通过`ZAssets`资源管理器进行加载，然后通过`ZImage/BImage`等类进行使用。

- Maplive地图编辑器（已弃用）

- ZYEditUI

  - UI可视化编辑器，可直接编辑XML配置文件实时预览界面，并支持PSD导出界面。

- KengSDK

  - 用于接入广告、支付、扩展等多种功能使用的SDK，可通过植入KengSDK进行使用。

- V2API

  - API功能最为完整的功能，于2020年10月份开始，V3API会陆续取代V2API；该API主要用于支持账号体系、用户存档、排行榜、数据统计等功能。

- V3API

  - 与2020年10月份开始整合，使用golang语言重构的服务器API，用于取代V2API。

- 自带着色器

  - 自带有灰度、描边、改色等着色器支持。

- 宏功能

  - 带有UI自动构造宏、数据自动构造宏等支持。

- 中文支持

  - 友好支持各个平台的中文显示。

- 音效支持

  - 在C++平台中使用ogg格式，在HTML5平台中使用MP3格式。（后续支持IOS、Android的MP3格式支持）