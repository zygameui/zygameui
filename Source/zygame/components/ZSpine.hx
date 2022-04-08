package zygame.components;

import haxe.Exception;
import openfl.display.Shader;
import zygame.utils.SpineManager;
import spine.AnimationState;
import zygame.display.batch.ImageBatchs;
import zygame.display.batch.BSpine;
import spine.openfl.SkeletonAnimation;
import spine.tilemap.SkeletonAnimation in TilemapAnimation;

/**
 * 可通过ZBuilder创建的骨骼动画(可点击、触摸)，默认允许XML中使用。
 * ```xml
 * <ZSpine src="spine:spine"/>
 * ```
 */
class ZSpine extends ZBox {
	private var spine:SkeletonAnimation;

	private var btilemap:ImageBatchs;
	private var bspine:BSpine;

	/**
	 * 是否循环播放，默认为true
	 */
	public var isLoop:Bool = true;

	/**
	 * 播放动作
	 */
	public var action(get, set):String;

	/**
	 * 皮肤ID
	 */
	public var spineSkin(get, set):String;

	/**
	 * 是否独立播放，如果独立播放，则不会受到`SpineManager`的控制影响。
	 */
	public var independent(get, set):Bool;

	/**
	 * 是否缓存模式，对三角形数据进行缓存处理，仅在spine的情况下才能够缓存
	 */
	public var isCache(get, set):Bool;

	private var _isCache = false;

	/**
	 * 是否使用tilemap渲染，默认为false
	 */
	public var tilemap:Bool = false;

	function get_isCache():Bool {
		return _isCache;
	}

	function set_isCache(value:Bool):Bool {
		_isCache = value;
		if (getNativeSpine() != null)
			getNativeSpine().isCache = value;
		return _isCache;
	}

	/**
	 * 获取`Sprite`渲染的Spine对象
	 * @return SkeletonAnimation
	 */
	public function getNativeSpine():SkeletonAnimation {
		return spine;
	}

	/**
	 * 获取`Tilemap`渲染的Spine对象
	 * @return TilemapAnimation
	 */
	public function getTilemapSpine():TilemapAnimation {
		return bspine != null ? bspine.spine : null;
	}

	private function set_spineSkin(name:String):String {
		try {
			if (btilemap != null)
				bspine.spineSkin = name;
			else {
				if (spine != null) {
					spine.skeleton.setSkinByName(name);
					spine.skeleton.setBonesToSetupPose();
					spine.skeleton.setSlotsToSetupPose();
				}
			}
		} catch (e:Exception) {
			trace("异常，无法找到皮肤：" + name);
		}
		return name;
	}

	private function get_spineSkin():String {
		if (spine == null && bspine == null)
			return null;
		if (bspine == null) {
			return spine.skeleton.getSkin() != null ? spine.skeleton.getSkin().name : null;
		}
		if (bspine.spine.skeleton.getSkin() == null)
			return null;
		return bspine.spine.skeleton.getSkin().name;
	}

	/**
	 * 动画状态
	 */
	public var state(get, never):AnimationState;

	private function get_state():AnimationState {
		if (bspine != null)
			return bspine.state;
		if (spine != null)
			return spine.state;
		return null;
	}

	private function get_action():String {
		if (bspine != null) {
			return bspine.action;
		}
		if (spine != null)
			return spine.actionName;
		return null;
	}

	private function set_action(v:String):String {
		try {
			if (bspine != null) {
				bspine.action = v;
				return v;
			}
			if (spine != null)
				spine.playForce(v, isLoop);
		} catch (e:Exception) {
			trace("异常：动作" + v + "不存在");
		}
		return v;
	}

	/**
	 * 停止
	 */
	public function stop():Void {
		if (bspine != null)
			bspine.spine.stop();
		if (spine != null)
			spine.stop();
	}

	override function set_width(value:Float):Float {
		if (btilemap != null)
			btilemap.width = value;
		return super.set_width(value);
	}

	override function set_height(value:Float):Float {
		if (btilemap != null)
			btilemap.height = value;
		return super.set_height(value);
	}

