## 数据储存

当需要本地持久化存储数据时，可以使用`zygame.utils.Lib`中的`setData`以及`getData`方法。

### 往本地储存数据

```haxe
Lib.setData("saveKey","储存值");
```

### 从本地读取数据

```haxe
var data = Lib.getData("saveKey","默认值");
```

