## 3D鼠标点击

在Away3D中，所有对象的可点击属性`mouseEnabled`都为false。如果需要使用点击事件，需要侦听点击的对象将`mouseEnabled`设置为true，并进行侦听：

```haxe
plane.addEventListener(MouseEvent3D.CLICK,function(e:MouseEvent3D):Void{
					trace("3D触摸位置：",e.localPosition);
				});
```



