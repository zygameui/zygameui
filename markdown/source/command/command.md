## 命令行

引擎带有便捷的命令行，可以使用命令行去构造、生成最终产物。

## 更新库列表

由引擎维护的版本库，可通过命令更新同步版本：

```shell
haxelib run zygameui -updatelib
```

如果本身某个库是开发者版本，希望使用线上的版本，可使用：

```shell
haxelib run zygameui -updatedev 库名
```

## 编译项目

引擎支持的编译平台很多，可以通过以下命令进行更新命令行：

- 如果初始化失败，请确保目录下存在.vscode目录，不存在可手动创建。

```shell
haxelib run zygameui -inittask
```

编译命令：

```shell
haxelib run zygameui -build 平台值
```

如果是HTML5特殊渠道的其他识别处理：

```shell
haxelib run zygameui -build html5:渠道名
```

## 上传库

当你拥有开发库的权限时，允许使用命令行上传库：

```shell
haxelib run zygameui -upload 库名
```

## 库列表

可通过命令，获取所有版本的情况：

```shell
haxelib run zygameui -libs
```

