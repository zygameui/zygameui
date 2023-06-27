# 已知问题
- [已解决]当前OpenFL9.0.2版本，C++版本的文本支持异常。
- [已解决]Haxe4.2.0目前不兼容当前的OpenFL&Lime版本。
- [已解决]缓存字在9.1.0版本后显示失真。
- [未解决]quartOut在JS压缩的情况下，会发生问题。

# ZYGameUI 更新日志
### 13.0.23
- [新增] 新增`ZLabel`的`openInput`方法，主动打开输入框支持；
- [改进] 改进载入线程为10；
- [改进] 改进`haxe.Http`的加载实现，减少安卓的卡加载流程问题；
- [新增] 新增`SaveDataContent`对`isChanged()`数据是否有更改的API；

### 13.0.15
- [新增] 新增`ZButton`的XML配置支持；
    - `color`：文本颜色，参数：0xffffff
    - `offest`：文本偏移，参数：x,y
    - `storek`：stroke，参数：0xffffff
- [新增] 新增`xmlStyle`样式的支持；

### 13.0.14
- [新增] 新增`ZString`扩展字符串对象，自带常用的API。
- [改进] 改进`ZBuilderScene`的`onBuildedEvent`事件顺序流程。（回退）
- [新增] 新增`ZInt64`扩展64对象支持，可以使用内置的`div`,`mul`方法。
- [新增] 新增`DisplayObjectRecyclerPool.withClass`支持，使用`FListView`时，推荐使用该方法进行创建`DisplayObjectRecycler`对象，自带垃圾池实现。
- [新增] 新增`C++`目标的远程资源加载资源。
- [改进] 改进`FluxaySuperShader`支持叠加强度。
- [修复] 修复`BytesLoader`会多执行一次多余的`ofPath`接口。

### 13.0.8
- [增强] 增强`AssetsUtils`的图片和字符串载入功能，允许优先从Zip资源包中载入。
- [新增] 新增`ZLabel.onGlobalCharFilter`文本过滤支持，允许在赋值的时候，统一进行过滤（如翻译）。
- [修复] 修复`ZButton`按钮的事件可能可以连续触发的问题。

### 13.0.1
- [新增] 新增`QuadsBatchs`批处理性能改进对象。

### 13.0.0
- [新增] 新增`ZScroll`属性`disableMoveTouchEvent`，设置为`true`可阻拦点击事件。
- [新增] 新增`NullMacro`宏支持`?a.?b.?c`的处理。（Haxe4.3.0后就不需要了）

### 12.0.1
- [改进] 改进onInit触发会在addChild之后发生。
- [新增] 新增`getStage`方法直接获得舞台对象。
- [删除] 删除`MapliveLoader`加载器的支持。
- [新增] 新增`openfl-console`的支持，在xml中新增`<define name="openfl-console"/>`可开启。

### 12.0.0
- [里程碑] 新增`featherui`UI组件库支持。
- [新增] 新增`FUITheme`UI组件库。
- [新增] 新增`FListView`列表渲染组件。
- [改进] 改进Spine的`:`分隔符智能识别。
- [删除] 删除已弃用的实现`SoundUtils`、`SocketIOServer`、`CullingRenderUtils`。
- [兼容] 对BLabel、ZLabel的Align规范处理。

### 11.0.6
- [改进] 改进自定义适配分辨率的实现。
- [改进] 改进ZQuad的构造函数，允许传递宽、高以及颜色。
- [新增] 新增对xml格式中的align百分比支持：<ZImage top="40%"/>。
- [修复] 修复XML的load=true预加载会被解析ID类型的问题。

### 11.0.5
- [修复] 修复ZList.cache的缓存错误的问题。
- [新增] 新增`ZLabel.setFontSelectColor`方法可设置文本局部颜色或者大小等。
- [优化] 优化`ZSpine`的皮肤设置报错处理。
- [兼容] 兼容`ZSpine`无法创建Spine时的错误。
- [改进] 改进访问空的ids错误会有空预判。
- [改进] 改进`BLabel`空格字符的兼容。
- [修复] 修复ogg转换命令不会处理缓存文件的问题。
- [改进] C++不支持使用disable_dynamic_fps。
- [改进] 优化已释放的场景、界面的引用关系，引用关系不会直接丢失而产生报空的问题。
- [修复] 修复ZQuad/ZBox在宽高为0，0的时候渲染不正确的问题。
- [新增] 新增ZBox.autoSize自动尺寸的api。
- [改进] 改进onRender的渲染事件，在没有绘制的情况下，如果存在当前事件，则会请求刷新。
- [新增] 新增ZBuilder的XML配置<ZBox load="true"/>支持，设置load后，则仅加载相关配置，但不会添加到容器上进行渲染。
- [增强] 改进ZScene的场景替换时可以实时更新属性。
- [增强] 改进ZBuilder产生的场景，进行释放时，会主动释放ZImage的数据。
- [新增] 新增`GPUUtils`工具，用于统计GPU内存的使用。
- [增强] 增强`ZList`的`destroy`接口。
- [增强] 增强统一在`releaseScene`接口上调用`destroy`释放接口。
- [新增] 新增连信H5游戏导出支持。
- [新增] ZBuilderScene新增自适配分辨率支持。（可通过XML的hdwidth/hdheight属性设置适合当前页面的宽高）
- [修复] 修复haxelib发生线程泄露的问题。
- [改进] `ZImage`新增`ZBuilder`位图读取支持，可直接通过id赋值到ZImage中。
- [改进] 改进`ZButton`的clickEvent改为可读。
- [弃用] 不再支持OpenFL8，请直接使用OpenFL9。
- [改进] 改进`ZBuilder.buildui`的align性能。
- [新增] 新增`ZLabel.setFontLeading`设置文本的行距。
- [改进] 改进`FlowLayout`流布局的算法。
- [改进] 改进`ZBox`在addChild或者removeChild时调用updateComponents的流程优化。
- [新增] 新增`ZBox`的`fit`属性支持，设置为ture后，会自动适配全屏屏等特殊屏幕的基本适配。
- [新增] 新增`ZBuilder`的`parentBind`属性支持，设置true后，可以让父节点的宽高设置与当前UI一致。
- [改进] 改进`ZProjectData`依赖`AutoBuilder.firstProjectData`缓存宏构造性能。
- [修复] 修复在Windows上无法正确解析python的UTF-8字符的问题。

### 11.0.4
- [新增] 新增`disable_dynamic_fps`可用于禁用动态FPS，部分平台可能不支持，需要禁用（例如vivo小游戏）。

### 11.0.3
- [新增] 新增`ZImage.fillStageImage`铺满舞台背景的支持。
- [新增] 新增`ZStackMoveAnimateStyle.LEFT_RIGHT`从左到右的动画支持。
- [新增] 新增`ZTween.sync`参数，在动画标签的start不为0的情况下，又希望强制一开始准备的情况下，可设置。如果希望所有动态参数生效，则填写到ZTween标签上。
- [新增] 新增`ZImage.fill`属性，设置为true时，会自动铺满舞台。

### 11.0.2
- [改进] 改进`SpineManager`批处理逻辑顺序。
- [新增] 新增`ZSpine.isCache`缓存支持。

### 10.9.9
- [改进] 改进`DisplayObjectContainer.__update`的性能。
- [改进] 改进调试面板的CPU负荷值的真实性。
- [新增] 新增`Start.dynamicFps`动态FPS支持：动态FPS，如果开启动态FPS，在CPU超过负荷的情况下，会自动调为低频渲染，但主帧逻辑仍然使用60FPS运行，默认为true

### 10.9.7
- [改进] 改进IOS编译，多次编译不会修改原来已经编译过的结构。
- [改进] 改进切换成就可能会有黑屏的问题。

### 10.9.5
- [修复] 修复场景切换时，会引起Spine黑色渲染的问题。

### 10.9.4
- [兼容] 允许使用`cpu_particles`回退为CPU粒子。
- [安卓] 打包时会产生32位/64位的APK包。

### 10.9.3
- [改进] 优化FPSDebug.fps参数改进。
- [新增] 新增CPU占用量预判。
- [新增] 新增`ZButton.label`访问文本对象的变量。

### 10.9.2
- [新增] 新增`ZSpine.independent`独立帧率支持，不会受到锁定的速率影响播放频率。
- [更改] 默认启动`gpu_particles`GPU粒子渲染。
- [修复] 修复`ImportAllClasses`IOSXCode编译错误。
- [修复] 修复九宫格图渲染。

### 10.9.0
- [改进] 九宫格图优化。

### 10.8.8
- [64位] IOS与安卓都将编译为64位游戏。

### 10.8.6
- [修复] 修复`ZTween.tween`的运算问题。
- [修复] 修复`ZSceneManager`在切换场景存在释放资源先后循序错误的问题。

### 10.8.5
- [修复] 修复`ZParticles`无法被解析的问题

