package zygame.components.data;

/**
 *  用于ZList的数据格式
 */
class ListData {

    private var _data:Array<Dynamic>;

    public function new(arr:Array<Dynamic> = null)
    {
        _data = arr!=null?arr:[];
    }

    /**
     *  获取数据长度
     */
    public var length(get,never):Int;
    private function get_length():Int
    {
        return _data.length;
    }

    public function addItem(data:Dynamic):Void
    {
        _data.push(data);
    }

    public function getItem(index:Int):Dynamic
    {
        return _data[index];
    }

    public function remove(index:Int):Dynamic
    {
        if(_data.length == 0)
            return null;
        return _data.splice(index,1)[0];
    }

}