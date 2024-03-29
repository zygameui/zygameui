package zygame.jsondata;

/**
 * `JSONData`宏的数据验证器接口
 */
interface IJsonDataValidate {
	/**
	 * 允许在通过`getDataArrayByXX`获得数据时，进行一个数据全验证的处理，默认为`false`，开启后可能存在性能影响，但如果需要完整的数据验证，可设置为`true`
	 */
	public var allowGetDataListValidate:Bool;

	/**
	 * 检验数据是否有被篡改
	 * @param object 
	 * @return Bool
	 */
	public function validateObject(object:Dynamic):Bool;

	/**
	 * 验证所有数据
	 * @return Bool
	 */
	public function validateAll():Bool;
}
