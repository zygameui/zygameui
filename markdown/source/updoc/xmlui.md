## XML格式界面

我们可以采取XML格式的方式，来渲染我们的UI界面。同时我们有[ZYEditUI工具](updoc/zyeditui.md)来处理导入界面以及实时预览。

默认支持的XML格式库：

原生组件：

- ZBox（容器）
- ZImage （图片）
- HBox （横向容器）
- VBox （纵向容器）
- ZAnimatoin （动画）
- ZBitmapLabel （纹理文本）
- ZLabel （文本）
- ZInputLabel （输入文本）
- ZList （列表）
- ZQuad （纯色块）
- ZScroll （滚动窗）
- TouchImageBatchsCountainer （触摸批渲染层）
- ImageBatchs （批渲染层）
- ZButton （按钮）
- ZSpine （Spine骨骼动画）
- ZStack （页面管理器）

批渲染组件：

- BBox （容器）
- HBBox （横向容器）
- VBBox （纵向容器）
- BButton （按钮）
- BLabel （纹理文本）
- BSprite （容器）
- BScale9Image （九宫格图片）
- BScale9Button （九宫格按钮）
- BSpine （Spine骨骼动画）
- BAnimation （动画）

功能组件：

- ZTween （动画过渡）
- ZInt （整数）
- ZFloat （浮点数）
- ZBool （布尔值）
- ZString （字符串）
- ZArray （数组）
- ZObject （动态类型）
- ZHaxe （hscript脚本）

图片赋值，都是使用`src`属性，来个简单的示例：

```xml
<ZBox>
	<ZButton src="图片名"/>
  <TouchImageBatchsCountainer src="精灵图名">
      <BImage src="精灵图名:精灵名"/>
  </TouchImageBatchsCountainer>
</ZBox>
```

文本赋值，都是使用`text`属性，同时高宽可以使用百分比计算赋值：

```xml
<ZBox>
	<ZLabel text="data" width="100%" height="32"/>
</ZBox>
```

## 父节点属性访问
使用`${参数名}`来访问父节点的属性，它会一直往上的父节点查找。例如下面的文本的颜色值，会找到父节点的color值进行赋值。
```xml
<ZBox color="0xff0000">
	<ZLabel text="data" width="100%" height="32" color="${color}"/>
</ZBox>
```

## 运行脚本

我们可以在XML配置中，可以得到创建完毕后执行脚本：

```xml
<ZBox id="box">
  <ZHaxe id="super">
  	//可以直接访问id
    box.x = 100;
  </ZHaxe>
</ZBox>
```

注意：<、>等符号需要转义，可以使用下面的描述代替：

| 原符号 | XML可用更改符 |
| ------ | ------------- |
| >      | gt            |
| <      | lt            |
| >=     | egt           |
| <=     | elt           |
| &&     | and           |
| \|\|   | or            |

示例：

```haxe
if(value lt 1 and value gt 0){
  //处理
}
```

## 构造UI

我们可以在XML中定义布局后，然后通过Haxe来构造：

```haxe
//构造成功后，会默认添加到第二个参数的容器中
var builder = ZBuilder.build(xml,this);
```

## 方法定义

我们还可以在XML中定义方法：

```xml
<ZBox id="box">
  <!-- 定义一个play的方法 -->
  <ZHaxe id="play">
  	//可以直接访问id
    box.x = 100;
  </ZHaxe>
</ZBox>
```

开始调用：

```haxe
builder.getFunction("play")();
```

## 扩展类型

我们还可以对ZBuilder进行类型扩展，先定义一个类型：

```haxe
class ExtendsClass extends ZBox {
  public var tag:String;
  public function new(tag:String = null):Void{
    super();
    this.tag = tag;
  }
}
```

然后进行扩展：

```haxe
//扩展一个ExtendClass的显示对象类型
ZBuilder.bind(ExtendClass);
```

这时你可以在XML中使用，同时可以对它的属性进行修改：

```xml
<ExtendsClass tag="extendsTag">
</ExtendsClass>
```

如果你想对属性进行特殊写入，那么可以更改写入方式：

```haxe
ZBuilder.bindParsing(ExtendsClass,"tag",function(ui,name,value){
  //其中ui是当前的ExtendsClass对象，name是tag，value是当前赋值
  cast(ui,ExtendsClass).tag = "[TAG]" + value;
});
```

如果你想在创建的时候，进行属性传参：

```haxe
ZBuilder.bindCreate(ExtendsClass,function(xml:Xml):Array<Dynamic>{
  //此处返回的数组，就是new的时候所使用的参数
  return [xml.get("tag")];
});
```

当你的容器需要修改添加方式：

```haxe
ZBuilder.bindAdd(ExtendsClass,function(obj:Dynamic,parent:Dynamic,xml:Xml):Void{
  //其中obj是添加对象，parent是父亲对象，xml是当前添加的配置
  cast(parent,ExtendsClass).addChild(obj);	
});
```

当你的组件结束添加后：

```haxe
ZBuilder.bindEnd(ExtendsClass,function(ui:Dynamic):Void{
  //ui是当前已结束添加的对象
});
```