### 10.8.4
- [修复] 修复描边后无法收到透明度影响的问题。
- [修复] 修复SWF死循环的问题。
- [新增] 新增`GPU粒子`支持，将移动运算逻辑全部转移到GPU运算，减少CPU运算；支持读取通用的粒子特效文件。
    该功能仍在实验中，开启时需要定义：`<haxedef name="gpu_particles"/>`，定义后，`ZParticles`将直接使用GPU粒子支持。

### 10.8.3
- [修复] 修复输出Frame数据时会导致死循环的问题。
- [修复] 修复`ZTween.add`运算的问题。

### 10.8.2
- [新增] 新增`快手小游戏`平台编译支持。

### 10.8.1
- [改进] 改进ZScene的lockScene、unlockScene的接口。
- [改进] 改进九宫格图着色器在C++上的运行。

### 10.8.0
- [修复] 修复ZScene切换时，没有隐藏旧的Scene的问题。

### 10.7.9
- [改进] 改进`ZTween.loop`为-1时，则会无限播放。
- [新增] 新增`ZTween.scale`标签支持，使用scale标签设置的scaleX、scaleY会始终以宽高中心缩放。
- [新增] 为框架的对象新增`tween`的动画赋值，能够直接为对象设置动画。

### 10.7.8
- [改进] 改进`replaceScene`API，替换场景时，会加载完毕后进行切换，不再发生漏背景切换。
- [新增] 新增`ZStack.initAll`初始化所有组件的API。

### 10.7.7
- [改进] 改进`ZTween`的tween的动画支持。

### 10.7.6
- [改进] 改进`ZImage.onBitmapDataUpdate`事件在更换了图片就会触发。
- [修复] 修复`ZImage.shader`在异步图片上无效的问题。

### 10.7.5
- [改进] 改进`ZTween`的`quartOut`的兼容性，会自动转换为`quintOut`运算。
- [新增] 新增`ZScene.lock`以及`ZScene.unlock`锁定画面API，可用于提高性能。
- [新增] 新增`ZScene.isLock`判断是否锁定的API。

### 10.7.1
- [新增] 新增`Shapes.testRay`射线支持。
- [新增] 新增`zygame.shader.FlashShader`闪光效果支持。

### 10.7.0
- [新增] 新增`CacheAssets`缓存器，可用于实现异步缓存多张图片。
- [改进] `ZAssets.start`方法新了错误调用的crash处理。
- [改进] 改进`ZList.autoSize`的实现。

### 10.6.9
- [改进] 改进`ZList.autoSize`的属性支持。
- [修复] 修复小游戏的输入框会死循环的问题。

### 10.6.7
- [改进] 改进`ZList`支持Item自适配高宽渲染，设置`ZList.layout.autoSize=true`开启。

### 10.6.6
- [改进] 改进`ZTween`的动画类型支持，多达44种。

### 10.6.4
- [改进] 改进`GC`的空判断。
- [新增] 新增`FPSDebug`的`RETAIN`引用数量显示。

### 10.6.3
- [改进] 改进`AssetsUtils`的加载回调引用关系。
- [新增] 新增`GC`类，可用于引用变量。

### 10.6.2
- [改进] 改进`SpineManager`的渲染性能。
- [改进] 改进`ZSpine`的visible渲染性能。

### 10.6.1
- [新增] 新增`ZLabel.restrict`正则表达式支持。
- [改进] 改进skin可以直接使用字符串设置，将从ZBuilder绑定资源中获取纹理。
- [新增] 新增`ZScene.releaseScene`释放场景的API。
- [改进] 为Spine创建的时候提供了json错误检测。

### 10.6.0
- [新增] 新增Mp3转Ogg命令：`haxelib run zygameui -ogg 资源目录`。
- [修复] 修复九宫格的着色器在C++上的渲染问题。

### 10.5.9
- [移除] 移除spine包，改使用`openfl-spine`库。
- [改进] 场景API可直接返回当前类型的场景。
- [改进] 改进预加载API，会加载缺少的xml文件。

### 10.5.8
- [新增] 对`SpriteSpine`新增了遮罩渲染支持。

### 10.5.7
- [修复] 修复IOS的swf载入错误的问题。
- [新增] 新增对`<haxelib bind="true"/>`的`bind`识别处理，如果需要资源引入该库的include时，请开启`bind`属性。

### 10.5.5
- [兼容] 兼容Vivo快游戏的九宫格图渲染。

### 10.5.3
- [改进] 改进`BSpine`的空处理。
- [改进] 改进`BSpine`的性能。
- [修复] 修复九宫格的上、下、中的渲染异常的问题。

### 10.5.2
- [修复] 修复九宫格scale9rect缺失时的异常。
- [支持] 支持BScale9Image九宫格的GeryShader着色器。

### 10.5.1
- [改进] 改进`SpriteSpine`混合模式的兼容。
- [修复] 修复`SpriteSpine`在C++上的呈现问题。

### 10.5.0
- [弃用] 不再支持`SpriteSpine`的`isNative`渲染支持，默认失效；如果仍然有需求，请参考`multipleTextureRender`多纹理渲染支持。
- [改进] 新增了`SpineRenderShader`着色器，改进`SpriteSpine`渲染，目前已新增了透明度、BlendMode.ADD、颜色修改等支持（网格同时支持）。

### 10.4.9
- [着色器] 新增`CircleMaskGLSL`圆形遮罩支持。
- [着色器] 新增`RoundMaskShader`圆角遮罩，可以设置四个角的圆角大小。
- [着色器] 删除`TextStrokeShader`文本描边着色器，改使用统一的描边着色器`StrokeShader`，提高描边质量。
- [库管理] 上传时不带隐藏以及无用文件。
- [着色器] 改进九宫格图的性能，不再使用多个瓦片组成渲染，而是用GLSL实现九宫格渲染。
- [修复] 修复九宫图透明度不受影响的问题。

### 10.4.6
- [改进] 改进`ZAssets`的进度回调空处理。
- [改进] 使用`openfl-glsl`作为编写GLSL的主要库。
- [改进] 改进`ZUShader`的GLSL功能。
- [弃用] 弃用`ZUShader`，改进`OpenFLShader`包含了`ZUShader`的API。
- [新增] 测试性功能：新增`ImageBatchs`的`hitTestEnbled`支持，默认为true，禁用后整个`ImageBatchs`都可穿透。
    - 备用方法：如果需要穿透，套一个ZBox，然后设置mouseEnabled=false;

### 10.4.5
- [改进] 改进`TimeRuntion`的空处理。
- [改进] 改进`V3Api`在HTML5平台上对https/http的兼容。

### 10.4.4
- [新增] 新增地图编辑器`LDTK`支持，该地图编辑器是由《细胞重生》的作者开发。
- [改进] 改进`Start`的缩放精准度。
- [新增] 新增`Start.new`新参数`scalePower`，可固定缩放比例为整数作为间隔。
- [新增] 新增`ZImage.smoothing`可设置图片的是否平滑的支持。
- [新增] 新增`Image.smoothing`可设置图片的是否平滑的支持。
- [新增] 新增`ZAssets.loadAsepriteTextureAtlas`加载，可用于加载Aseprite生成的精灵图文件。
- [弃用] 弃用`Lib.resumeCall`：该resumeCall接口已弃用，但仍然兼容可用，它的效果与renderCall一致，请使用renderCall接口。
    - resumeCall会有渲染异常的问题，可直接调用renderCall。

### 10.4.3
- [新增] 新增`ZBitmapLabel.getCharBounds`获取字符的位置尺寸API。
- [新增] 新增`ZLabel.getCharBounds`获取字符的位置尺寸API。
- [改进] 改进`ZBuilber`对`text`属性排序到最后。

### 10.4.2
- [改进] 改进`ZAnimation`播放一次结束后将保持在最后一帧。
- [修复] 修复文本显示区域不完整的问题。

### 10.4.1
- [新增] 新增`ZScroll.onScrolling`实时滑动侦听。
- [改进] 改进C++的文本渲染。

### 10.3.8
- [修复] 修复`ZBuilder.buildui`创建子XML时赋值会影响到原来的XML数据的问题。

### 10.3.5
- [兼容] 兼容Haxe4，全面弃用`Std.is`更改为`Std.isOfType`。
- [新增] 新增`ZCacheBitmapLabel`缓存文字渲染支持（测试性功能）。
- [改进] 移除`BStack`的日志。

### 10.3.4
- [新增] 新增`BStack`实现，与`ZStack`功能相同，但是暂没有切换效果支持。

### 10.3.2
- [改进] 改进背景音乐可能会重叠播放的问题。
- [改进] 改进`ZBuilderScene`的xml文件缓存读取。
- [新增] 新增`ZAssetsUtils.preload`API，可用于预加载XML配置。
- [改进] 改进`ZAssets.start`如果加载资源是空的会立即返回成功。
- [API变更] `SoundChannelManager.current()`变更为`SoundChannelManager.current`。
- [新增] 新增`SoundChannelManagerEvent`事件，可以对`SoundChannelManager`进行侦听背景音乐停止与恢复时机。