	/**
	 * 构造一个Spine对象
	 * @param atlasName 纹理名称
	 * @param skeletionName 骨骼名称
	 * @param tilemap 是否tilemap渲染
	 * @param native 此参数已弃用
	 * @param isLoop 是否循环播放
	 */
	public function new(atlasName:String = null, skeletionName:String = null, tilemap:Bool = false, native:Bool = false, isLoop:Bool = true) {
		super();
		this.tilemap = tilemap;
		this.isLoop = isLoop;
		if (atlasName == null || skeletionName == null) {
			return;
		}
		createSpine(atlasName, skeletionName);
	}

	/**
	 * 创建Spine
	 * @param atlasName 纹理名称
	 * @param skeletionName 骨骼名称
	 */
	public function createSpine(atlasName:String, skeletionName:String):Void {
		if (tilemap) {
			if (bspine != null && bspine.parent != null) {
				bspine.parent.removeTile(bspine);
				bspine.spine.destroy();
			}
			if (btilemap == null) {
				btilemap = new ImageBatchs(ZBuilder.getBaseTextureAtlas(atlasName));
				this.addChild(btilemap);
			}
			bspine = new BSpine(atlasName, skeletionName);
			btilemap.addChild(bspine);
		} else {
			if (spine != null && spine.parent != null) {
				spine.parent.removeChild(spine);
				spine.destroy();
			}
			spine = ZBuilder.createSpineSpriteSkeleton(atlasName, skeletionName);
			if (spine == null)
				trace("Error:" + atlasName + ":" + skeletionName + " spine is not create");
			// spine.isNative = native;
			if (spine != null) {
				this.addChild(spine);
			}
		}
	}

	override function onInit() {
		super.onInit();
		if (bspine != null)
			bspine.mouseEnabled = this.mouseEnabled;
		else if (spine != null)
			spine.mouseEnabled = this.mouseEnabled;
	}

	override function onRemoveToStage() {
		super.onRemoveToStage();
		if (bspine != null) {
			@:privateAccess SpineManager.removeOnFrame(bspine.spine);
		}
	}

	override function onAddToStage() {
		super.onAddToStage();
		if (bspine != null) {
			@:privateAccess SpineManager.addOnFrame(bspine.spine);
		}
	}

	override function set_shader(value:Shader):Shader {
		super.set_shader(value);
		if (this.getNativeSpine() != null)
			this.getNativeSpine().shader = value;
		if (this.getTilemapSpine() != null)
			this.getTilemapSpine().shader = value;
		return value;
	}

	override public function set_visible(v:Bool):Bool {
		if (getNativeSpine() != null)
			getNativeSpine().visible = v;
		if (getTilemapSpine() != null)
			getTilemapSpine().visible = v;
		return super.set_visible(v);
	}

	function get_independent():Bool {
		if (getNativeSpine() != null)
			return getNativeSpine().independent;
		if (getTilemapSpine() != null)
			return getTilemapSpine().independent;
		return false;
	}

	function set_independent(value:Bool):Bool {
		if (getNativeSpine() != null)
			getNativeSpine().independent = value;
		else if (getTilemapSpine() != null)
			getTilemapSpine().independent = value;
		return value;
	}

	public function setMixByName(fromName:String, toName:String, duration:Float):Void {
		if (fromName == null || toName == null)
			return;
		if (this.getNativeSpine() != null) {
			if (this.getNativeSpine().state.getData().skeletonData.findAnimation(fromName) != null
				&& this.getNativeSpine().state.getData().skeletonData.findAnimation(toName) != null)
				getNativeSpine().state.getData().setMixByName(fromName, toName, duration);
		} else if (this.getTilemapSpine() != null) {
			if (this.getTilemapSpine().state.getData().skeletonData.findAnimation(fromName) != null
				&& this.getTilemapSpine().state.getData().skeletonData.findAnimation(toName) != null)
				getTilemapSpine().state.getData().setMixByName(fromName, toName, duration);
		}
	}
}
