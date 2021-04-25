package zygame.mini;

import zygame.events.ZEvent;
import zygame.script.ZHaxe;
import zygame.components.ZBuilder;

/**
 * MiniUtils工具类
 */
@:keep
class MiniUtils {

    private static var _assets:MiniEngineAssets;

    /**
     * 创建扩展类型对象
     * @param type 
     * @return DisplayObject
     */
    public static function createTypeObject(assets:MiniEngineAssets,type:String,args:Array<Dynamic> = null):Dynamic
    {
        var builder = ZBuilder.buildXmlUI(assets,type,null);
        if(Std.isOfType(builder.display,MiniExtend))
            cast(builder.display,MiniExtend).baseBuilder = builder;
        else 
            throw "Mini engine Class must extend MiniExtend!";
        variablesAllHaxe(assets,builder,type);
        //判断new语法
        if(builder.ids.exists("new"))
        {
            builder.get("new",ZHaxe).call(args!=null?args:[]);
        }
        return builder.display;
    }

    /**
     * 定义所有Haxe的引用
     * @param assets 
     * @param builder 
     * @param type 
     */
    public static function variablesAllHaxe(assets:MiniEngineAssets,builder:Builder,type:String):Void
    {
        var minihaxe = assets.haxeMaps.get(type);
        for (key => type in minihaxe.imports) {
			builder.variablesAllHaxe(type.substr(type.lastIndexOf(".") + 1), Type.resolveClass(type));
		}
        builder.variablesAllHaxe("Math",Math);
        builder.variablesAllHaxe("miniLib",MiniUtils);
        builder.variablesAllHaxe("assets",assets);
        builder.variablesAllHaxe("app",assets.getApp());
        //静态属性
        for (key => value in assets.staticData) {
            builder.variablesAllHaxe(key, value);
        }
        builder.variablesAllHaxeBindMiniAssets(assets);
    }

    /**
     * 获取Assets资源
     * @return MiniEngineAssets
     */
    public static function getAssets():MiniEngineAssets
    {
        return _assets;
    }

    /**
     * 获取App宿主
     * @return MiniEngineScene
     */
    public static function getApp():MiniEngineScene
    {
        return _assets.getApp();
    }

    /**
     * 删除数组时，请使用该API，如果直接使用[].remove()删除，会发生异常。
     * @param array 
     * @param item 
     */
    public static function removeArrayItem(array:Array<Dynamic>,item:Dynamic):Void
    {
        if(array != null)
            array.remove(item);
    }
    
}