### 10.3.1
- [改进] 改进`ZButton.text`的XML配置变为同步。
- [改进] 改进`ZLabel.textHeight`的动态计算逻辑。

### 10.2.9
- [改进] 改进`ZLabel`在高度不足时，自动扩展高度的计算。
- [新增] 新增`ZSceneManager.replaceHistoryScene`返回上一个场景方法，仅支持记录5个场景记录。
- [改进] 改进`ZSceneManager.replaceScene`新增isHistory是否允许列入历史场景中，默认为true。
- [删除] 删除文本的深度清理功能，该功能会有一定的性能影响。
- [新增] 新增`ZScene.replaceHistoryScene`方法
- [改进] 优化单图载入的资源。

### 10.2.8
- [兼容] 兼容IOS和安卓的`openfl-disable-graphics-upscaling`在OpenFL9的表现。
- [新增] 新增自动导入类型宏：`@:build(zygame.macro.ImportAllClasses.build("源代码路径"))`。
- [新增] 优化字体的内存使用，低端分辨率的游戏，可使用`high_label`开启高清字体，但使用1980p的游戏不再需要使用。
- [兼容] 安卓仅生产v7文件。
- [修复] 修复`ZSound`播放会失效的问题。
- [改进] 改进`ZBuilderScene`当无法加载时，会自动移除，避免卡死。

### 10.2.7
- [修复] 修复`ZSound.stopAllSound()`无效的问题。

### 10.2.6
- [兼容] 已支持`swf3.0.2`版本。
- [注意] SWF已支持`OpenFL9.1.0`，但SWF需要全部生成。

### 10.2.5
- [改进] 对`TilemapSpine`新增`SpineEvent`侦听支持。
- [新增] 批渲染容器新增事件支持。
- [兼容] 与`openfl9.1.0`兼容，主要更新内容如下：
    - [支持] 支持最新的Haxe4.2.x版本。
    - [新增] 新增`ServerSocket`以及`DatagramSocket`本机功能。
    - [新增] 新增`ObjectPool`对象池功能。
    - [改进] 改进`TextField`的性能以及缓存渲染，这将恢复了引擎文字缩放效果。
    - [改进] 改进了`TileContainer`的嵌套性能，这将提高了批渲染对象的性能。
    - [修复] 修复了一些矢量渲染的问题。
- [兼容] 与`lime7.9.0`兼容。
- [兼容] 与`hxcpp4.2.1`兼容。
- [修复] 修复`ZHaxe`的方法访问。
- [兼容] 弃用`Std.is`改使用`Std.isOfType`。
- [功能缺陷] 新版本的SWF可自动转为zip，但因格式未兼容，因此OpenFL9.1.0版本暂无法使用SWF功能。

### 10.2.4
- [新增] 正式引入粒子效果库到zygame库中，不再需要引入`zparticles`;
    - 注意：旧版本和新版本的使用可能存在差异，请参考文档使用。
- [新增] 新增`ZParticles`粒子组件功能，可在XML中直接配置`<ZParticles src="粒子图片名称:粒子JSON名称"/>`直接使用。

### 10.2.2
- [改进] `ZLabel.bold`新增加粗字体的支持。
- [改进] 改进`classed`的XML属性识别，可不需要ZBuilder.bind就可以确定类型。
- [改进] 改进`classed`不解析无效的ID变量。
- [改进] 改进`ZQuad`的透明值效果不一致的问题。
- [改进] 改进`ColorShader`的透明效果与实际匹配。

### 10.2.1
- [保留] 避免丢失大部分有用信息，保留了trace的输出。
- [改进] `ZLabel.stroke`改进了描边效果，游戏可使用质量较高的描边效果，白色字体+任意颜色描边效果最佳。

### 10.1.9
- [改进] 改进对`ZShader`的支持，发生异常不会造成游戏卡死的问题。
- [修复] 修复`ZBuilder`对ZInt的属性赋值异常的问题。

### 10.1.8
- [新增] 新增XML属性`classed`，需要布局绑定类型时，则可以使用这个属性，填入包类名后将会解析成绑定的类型。
    ```xml
    <!-- 同时在使用classed时，可不需要ZBuilder.bind进行绑定，但要确定类型导入 -->
    <!-- 指向WechatView类 -->
    <ZBox classed="game.wechat.WechatView"/>
    ```
- [删除] 删除`ZBuilder`的缺省UI功能。
- [改进] 改进`ZSpine`支持${}读取。
- [新增] 新增`ZList`的`selectIndex`选择索引支持。
- [修复] 修复`ZBuilder`对包名类识别的问题。
- [修复] 修复`Spine`的`timeScale`实现相反的问题。

### 10.1.7
- [新增] 新增`EffectUtils`工具包，可统一为显示对象添加呼吸效果。
- [新增] 新增`Music.toMusic`功能，可以将Sound转换为Music，当做背景音乐使用。
- [修复] 修复`Spine.isPlay`返回不正常的问题。
- [修复] 修复`BAnimation`无法正常播放动画的问题。

### 10.1.6
- [改进] 改进`ZSound`的播放以及释放处理。
- [新增] 新增`ZSound.stopAllSound`方法来释放所有`ZSound`音频。
- [改进] 改进`FPSDebug`会根据分辨率自动适配。
- [改进] 改进`FPSDebug`遮挡点击问题。
- [改进] 改进舞台的尺寸获取时机。

### 10.1.5
- [修复] 修复`topView`没有适配强制横屏功能的问题。
- [改进] 新增JPG资源载入支持。
- [修复] 修复ZStack样式切换父节点空判断。
- [新增] 新增`FrameEngine.stopAllFrameEngine`支持所有帧事件引擎停止。
- [新增] 新增`ZSound`功能组件，可以在XML配置中添加音效，并可以配置节奏播放。
- [新增] 新增`ZButton.sound`音频播放设置。
- [新增] 新增`BButton.sound`音频播放设置。
- [新增] 新增`ZButton.defaultSound`静态变量设置默认音频播放设置。

### 10.1.4
- [修复] 修复`ZStack`第一次设置currentId时，无法发生切换效果的问题。
- [新增] 新增`ZBuildScene.assetsBuild.onProgress`侦听资源加载进度。
- [修复] 修复`Spine`修改动画后的状态同步问题。
- [修复] 修复`Spine`的`isPlay`状态不准确的问题。
- [改进] 改进`AutoBuilder`支持jpg格式图片加载。 

### 10.1.3
- [改进] 改进`FPSDebug`的信息栏显示。
- [改进] 改进`Spine`的`advanceTime`性能。
- [改进] 改进`ZStack`的渲染性能，无用的对象会直接移除。

### 10.1.2
- [修复] 修复`ZStack.currentId`在XML中配置不会立即生效的问题。
- [新增] 新增`ZStackAlphaAnimateStyle`透明渐变过渡效果。
- [新增] 新增`ZStackMoveAnimateStyle`位移过渡效果。

### 10.1.1
- [新增] 新增对ZSpine.native的支持，可以使用Spine的原生渲染。
- [优化] 优化了Spine侦听器，可以直接侦听Spine.addEventListener(SpineEvent.EVENT,_)；
- [新增] 新增`ZStack`页面管理组件，可直接使用currentId来决定显示什么组件内容。

### 10.0.9
- [新增] 新增对AutoBuilder自动构造支持子XML载入。
- [新增] 新增对子XML读取，如果父节点设置了id，子XML会自动追加。

### 9.9.3
- [修复] 修复在舞台发生变化时，`topView`不会同步缩放比例的问题。
- [兼容] 兼容meizu-rpk-core的index.html编译。

### 9.9.2
- [新增] 新增`electron`目标编译支持。
- [新增] 新增`Lib.renderCall()`在渲染事件发生时进行回调。
- [兼容] HTML5使用设备的分辨率比，避免部分电脑发生卡顿问题。
- [新增] 新增`ZGraphics.checkIn`检查当前点是否已经绘制过内容。

### 9.9.1
- [改进] 微信小游戏库自动引入，编译微信、手Q、4399盒子等小游戏时，会自动引入`wechat-zygame-dom`库。
- [改进] vivo/oppo/huawei/xiaomi等库会自动引入。
- [兼容] 兼容hashlink虚拟机支持。
- [新增] 新增hashlink编译平台。
- [修复] 修复hashlink的应用宝无法正常直接启动的问题。

### 9.8.8
- [改进] 优化inittask命令可以保留自定义命令。


### 9.8.7
- [新增] 新增`haxelib run zygameui -inittask`用于更新编译命令列表。

### 9.8.3
- [改进] 改进魅族小游戏打包流程。

### 9.8.2
- [改进] 升级上传接口为OSS直接上传。
- [新增] 新增ExtendDynamic防CE内存修改器支持，可使用`:ce`元数据给Int类型添加防CE修改支持。

