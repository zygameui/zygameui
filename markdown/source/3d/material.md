## 材质

材质是用来渲染3D模型的表面的主要对象，使用图片、颜色来渲染画面。当材质收到光线的影响、就可以得到一个真实3D的材质。

Away3D中拥有两种常用材质：

#### TextureMaterial 纹理材质

使用`BitmapData`作为纹理生成出材质：

```haxe
var planeMaterial = new TextureMaterial(Cast.bitmapTexture(_zassets.getBitmapData("floor_diffuse")));
```

#### ColorMaterial 颜色材质

```haxe
var color = new ColorMaterial(0xff0000);
```