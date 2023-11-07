package zygame.components.base;

interface IBuilder {
	/**
	 * 定义值，影响编译界面
	 * @return Map<String, String>
	 */
	public function onDefineValues():Map<String, String>;
}
