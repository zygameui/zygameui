## 碰撞系统

该系统基于`differ`库实现的封装功能。该`differ`库实现了不规则形状、圆形以及射线等基础碰撞实现，可以用于实现游戏的碰撞逻辑。

## Shapes

`zygame.differ.Shapes`是一个用于管理所有的形状的管理类，可用此类来轻松管理所有对象的碰撞，使用方法：

```haxe
//创建一个正方形
var box = Polygon.rectangle(0, 0, 100, 100);
//创建形状管理器
var shapes = new Shapes();
//将矩形丢入形状管理器中
shapes.add(box);
```

给碰撞形状进行分类：

```haxe
//将矩形丢入管理器，分类为enemy
shapes.add(box,"enemy");
```

图形碰撞检查：

```haxe
//碰撞测试
var ret = shapes.test(box,"enemy");
trace(ret); //这是碰撞结果，如果ret为null时，则为无碰撞。
```

使用`zygame.differ.DebugDraw`可以简单显示所有形状的渲染，使用方法：

```haxe
//创建调试对象，并将显示对象添加到舞台
var debug = new DebugDraw();
this.addChild(debug.display);
//传入Shapes类型
debug.drawShapes(shapes);
```

Differ碰撞API请直接参考differ库中的[docs文档]()。

