package zygame.utils;

import spine.openfl.SkeletonAnimation;
import zygame.utils.load.DynamicTextureLoader.DynamicTextureAtlas;

/**
 * Spine转纹理图集工具类
 */
class SpineToTextureUtils {
	/**
	 * 将Spine对象，解析成纹理图集，纹理图集最大支持4096的大小
	 * @param spine 需要解析成纹理图集的Spine对象
	 * @param actions 需要解析的动作
	 * @param fps 解析的FPS帧率
	 * @param call 解析回调，完成后会直接返回一个DynamicTextureAtlas对象
	 * @param defaultAtlas 如果需要将多个spine解析到同一个纹理集中时，请传递同一个纹理图集对象
	 * @param extname 在图集名称前面添加前缀，会使用_进行拼接，如extname_action1
	 */
	public static function parserSpineTextureAtlas(spine:SkeletonAnimation, actions:Array<String>, fps:Int, call:DynamicTextureAtlas->Void = null,
			defaultAtlas:DynamicTextureAtlas = null, extname:String = null):Void {
		var dynamicAtlas = defaultAtlas != null ? defaultAtlas : new DynamicTextureAtlas();
		for (action in actions) {
			spine.state.setAnimationByName(0, action, false);
			var curAnimeData = spine.getAnimation(action);
			var frame = 0;
			var time:Float = 0;
			while (true) {
				frame++;
				time += 1 / fps;
				if (time > curAnimeData.getDuration())
					break;
				@:privateAccess spine._advanceTime(1 / fps);
				// 渲染到动态图中
				var name = extname != null ? extname + "_" : "";
				dynamicAtlas.putSprite(name + action + frame, spine);
			}
		}
		if (call != null)
			call(dynamicAtlas);
		else if(defaultAtlas == null)
			throw "Must need a call or defaultAtlas.";
	}
}