### 9.7.3
- [新增] 新增对梦工厂包编译的支持。

### 9.7.2
- [优化] Sprite-Spine新增`isCache`缓存API，可用于缓存Spine动画，以便减少CPU的使用率。
- [修复] 修复动态纹理无法正常载入的问题。
- [优化] 优化载入进度流程。

### 9.7.1
- [新增] 新增`FluxaySuperShader`流光着色器支持（在不需要的时候，请调用dispose）。
- [优化] Spine性能优化：time重置。

### 9.7.0
- [新增] 可以通过Frame精灵图或者BitmapData对象，直接赋值到ZImage3D显示。
- [修复] 修复ZAssets会发生空载入的问题。

### 9.6.9
- [新增] `ZAssets`新增设置3D载入器方法。
- [优化] 优化ZAssets的ParserBase解析流程。
- [修复] 修复ZAssets的小游戏无法载入分包内容的问题。

### 9.6.8
- [兼容] 兼容ogg格式载入。
- [新增] 新增OpenFL9版本支持（SWF功能受限/升级/旧版本不兼容）。
    - 已知缺陷：
        - BLabel无法正常渲染。(修复)
        - ZLabel无法正常设置文本格式。(修复)
        - FPSDebug没有正常渲染。(修复)
        - SWF受限，暂不支持。
        - gl_stats受限，暂无法统计drawcall。(可用)
        - C++可用性确认。(可用)
- [兼容] 兼容Haxe4，移除旧__js__语法。
- [移除] 移除API协议相关接口，转使用`zygameui-api`库。

### 9.6.7
- [新增] 新增`KnifeLight`刀光效果支持。
- [优化] 优化登录/注册的统计计算。
- [重构] 重构资源管理加载器，可以自行通过扩展`ParserBase`来实现自定义载入，并优化了进度细化。
- [新增] 新增3D粒子特效支持`SparticleParser`，通过loadFile直接载入。

### 9.6.6
- [新增] 新增`haxelib run zygameui build wifi`的打包方式：WIFI无极小游戏环境。
- [新增] 新增`<define name="version" value="1003"/>`来定义当前游戏版本号。
- [新增] 新增`Base64TextureLoader`用于加载内嵌精灵图支持。
- [新增] 新增`AssetsUtils.loadBitmapData`对base64位的图片加载支持。
- [新增] 新增`ZMacroUtils.loadEmbedTextures`用于加载嵌入式资源，资源会被嵌入到JS文件中。

### 9.6.4
- [兼容] spine-hx默认使用3.6.0版本，需要使用3.8+版本需要定义`<define name="spine3.8"/>`。
- [修复] 修复spine翻转显示不正确的问题。

### 9.6.3
- [新增] 新增C++崩溃时附带一些有用的信息。

### 9.5.7
- [新增] 新增BSpine可被点击支持。
- [新增] 新增BButton在没有皮肤的情况下，会有点击缩放反应。

### 9.5.4
- [新增] 新增AssetsUtils.failTryLoadTimes加载重试次数支持，默认重载3次。
- [支持] Sound/BitmapData(HTML5)/Text等加载支持重载次数，BtimapData暂不支持C++。
- [新增] 新增4399快游戏编译支持。

### 9.3.2
- [调整] 取消全局平滑，提高性能，并提高画面感。

### 9.2.8
- [修复] 修复ZList的横向ListData的渲染问题。
- [调整] Image的宽度可能会有不兼容frameWidth/frameHeight的问题。
- [兼容] 增加AutoBuilder更多的类型兼容。
- [兼容] 增强AutoBuilder对多级继承关系的支持。

### 9.2.7
- [优化] `BLabel`的updateText接口在`ZBuilder`创建下同步化。
- [优化] `BLabel`的宽度高度在为0的情况下，会使用textWidth/textHeight。

### 9.2.6
- [新增] 新增`ScaleMaskShader`缩放性遮罩支持。
- [新增] 新增`BRotateImage`兼容旋转精灵表支持。

### 9.2.5
- [新增] 新增`ExtendsDyanmic`自动构造set/get方法。
- [优化] 优化`JSONData`对变量属性添加文档支持。
- [优化] 优化`haxelib run zygameui -xls`命令对变量属性添加文档支持。

### 9.2.4
- [新增] 新增`AutoBuilder`自动构造宏，可以自动创建依赖`ZBuilder`创建的布局，同时可直接使用变量引用配置中的成员；并会自动配置资源的加载流程。

### 9.2.3
- [新增] 新增`JSONData`宏构建，可以自动创建数据格式类型。

### 9.2.1
- [优化] 优化瓦片Spine批渲染的骨骼渲染处理。
- [新增] 新增`MAX_LOAD_COUNT`宏，控制`ZAssets`最大同时加载数。
- [新增] 新增XML格式异常加载反馈。

### 9.2.0
- [新增] 新增BLabel、BImage对SpineTextureAtlas纹理渲染的支持。
- [新增] 新增ZAssets.getBitampData("Spine纹理名:xxxx")。

### 9.1.6
- [新增] ZModel.fontSize调整字体大小。

### 9.1.3
- [新增] 新增腾讯IP位置获取API。
- [新增] 新增ZButton九宫格绑定支持。

### 9.0.7
- [新增] 新增`Cmnt.getIp`获取用户IP接口。

### 9.0.6
- [优化] 优化BAnimation的ZBuilder多图解析支持，优化内部API。
- [自动化] 新增九宫格图自动化，请在图片命名前面定义`s9_`。

### 9.0.5
- [优化] 优化九宫格`scale9rect`属性允许二次修改。
- [新增] 新增Builder.disopView()释放资源和窗口。 
- [新增] 新增ZAnimation的ZBuilder解析支持，优化API。

### 9.0.4
- [兼容] 兼容IOS的数据统计处理。
- [兼容] 兼容IOS的输入框无法正常输入的问题。
- [修复] 修复批渲染对象点击触发多次的问题。
- [修复] 修复批渲染对象点击会穿透的问题。

### 9.0.2
- [新增] 新增`Cmnt.getCity`获取位置属性支持，支持位置缓存，可频繁调用，当有缓存时会直接返回缓存位置。
- [优化] 优化排行榜接口，新增了一个pname的别名数据，可用来区分省份、城市等排行榜作用。
- [新增] 新增IOS渠道标示。
- [新增] 新增`Lib.getVersion`统一获取版本号的支持。

### 9.0.1
- [新增] 新增`TCP`协议帧同步支持。

### 9.0.0
- [新增] 新增`UDP`支持，可用于发送UDP消息，支持C++/HTML5平台（HTML5平台需要NWJS框架支持）。
- [新增] 新增`ZModel`模态弹窗支持，内置showTextModel支持，可用于弹出简易的消息使用。
- [新增] 新增`GameServerManager`帧同步服务器API支持，v0.0.1版本，未完整完成。
- [新增] 新增`OnlineUserData.clearSharedObject`清理存档支持。
- [新增] 新增`Cmnt.reportInvitationByCode`邀请码上报接口。
- [新增] 新增`Cmnt.getInviteCode`获取当前用户邀请码接口。

### 8.9.8
- [优化] 优化瓦片的触摸性能。

### 8.9.6
- [新增] 新增`SkeletonSprite`tilemap渲染支持点击。
- [新增] 新增`FPSDebug`对Spine的侦听数查看。

### 8.9.3
- [新增] 新增`differ`不规则碰撞块库支持，该库无引擎支持，可支持纯圆形、不规则、射线等功能。
- [新增] 新增`zygame.differ`包，用于支持`differ`碰撞系统。（[参考文档](zygame-md/zygame/differ/碰撞系统.md)）
- [新增] 新增`zygame.differ.Shapes`图形碰撞系统，可用于管理碰撞处理。
- [新增] 新增`zygame.differ.DebugDraw`图形调试画布，可用于测试`differ`的碰撞画面，支持小游戏渲染。
- [升级] 升级`GameUtils`对KengSDKv2后台的关卡统计实现，为`gameStart`/`gameWin`/`gameOver`等方法新增第三个参数`levelSerial`；levelSerial请传入关卡顺序。

### 8.9.1
- [新增] 新增`GameUtils.start`以及`GameUtils.loaded`接口，用于统计首屏所需资源加载所需时长。

### 8.9.0
- [新增] 新增编译命令执行错误后，将直接编译失败，需要确保编译命令正常，这将可以自行实现编译前的基本单元测试。
- [新增] 新增CDB数据格式支持，可以使用CastleDB工具来提升表格编辑效率。

### 8.8.7
- [兼容] 兼容HTML5平台安卓输入框显示。
- [新增] `ZButton`新增`clickEvent`支持，与`BButton.clickEvent`使用方法保持一致。
- [修复] 修复Image移除舞台时，不会同时移除刷新器的问题。
- [修复] 修复Spine播放空白帧的时候，会引起内存泄露的问题。

