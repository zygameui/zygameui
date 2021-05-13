## 自动导入类型

在`zygameui10.2.9`开始，支持批量自动导入某个文件夹下的所有类型：

```haxe
@:build(zygame.macro.ImportAllClasses.build(源代码相对目录))
class SelectScene {
  
}
```

该功能常用于需要创建关卡类进行频繁手动导入的地方。