## 滚动窗

能够根据容器的高宽来滚动关卡，可以用来实现滑动菜单等功能。

简单的示例：

```haxe
//创建一个Scroll
var scroll = new ZScroll();
scroll.width = 300;
scroll.height = 300;
this.addChild(scroll);
//创建一个方块放入Scroll
var quad = new ZQuad();
quad.width = 600;
quad.height = 600;
scroll.addChild(quad);
```

