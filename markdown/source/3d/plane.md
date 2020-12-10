## 地面

一般用于地面渲染都是使用一张面`PlaneGeometry`来解决。常规渲染方式：

```haxe
var plane:Mesh = new Mesh(new PlaneGeometry(5000, 5000), 材质);
cast(plane.geometry, PlaneGeometry).doubleSided = true; // 双面 贴图
this.addChild(plane);
```