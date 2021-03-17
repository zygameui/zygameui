## 页面管理器
通过页面管理器，可以管理不同的显示页面。

## 基础使用
```haxe
var stack = new ZStack();
this.addChild(stack);
var box = new ZQuad();
box.width = 100;
box.height = 200;
box.name = "boxid";
// 显示box的对象
stack.currentId = "boxid";
```

## 切换效果
ZStack默认是没有切换效果的，如果需要切换效果，那么可以对它的`style`进行设置：
```haxe
stack.style = new DefalutZStackAnimateStyle(); // 该样式是默认的黑色过渡切换效果
```