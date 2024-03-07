package zygame.jsondata;

/**
 * `JSONData`宏的数据验证器接口
 */
interface IJsonDataValidate {
	/**
	 * 检验数据是否有被篡改
	 * @param object 
	 * @return Bool
	 */
	public function validateObject(object:Dynamic):Bool;
}
