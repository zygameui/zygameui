## 条件编译

当需要为不同的平台定义不同的编译条件时，可在命令后面追加条件`:编译条件`：

```haxe
haxelib run zygameui -build html5:red
```

这时候就会自动追加一个`red`的`haxedef`定义，可以直接在Haxe中使用，如：

```haxe
var color = 0xffffff;
#if red
color = 0xff0000;
#end
```

通过条件编译，可区分测试功能模块等，或者是功能实现。

