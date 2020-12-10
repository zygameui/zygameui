## 列表

数据列表显示，用于实现复用列表数据，仅支持一种ItemReander渲染。经过优化的列表，每个item组件高度或者宽度都是固定的，但是你可以存放100000+的数据也不会感觉到卡顿。使用该组件，你需要配合ItemRender得到自定义渲染结构。然后将你的渲染对象赋值到itemRenderType中，使全局都使用该渲染对象。可以修改ListLayout布局的方向实现，得到横向的List。

普通例子：

```haxe
var list = new ZList();
this.addChild(list);
list.dataProvider = new ListData([0,1,2,3,4,5,6,7]);
list.width = 100;
list.height = 100;
```

## ItemRender渲染

在使用ItemRender渲染需要定义一个继承`zygame.components.base.ItemRender`的对象类型，然后根据实际逻辑来做Item的内容渲染：

```haxe
class Item extends ItemRender {
  override private function set_data(value:Dynamic):Dynamic{
    super.set_data(value);
    if(value != null){
      //有数据时，刷新内容
    }
    else{
      //无数据时，刷新内容
    }
  }
}
```

有了ItemRender对象只会，就可以直接赋值到列表组件里，进行使用：

```haxe
list.itemRenderType = Item;
```

## 注意实现

务必减少使用大量消耗drawcall的对象，如文本等。