## 图形显示（批渲染）

只接受精灵数据的图像对象，它的使用方法，基本与Image类一致。需要注意的是更换精灵数据时，请使用：

```haxe
img.setFrame(assets.getBitmapData("GameUI:2"));
```

与Image的区别是，功能会有一定的受限，例如不支持中心锚点等。