[dir]:doc

## zygameui公共库代码
js目录下是在QQ/微信小游戏中使用的公共库代码。

# 该库作用

使用该库开发的游戏，可以轻松发布到各个小游戏平台，并可以得到C++性能级别的安卓/IOS运行包。同时我也在维护openfl/Away3D库，该库可以轻松载入3D资源，3D库：http://github.com/rainyt/zygameui-3d。

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

## 主要库依赖
- Openfl8.9.3+
- castle
- differ
- spine-hx
- hscript
- tweenxcore

## 平台支持

引擎目前支持Android/IOS/Window/Mac/HTML5等主流平台，但唯一已不再支持Flash输出。

在Android/IOS/Window/Mac等平台上，游戏将使用C++运行游戏，可使用高性能的本机运行。

在HTML5等平台上，游戏将使用JavaScript运行游戏；并支持不同渠道的小游戏兼容。

### 已支持小游戏平台

- 微信小游戏、百度小游戏、QQ小游戏、字节小游戏、梦工厂小游戏、360奇虎小游戏、BILIBILI小游戏（wechat-zygame-dom）
- 4399H5小游戏（4399h5-sdk）
- 4399游戏盒小游戏（wechat-zygame-dom）
- WIFI连尚无极小游戏（wifi-cpk-core）
- 魅族小游戏（meizu-rpk-core）
- 移动MMH5小游戏（mm-h5-sdk）
- Oppo快游戏、H5小游戏（oppo-rpk-core、oppocore-jssdk）
- UCH5小游戏（uc-h5-sdk）
- Vivo快游戏（vivo-rpk-core）
- 小米快游戏、H5小游戏（xiaomi-rpk-core、xiaomi-h5）
- 小米赚赚H5小游戏（xiaomi-zz）
- YYH5小游戏（yy-sdk）
- 章鱼输入法小游戏（zhangyu-sdk）

（以上库暂未发布，如果有需要，可以联系我！）
