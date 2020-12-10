## 按钮

非批渲染的按钮，可以通过ZButton.createButton的方法进行创建：

```haxe
var button = ZButton.createButton(assets.getBitmapData("button"));
```

批渲染使用的按钮对象，使用方法可以直接通过BButton.createButton方法创建：

```haxe
//创建一个按钮
var button = BButton.createButton(assets.getTextureAtlas("GameUI"),
assets.getBitmapData("GameUI:btn1"));
//添加到批渲染中
batchs.addChild(button);
```

如按钮需要侦听点击事件，可简易的使用：

```haxe
button.clickEvent = function():Void{
  //点击事件
}
```

## 按钮皮肤

BButton以及ZButton对象类都是使用`zygame.commponents.skin.BaseSkin`类管理皮肤。当需要更换图像的内容时，可简单通过以下方式更换，但需要注意批渲染需要提供精灵数据，而非批渲染则需要提供位图数据：

```haxe
//更换upSkin对象
button.skin.upSkin = assets.getBitmapData("button2");
```

#### 皮肤逻辑

当通过createButton方法，只传入了一个upSkin参数的图像数据时，该Button被点击时，会呈现缩放效果。
当通过createButton方法，传入了upSkin，以及downSkin图像数据时，该Button被点击时，会呈现切换为downSkin图像效果。

## 九宫格皮肤

当批渲染按钮需要支持九宫格时，请使用`zygame.display.batch.BScale9Button`功能：

```haxe
var button:BScale9Button = BButton.createScale9Button(精灵表,宽,高,默认皮肤);
//很多时候九宫格都是不含内容的，需要追加内容时，请使用精灵数据通过setConntent方法添加。
button.setConntent(精灵数据);
```

