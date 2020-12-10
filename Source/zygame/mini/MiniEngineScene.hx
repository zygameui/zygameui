package zygame.mini;

import zygame.utils.ZAssets;
import zygame.utils.Lib;
import zygame.components.ZBuilder;
import zygame.components.ZScene;
import zygame.events.ZEvent;

/**
 * 迷你小引擎，可用于开发热更新的动态内容使用。
 */
class MiniEngineScene extends ZScene implements BuilderRootDisplay {

	/**
	 * 默认引用
	 */
	public var builder:Builder;

	/**
	 * 资源管理
	 */
	public var assets:ZAssets;

	/**
	 * ZBuilder完成后，触发的Builder事件，应从onInit转移到这里进行实现初始化逻辑
	 * @param builder
	 */
	public function onInitBuilder():Void {
		Lib.nextFrameCall(function() {
			var call = this.builder.getFunction("onInit");
			if (call != null)
				call();
		});
	}

	override function onInit() {
		super.onInit();
	}

	/**
	 * 卸载游戏
	 */
	public function unload():Void {
		if (this.builder != null) {
			var call = this.builder.getFunction("unload");
			if (call != null)
				call();
			this.builder = null;
			this.assets = null;
		}
	}

	private var _isPause:Bool = false;

	/**
	 * 获取当前是否暂停了
	 * @return Bool
	 */
	public function isPause():Bool {
		return _isPause;
	}

	/**
	 * 暂停游戏应用
	 */
	public function pauseApp():Void {
		_isPause = true;
	}

	/**
	 * 恢复游戏应用
	 */
	public function resumeApp():Void {
		_isPause = false;
	}

	/**
     * 发送事件
     * @param type 事件类型
     * @param data 事件数据
     */
    public function postEvent(type:String,data:Dynamic = null):Void
    {
        this.dispatchEvent(new ZEvent(type,data));
    }
}
