## C++调试

在生成C++版本时，发布正式版的时候，是没有堆栈跟踪的，需要添加以下宏进行支持：

```xml
<!-- 即使在发布模式下，也要在最终二进制文件中添加符号。 -->
<define name="HXCPP_DEBUG_LINK" if="debug"/>
<!-- 即使在发布模式下，也具有有效的功能级堆栈跟踪。 -->
<define name="HXCPP_STACK_TRACE" if="debug"/>
<!-- 即使在发布模式下，也将行信息包括在堆栈跟踪中。 -->
<define name="HXCPP_STACK_LINE" if="debug"/>
<!-- 即使在发布模式下，也要添加空指针检查。 -->
<define name="HXCPP_CHECK_POINTER" if="debug"/>
```

添加`debug`条件是因为发布正式版的时候，一般不需要包含这些信息，移除后可以提高性能。

当需要进行debug调试时，可运行以下例子命令：

```shell
lime build android -debug
```

或者

```shell
haxelib run zygameui -debug android
```



