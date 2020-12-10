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

引擎支持的编译平台很多，目前已支持的平台指令有：

- wechat（微信小游戏）
- tt（头条小游戏）
- baidu（百度小游戏）
- android（安卓）
- ios（IOS）
- oppo（OPPO快游戏）
- vivo（VIVO快游戏）
- qqquick（QQ小游戏）
- html5（H5版本）
- 4399（4399H5）
- g4399（4399快游戏）
- xiaomi-zz（小米赚赚）
- xiaomi-h5（小米H5）
- xiaomi（小米快游戏）
- mgc（梦工厂小游戏）
- wifi（WIFI连尚无极小游戏）
- meizu（魅族快游戏）
- mmh5（MM移动H5小游戏）
- facebook（FaceBook小游戏）
- huawei（华为快游戏）
- qihoo（奇虎360快游戏）
- bili（BiliBili小游戏）

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

