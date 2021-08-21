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
 * 可通过ZBuilder创建的骨骼动画(可点击、触摸)
 */
class ZSpine extends ZBox {
	private var spine:SkeletonAnimation;

	private var btilemap:ImageBatchs;
	private var bspine:BSpine;

	public var isLoop:Bool = true;

	public var action(get, set):String;

	public var spineSkin(get, set):String;

	public var independent(get, set):Bool;

	/**
	 * 仅在spine的情况下才能够缓存
	 */
	public var isCache(get, set):Bool;

	private var _isCache = false;

	function get_isCache():Bool {
		return _isCache;
	}

	function set_isCache(value:Bool):Bool {
		_isCache = value;
		if (getNativeSpine() != null)
			getNativeSpine().isCache = value;
		return _isCache;
	}

	public function getNativeSpine():SkeletonAnimation {
		return spine;
	}

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

	public var state(get, never):AnimationState;

	private function get_state():AnimationState {
		if (bspine != null)
			return bspine.state;
		return spine.state;
	}

	private function get_action():String {
		if (bspine != null) {
			return bspine.action;
		}
		if(spine != null)
			return spine.actionName;
		return null;
	}

	private function set_action(v:String):String {
		if (bspine != null) {
			bspine.action = v;
			return v;
		}
		if(spine != null)
			spine.playForce(v, isLoop);
		return v;
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

	public function new(atlasName:String = null, skeletionName:String = null, tilemap:Bool = false, native:Bool = false, isLoop:Bool = true) {
		super();
		this.isLoop = isLoop;
		if (tilemap) {
			btilemap = new ImageBatchs(ZBuilder.getBaseTextureAtlas(atlasName));
			this.addChild(btilemap);
			bspine = new BSpine(atlasName, skeletionName);
			btilemap.addChild(bspine);
		} else {
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
			bspine.mouseEnabled = true;
		else if(spine != null)
			spine.mouseEnabled = true;
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
}
