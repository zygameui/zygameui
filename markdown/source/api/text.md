## 文本显示

一般用于文本显示，可直接使用`zygame.commponents.ZLabel`类进行显示：

```haxe
var label = new ZLabel();
this.addChild(label)l
label.width = 100;
label.dataProvider = "我是显示内容";
```

但要注意的是，使用ZLabel则不要经常去修改它，因为是直接使用原生API渲染，这样会消耗一定的性能。如果需要高性能的文本渲染，可使用批渲染渲染：`zygame.commponents.ZBitmapLabel`。

## 纹理文本

使用`zygame.commponents.ZBitmapLabel`可以正常渲染精灵图对象，或者是Fnt格式纹理字。使用ZBitmapLabel渲染的文本，可以频繁修改，也不会降低性能。

```haxe
var label:ZBitmapLabel = new ZBitmapLabel(assets.getTextureAtlas(纹理ID));
label.dataProvider = "我是缓存文字"; 
this.addChild(label);
label.width = 100;
label.height = 32;
```

## 缓存文本

从zygameui5.2.2开始，将正式支持缓存文本的支持，类似于将文本一次性绘制出来，然后相当于取精灵表一样进行使用，可以得到文本渲染性能提升。目前可以配合BLabel、ZBitmapLabel两个类进行使用。

缓存文本的操作是同步的，只有缓存成功的文字，才能够被正常渲染。当需要使用缓存文字功能时，可直接访问资源管理器：

```haxe
/小游戏中文字一般会比较模糊，可以刻意提高一下字体大小，例如平时使用是24size，那么创建时可以传递40size。
assets.cacheText(缓存ID,"我是需要缓存的文字",字体,字体大小);
```

成功缓存的文本，会自动转换成精灵表（TextureAtlas），BLabel和ZBitmapLabel都可以使用TextureAtlas进行渲染：

```haxe
var label:ZBitmapLabel = new ZBitmapLabel(assets.getTextAtlas(缓存ID));
label.dataProvider = "我是缓存文字"; //文字必须是在缓存中的文字，否则会无法渲染。
```

