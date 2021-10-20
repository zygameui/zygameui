## ZBuilderScene

通过xml配置异步展示场景，如果在ZBuilder缓存池里能够找到资源的话，则不需要加载，直接显示。

```haxe
class View extends ZBuilderScene {
  
  public function new(){
    super("assets/view.xml");
  }
  
  override public function onBuilded():Void{
    // 页面构造成功，通过这里进行实现界面逻辑
  }
  
}
```

使用时：

```haxe
var view = new View();
this.addChild(view);
```

## 自动构造

ZBuilderScene允许使用`zygame.macro.AutoBuilder.build`建造宏，同时支持异步载入资源展示。[详情文档](updoc/autobuild.md)

## 自适配

当页面需要指定分辨率进行适配时，需要xml文件新增`hdwidth`以及`hdheight`两个属性：

```xml
<ZBox hdwidth="1080" hdheight="1920">
</ZBox>
```

当定义了hdwidth/hdheight后，当前页面在任何分辨率上渲染，都是以1080x1920的比例进行渲染。

