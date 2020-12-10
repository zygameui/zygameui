## 文本输入

使用`zygame.components.ZInputLabel`组件来输入内容。在HTML5、小游戏中，暂无法对文字进行选择。

示例：

```haxe
var label = new ZInputLabel();
label.width = 100;
label.height = 32;
this.addChild(label);
//可设置默认文案
label.defaultText = "请输入文案";
```

更多详情请参考[ZInputLabel]()。

