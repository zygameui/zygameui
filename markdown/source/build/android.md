## 安卓编译

需要生成apk包体时，需要以下环境：

- JDK13（前往官方下载，建议使用JDK13）
- AndroidSDK（可以下载AndroidStudio，使用Studio进行安装AndroidSDK）
- NDKr15c（前往官方下载）

当以上资源都准备好后，就可以开始进行配置：

```shell
lime setup android
```

配置过程中将环境路径配置完毕之后，就可以通过命令进行安卓编译：

```shell
haxelib run zygameui -build android
```



