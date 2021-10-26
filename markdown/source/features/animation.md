## 动画

能够通过`zygame.components.ZAnimation`类实现简单的帧动画实现，一个简单的示例：

```haxe
//在这里传入帧率，以及位图数据列表，请注意这里是支持精灵数据的。
var animation = ZAnimation.createAnimation(24,[assets.getBitmapData("an1"),assets.getBitmapData("GameUI:an1")]);
```

当需要停止到某一帧，或者播放，可简单用到：

```haxe
//持续播放22次
animation.play(22);
//停止到指定帧
animation.stop(2);
//指定帧开始播放，并播放22次。
animation.playGo(2,22);
```

更多详细请阅读[ZAnimation]()。

## 动画回调

可通过`zygame.components.data.AnimationData`设置帧事件：

```haxe
cast(animation.dataProvider,AnimationData).setFrameCall(6,function(){
  	//第6帧的时候，发生回调。
});
```

