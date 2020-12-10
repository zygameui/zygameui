## UI自动构造

使用`AutoBuilder`为你的类自动构造布局生成器，可简化类的编写流程。需要使用`@:build`方法进行构造：

```haxe
//此处的文件名可不带后缀
@:build(zygame.macro.AutoBuilder.build("文件名"))
```

#### zygame.components.ZBuilderScene

当你对继承ZBuilderScene的类进行使用时，将不能自主构造`onInit`方法。如在此界面需要额外加载资源，请在`onLoad`方法进行重写重新处理；同时你可以在`onBuilded`方法后，在此方法中直接调用id命名直接访问对象。

```haxe
@:build(zygame.macro.AutoBuilder.build("DiaryGoods"))
class DiaryGoodsView extends ZBuilderScene {
    
    override public function onLoad() {
        //额外加载资源
        this.assetsBuilder.loadFiles(["assets/views/DiaryGoodsItem.xml"]);
    }

    override function onBuilded() {
        super.onBuilded();
        //直接访问属性list和close
        this.list.itemRenderType = DiaryGoodsItem;
        this.list.dataProvider = new ListData([1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30]);
        this.close.clickEvent = function(){
            this.parent.removeChild(this);
            this.onSceneRelease();
        };
    }

}
```

#### 其他显示对象

当你对其他显示对象使用该宏构造时，会自动创建一个assetsBuilder属性（ZAssetsBuilder），并创建时是同步接口，可直接重写`onInit`接口来直接实现逻辑。

```haxe
@:build(zygame.macro.AutoBuilder.build("DiaryGoodsItem"))
class DiaryGoodsItem extends ItemRender {

    override function set_data(value:Dynamic):Dynamic {
        //直接访问ID属性
        this.fangzi.visible = false;
        this.frame1.visible = false;
        this.frame2.visible = false;
        this.top.visible = false;
        this.bottom.visible = false;

        if(value == 1){
            this.fangzi.visible = true;
            this.frame1.visible = true;
            this.bottom.visible = true;
        }
        else
        {
            this.frame2.visible = true;
            this.top.visible = true;
            this.bottom.visible = true;
        }
        return super.set_data(value);
    }

}
```

## 文件索引

该构造函数是依赖zproject.xml中的assets配置，如果没有在assets配置列表中时，将不会索引成功。可通过给assets添加`"unparser"="true"`参数来拒绝索引：

```xml
<assets path="assets" unparser="true"/>
```

