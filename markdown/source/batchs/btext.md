## 纹理文本

在批渲染中的文本，都是使用位图文字。在精灵表中要添加字体，需要遵循字体规则，默认BLabel是空白字体名，那么需要用到0-9的数字文字时，需要在精灵表中添加0.png/1.png...9.png等文件。然后可以以下面的方式创建文本内容：

```haxe
//创建一个使用与批渲染一致的精灵表数据
var label:BLabel = new BLabel(assets.getTextureAtlas("GameUI"));
//添加到批渲染中
batchs.addChild(label);
//渲染文本
label.updateText("99930");
```

当你需要使用多个字体文本时，那么可以利用字体来处理单张精灵表的多种字体显示，如：

```haxe
//为文本设置字体
label.fontName = "font";
```

这时，使用font字体的文本对象，将会去读取font0.png..font9.png等位图资源，因此精灵表应包含这些资源，才能正常渲染显示。