### 8.8.5
- [修复] 修复MapliveLoader加载的失败回调无回调的问题。
- [新增] 新增HTML5平台的输入支持，修复原OpenFL不支持输入中文的问题。
- [兼容] 兼容HTML5平台手机输入框。

### 8.8.2
- [优化] 优化Spine的数组创建处理。
- [修复] 修复ZImage无法正确获取shader的问题。
- [修复] 修复MapliveLoader加载器的错误回调处理。

### 8.7.6
- [优化] 调整FPS锁帧60，即便120FPS的玩家也会体验到60FPS的体验。

### 8.7.5
- [优化] 优化暂停、恢复时背景音乐恢复处理。
- [弃用] 弃用`Cmnt.initCore`接口，改使用`Cmnt.initGroup`方法。修改原因：不再强制需要初始化group，内部渠道号会自动通过`Lib.getChannel`获取。

### 8.7.4
- [新增] 新增MapliveData数据加载进度侦听。

### 8.7.3
- [修复] 修复ZInterp在CPP运行存在的一些问题。
- [兼容] 兼容MessageSystem.send接口支持扩展动态类型参数。

### 8.7.2
- [修复] 修复unapi下错误日志会发生异常的问题。
- [优化] 优化FrameEngine接口。

### 8.7.0
- [兼容] 兼容使用URL的H5底层支持。
- [修复] 修复getBounds的无法获取scale<1的比例方块。
- [更新] 更新getNickName获取昵称的接口为v2接口。

### 8.6.3
- [新增] 新增REMOTE_PATH远程地址宏的支持：`<define name="REMOTE_PATH" value="网络地址"/>`。
- [优化] 使远程访问不再限制只在小游戏中生效，HTML5中也可以用。

### 8.6.2
- [移除] 移除旧版本用户数据读取的支持。
- [修复] 修复ZLabel、Spine触摸时产生的错误。
- [优化] 优化内置小游戏对:的解析处理。

### 8.6.1
- [新增] 新增`SoundChannelManager`音频管理器，用于管理游戏的全局音频，如停止所有音频、静音、停止背景音乐、恢复背景音乐等点功能。
- [兼容] 兼容ZLabel的宽度显示设计。

### 8.5.4
- [新增] 新增`ZBuilder`全局定义支持。
- [修复] 修复了`ZLabel`的默认文本不会居中的问题。
- [修复] 修复了`ZLabel`的触摸范围不正确的问题。

### 8.5.2
- [修复] 修复API请求的错误统计，会统计到正常请求的API问题。
- [新增] 新增`SpineManager.enbed`可禁用自带的帧事件处理。
- [新增] 新增`FrameEngine`帧驱动功能，可以快捷得独立建立一个帧驱动事件，执行一段自定义逻辑。

### 8.4.9
- [新增] 新增`Lib.getRenderMode`方法获取渲染模式。可用此识别是否使用webgl渲染。
- [新增] 新增`ZImage`默认支持读取九宫格数据。
- [优化] 优化`ZTween`的add过渡计算。
- [新增] 新增`ZTween.nextFrame/lastFrame`支持。

### 8.4.8
- [新增] 新增API访问异常的错误统计。

### 8.4.5
- [修复] 修复一系列语法解析处理。
- [新增] 新增reportErrorLog错误统计接口。
- [新增] 新增API请求、资源加载错误统计。

### 8.4.1
- [修复] 修复`function main(){}`的方法格式解析错误问题。
- [修复] 修复`array[0]`数组访问的解析错误问题。
- [修复] 修复`for(i in arg.length)`的属性访问错误问题。
- [修复] 修复4399平台无法正常储存的问题。
- [修复] 修复`!att`感叹号语法没有正常解析的问题。

### 8.3.6
- [修复] 修复HaxeScript对switch的支持。
- [新增] 新增内置引擎编译命令，能够指定生成位置。
- [优化] 优化内置引擎的创建流程，灵活使用。
- [优化] 优化内置引擎的释放处理。

### 8.3.0
- [兼容] 调整SoundChannel接口，ZAssets.playSound返回的类型统一为`zygame.media.base.SoundChannel`，编码不再需要extsound做区分。(注意需要更新兼容性)
- [兼容] 调整`wechat-zygame-dom`库为自动引入。
- [新增] 新增Maplive.ZMaliveAssets支持，用于支持纹理图集的查找读取。
- [回归] ZBitmapData的纹理优化回归处理。

### 8.2.9
- [兼容] 兼容OpenFL8.9.6的触摸异常问题。
- [修复] 修复编译ZBitmapData方法缺失的问题。
- [修复] 修复小游戏的缓存字渲染问题。
- [修复] 修复多次渲染缓存字异常显示问题。

### 8.2.7
- [新增] 调整FPSDebug在顶部。
- [优化] 优化纹理释放处理。
- [修复] 修复缓存字纹理内存使用过大的问题。
- [修复] 修复部分BitmapData无法正常释放纹理的问题。

### 8.2.6
- [修复] 修复ImageBatch使用Font纹理会发生异常的问题。
- [新增] 新增默认载入hx文件为文本格式。

### 8.2.5
- [新增] 新增`Lib.angleToRadian/radianToAngle`等弧度角度换算方法。
- [新增] 新增`Lib.getChanenl`对`huawei`渠道的支持。

### 8.2.4
- [新增] 新增`Cmnt.checkSensitiveWord`敏感词检测API。
- [新增] 新增`Cmnt.updateUserInfo`增加了敏感词检测API。

### 8.1.8
- [优化] 优化SharedObject不再立即初始化，避免部分快游戏渠道会引起问题。

### 8.1.0
- [优化] 优化ZQuad的位图准备好之后才进行onInit。
- [新增] 新增ZTween对loop循环次数的支持。
- [优化] 优化ZBuilder对ZTween的释放。
- [优化] 优化ZButton对content的宽高动态设置的处理。
- [优化] 优化ZQuad边边存在露馅的情况。
- [修复] 修复ZQuad的初始化事件没有全面覆盖的问题。
- [优化] 优化Lib.getChannel对奇虎360的渠道标示（qihoo）识别。
- [新增] 新增`trace`宏定义控制在final情况下保留trace语句。
- [新增] 新增`ZBuilder.removeDefine`用于删除全部编译定义使用。
- [删除] 删除库中的trace语句。
- [修复] 修复批渲染对象visible=false时，仍然可以被点击的问题。

### 8.0.4
- [修复] 修复输入文本的光标显示默认没有跟实际文本同步的问题。
- [优化] 优化在线数据，支持1层原生类数据格式。

### 8.0.3
- [解析器] 优化XLS的解析器，解析不是xls的文件会自动跳过。
- [修复] 修复hAlign/vAlign的初始值不正确的问题。
- [新增] 新增ImageBatch支持平滑属性。

### 7.9.6
- [优化] 优化UserData初始化时机提前，不依赖Cmnt.init初始化而初始化，应用启动时主动初始化。
- [优化] 发布`final`正式版的时候，将不再输出log。
- [兼容] 兼容IOS的ZMacroUtils.readFileContentBase64以及readFileContent接口，并更改为强制异常报错。
- [强制] 添加ZMacroUtils.getHttpContent更改为强制异常报错，如接口不是200时会无法编译成功（依赖网络的接口，如断网的情况下，则无法正常编译。）。
- [修复] 修复`BScale9Image`在没有精灵表数据的情况下，getBounds返回null的问题。
- [新增] 新增`loginByOpenID`用于登录OpenID。
- [新增] 新增`Cmnt.userData`对游客逻辑处理。

### 7.9.5
- [新增] 新增`NativeZBitmapLabel`在XML配置中的支持。可通过`<haxedef name="native_label"/>`将ZBitmapLabel转化成ZLabel。

### 7.9.3
- [新增] 新增`ZImage`对XML配置的本地路径读取支持。
- [新增] 新增`vAlign`、`hAlign`的对齐属性读取与设置。
- [新增] 新增`ZImage`的`alignPivot`支持。

### 7.9.2
- [修复] 修复BAnimation设置动画会发生异常的问题。

### 7.9.1
- [修复] 修复android无法编译的问题。
- [新增] 新增阿拉丁（alading-sdk）统计支持。

### 7.8.6
- [新增] 新增cp指令`all`，允许全部平台拷贝。
- [修复] 修复Cmnt.updateUserInfo接口不会刷新名字的问题。
- [修复] 修复`clear`删除不存在的资源或者目录时会发生异常的问题。
- [修复] 修复`OnlienUserData`用户数据会丢失的问题。
- [新增] 新增XML对ZInputLabel的文本颜色设置支持。

### 7.8.0
- [新增] 新增`MiniEngine`内置应用引擎支持，可用于实现热更式内置小游戏、功能页面等。
    - 核心功能支持
        1、支持定义任意类型变量（不区分private/public）。
        2、支持方法访问。
        3、支持资源（普通图片、JSON、XML、精灵表）。
        4、支持zygameui下的所有功能。
        5、支持使用new语句。
        6、支持自定义扩展类型（仅可以继承ZExendt组件，同时支持new传参实现，但是不支持super级别传递）。
        7、支持Haxe语法。
        8、支持Import导入类型。
        9、支持方法传参。（最大5个参数）
        10、支持每个类统一的资源读取。
        11、支持静态属性访问。
        12、支持静态方法访问。
