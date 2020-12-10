## 资源管理

在OpenFL中有`openfl.utils.Assets`工具类的实现，可以用于加载资源；但是其中加载的资源并不能满足于我们一些资源载入。为此，我给它封装了一个`zygame.utils.ZAssets`对象。

当你拥有一个资源管理对象后，你将可以使用它进行加载以下格式：

- png、jpg 基础的图片资源，可通过getBitmapData获取。
- mp3、ogg 背景音乐以及音效，可通过getMusic以及getSound获取。
- json 动态JSON对象，当加载完成后就直接是Dynamic对象，可通过getObject获取。
- png、xml精灵表 基础的XML格式的精灵表数据，可通过getTextureAtlas获取。
- xml XML格式数据，可通过getXml获取。
- swflite SWFLite数据格式，可通过getMovieClip创建已载入的SWFMovieClip对象。
- fnt 位图字体资源，可通过getFntData获取位图字体资源。
- spine Spine资源，涉及的API较多，请直接参考2.9节点介绍。
- maplive Maplive地图数据格式，涉及的API较多，请直接参考2.10节点介绍

简单的加载示例：

```haxe
//单个文件加载
assets.loadFile("1.png");
//加载多个文件
assets.loadFiles(["2.png","3.mp3"]);
//加载精灵表数据
assets.loadTextures("4.png","4.xml");
```

一般游戏过程中，都是需要等待资源加载完成后，才能继续游戏逻辑处理。我们通过上面的API示例，仅仅只是将资源放入加载列表中，其实内部还未开始加载。需要调用以下实现进行加载，同时会返回一个进度值，用于判断资源是否加载完成：

```haxe
assets.start(function(f:Float):Void{
    if(f == 1)
    {
        //加载完成，开始游戏逻辑处理
    }
});
```

当加载完成后，你可以通过访问API获取数据，例如获取一个位图：

```haxe
assets.getBitmapData("1"); //自动识别1.png
assets.getBitmapData("4:1"); //获取4.png的精灵图对象
```

## 使用ZIP包资源载入

提供了压缩包文件读取方式入口，可通过压缩包将资源一次性载入。然后再通过普通的资源进行加载；Zip是属于平台通用功能，但会带来一定的性能影响。

#### 使用说明

loadAssetsZip的API不论先后，都会优先第一时间读取zip资源。然后再加载其他资源，其他资源会根据zip是否包含资源来决定是否从zip中获取资源。

```haxe
assets.loadAssetsZip("GameMain.zip");
```

当资源不再需要时，可卸载zip所占用的资源。

```haxe
assets.unloadAssetsZip("GameMain");
```

当资源被载入到Zip后，游戏可以快速地进行读取资源。这时可以根据需要来加载所需的图片。

更详细的API请直接参考：[ZAssets]()。

## 资源绑定

一个assets是独立的，如果你希望它可以被其他ZAssets所读取使用，那么你需要使用`zygame.components.ZBuilder`进行绑定：

```haxe
ZBuilder.bindAssets(assets);
```

绑定的资源就会进行全局共享，可通过API直接全局获取：

```haxe
//从全局里获取精灵图
ZBuilder.getBaseTextureAtlas("name");
```

它还可以应用在`ZBuilder.build`中，一个界面由多个精灵图组成时，需要使用`bindAssets`功能让它们可以找到资源。