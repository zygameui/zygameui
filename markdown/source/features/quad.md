## 纯色块

能够快捷生成出色块，该类做了色块优化，性能会比Spirte的绘图API高。所以在关于纯色块的使用，不要直接使用Bitmap/Sprite创建出来的色块，简单示例：

```haxe
var quad = new ZQuad();
//设置颜色
quad.color = 0xff0000;
//设置高宽
quad.width = 300;
quad.height = 600;
this.addChild(quad);
```

