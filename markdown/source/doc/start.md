## 开始

需要下载所需依赖组件：

```shell
haxelib install zygameui.zip
haxelib run zygameui -updatelib
```

[注意] 请勿使用官方的OpenFL & Lime库，zygameui将使用兼容后的OpenFL & Lime库。

## 创建项目

使用openfl命令创建项目：

```shel
openfl create project 项目名
```

## 编程

使用Visual Studio Code打开工作区目录，指向当前项目目录。并需要为Visual Studio Code安装所需的插件：

``` shell
Haxe
Lime
```

## 添加库

在project.xml中新增：

```xml
<haxelib name="zygameui"/>
```

## 修改Main类

请继承zygame.core.Start类：

```haxe
import zygame.core.Start;
class Main extends Start {

    public function new(){
        super(1024,600,true);
    }

    override public function onInit():Void{
        //请在这里编写游戏逻辑
    }

}
```

## 编译项目

Mac环境下，请使用<kbd>Command</kbd> + <kbd>Shift</kbd> + <kbd>B</kbd>进行调用编译命令。

## 测试项目

```shel
openfl test html5 --port=自定义端口，不提供默认3000
```

