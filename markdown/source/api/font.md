## 字体设置

除了HTML5以外的平台都会有默认绑定的字体路径`assets/DroidSansFallbackFull.ttf`。

可以在Haxe中进行设置：

```haxe
zygame.components.base.ZConfig.fontName = "font.ttf";
```

### 注意事项

在C++平台上，如果不设置字体的话，将无法正常渲染中文。