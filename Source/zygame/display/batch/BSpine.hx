package zygame.display.batch;

import spine.AnimationState;
import zygame.components.ZBuilder;
import spine.tilemap.SkeletonAnimation;

class BSpine extends BBox {
	public var spine:SkeletonAnimation;

	public var spineSkin(get, set):String;

	private function set_spineSkin(name:String):String {
		spine.skeleton.setSkinByName(name);
		spine.skeleton.setBonesToSetupPose();
		spine.skeleton.setSlotsToSetupPose();
		return name;
	}

	private function get_spineSkin():String {
		return spine.skeleton.getSkin() != null ? spine.skeleton.getSkin().name : null;
	}

	public var action(get, set):String;

	private function get_action():String {
		return spine.actionName;
	}

	private function set_action(v:String):String {
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
		}
	}

	override function onInit() {
		super.onInit();
		spine.mouseEnabled = true;
	}
}
