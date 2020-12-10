## 场景

游戏中可能会存在多个场景，但场景一般都是多用于复用的情况下，如首页、选关页面，这些页面切换后，应该仍然留在内存中，以便下次获取可以直接使用。如果我们需要用到场景，应继承ZScene对象，场景会比基础容器API会多以下几个API：

```haxe
//当场景不再需要，可以在这里做一些特定释放处理
public function onSceneRelease():Void{};

//当场景已经被创建后，但经过API再次添加到舞台时，会调用此方法，可作为刷新页面的作用
public function onSceneReset():Void{};
```

一个简单的示例：

```haxe
class MainScene extends ZScene {

    override public function onInit():Void{
        super.onInit();
        //实现逻辑
    }

    override public function onSceneRelease():Void{
        //实现页面失效处理
    }

    override public function onSceneReset():Void{
        //实现页面重用，刷新处理等
    }

}
```

场景一般不需要主动new，场景管理器会管理所有的场景用例。如果该场景是复用场景，可以直接调用replaceScene实现。

```haxe
//创建一个MainScene的场景类
ZSceneManager.current.createScene(MainScene);
```

当需要切换场景，或者显示场景时，可直接调用replaceScene实现，这个方法会同时处理createScene方法。

```haxe
//切换至一个ManScene的场景类，如果该类已经存在，则会进行复用，其中布尔值是决定当前被切换的场景是否需要直接释放掉。
ZSceneManager.current.replaceScene(MainScene,false);
```

提供了有2种释放方法：

```haxe
//针对场景实例进行释放
ZSceneManager.current.releaseScene(scene);
//针对场景类进行释放
ZSceneManager.current.releaseSceneFormClass(MainScene);
```