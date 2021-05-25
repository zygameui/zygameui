package zygame.display.batch;

import spine.AnimationState;
import zygame.components.ZBuilder;
import spine.tilemap.SkeletonAnimation;

class BSpine extends BBox {
	public var spine:SkeletonAnimation;

	public var spineSkin(get, set):String;

	private function set_spineSkin(name:String):String {
		if (spine == null)
			return name;
		spine.skeleton.setSkinByName(name);
		spine.skeleton.setBonesToSetupPose();
		spine.skeleton.setSlotsToSetupPose();
		return name;
	}

	private function get_spineSkin():String {
		return spine == null ? null : spine.skeleton.getSkin() != null ? spine.skeleton.getSkin().name : null;
	}

	public var action(get, set):String;

	private function get_action():String {
		return spine == null ? null : spine.actionName;
	}

	private function set_action(v:String):String {
		if (spine != null)
			spine.play(v, true);
		return v;
	}

	public var state(get, never):AnimationState;

	private function get_state():AnimationState {
		return spine.state;
	}

	public function new(atlasName:String = null, skeletionName:String = null) {
		super();
		spine = ZBuilder.createSpineTilemapSkeleton(atlasName, skeletionName);
		if (spine != null) {
			this.addChild(spine);
			spine.mouseEnabled = true;
		}
	}

	override function onInit() {
		super.onInit();
	}
}
