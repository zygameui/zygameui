## 粒子动画

粒子动画使用的是`openfl-gpu-particles`库实现，简单的使用例子：

```haxe
var particles = new ZParticles();
// 传递名字即可，会通过ZBuilder绑定的资源管理中加载对应的资源
particles.dataProvider = "粒子数据JSON文件名:粒子图片名";
this.addChild(particles);
```

该ZParticles默认使用GPU粒子渲染，可通过访问`gpuSystem`来做更加详细的操作，可参考API：https://github.com/rainyt/openfl-gpu-particles

