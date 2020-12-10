## 容器

在引擎中，容器基础类是`zygame.display.DisplayObjectContainer`，我们会使用它来代替OpenFL的`openfl.display.Sprite`。并为它封装了便捷易用的接口：

```haxe
//进行游戏逻辑处理时，请务必在onInit中实现，勿在构造函数中实现。
public function onInit():Void{};

//帧事件处理，当容器被记录为更新器时，该接口会以帧率的速度进行调用。
public function onFrame():Void{};

//当自已从舞台删除时
public function onRemove():Void{};

//当从舞台删除时（如父亲对象）
public function onRemoveToStage():Void{};

//当添加到舞台时
public function onAddToStage():Void{};

//释放接口，当含有自定义对象，需要手动释放内存的时候，可在这里进行实现。
public function destroy():Void{};
```

## 触摸事件容器

使用`zygame.display.TouchDisplayObjectContainer`可以轻松获得触摸能力：

```haxe
//点击开始
public function onTouchBegin(e:TouchEvent):Void{}
//移动事件
public function onTouchMove(e:TouchEvent):Void{}
//松开事件
public function onTouchEnd(e:TouchEvent):Void{}
```

## 批渲染容器

除了普通的容器，还使用了`Tilemap`的原理实现了具有触摸事件的批渲染容器`zygame.display.TouchImage`。[如何使用批渲染？]()

