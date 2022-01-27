package zygame.components.base;

/**
 *  包含数据的组件
 */
class DataProviderBox extends ZBox {
	public function new() {
		super();
	}

	/**
	 *  数据接口，所有组件的数据接收源
	 */
	private var _dataProvider:Dynamic;

	public var dataProvider(get, set):Dynamic;

	private function set_dataProvider(data:Dynamic):Dynamic {
		_dataProvider = data;
		return data;
	}

	private function get_dataProvider():Dynamic {
		return _dataProvider;
	}
}
