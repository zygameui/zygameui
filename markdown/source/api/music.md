## 音频管理

可通过`zygame.media.SoundChannelManager`来管理音频，可控制背景音乐、音效的开关，停止/恢复等操作。

停止背景音乐：

```haxe
SoundChannelManager.stopMusic();
```

恢复背景音乐：

```haxe
SoundChannelManager.resumeMusic();
```

停止所有音效播放：

```haxe
SoundChannelManager.stopAllEffect();
```

停止所有音效和背景音乐：

```haxe
SoundChannelManager.stopAllEffectAndMusic();
```

设置背景音乐是否可用：

```haxe
SoundChannelManager.setMuciAvailable(true);
```

设置音效是否可用：

```haxe
SoundChannelManager.setEffectAvailable(true);
```

获取音效或者背景音乐的可用性：

```haxe
// 音效
SoundChannelManager.isEffectAvailable();
// 音乐
SoundChannelManager.isMusicAvailable();
```

## 静音功能

如果游戏需要使用静音功能，一般只需要使用上述接口就可以实现。