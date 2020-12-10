## Project项目配置

游戏编译过程中，会依赖Lime的project.xml配置文件来进行编译，此文档可以帮助你了解XML功能模块。

### 条件编译

首先，项目文件格式中的每个节点都支持`if`和`unless`属性。这些是条件值，可帮助您基于许多值来定制构建过程。以下是一些默认值：

- mobile（手机）
- desktop（桌面）
- web（浏览器）
- ios （IOS平台）
- android（安卓平台）
- windows（Window系统）
- mac（MacOs系统）
- linux（Linux系统）
- html5（HTML5）
- cpp（C++运行时）
- neko（Neko虚拟机）
- flash（Flash虚拟机）
- js（JS运行时）

您可以`<set />`或`<unset />`条件逻辑的值：

```xml
<set name="red" />
<window background="#FF0000" if="red" />
```

这也可以用来传递特殊值：

```xml
<set name="color" value="#FF0000" if="red" />
<set name="color" value="#0000FF" if="blue" />
<window background="${color}" if="color" />
```

您可以在[模板中](https://lime.software/docs/project-files/xml-format/#template)使用这些值，如下所示：`::SET_COLOR::`

同样，您也可以将值`<define />`或`<undefine />`也传递给Haxe的值。

```xml
<define name="red" />
<window background="#FF0000" if="red" />
#if red
trace ("Background is red");
#end
```

您可以使用`::DEFINE_RED::`或者是`::SET_RED::`。

您也可以使用命令行添加定义：

```shell
lime test flash -Ddefine
```

如果您需要在条件中包含多个值，则空格表示“和”，竖线表示“或”，如下所示：

```xml
<window width="640" height="480" if="define define2" unless="define3 || define4" />
```

### 重复项

每个标签可以包含多个副本，因此不必担心将它们全部放在一个地方。您定义的所有值都将使用。如果您多次定义相同的值，则将使用最后一个定义。

```xml
<window width="640" />
<window height="480" />
```

### include.xml

如果创建haxelib，则可以将“ include.xml”添加到顶级目录。构建工具将自动将文件内容添加到用户的项目中。您可以使用它来添加二进制依赖项，其他类路径等。

## XML标记词汇表

### 应用程式

该`<app />`标签值集建设项目，包括入口点（主类），输出文件目录，重要的或者如果你想定制的可执行文件名或定义为一个网络平台自定义的预加载：

```xml
<app main="com.example.MyApplication" file="MyApplication" path="Export" preloader="CustomPreloader" />
<app swf-version="11" />
```

### 建筑

使用`<architecture />`标签设置或排除特定于Android的体系结构。这些可以是`ARMv7`，`ARMv6`，`ARMv5`和`X86`。

默认情况下，构建的唯一体系结构是`ARMv7`。

例如，如果要启用`ARMv6`和禁用，则`ARMv7`可以将`<architecture />`标签设置为：

```xml
<architecture name="armv6" exclude="armv7" if="android" />
```

### 资产

使用资产节点将资源添加到您的项目中，可以使用`lime.Assets`。

path属性可以指向文件或目录。这些文件将被复制（或嵌入）在您的最终项目中，并且可以使用`lime.Assets`类进行访问。

例如，如果在项目文件中包括以下节点：

```xml
<!-- 一般embed默认为true，但在引擎里一般不这样使用，需要改为embed为false，使资源能够自行加载处理 -->
<assets path="images/MyImage.jpg" embed="true"/>
```

您可以像这样在应用程序中访问它：

```haxe
//一般引擎里不这样使用，需要通过ZAssets资源管理来加载读取
var bitmapData = Assets.getBitmapData ("images/MyImage.png");
```

默认情况下，目标路径将镜像源路径，但是如果您希望使用其他目标路径，则还可以包括一个重命名属性。该`lime.Assets`班将使用*目标*的默认路径，所以使用重命名属性将改变你使用引用您的文件的名称。

如果您希望自己为资产文件设置ID，请使用“ id”属性。这仅适用于指向文件而不是目录路径的资产节点。

指向目录时，可以使用include或exclude属性指定用于自动包括文件的模式。支持通配符。例如，要包括目录下的所有文件，请使用包含值“ *”。您可以使用“  ”字符。

您可以将资产节点相互嵌套。如果在顶级资产节点中指定目录，则该目录的路径将追加到在后续节点中指定的路径。

每个文件的类型将根据每个文件扩展名自动确定，但是您可以使用type属性自行为文件或目录设置它。如果要将节点嵌套在另一个资产节点内，则还可以使用类型的名称作为节点的名称。

这些是当前类型：

- binary（二进制）
- font（字体）
- image（图片）
- music（音乐）
- sound（声音）
- template（模板）
- text（文本）

某些目标只能支持一次播放一个音乐文件。对于设计为作为背景音乐播放的文件，应使用“音乐”，对于所有其他音频，应使用“声音”。“ binary”和“ text”是通用类型，可以在应用程序中以ByteArray或String形式使用。大多数目标可以互换使用。

如果将资产指定为“模板”，则不会将其复制/嵌入为普通资产，而是将其复制到项目的根目录，因此您可以替换任何模板HX，HXML或特定于平台的模板目标文件。

```xml
<assets path="assets" include="*" />
<assets path="../../assets" rename="assets" include="*" />
<assets path="assets/images" rename="images" include="*.jpg|*.png" exclude="example.jpg" />
<assets path="assets">
<assets path="images" include="*" type="image" />
<assets path="assets">
	<sound path="sound/MySound.wav" id="MySound" />
	<music path="sound/BackgroundMusic.ogg" />
</assets>
```

### 证书

使用`<certificate />`标记添加密钥库以在某些平台上进行发布签名。

如果不包括密码属性，则将在命令行提示您输入证书密码。

对于Android，默认情况下，别名将设置为证书的文件名，不带扩展名。如果别名不同，则可以使用alias属性。

如果设置了password属性，则alias_password属性将默认为相同的值。否则，您可以添加一个别名密码属性来指定其他值。

```xml
<certificate path="to/certificate.crt" password="1234" alias="my-alias" alias-password="4321" />
```

iOS不使用证书`path`和`password`，而是使用`team-id`与Apple Developer门户中为您的团队提供的ID匹配的属性：

```xml
<certificate team-id="SK12FH34" />
```

### 类路径

与“来源”相同。

### 编译器标志

与“ haxeflag”相同。

### 配置

使用`<config />`标签设置特定于平台的值。当前支持以下目标：

- air
- android
- blackberry
- console-pc
- firefox
- flash
- html5
- ios
- linux
- mac
- ps3
- ps4
- tizen
- vita
- windows
- webos
- wiiu
- xbox1
- emscripten
- tvos

**根据平台的不同，必须在标签后缀一个后缀。**

例如，使用`<config:android />`标签设置特定于Android的值：

```xml
<config:android install-location="preferExternal" />
<config:android permission="com.android.vending.BILLING" />
<config:android target-sdk-version="16" />
```

`<config:ios />`编译时使用标签设置特定于iOS的值。该`deployment`属性可以设置您希望定位的最低iOS版本。该`prerendered-icon`属性可以帮助控制图标的样式。

```xml
<config:ios deployment="5.1" />
<config:ios prerendered-icon="false" />
```

### 定义

与`<set />`标签类似，用于`<define />`将值也传递给Haxe。请参阅上面的[条件](https://lime.software/docs/project-files/xml-format/#Conditionals)部分。

```xml
<define name="myDefineFlag" />
```

### 依赖

使用`<dependency />`标记可以指定编译项目所需的本机框架或参考，以及需要复制的其他库。

```xml
<dependency name="GameKit.framework" if="ios" />
```

### 输出信息

将指定的消息打印到控制台。

```xml
<echo value="Some output message" />
```

### 错误

记录一个错误，`lime.utils.Log.error()`默认情况下会引发该错误`value`并停止编译（如果`lime.utils.Log.throwErrors`设置为`true`）。

例子：

```xml
<section if="html5">
	<error value="html5 isn't supported!" />
</section>
```

### Haxe定义

使用`<haxedef />`标签添加Haxe定义（类似于将a`<haxeflag />`与“ -D”一起使用）：

```xml
<haxedef name="define" />
```

### Haxeflag

使用`<haxeflag />`标签在Haxe编译过程中添加其他参数：

```xml
<haxeflag name="-dce" value="std" />
```

### Haxelib

使用`<haxelib />`标签包括Haxe库：

```xml
<haxelib name="actuate" />
```

如果您愿意，还可以指定一个版本：

```xml
<haxelib name="actuate" version="1.0.0" />
```

### 图标

使用`<icon />`节点将图标文件添加到您的项目。当命令行工具请求目标平台的图标时，它将使用您提供的精确大小匹配，或者将尝试查找最接近的匹配并调整大小。如果包含SVG矢量图标，则该文件应优先于调整位图文件的大小。

```xml
<icon path="icon.png" size="64" />
<icon path="icon.png" width="96" height="96" />
<icon path="icon.svg" />
```

### 包含其他XML文件

使用`<include />`标签可添加在另一个项目文件中找到的标签，或在目标目录中找到“ include.xml”文件：

```xml
<include path="to/another/project.xml" />
<include path="to/shared/library" />
```

### JAVA

`<java />`定位Android时，使用标签将Java类添加到项目中：

```xml
<java path="to/classes" />
```

### 语言

在支持的语言列表中添加一种语言（默认情况下，该列表为空）。

```xml
<language name="en-US" />
```

### 启动图像

设置启动应用程序映像的路径（该映像将在应用程序启动时显示）

```xml
<launchimage path="launchImage.png" />
```

### 发射板

设置启动屏幕故事板（仅适用于iOS开发）。

```xml
<launchstoryboard path="image.png" />
```

要么

```xml
<launchstoryboard name="image.png" />
```

您也可以将其`template`用于此目的（将来记录）。

### 库

所有资产都进入“默认”库，但是通过添加`<library>`标签，可以修改默认库，还可以定义其他库并根据需要加载/卸载它们。

要在默认库上禁用预加载：

```xml
<library name="default" preload="false" />
```

要在运行时加载资产，请执行以下操作：

```haxe
Assets.loadLibrary ("default").onComplete (function (library) {

    var bitmapData = Assets.getBitmapData ("default:image.png");
    // or
    var bitmapData = Assets.getBitmapData ("image.png");
    // "default:" prefix is implied, if no library prefix is included
});
```

**使用其他资产库**

您可以轻松地将资产添加到“默认”库以外的库中。这些默认情况下不会预先加载，除非您添加：`<library name="myOtherLibrary" preload="true" />`

然后将某些资产分配给上述库： `<assets path="assets/other" library="myOtherLibrary" />`

检索代码中的资产时，请确保指定正确的库。有关使用库前缀的信息，请参见上面的示例。

您也可以使用`Assets.unloadLibrary`，当您使用这些资源做。

### 日志

记录错误（请参阅“错误”），警告或信息消息。

例子：

```xml
<log error="error message" />
<log warn="warn message" />
<log info="info message" />
<log value="your message" />
<log verbose="verbose message" />
```

### 元数据

使用`<meta />`标签添加有关您的应用程序的信息，通常不会影响应用程序的运行方式，但会影响如何将其标识到目标操作系统或应用程序商店中：

```xml
<meta title="My Application" package="com.example.myapplication" version="1.0.0" company="My Company" />
```

### Module

还有更多。

### NDLL

您可以使用`<ndll />`标签来包含本机库。这些通常位于“ ndll”目录下，并根据目标平台提供其他目录。通常，`<ndll />`标记将作为扩展的一部分包含在内，并且很少直接使用：

```xml
<ndll name="std" haxelib="hxcpp" />
```

### PATH

使用`<path />`标记将目录添加到系统的PATH环境变量。

```xml
<path value="path/to/add/to/system/PATH" />
```

### 构造后命令

使您可以设置构建后命令，例如Haxe代码（由Haxe解释器插入），运行文件命令或控制台命令。

```xml
<postbuild haxe="Haxe code"/>
<postbuild open="file to run"/>
<postbuild command="command to run"/>
<postbuild cmd="command to run"/>
```

### 预构造前命令

使您可以设置预构建命令，例如Haxe代码（由Haxe解释器插入），运行文件命令或控制台命令：

```xml
<prebuild haxe="Haxe code"/>
<prebuild open="file to run"/>
<prebuild command="command to run"/>
<prebuild cmd="command to run"/>
```

### 更改预加载入口

```xml
<app preloader="preloaderClass" />
```

### 组合

该`<section />`标签是用来组其他标签一起。当结合“如果”和/或“除非”逻辑时，这通常是最有价值的：

```xml
<section if="html5">
	<source path="extra/src/html5" />
</section>
```

### 设置

使用`<set />`标签设置条件逻辑变量。请参阅上面的[条件](#Conditionals)部分。

```xml
<set name="red" />
```

### 设定

使用`<setenv />`标签设置环境变量：

```xml
<setenv name="GLOBAL_DEFINE" />
```

### 源代码

使用`<source />`标签添加Haxe类路径：

```xml
<source path="Source" />
```

如果你正在使用`@:file`，`@:bitmap`，`@:sound`或`@:file`在项目中的标签，确保资产的文件是你HAXE源路径中可用。

### 目标

通过运行自定义的haxelib命令，可以重新定义特定目标的构建过程。如果您想使用自己的库来构建项目，这可能很有用，例如，您知道自己在做什么，并且知道Lime构建系统是如何工作的。

```xml
<target name="customTarget" handler="yourHandler" />
```

### 模板

使用`<template />`标签添加路径，这些路径可以覆盖命令行工具使用的模板。

您可以添加完整的模板路径，如下所示：

```xml
<template path="templates" />
```

否则，您可以像这样覆盖单个文件：

```xml
<template path="Assets/index.html" rename="index.php" />
```

### 模板路径

请参阅“模板”。

```xml
<templatepath name="path"/>
```

### 未定义

取消设置先前定义的标志。请参阅的条目`<define />`。

```xml
<undefine name="red" />
```

### 未设定

取消先前设置的值。请参阅的条目`<set />`。

```xml
<set name="red" value="0xff0000" />
<unset name="red" />
```

### 窗口

您可以使用`<window />`标签来控制如何初始化应用程序。这包括屏幕分辨率和背景色，以及其他选项，例如是否应允许硬件或显示模式标志。

默认情况下，移动平台使用的窗口宽度和高度为0，这是一个使用当前显示器分辨率的特殊值。这在台式机平台上可用，但通常建议改为启用该`fullscreen`标志，并将`width`和`height`值设置为良好的窗口分辨率。`fps="0"`HTML5有一个特殊值，它是默认值，它使用“ requestAnimationFrame”而不是强制使用帧速率。

```xml
<window width="640" height="480" background="#FFFFFF" fps="30" />
<window hardware="true" allow-shaders="true" require-shaders="true" depth-buffer="false" stencil-buffer="false" />
<window fullscreen="false" resizable="true" borderless="false" vsync="false" />
<window orientation="portrait" />
```

该`orientation`值预期为“纵向”或“横向”……默认值为“自动”，它允许操作系统决定要使用的方向。