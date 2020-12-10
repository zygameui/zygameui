## 资源引用

该功能开启后，会对项目的资源进行默认的读取，并自动生成出资源路径解析，直接通过`R`类型访问：

```haxe
var url = R.xml.FileName.url; //assets/game/views/FileName.xml
var name = R.xml.FileName.name; //FileName
var atlasPng = R.atlas.FileName.png //assets/game/ui/FileName.png
var atlasPng = R.atlas.FileName.xml //assets/game/ui/FileName.xml
```

## 刷新引用

当你存在新增的资源时，需要重置语言服务器刷新引用。

## 使用注意事项

整个zproject配置下，不应该有重复命名的资源。否则会产生冲突。仅读取zproject.xml的资源列表，不会读取子资源列表。

## 类型支持

目前仅支持识别png/jpg/xml/json等文件。

## 禁用资源引用

该项功能目前是默认启动，如果不需要，则可通过宏关闭：

```xml
<haxedef name="disable_res"/>
```