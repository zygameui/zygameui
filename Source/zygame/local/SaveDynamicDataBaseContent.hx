package zygame.local;

class SaveDynamicDataBaseContent {
	/**
	 * 数据是否发生了变化
	 */
	public var changed:Bool = true;

	public function new() {}

	public function flush(key:String, changeData:Dynamic):Void {}

	public function getData(key:String, data:Dynamic):Void {}
}
