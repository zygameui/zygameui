## 加载模型

目前引擎支持的3D模型格式有以下几种：

- awd1.0 & awd2.0
- 3ds
- obj
- dae1.4
- dxf
- md2
- md5mesh & md5anime
- ac3d
- FBX（尚未支持，可使用md5mesh & md5anime代替）

可以通过`zygameui.utils.ZAssets`进行载入3D模型，常规的使用方法：

```haxe
var assets = new ZAssets();
assets.load3DFile("scene.awd");
assets.start(function(f){
  if(f == 1){
    //加载完成
  }
});
```

## 模型使用

当模型被加载后，需要获取使用模型时，可通过：

```haxe
//创建一个完整的scene对象
assets.buildObject3D("scene"); 
```

或者只创建其中一个模型（注意该接口获取的是源数据，如果需要新建需要clone。）：

```haxe
assets.get3DMesh("scene:role");
```

