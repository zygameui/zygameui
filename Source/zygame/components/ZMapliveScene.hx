package zygame.components;

import zygame.components.ZScene;
import zygame.utils.load.MapliveLoader;
import zygame.display.DisplayObjectContainer;
import openfl.display.DisplayObject;
import zygame.utils.DisplayObjectUtils;
import zygame.components.ZLabel;

/**
 * **已弃用，勿使用**，Maplive2数据渲染场景
 */
@:deprecated("该API已弃用，不再支持旧版本的Maplive编辑更新")
class ZMapliveScene extends ZScene{

    private var _data:MapliveSceneData;

    private var _node:DisplayObjectContainer;

    /**
     * 构造一个ZMapliveScene对象
     * @param data 
     */
    public function new(data:MapliveSceneData):Void
    {
        super();
        _data = data;
        
    }

    /**
     * 初始化渲染数据
     */
    override public function initComponents():Void{
        super.initComponents();
        _node = new DisplayObjectContainer();
        this.addChild(_node);
        var arr:Array<Dynamic> = _data.getLayers();
        for(i in 0...arr.length)
        {
            var data:Dynamic = arr[i];
            var layer:ZMapliveLayer = new ZMapliveLayer(data,_data);
            layer.name = data.name;
            _node.addChild(layer);
        }
    }

    public function getLayerCount():Int
    {
        return _node.numChildren;
    }

    /**
     * 通过索引获取图层
     * @param index 
     * @return ZMapliveLayer
     */
    public function getLayerAt(index:Int):ZMapliveLayer
    {
        var display:DisplayObject = _node.getChildAt(index);
        if(display == null)
            return null;
        return cast display;
    }

    /**
     * 获取场景
     * @param name 
     * @return ZMapliveLayer
     */
    public function getLayer(name:String):ZMapliveLayer
    {
        var display:DisplayObject = _node.getChildByName(name);
        if(display == null)
            return null;
        return cast display;
    }

    public function getSceneData():MapliveSceneData
    {
        return _data;
    }
}

/**
 * 图层渲染
 */
class ZMapliveLayer extends DisplayObjectContainer{

    private var _data:Dynamic;

    public var sceneData:MapliveSceneData;

    public function new(data:Dynamic,sceneData:MapliveSceneData):Void
    {
        super();
        _data = data;
        this.sceneData = sceneData;
        this.name = _data.name;
        this.alpha = _data.alpha;
        this.visible = _data.visible;
    }

    override public function onInit():Void
    {
        super.onInit();
        //创建显示对象列表
        DisplayObjectUtils.createChildren(_data.children,this,sceneData);
    }

}