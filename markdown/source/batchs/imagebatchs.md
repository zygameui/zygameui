## 批渲染对象

批渲染其实就是一种能够使用同一张图，进行多次绘制，达到批渲染提高性能的效果。在批渲染下，一个对象之下，不管里面有多少个对象，绘制多少次，也只会产生1次drawcall的调用。

在使用批渲染时，必须要有一个`zygame.display.batch.ImageBatchs`对象用于渲染内容。它只接受精灵表数据，在内部它可以多次添加精灵表数据的对象。

```haxe
var batchs = new ImageBatchs(assets.getTextureAtlas("GameUI"));
```

当拥有了一个批渲染对象后，将可以在里面放入其他批渲染基础对象，如：

```haxe
//从精灵表数据中获取精灵数据
var img = new BImage(assets.getBitmapData("GameUI:1"));
//添加到批渲染中
batchs.addChild(img);
```

需要注意的是：每个批渲染对象，只能够渲染一张精灵表，如果需要渲染多张精灵表时，请分开创建，无法混合使用。

## 触摸批渲染对象

在原生OpenFL的批渲染对象中，是没有支持触摸实现的，由引擎封装实现了触摸事件。`zygame.display.batch.TouchImageBatchContainer`与ImageBatch不一样的是，它拥有图层关系，即里面允许同时批渲染多个不同的精灵表，但不同的精灵表需要在不同层次进行渲染：

```haxe
//创建一个默认的精灵表对象
var touchBatchs = new TouchImageBatchsContainer(assets.getTextureAtlas("GameUI"));
//默认精灵表对象会创建在0层次，可直接通过以下方式添加对象
touchBatchs.getBatchs().addChild(display);
```

如需要多个层次时，创建新的精灵表批渲染对象：

```haxe
//创建一个新的批渲染对象
var batch = new ImageBatchs(assets.getTextureAtlas("GameUI2"));
touchBatchs.addBatchs(batch);
//由于是第二层，可通过1下标获取
touchBatchs.getBatchs(1).addChild(display);
```

触摸事件侦听，使用跟普通的TouchEvent的差异不大，但它只能针对touchBatchs进行侦听，不能单独对批渲染内部子对象进行侦听，触摸事件包含有TOUCH_BEGIN_TILE、TOUCH_END_TILE、TOUCH_MOVE_TILE，请参考示例：

```haxe
touchBatchs.addEventListener(TileTouchEvent.TOUCH_BEGIN_TILE,function(event:TileTouchEvent):Void{
    //获取触摸到的对象
    var tile:Tile = event.tile;
});
```

TouchImageBatchsContainer类拥有穿透点击的效果，当触摸没有触摸到对象时，仍然可以触摸后面的非批渲染对象。

##### 性能优化

如果在不需要改色、透明值、BlendMode等渲染支持的情况下，可以禁用以下对应的属性，提高一定的性能：

```haxe
batch.getBatchs().tileAlphaEnabled = false;
batch.getBatchs().tileBlendModeEnabled = false;
batch.getBatchs().tileColorTransformEnabled = false;
```