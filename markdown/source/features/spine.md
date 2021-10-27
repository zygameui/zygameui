## Spine骨骼动画

在ZYGameUI中，它支持两种渲染模式，一种是利用Sprite进行三角形渲染；另外一种是利用Tilemap进行批渲染实现。

Spine骨骼资源会提供出以下几种文件格式：

- json - 动画资源文件，记录动画数据。
- atlas - 位图映射数据问题，用于映射图片精灵表图的数据。
- png - 骨骼所使用到的图片资源。

了解这些资源格式后，我们来看看加载示例：

```haxe
var _assets:ZAssets = new ZAssets();
//加载动画资源
_assets.loadFile("assets/Comic1.json");
//加载多张资源图纹理集
_assets.loadSpineTextAlats(["assets/Comic1.png","assets/Comic12.png","assets/Comic13.png","assets/Comic14.png"],"assets/Comic1.atlas");
```

## Spine-Sprite对象（spine.openfl.SkeletonAnimation）

该对象拥有批渲染高性能渲染，能够得到1draw的渲染。但是会有以下几个限制：

- 必须使用单张资源纹理渲染。
- 单张纹理资源大小不超过2048*2048。
- 使用批渲染渲染时，暂时不支持透明度，改色等功能；但是支持网格功能。

创建示例：

```haxe
//创建SpriteSpine
var spine:SkeletonAnimation = _assets.createSpineSpriteSkeleton("Comic1","Comic1");
this.addChild(spine);
//播放动画
spine.play("G1_5_2");
```

上面提及到必须使用单张图片纹理渲染，但也可以通过isNative属性开启支持多纹理、透明度、改色等功能，但将会牺牲一定层度的性能：

```haxe
//功能能够通过isNative属性开启，多张纹理图的渲染，必须开启这个属性，否则渲染会有异常。
spine.isNative = true;
```

## Spine-Tilemap对象（spine.tilemap.SkeletonAnimation）

该对象拥有批渲染高性能渲染，同时支持在Tilemap中进行渲染。但是会有以下几个限制：

- 必须使用单张资源纹理渲染
- 单张纹理大小不超过2048*2048
- 不支持多张纹理图渲染，即无isNative支持。
- 不支持网格渲染。

创建示例：

```haxe
//注意需要先调用createSpineTilemapSkeleton，这样可以确保Alats可以获取到纹理渲染。
var spine:SkeletonAnimation = _assets.createSpineTilemapSkeleton("Comic1","Comic1");
var batchs:ImageBatchs = new ImageBatchs(Game.assets.getSpineTextureAlats("纹理名"));
batchs.addChild(spine);
```

## ZSpine组件

另还封装了一个便捷使用的`zygame.components.ZSpine`对象类，可以简化使用方法，同时它会从已绑定的资源中获取内容：

```haxe
var spine = new ZSpine("spineName","skeletionName",false);
this.addChild(spine);
```

[什么是绑定资源？](api/assets.md)

## 事件侦听
通过`SpineEvent`事件，侦听Spine发生的事情。
```haxe
spine.getNativeSpine().addEventListener(SpineEvent.EVENT,function(e){
    // 接收事件
});
```