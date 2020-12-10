## 时间管理器

时间管理器不依赖时间戳，因此效果是跟帧率计算有关，下面一个简单的延迟事件：

```haxe
Lib.setTimeout(function(){

},秒数,可选传参,可选运行环境);
```

进行一个循环间隔事件：

```haxe
Lib.setInterval(function(){

},秒数,可选传参,可选运行环境);
```

管理单个事件时，需要记录对应的计时器ID：

```haxe
var id = Lib.setInterval(function(){

},秒数,可选传参,可选运行环境);
Lib.clearInterval(id);
```

下一帧执行的事件：

```haxe
Lib.nextFrameCall(function(){

},可选参数,可选运行环境);
```

兼容活动恢复时执行事件，一般多用于脱离的游戏屏幕，返回游戏时：

```haxe
Lib.resemeCall(function(){

},可选参数,可选运行环境);
```

##### 可选运行环境

该库在zygameui5.8.3版本后，支持多个时间管理器，可利用可选运行环境，定义新的计时器运行环境；同时提供了两个清理时间运行环境中的所有计时事件的方法：

```haxe
Lib.clearTimeRuntime(可选运行环境); //不传时为默认运行环境
Lib.clearAllTimeRuntime(); //清理所有运行环境
```