## 盒子容器

可使用`zygame.components.ZBox`作为基础容器，该类是继承`zygame.display.DisplayObjectContainer`的子类。区别特点是，如果设置的高宽，该对象的宽高即将被固定，并不会发生内容拉伸。

## 横向排列容器

可使用`zygame.components.ZBox.HBox`进行横向排列显示对象：

```haxe
var box = new HBox();
this.addChild(box);
box.addChild(display1);
box.addChild(display2);
box.addChild(display3);
box.gap = 5; //设置间隔
box.updateLayout() //更新布局
```

## 纵向排列容器

同理，可使用`zygame.components.ZBox.VBox`进行纵向排列显示对象：

```haxe
var box = new VBox();
this.addChild(box);
box.addChild(display1);
box.addChild(display2);
box.addChild(display3);
box.gap = 5; //设置间隔
box.updateLayout() //更新布局
```

