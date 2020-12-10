## 嵌入加载

`zygame.macro.ZMacroUtils`支持嵌入加载TextureAtlas以及SpineTextureAtlas功能，使用该功能后，资源会被嵌入到代码中：

```haxe
//加载嵌入TextureAtlas纹理示例
ZMacroUtils.loadEmbedTextures(Game.assets,"GameAssets/StartScene.png", "GameAssets/StartScene.xml",false);
//加载嵌入Spine示例
ZMacroUtils.loadSpineEmbedTextures(Game.assets,["GameAssets/spine/main.png"], "GameAssets/spine/main.atlas");
Game.assets.setObject("main",Json.parse(ZMacroUtils.readFileContent("GameAssets/spine/main.json")));	
```

通过`zygame.utils.ZAssets`完成加载流程：

```haxe
Game.assets.start(function(f){
  if(f == 1){
    trace("加载完成");
  }
})
```

