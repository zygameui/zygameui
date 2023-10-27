package zygame.components.base;

/**
 *  包含数据的组件
 */
class DataProviderBox extends ZBox implements IDataProvider {
	public function new() {
		super();
	}

	private var _dataProvider:Dynamic;

	/**
	 *  数据接口，所有组件的数据接收源
	 */
	public var dataProvider(get, set):Dynamic;

	private function set_dataProvider(data:Dynamic):Dynamic {
		_dataProvider = data;
		return data;
	}

	private function get_dataProvider():Dynamic {
		return _dataProvider;
	}
}
