[dir]:doc

## zygameui公共库代码
js目录下是在QQ/微信小游戏中使用的公共库代码。

# 重要

当需要在微信小游戏提交审核时，需要备注内容，避免代码库导致审核失败：

```haxe
您好，存在多款游戏使用的公共引擎库一致，以下为公共库情况链接：
OpenFL引擎库：https://github.com/openfl/openfl
Lime引擎库：https://github.com/haxelime/lime
游戏框架库：https://github.com/rainyt/zygameui
公共库JavaScript文件：https://github.com/rainyt/zygameui/tree/master/js
```

# 该库作用

使用该库开发的游戏，可以轻松发布到各个小游戏平台，并可以得到C++性能级别的安卓/IOS运行包。同时我也在维护openfl/Away3D库，该库可以轻松载入3D资源，3D库：http://github.com/rainyt/zygameui-3d 

## 入门

由Haxe+OpenFL+Lime支持的跨平台2D游戏引擎。是由[左眼]于2018年创建，并投入开发项目使用。经过多个版本的维护，当前版本已满足绝大部分游戏开发需求，拥有核心组件以及小游戏驱动良好支持。

## 引擎特点

- 支持Tilemap点击事件
- 自带精灵图系统
- 支持基础组件（兼容小游戏）
- xml创建UI布局
- 内置迷你小游戏引擎

## 教程

请参考http://static.zygameui.cn/games/doc/index.html

## Python3+
zygameui命令行需要依赖python3，同时需要安装以下库：
```shell 
pip3 install chardet
pip3 install pandas
pip3 install xlrd
```

## 主要库依赖安装
```shell
haxelib install openfl
haxelib install lime
haxelib setup openfl
haxelib install openfl-glsl
haxelib install openfl-gpu-particles
haxelib install vector-math
haxelib install openfl-spine
haxelib install swf
haxelib install hscript
haxelib install spine-hx 3.6.0
haxelib install tweenxcore
haxelib install castle
haxelib install crypto
haxelib install differ
```

## 平台支持

引擎目前支持Android/IOS/Window/Mac/HTML5等主流平台，但唯一已不再支持Flash输出。

在Android/IOS/Window/Mac等平台上，游戏将使用C++运行游戏，可使用高性能的本机运行。

在HTML5等平台上，游戏将使用JavaScript运行游戏；并支持不同渠道的小游戏兼容。

### 已支持编译平台
- HTML5
- 微信小游戏
- 4399游戏盒
- Bilibili快游戏
- 字节跳动快游戏
- 手Q小游戏
- 百度小游戏
- 梦工厂小游戏
- 奇虎小游戏
- Facebook小游戏
- 魅族快游戏
- 华为快游戏
- 小米快游戏
- 移动MMH5小游戏
- Vivo快游戏
- Oppo快游戏
- Wifi无极环境小游戏
- 豹趣H5小游戏
- 趣头条H5小游戏
- 360奇虎快游戏
- 九游UCH5小游戏
- 安卓Android
- 苹果IOS
- 4399H5全平台兼容小游戏
- 小米赚赚H5小游戏
- YY小游戏（H5）
- HashLink

（以上库暂未发布，如果有需要，可以联系我！）
