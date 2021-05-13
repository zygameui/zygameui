## 音频组件

使用音频组件可以在XML中直接配置MP3资源，当使用`AutoBuilder`和`ZBuilderScene`配合时，音频会自动加载：

```xml
<ZSound id="sound" src="bg"/>
```

通过AutoBuilder绑定完成后，当需要在Haxe中调起该音频时：

```haxe
// 播放单次
this.sound.play();
// 多次播放
this.sound.play(99999);
```

## 节奏

音频组件支持多重音频播放，根据`rhythm`属性，可配置音频的节奏：

```haxe
this.sound.rhythm = "100 200 300 100"; //单位为毫秒，多个间隔节奏请使用空格隔开。
```

成功设置节奏后，需要重新调用`play()`才会正常生效。

## 停止所有ZSound音频

一般音频组件无法使用`ZAssets`直接停止，单个音频停止，请使用：

```haxe
this.sound.stop();
```

如果需要停止所有ZSound的音频，请使用：

```haxe
ZSound.stopAllZSound();
```

