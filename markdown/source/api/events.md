## 基础事件

### 帧事件

在引擎中不推荐直接使用OpenFL的`Event.FRAME_ENTER`以及`Event.FRAME_OUT`等事件，请直接使用已封装好的API：

```haxe
//启动帧事件
this.setFrameEvent(true);
//关闭帧事件
this.setFrameEvent(false);
//重写onFrame方法，接收帧事件
override public function onFrame():Void{}
```

### 触摸事件

在引擎中一般可以不需要使用OpenFL的侦听管理，只需在类里重写方法：

```haxe
//触摸事件：当按下触摸时
override public function onTouchBegin(e:TouchEvent):Void{}

//触摸事件：当松开手时
override public function onTouchEnd(e:TouchEvent):Void{}

//触摸事件：当手在移动时
override public function onTouchMove(e:TouchEvent):Void{}

//鼠标事件：移出对象时
override public function onTouchOut(e:MouseEvent):Void{}

//鼠标事件：移入对象时
override public function onTouchOver(e:MouseEvent):Void{}
```

最后我们需要启动触摸事件：

```haxe
//开启触摸事件
this.setTouchEvent(true);

//当不需要时，进行关闭触摸事件
this.setTouchEvent(false);
```

### 原生事件

封装的事件，有效我们进行管理，但很多情况下，会出现需要直接调用原生事件的实现：

```haxe
//简单的侦听一个点击事件
this.addEventListener(MouseEvent.CLICK,function(e:MouseEvent):Void{});

//我们可以侦听一个自定义事件
this.addEventListener("eventName",function(e:Event):Void{});

//发起自定义事件调用
this.dispatchEvent(new Event("eventName"));
```

更多的原生事件知识，请前往OpenFL查阅学习：http://openfl.org

