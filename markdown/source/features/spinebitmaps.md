## Spine位图缓存
使用Spine位图缓存意味着将丢失Spine原有的中间差值过渡支持。但相反，可以得到一张统一的精灵图，这意味着允许将Spine动画直接在批渲染中进行使用。

当如果我们需要使用Spine位图缓存时，则需要使用`DynamicTextureAtlas`类型来进行缓存Spine，这是一个简单的例子：

```haxe
var textureAtlas = new DynamicTextureAtlas();
// 确保所有的Spine资源都加载完毕，通过平常的方式创建Spine，并设置好自已所需的皮肤
var spine = this.assetsBuilder.assets.createSpineSpriteSkeleton(file, file);
// 从这里开始进行缓存，将Spine对应的动作run缓存到textureAtlas中
zygame.utils.SpineToTextureUtils.parserSpineTextureAtlas(spine, ["run"], 24, null, textureAtlas, file);
spine.destroy();
```

### 注意事项
- 由于是位图缓存技术，在位图已经被任何对象当做纹理使用的时候，则无法再往纹理里进行写入，否则会发生异常错误。
- 位图缓存技术支持4096的大尺寸图集，但如果填充的位图超过了这个尺寸，也会发生异常错误，因此需要根据实际情况，填补内容。