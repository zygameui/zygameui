package zygame.local;

/**
 * 其他数据储存接口
 */
interface ISave {
	/**
	 * 储存数据
	 * @param data 储存的数据
	 * @param savecb 储存回调，当处理成功后，需要将已经上报的数据按原格式返回
	 */
	public function saveData(data:Dynamic, savecb:Dynamic->Void):Void;

	/**
	 * 读取数据
	 * @param cb 读取数据，返回对应的数据，如果存在错误，请使用err数据
	 */
	public function readData(cb:Dynamic->Dynamic->Void):Void;
}
