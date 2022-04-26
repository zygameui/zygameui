package zygame.utils;

import openfl.display.DisplayObject;
import zygame.utils.load.MapliveLoader;
import openfl.display.DisplayObjectContainer;

/**
 * 显示对象工具
 */
@:deprecated("DisplayObjectUtils is deprecated.")
class DisplayObjectUtils {

    public static function setDisplayObject(display:DisplayObject,data:Dynamic,sceneData:MapliveSceneData):Void
    {
        var fieldKeys:Array<String> = Reflect.fields(data);
        for(i in 0...fieldKeys.length){
            var key:String = fieldKeys[i];
            if(key == "width" || key == "height")
                continue;
            var value:Dynamic = Reflect.getProperty(data,key);
            if(key.indexOf("()") != -1)
            {
                //方法调用
                var strData:String = cast value;
                var func:String = key.substr(0,key.lastIndexOf("()"));
                var array:Array<Dynamic> = strData.split(",");
                var call:Dynamic = Reflect.field(display, func);
                for(i in 0...array.length)
                {
                    array[i] = getValue(array[i],sceneData);
                }
                Reflect.callMethod(display,call,array);
            }
            else
            {
                //属性赋值
                value = getValue(value,sceneData);
                if(value != null)
                    Reflect.setProperty(display,key,value);
            }
        }
    }
    
    /**
     * 转换值处理
     * @param value 
     * @param sceneData 
     * @return Dynamic
     */
    public static function getValue(value:Dynamic,sceneData:MapliveSceneData):Dynamic
    {
        if(Std.isOfType(value,String))
        {
            var curData:String = cast value;
            if(curData.indexOf("0x") == 0)
            {
                //UInt支持
                value = Std.parseInt(curData);
            }
            else if(curData.indexOf("image:") == 0)
            {
                //BitmapData支持
                curData = curData.substr(6);
                value = sceneData.getBitmapData(curData);
            }
            else if(curData.indexOf("bool:") == 0)
            {
                //Boolean支持
                #if cpp
                value = (curData == "bool:ture")?1:0;
                #else 
                value = (curData == "bool:ture")?true:false;
                #end
            }
            else if(curData.indexOf("int:") == 0)
            {
                //Int支持
                curData = curData.substr(4);
                value = Std.parseInt(curData);
            }
            else if(curData.indexOf("spineSpriteData:") == 0)
            {
                //Spine数据
                curData = curData.substr(16);
                value = sceneData.getSpineSpriteData(curData);
            }
        }
        return value;
    }
    
    /**
     * 创建子集
     * @param array 
     */
    public static function createChildren(array:Array<Dynamic>,parent:DisplayObjectContainer,sceneData:MapliveSceneData):Void
    {
        //初始化子对象
        for(i in 0...array.length)
        {
            var data:Dynamic = array[i];
            var array:Array<Dynamic> = [];
            if(data.construct != null && data.construct.length > 0)
            {
                array = data.construct;
                for(i in 0...array.length)
                    array[i] = getValue(array[i],sceneData);
            }
            var pClass:Dynamic = Type.resolveClass(data.property.bindType);
            if(pClass == null)
                pClass = Type.resolveClass(data.type);
            var display:DisplayObject = Type.createInstance(pClass,array);
            display.name = data.name;
            parent.addChild(display);
            DisplayObjectUtils.setDisplayObject(display,data.property,sceneData);
            DisplayObjectUtils.setDisplayObject(display,data.data,sceneData);
            if(data.children != null && Std.isOfType(display,DisplayObjectContainer))
            {
                DisplayObjectUtils.createChildren(data.children,cast display,sceneData);
            }
        }
    }
    
}