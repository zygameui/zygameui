## 动画过渡

动画过渡使用`actuate`库的实现，由`openfl`的作者提供。

## 简单的例子

Actuate设计为易于使用，如果你希望修改某一个对象的某个值时：

```haxe
motion.Actuate.tween(MySprite,1,{
   alpha: 0.5
}).onComplete(function(){
  trace("过渡动画结束");
});
```

Actuate会自动处理你的多个过渡的关系，可以通过覆盖的参数，来决定是否存在多个过渡关系：

```haxe
Actuate.tween (MySprite, 1, { alpha: 1 });
Actuate.tween (MySprite, 1, { alpha: 0 }, false).delay (1);
```

也可以很简单的控制过渡动画的停止与恢复：

```haxe
// 停止
Actuate.stop (MySprite);
Actuate.stop (MySprite, "alpha");
// 暂停所有
Actuate.pauseAll ();
// 暂停
Actuate.pause (MySprite);
Actuate.pause (MySprite, MyOtherSprite);
// 恢复所有
Actuate.resumeAll ();
// 恢复
Actuate.resume (MySprite);
Actuate.resume (MySprite, MyOtherSprite);
// 重置
Actuate.reset ();
```

同时它自身具备自带有一个计时器的过渡：

```haxe
// 延迟一秒后触发
Actuate.timer (1).onComplete (trace, "Hello World!");
```

使用`apply`来给对象清空所有动画效果，并将属性应用到对象身上：

```haxe
Actuate.apply (MySprite, { alpha: 1 });
```

为动画定义自定义缓和方程式。Actuate包括许多标准和优化格式的常用缓解功能。默认值为Expo.easeOut，但您可以通过Actuate.defaultEase更改默认方程式：

```haxe
Actuate.tween (MySprite, 1, { alpha: 1 }).ease (Quad.easeOut);
```



## 高级功能

更多详情的使用方法，可以参阅：http://github.com/openfl/actuate