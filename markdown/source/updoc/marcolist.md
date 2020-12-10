## 宏工具

可使用`zygame.marco.ZMacroUtils`处理一些功能。请注意宏读取的路径都是相对于项目根目录。

## 缓存内容到代码

如果你需要将HTTP的请求内容，缓存一份到代码中：

```haxe
var httpcontent = ZMacroUtils.buildHttpContent(url,postdata);
```

也可以把本地的文件内容，缓存一份到代码中：

```haxe
var localcontent = ZMacroUtils.readFileContent(file);
```

同时，如果是二进制文件，可以缓存Base64数据到代码中：

```haxe
var base64data = ZMacroUtils.readFileContentBase64(file);
```

## 生成ZIP文件

将某个文件夹压缩成Zip资源包，并返回对应的加载路径。路径仅使用于Export，HTML5、Android、IOS平台。

```haxe
// 会将views目录压缩成一个views.zip文件，然后可通过ZAssets加载zip的方式进行加载。
var loadzipPath = ZMacroUtils.buildZipAssets("assets/views");
```