- [新增] 新增批渲染对象对onInit初始化支持。
- [新增] 新增批渲染对象对onFrame帧事件支持，可以使用`setFrameEvent`方法进行启动。
- [新增] 新增批渲染对象可以直接访问到getStageWidth、getStageHeight方法。
- [新增] 新增`ZGC.disposeFrameEvent`方法用于批量移除setFrameEvent启动的事件。 
- [优化] 优化背景音乐为静态变量，可独立使用。
- [弃用] 放弃对Haxe3.0的支持，请使用稳定版的Haxe4.0。
- [修复] 修复魅族编译会发生异常错误的问题。
- [兼容] 兼容小米库没有`addEventListener`方法的问题。

### 7.7.9
- 【Bate】新增：ATF编译命令，不稳定，暂不能使用。

### 7.7.8
- 修复：修复ZAssets加载多次后无法加载的问题。

### 7.7.7
- 新增：新增360编译支持`haxelib run zygameui -build qihoo`。
- 优化：强制禁用Blob支持。

### 7.7.6
- 修复：修复`Lib.setTimeou`、`Lib.nextFrameCall`等方法调用循序不一致的问题。

### 7.7.3
- 优化：为BLabel添加keep标示。
- 新增：MessageSystem新增removeAllMessage接口。
- 删除：API不再做容错判断，
- 优化：`ZImage`当是异步载入时，重新赋值时，会删除上一次位图。

### 7.7.0
- [优化]`wechat-zygame-dom`使用编译命令编译时，会自动引入。
- [新增]`ZMacroUtils`新增`readFileContentBase64`读取二进制Base64实现。

### 7.6.7.bate
- [bate]Shader着色器实时编辑器。
- [bate]新增`ZShader`着色器支持，可读取XML配置的着色器。
- [新增]新增`qihoo`编译奇虎360小游戏目标。

### 7.6.6
- 优化`TextureAtlas.bindScale9`性能，绑定时不会产生`Frame`，在使用时才会创建。

### 7.6.1
- HTML5：新增visibilitychange事件的处理。
- 资源管理：新增允许资源在无法加载的情况下，仍然继续完成加载。
- 变更StringUtils.getName的实现，最后获取的没有带.的会直接返回原始url路径。
- 新增OnlineUserData强制上传覆盖数据接口。

### 7.6.0
- [bate]新增visibilitychange事件的处理。

### 7.5.9
- 新增`shell`命令`after`属性处理，允许命令在编译结束后处理。
- 新增HTML5通用编译命令，使用方法：`haxelib run zygameui -build html5:渠道名`。

### 7.5.8
- 新增`ZBuilder`对宏判断的支持，自动导入`-D``<define/>``<haxedef/>`定义。

### 7.5.7
- 优化`OnlineUserData`用户储存为base64格式。

### 7.5.6
- 修复`BLabel`居中在缩放后计算不正确的问题。

### 7.5.5
- 新增`BScale9Image`在XML配置中可以直接设置九宫格参数。
    - 基础用法：`<BScale9Image src="A:B:九宫格参数" />`。
- 取消了`ZImage`对`openfl.Assets`的支持。

### 7.5.3
- 编译：新增`<copy path="需要拷贝文件路径" rename="最终修改路径">`。
- HTMl5回退ZSceneManager为7.4.8行为。

### 7.5.0
- Dictionary在Haxe4.0不稳定，不推荐使用。
- `ZSceneManager`不再使用Dictionary，改使用Map。
- `ZAssets`不再使用Dictionary，改使用Map。
- `ZAssets`恢复IOS的加载线程为5。
- 修复`js`包异常使用。

### 7.4.9
- 修复`ZBitmapLabel`以及`BLabel`在没有赋值的情况下会显示null的问题。

### 7.4.8(bate)
- 调整：批渲染对象的高宽使用底层的width/height获取。
- 弃用`curWidth`以及`curHeight`属性，请直接使用`width`以及`height`。
- 使用底层更加精准的宽高。

### 7.4.7
- 新增`DynamicTextureAtlas`动态纹理支持，能够将散图通过加载成一个动态纹理精灵图集。

### 7.4.6
- 修复`haxelib run zygameui -build html5`对`html5-platform`宏的支持。
- 支持`ZBuilder`对多个assets资源库的读取。
- 修复BImage的实际高宽获取错误的问题。
- 新增`BAnimation`批渲染动画对象支持。
- 新增`ZGC.disposeTileRefresher`用于清理Tilemap批渲染中的刷新器。
- 优化Spine对透明度的支持。

### 7.4.5
- 新增`haxelib run zygameui -build huawei`编译华为快游戏命令支持。

### 7.4.4
- 修复include标签无法正常判断的问题。
- 新增`clear`标签，可用于清理导出来资源不再需要的资源，使用方法：
    - 用法：`<clear path="需要清理的目录" igone="忽略路径,忽略路径"/>`

### 7.4.3
- 新增`Lib.isPc()`判断是否为电脑、返回false则为移动设备。
- 优化`xiaomi`小米平台的编译流程。

### 7.4.0
- 升级编译命令，新增include标签支持，能够读取include标签的配置。
- 优化ZBitmapLabel在ZBuilder能够读取Text缓存字的实现。
- 新增`AssetsBuilder`类，用于支持`ZBuilder`异步载入。

### 7.3.8
- 新增`zygameui -build`命令运行时宏定义支持。

### 7.3.7
- 新增`haxelib run zygameui -build oppo`支持。
- 新增对`oppo`快游戏的分包加载支持。
- 修复`ios`平台的载入闪退问题。

### 7.3.6
- 移除`ZTween.pause`方法实现。
- 优化`ZTween.play`方法实现。
- 修复`haxelib run zygameui`运行命令的问题。

### 7.3.5
- 新增`zygameui`编译命令对自定义脚本的支持。
    - 使用方法，如：`<shell command='echo 命令'/>`

### 7.3.4
- 删除`vivo`的BLabel文字偏移支持。
- 新增`NativeZBitmapLabel`支持，能够在缓存字不可用的情况下，使用ZLabel。
- 修复`ZTween`过渡参数不支持浮点数的问题。
- 修改`ZAssets.loadText`的实现。
- 修复`ios`在`zygameui:7.3.0`以后版本无法正常加载资源的问题。

### 7.3.2
- 新增`UploadAPI`通用的上传API接口（目前仅支持微信小游戏）。
- 修复`C++`目标无法加载网络图片资源的问题。

### 7.3.1
- 新增`nape`宏，可使用该宏引入`nape`库，同时支持`zygame.nape.NapeDebug`来渲染调试画面。
    - 使用的是zygameui的绘图类，能够在小程序中渲染。
- 新增`MessageSystem.onMessage`支持，可以用于侦听消息回调处理。
- 新增`facebook`平台编译，编译命令：`haxelib run zygameui -build facebook`。
- 修复`ColorShader`的BUG。

### 7.3.0
- 兼容`zygameui-3d`的md5格式载入处理。
- 修复`C++`目标`BScale9Image.setFrame`在使用ZBuilder创建UI时，会为null的问题。

### 7.2.7
- 优化`ZMacroUtils.buildZipAssets`压缩资源实现，当不存在文件夹时不会导致编译失败。
- 新增`ZAssets.extPasrer`扩展解析支持，用于扩展不同的后缀，可以按照已知后缀方式进行加载。
- 优化`ZImage`对Frame的解析处理，减少位图不可见的问题。
- 新增`un_emoj`支持用于禁用缓存字的表情显示。

### 7.2.6
- 新增`ZLabel`对`minigame`主动清理纹理的支持，用于修复微信小游戏平台部分手机会重叠渲染的问题。

### 7.2.5
- 修复文本泄露的问题。

### 7.2.4
- 优化`ZButton.shader`着色器设置实现。
- 优化`ZImage.shaer`着色器设置实现。

### 7.2.3
- 取消了加载zip包的延迟处理，提高执行速度。

### 7.2.2
- 优化`Cmnt.getRankList`接口不再需要登录获取排行数据。

### 7.2.1
- 新增`haxelib run zygameui -build mmh5`命令编译移动MMH5版本使用。

### 7.2.0
- 优化`Cmnt.getCommentList`不再需要登录获取评论数据。

### 7.1.9
- 新增`zygameui-3d`库支持。
- 新增`Start.super3d`方法，用于初始化3D渲染引擎。
- 新增刷新器`Refresher`支持，帧事件结构变更，可兼容到3D视图中一起使用。
- 新增`ZAssetes.load3DFile`支持，用于加载3D资源。

