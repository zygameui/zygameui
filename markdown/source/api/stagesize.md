## 舞台高宽获取

在OpenFL中，通常可以通过以下命令获取到舞台的高宽：

```haxe
this.stage.stageWidth;
this.stage.stageHeight;
```

但是请注意，这里获取的宽高是没有经过适配兼容，请使用正确的舞台宽高获取方法：

```haxe
this.getStageWidth();
this.getStageHeight();
```

