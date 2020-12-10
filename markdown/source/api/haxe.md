## Haxe语法注意事项

Haxe的语法跟原生的ActionScript3是有一定的区别的。下面会讲述区别以及代替方法。

#### 3.6.1 for循环

Haxe中没有for(var i:int = 0;i<10;i++){}的写法，可使用下述的方式编写：

```haxe
//其中i变量不需要定义类型
for(i in 0...10)
{

}
```

如果需要写for(var i:int = 0;i<10;i+=2){}的实现怎么办？别怕，看下面：

```haxe
var i:Int = 0;
while(i < 10)
{
    i += 2;
}
```

#### 3.6.2 类型命名

关于Haxe中的类型命名，第一个字母是必须为大写的。但是它有一个特殊的类名就是import.hx，该类一般用来作为全局导入类使用，这样其他类就不用重新import了。

#### 3.6.3 类型判断

原来AS3中是使用as语句进行判断的：

```haxe
if("13123" as String)
{
    trace("我是字符串类型！");
}
```

在Haxe中进行类型判断，请使用Std.is方法进行判断：

```haxe
if(Std.is("13123",String))
{
    trace("我是字符串类型！");
}
```

#### 3.6.4 泛型

动态类型在AS3中是称之为Object的类型，在Haxe中，是Dynamic类型。

#### 3.6.5 动态获取变量属性

通过一个字符串键值，去获取对象的属性。

在AS3中的实现十分简单：

```haxe
var obj:Object = {
    key:"abcdef"
}
trace(obj["key"]);
```

这在Haxe中，全部都围绕着Reflect类；那么如何动态获取一个对象的属性呢？请看示例：

```haxe
var obj:Dynamic = {
    key:"abcdef"
};
var keyValue:String = Reflect.getProperty(obj,"key");
trace(keyValue); //输出内容为：abcdef
```

上述的例子就是一个非常简单获取变量属性的方法。

#### 3.6.6 动态创建对象

一般是指通过字符串获取到Class，然后创建出对象，称之为对象反射。

AS3版本：

```haxe
var objClass:Class = getDefinitionByName(objName) as Class;
var obj:Object = new ObjClass();
```

Haxe版本，将主要围绕着Type类型：

```haxe
var objClass:Class<Dynamic> = Type.resolveClass(objName);
var obj:Dynamic = Type.createInstance(objClass);
```

#### 3.6.7 类型转换

在使用过程中，经常会遇到类型转换：

AS3版本：

```haxe
var mc:MovieClip = display as MovieClip;
```

Haxe版本：

```haxe
var mc:MovieClip = cast(display,MovieClip);
```

#### 3.6.8 C++注意事项

- Reflect.hasField问题

```haxe
Reflect.hasField(); //方法在CPP中永远返回false，可利用try来代替hasField判断。
```