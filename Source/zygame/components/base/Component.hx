package zygame.components.base;

import zygame.components.ZBuilder.Builder;
import zygame.display.TouchDisplayObjectContainer;
import zygame.components.skin.BaseSkin;
import openfl.events.Event;

/**
 * 实现基础组件的基础功能
 */
class Component extends TouchDisplayObjectContainer
{

    /**
     * 组件列表
     */
    public var childComponents:Array<Component>;

    public function new()
    {
        super();
        childComponents = [];
    }

    override public function onInit():Void
    {
        super.onInit();
        this.initComponents();
    }

    /**
     * 初始化组件，每个组件都要重写该方法
     */
    public function initComponents():Void
    {
        throw "请不要直接使用Component类，它不能直接被初始化！每个新的组件都要重写该方法。";
    }

    /**
     * 更新所有组件
     */
    public function updateComponents():Void
    {

    }

    /**
     * 查询组件
     * @param pname - 组件的名字
     * @return Component
     */
    public function findComponent(pname:String):Component
    {
        for(i in 0...childComponents.length)
        {
            if(childComponents[i].name == pname)
                return childComponents[i];
        }
        return null;
    }

    /**
     * 添加组件
     * @param child - 组件
     * @param pname - 名字，定义好后可通过findComponent方法查找
     * @return Component
     */
    public function addComponent(child:Component,pname:String):Component
    {
        if(child.parent == null)
            this.addChild(child);
        child.name = pname;
        childComponents.push(child);
        return child;
    }

    /**
     * 设置皮肤，皮肤一般在updateComponent方法中进行渲染使用
     */
    private var _skin:BaseSkin;
    public var skin(get,set):BaseSkin;
    private function set_skin(s:BaseSkin):BaseSkin
    {
        if(_skin != null)
            _skin.removeEventListener(Event.CHANGE,_onSkinChange);
        _skin = s;
        _skin.addEventListener(Event.CHANGE,_onSkinChange);
        this.updateComponents();
        return s;
    }
    private function get_skin():BaseSkin
    {
        return _skin;
    }

    private function _onSkinChange(e:Event):Void
    {
        this.updateComponents();
    }

    #if flash
    @:setter(x)
    private function set_x(value:Float):Float
    {
        super.x = value;
        return value;
    }
    @:setter(y)
    private function set_y(value:Float):Float
    {
        super.y = value;
        return value;
    }
    #else
    override private function set_x(value:Float):Float
    {
        super.x = value;
        return value;
    }
    override private function set_y(value:Float):Float
    {
        super.y = value;
        return value;
    }
    #end

    private var _layoutData:Dynamic;
    public var layoutData(get,set):Dynamic;
    private function get_layoutData():Dynamic
    {
        if(_layoutData == null)
        {
            _layoutData = {};
        }
        return _layoutData;
    }
    private function set_layoutData(data:Dynamic):Dynamic
    {
        _layoutData = data;
        return _layoutData;
    }

    /**
     * 是否存在布局文件
     * @return Bool
     */
    public function hasLayoutData():Bool
    {
        return _layoutData != null;
    }

}