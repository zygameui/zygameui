package zygame.components;

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

	public function getNativeSpine():SkeletonAnimation {
		return spine;
	}

	public function getTilemapSpine():TilemapAnimation {
		return bspine.spine;
	}

	private function set_spineSkin(name:String):String {
		if (btilemap != null)
			bspine.spineSkin = name;
		else {
			spine.skeleton.setSkinByName(name);
			spine.skeleton.setBonesToSetupPose();
			spine.skeleton.setSlotsToSetupPose();
		}
		return name;
	}

	private function get_spineSkin():String {
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
		return spine.actionName;
	}

	private function set_action(v:String):String {
		if (bspine != null) {
			bspine.action = v;
			return v;
		}
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
				throw atlasName + ":" + skeletionName + " spine is not create.";
			spine.isNative = native;
			if (spine != null) {
				this.addChild(spine);
			}
		}
	}

	override function onInit() {
		super.onInit();
		if (bspine != null)
			bspine.mouseEnabled = true;
		else
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
}
