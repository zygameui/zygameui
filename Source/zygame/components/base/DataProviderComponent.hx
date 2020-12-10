package zygame.components.base;

import zygame.components.base.Component;

/**
 *  包含数据的组件
 */
class DataProviderComponent extends Component {

    public function new()
    {
        super();
    }

    /**
     *  数据接口，所有组件的数据接收源
     */
    private var _dataProvider:Dynamic;
    public var dataProvider(get,set):Dynamic;
    private function set_dataProvider(data:Dynamic):Dynamic
    {
        _dataProvider = data;
        return data;
    }
    private function get_dataProvider():Dynamic
    {
        return _dataProvider;
    }

}