## 图形显示

我们可以直接使用`zygame.display.Image`类来代替`openfl.display.Bitmap`。

## 图形数据

一般使用图形数据有两种：`openfl.display.BitmapData`以及`zygame.utils.load.Frame`。

#### 1. BitmapData

BitmapData属于普通的位图数据，可以直接读取使用。

#### 2. Frame

Frame属于精灵图表的位图数据，需要使用`zygame.display.Image`显示。

简单的位图显示例子：

```haxe
var img = new Image(assets.getBitmapData("img"));
this.addChild(img);
```

## 图形组件

同时，为了提高便捷性，还提供了图片组件`zygame.components.ZImage`，该类可以便捷的使用。

```haxe
var img = new ZImage();
img.dataProvider = assets.getBitmapData("img");
this.addChild(img);
```

使用网络图片：

```haxe
img.dataProvider = "http://zygameui.cn/icon.png";
img.onBitmapDataUpdate = function(){
  //异步同步图片回调
}
```

使用异步本地图片：

```haxe
img.dataProvider = "assets/1.jpg";
```

使用九宫格图片：

```haxe
img.setScale9Grid(new Rectangle(5,5,10,10));
```

图片锚点修改：

```haxe
img.hAlign = "center";  //横向居中
img.vAlign = "center";	//纵向居中
```