### 7.1.8
- 修复`ToggleButton.setContext`多次调用后，无法清除对象。
- 修复`ZScroll.disableSuperscreenEasing = true`时，坐标计算不正确的问题。
- 新增`SpineManager`管理器支持，优化了Tilemap的Spine骨骼对象性能。

### 7.1.7
- 更改`MessageSystem`的扩展参数为动态类型。
- 优化`Cmnt.getAllLevelCount`接口，不再需要登录获取。
- 优化`ZAssets.unloadAll`对Spine精灵表的卸载处理。
- 新增缓存字`no_cheak_zh`不检查是否中文字符处理，对于某些平台可以提高一定的性能。

### 7.1.6
- 为Lib.getChannel新增`meizu`渠道支持。

### 7.1.5
- 新增`haxelib run zygameui -build meizu`命令，用于编译魅族版本。
- 修复`zygameui -updatedev`命令无法正常运行的问题。

### 7.1.4
- 新增Spine对颜色更改、BlendMode全面支持。
- 新增`haxelib run zygameui -build ios`命令，用于编译IOS。

### 7.1.3
- 优化`BLabel`对vivo平台的显示优化。

### 7.1.2
- 新增`MessageSystem.send`发送消息给某个玩家的功能。
- 新增`MessageSystem.clearReadMessage`清除已读消息。
- 新增`MessageSystem.read`对某条消息已读。
- 新增`MessageSystem.remove`对某条消息进行删除。

### 7.1.1
- 新增`MessageSystem`消息系统功能，可获取临时、全局消息等。

### 7.0.8
- 修复`ZTween`的数据分析错误的问题。
- 方法支持读取`ZTween.play`。

### 7.0.7
- 新增`tweenxcore`库支持，作为过渡库使用。
- 新增常用的`@:keep`实现。
- 新增`ZTween`过渡库支持。
- 增强`Cmnt`的统计接口：新增了游戏胜利、游戏失败、游戏开始、关卡分享等接口。
- 增强`GameUtils`的统计接口，绑定了`Cmnt`的游戏胜利、失败、开始等接口

### 7.0.6
- 为`ZBuilder`批渲染对象，新增`use_default_ui`支持。

### 7.0.5
- 为`spine.tilemap.BitmapDataTextureLoader`添加`@:keep`标识。

### 7.0.4
- 优化`ZImage`的scaleX、scaleY与width、height的计算关系。
- 新增`ZBuilder`可用接口`buildXmlUI`。
- 修复`spine.events`类缺失的问题。
- 增强`SpineTextureAltas`类继承`Altas`类，可提供给ImageBatchs使用。

### 7.0.3
- 优化`spine.openfl.SkeletonSprite`帧事件移除、添加处理。
- 修复`ZAssets`在完成事件中重新start会发生异常加载现象的问题。

### 7.0.2
- 从主库中移除`spine-hx`，直接使用`<haxelib name="spine-hx"/>`库。
- 修复IOS可能会永远处于`debug`模式的问题。
- Spine兼容`spine-hx:3.7.0`版本，建议使用稳定版本`spine-hx:3.6.0`。
- 修正SpineTextureAtlasLoader类名。
- 为`spine.openfl.SkeletonSprite`的`isNative=true`渲染添加了垃圾池处理。

### 7.0.0
- 增强Spine的渲染能力。

### 6.9.9
- 增强Spine（Sprite）的渲染能力。

### 6.9.6
- 新增`use_default_ui`宏支持，可以使ZBuilder使用默认缺省UI资源，仅区分按钮与图片两个缺省资源。
- 强制取消Blob/URL的支持。
- 修复Spine剪切空白区域时会渲染异常的问题。

### 6.9.5
- 修复`ZTextField`编译C++发生的错误。

### 6.9.4
- 修复`ZLabel`的getBounds获取的值没有经过`_scale`计算的问题。

### 6.9.3
- 新增`if` `unless`对ZBuilder的支持，能够通过`ZBuilder.defineValue`定义值，根据定义值来决定是否创建对应的对象。
- 新增`::定义名::`对ZBuilder的支持，能够通过`ZBuilder.defineValue`定义值，根据定义值转换传入值。
- 增强ZHaxe对ZBuilder的支持，ID定义为`super`的方法，会在初始化时进行自动调用。
- 增强ZHaxe，默认会绑定this为`builder.display`对象。
- 新增`BuilderRootDisplay`类型，用于扩展直接使用ZBuilder.build创建的UI初始化事件。
- 优化`ZBuilder`，当定义了`id`但没有定义`name`的时候，会将`name`设置成`id`的值。
- 新增`ZMacroUtils.buildZipAssets`压缩Export中的资源目录为zip的方法，压缩后会返回路径，可以用于加载使用。

### 6.9.2
- 优化`ZBuilder`对`ImageBatchs`显示对象添加处理。

### 6.9.0
- 新增`ZMacroUtils.readFileContent`宏方法，可用于读取本地文件作为字符串写入代码。

### 6.8.9
- 修复`ZTextField`类在HTML5上会重叠输入的问题。
- 修复`ZInputLabel`类在HTML5上输入时默认字不会消失的问题。

### 6.8.8
- 优化缓存字的渲染。
- 新增游客登录时获取的UUID值：`Lib.getUUID()`。
- 新增游客登录v2版本接口：`Cmnt.loginGuest(游客名称,回调)`。
- 正式移除成就数据类型。
- 正式移除`Cmnt`v1接口。

### 6.8.6
- 修复安卓的`TouchDisplayObjectContainer`会无null返回的问题。

### 6.8.5
- 修复微信小游戏`IOS`缓存文字存在渲染异常的情况。
- 修复C++使用了不可用的正则表达式。
- 优化`ZTextCacheField`渲染方式。

### 6.8.4
- 新增当前路径宏读取`zygame.macro.ZMacroUtils.buildPath(项目路径))`，该方法返回绝对路径。

### 6.8.3
- 兼容`wechat-zygame-dom`库导出talkingData/YouziSDK时，资源自动拷贝的处理。

### 6.8.1
- 优化`ZAssets.loadFiles`去重加载。
- 新增`jpeg`格式加载。

### 6.8.0
- 优化`ZAssets.loadFile`去重加载。

### 6.7.6
- 优化`API.getUserAPI`接口，当userData不存在token时，将会自动以406错误码打回。
- 新增`ZBuilder`对xml继承XML关系的支持。

### 6.7.5
- 优化`ZAssets.unloadAll`接口，会同时卸载ZIP资源。

### 6.7.4
- 优化文本的光标切换不灵敏的问题。

### 6.7.3
- 新增默认文本实现，`ZLabel`可通过`defalutText`属性创建对应的默认显示文本。
- 新增默认文本颜色实现，`ZLabel`可通过`defalutColor`属性设置默认显示文本的颜色。

### 6.7.2
- 优化`ZLabel`的布局实现。
- 新增`Start.foucs`焦点实现，可获取最后点击的焦点。
- 新增`ZLabel`焦点光标控制。
- 新增`ZLabel`通用的输入光标处理。

### 6.6.9
- 新增相册路径支持`photo://`;
- 新增`ZAssets`对`txt`格式加载的支持，可以通过`getString`获取。

### 6.6.8
- 优化`ZScene`的`onSceneReset()`实现。
- 修复`ZGraphics`的撤销功能错乱的问题。

### 6.6.6
- 修复`ZGraphics`绘图API会产生断裂的问题。
- 修复`ZGraphics`全部清理后之后，不能正常绘制的问题。
- 修复`ZGraphics`撤销API异常的问题。

### 6.6.3
- 新增`ZEvent`作为带data的通用事件。
- 新增`ZInputLabel`的`ZBuilder.size`属性配置支持。

### 6.6.2
- 修复`ZGraphics`的绘制UVS不正确的问题。
- 新增`ZGraphics`的最大绘画区域属性支持`maxDrawWidth`以及`maxDrawHeight`。

### 6.6.1
- 修复Spine骨骼动画无法播放的问题。
- 新增WIFI智能钥匙连尚小程序的编译命令`haxelib run zygameui -build wifi`;

### 6.6.0
- 优化TalkingData的统计格式。

### 6.5.9
- 新增`ZGraphics`绘制API类，可用于绘制自定义方块、线条等，兼容各种小游戏平台。
    - 支持简易的线条绘制、矩形绘制。
    - 支持Base64压缩格式导出&导入。
    - 支持清除画布。
    - 支持撤销上一步操作（擦除&绘制）。
    - 支持橡皮檫。
    - 使用精灵表对象进行渲染。
    - 支持连线渲染。

### 6.5.4
- 新增`no_html5_cache_render`可禁止使用新的缓存字渲染器。
- 新增`no_spaces`可禁止缓存字使用空格作为间隔。用于部分平台计算不正确时可忽略空格。
- 兼容`HTML5CacheTextFieldBitmapData`可运行在旧版OpenFL&Lime。
- 优化了`qqquick`手Q小游戏平台的缓存字渲染。

### 6.5.3
- 增强`HTML5CacheTextFieldBitmapData`渲染器，新增Emoj表情支持。
- 改善了`BLabel`对Emoj表情的支持。
- 改善了`ZCacheTextField`对Emoj表情的支持。
- 优化了`HTML5CacheTextFieldBitmapData`渲染器性能。

### 6.5.1
- [HashLink]修复Spine的JsonValue对hl的兼容性。
- [HashLink]框架兼容hl运行，如果出现hl错误，可添加`<define name="hl-check">`进行检查。
- 增强缓存字功能`ZCacheTextField`，为其新增了`HTML5CacheTextFieldBitmapData`HTML5专用的文字渲染器，解决存在杂点、可数字数少的问题。HTML5平台不再需要关心`ZAssets.cacheText`的`autoWarp`的参数。
- 修复缓存字重复缓存会渲染异常的问题。
- 修复`HTML5CacheTextFieldBitmapData`在小游戏编辑器中显示小的问题。
- 修复`HTML5CacheTextFieldBitmapData`的字体颜色无法自定义的问题。
- 移除`ZCacheTextField`快游戏的`clear`清理实现。

### 6.4.7
- 兼容Lime7.6.0，其`URL.createObjectURL`功能不可用，默认小游戏返回null。
- 兼容Lime7.6.0，新增`Blob`类，默认小游戏不能使用Blob。

### 6.4.6
- 升级OpenFL依赖到8.9.2(online 本地8.9.6) 兼容旧版。
- 升级Lime依赖到7.6.0(online 本地7.2.4) 兼容旧版。
- 兼容ZCacheTextFileld渲染支持。
- 更改了OpenFL的文本渲染释放处理。
- 兼容处理批渲染对象的高宽读取。
- 优化了`BLabel`缓存纹理的读取。
- 优化了`ZTextCacheLabel`缓存字的缓存方式。
- 修复多次缓存字的时候，会导致文本渲染错乱的问题。
- 修复6.4.4编译C++时缓存字的中文无法渲染的问题。

### 6.4.4
- 修复`ZCacheTextField`IOS字体路径不正确的问题。

### 6.4.3
- 兼容haxe3.4.7版本编译。
- Cmnt.login接口新增了openid、昵称检索，如果不存在时，则直接返回错误码400。

### 6.4.1
- 优化`zygame.sensors.Accelerometer`类，兼容所有HTML5平台的输出。
- 更新了API文档，可在docs/index.html打开查阅。

### 6.4.0
- 新增小米快游戏编译器`haxelib run zygameui -build xiaomi`。
- 优化`Lib.getChannel`安卓接口，读取渠道时按KengSDK的渠道标示获取。

### 6.3.7
- 修复`C++`平台的`Cmnt.saveUserData`接口异常的问题。

### 6.2.9
- 修复缓存字的`cacheAutoWrap`属性无效的问题。
- 修复缓存字渲染异常的问题。
- 移除对快游戏的字体位移计算处理。

### 6.2.4
- 新增`base64quad`对base64的色块载入支持。

### 6.2.2
- 兼容`wechat-zygame-dom:3.6.1`版本的编译。

### 6.2.1
- 优化缓存字的字数限制，缓存字是否进行换行，换行可能会减少杂点的情况，但是渲染的字数将会大大下降，默认为false。
- `invalidate`安卓将默认启动。

### 6.1.7
- 优化`API.getBaseApi`接口实现，会自动过滤掉null属性，避免服务器报网关错误的问题。

### 6.1.6
- `ZQuad`梦工厂兼容，修复无法正常显示的问题。
- `Cmnt.login`接口修正，使用getApi请求API。

### 6.1.3
- 新增`mgc`梦工厂的编译目标。
- `Lib.getChannel`新增`mgc`的渠道标示。

### 6.1.2
- 新增`-debug`编译命令，可编译本地原生的debug包。
    - 支持平台：android ios
- `ZBuilder`兼容C++无定义的属性赋值。
- `GameUtils`新增`TalkingData`统计支持，仅支持`insertValueEvent`、`insertEvent`等API。

### 6.1.1
- `zygameui`命令新增`-build`生成命令。
    - 已支持平台：
        - android
        - html5 纯html5
        - wechat 微信小游戏
        - qqquick QQ小游戏
        - tt 头条小游戏
        - baidu 百度小游戏
    - 扩展project.xml功能
        - assets参数`cp="wechat"`可定义平台是否需要拷贝资源，仅支持小游戏。

### 6.0.5
- 优化`setFrameEvent`的内部实现，解决会出现`null.onFrame`的报错情况。

### 6.0.4
- 修复OnlineUserData新用户登录时会报错的问题。
- 不提供oldAppKey的时候，将不再去获取旧版本的用户数据。

### 6.0.3
- 缓存文字支持原色显示emoj表情。
    - 已知手Q平台不支持原色emoj表情。
- 缓存文字新增emoj表情支持，解决显示会乱码的问题。
- 特殊字节formCode 800 - 900之间的字符不加入到缓存字中。
- 修复部分字母显示不齐全的问题。
- 扩大了缓存文字的区域，清除杂点。
- 新增特殊空格字符过滤实现。
- 针对`qqquick`手Q平台做了ZQuad兼容显示。
- 针对`qqquick`手Q平台优化了缓存文本显示。

### 5.8.6
- 优化API的debug输出。

### 5.8.4
- 优化OnlineUserData，对于线上版本无版本号的数据，以无版本号为准。

### 5.8.3
- 新增`Lib.clearTimeRuntime()`清理指定的计时器运行环境。
- 新增`Lib.clearAllTimeRuntime()`清理所有计时器运行环境。
- `Lib`所有时间API，都新增了`runtimeTag`的传参，用于自定义计时器运行环境。
- 新增`Lib.getTimeRuntime()`获取指定的计时器运行环境。

### 5.8.1
- 修复`ZAssets`图片无法释放的问题。
- 优化`v2.Sign`的签名实现。

### 5.7.6
- 删除1px载入支持，优化ZQuad的显示实现。
- 新增`Lib.getChannel()`支持，能够读取qq、微信、百度、字节、VIVO、Oppo等对应渠道名。

### 5.7.3
- 修复ZScorll使用批渲染对象时，会点击越界的问题。

### 5.7.2
- Cmnt.login升级：新增性别传参。

### 5.6.4
- 新增点赞评论接口`Cmnt.praiseComment(评论ID,回调)`。

### 5.6.1
- ZLabel新增getTextHeight();getTextWidth();接口。

### 5.6.0
- 兼容烦恼API接口。
- 修复缓存字存在点点的问题。

### 5.5.8
- 修复ZButton的九宫格皮肤无法更换的问题。
- 修复HTML5字体会影响微信小游戏字号的问题。

### 5.5.6
- 修复`CmntUserData`使用v2登录接口成功后无法获取UserId的问题。

### 5.5.5
- 为ZHaxe所用到的自定义类型添加了`@:keep`

### 5.5.4
- 修复ZGC释放资源时导致的卡顿问题。

### 5.5.2
- `ZAssets.loadSwfliteFile`新增`isZip`属性（默认为true），可设置为false后加载非zip的bundle数据。

### 5.5.1
- XML新增ZArray数组类型支持。

### 5.4.9
- 修复ZBuilder在C++中发生死循环的问题。
- 改善`debug`宏产生的curl数据格式，附带访问结果。
- 修复ZBuilder在C++中呈现异常的问题。
- `Start`类继承`ZScene`，作为中心类，不会被ZSceneManager更换。
- 更新Cmnt的评论API接口。

### 5.4.8
- 新增ZString类型，可在XML中定义字符串。

### 5.4.7
- 新增un_scale_label宏：是否禁用ZLabel的高清缩放显示功能。

### 5.4.6
- 修复ZButton使用九宫格图时无法更改图片的问题。

### 5.4.5
- 修复社区功能Cmnt（v2）的登录BUG。

### 5.4.4
- 新增社区功能Cmnt（v2）API功能（含登录、评论、用户存档等）

### 5.4.2
- 发布非debug版本时，所有trace都会失效。可通过`<define name="untrace">`禁用trace。

### 5.3.5
- 新增ZHaxe支持，ZBuilder将可以写入动态脚本。

### 5.2.9
- 修复ZList切换数据时，设置vscroll会导致渲染显示不完整的问题。

### 5.1.9
- BLabel使用精灵表时支持自动换行wordWrap属性。

### 5.1.7
- Assets新增了文字缓存功能。

### 5.1.6
- 兼容Haxe4.0
- 移除ZLabel的unlock/lock支持。

### 5.1.4 
- ZBitmapLabel新增了setFontName支持。

### 4.9.6
- ZList组件添加cache属性，可以更换缓存方式为item缓存，而不是虚拟缓存。

### 4.9.5
- 修复BSprite缩放后高宽不正确的问题。

### 4.9.2
- 新增了一系列功能：VBox HBox VBBox HBBox