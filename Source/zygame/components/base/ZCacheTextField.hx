package zygame.components.base;

import openfl.geom.Rectangle;
import openfl.text.TextFormat;
import zygame.utils.load.TextureLoader;
import zygame.utils.load.TextureLoader.TextTextureAtlas;
#if (html5 && !no_html5_cache_render)
import zygame.components.renders.text.HTML5CacheTextFieldBitmapData;
#end
#if (openfl >= '9.0.0')
import openfl.display._internal.Context3DTextField;
#else
import openfl._internal.renderer.context3D.Context3DTextField;
#end
import openfl.display.BitmapData;

/**
 * 文本缓存器，用于解决fillText渲染过慢的问题，该API只适用于HTML5
 */
class ZCacheTextField extends #if (html5 && !no_html5_cache_render) HTML5CacheTextFieldBitmapData #else ZTextField #end {

    /**
     * 文本精灵表
     */
    private var _atlas:TextTextureAtlas;

    private var _xml:Xml;

    private var _color:UInt;

    #if (cpp || !(html5 && !no_html5_cache_render))
    private var _text:String = "";
    #end

    /**
     * 缓存字是否进行换行，换行可能会减少杂点的情况，但是渲染的字数将会大大下降，默认为false。
     */
    public var cacheAutoWrap:Bool = false;

    /**
     * 一行的字数
     */
    private var _lineCount:Int;

    /**
     * 字体规格
     */
    private var f:TextFormat = new TextFormat();

    public function new(id:String,fontName:String,fontsize:UInt,color:UInt = 0xffffff) {
        super();
        #if (html5 && !no_html5_cache_render)
        this.id = id;
        #end
        this._color = color;
        this.width = 2000;
        this.height = 4000;
        this._lineCount = Std.int(this.width/(fontsize*2));
        this.selectable = false;
        this.mouseEnabled = false;
        f.size = fontsize;
        f.color = color;
        #if ios
        f.font = "assets/" + fontName;
        #else
        f.font = fontName;
        #end
        this.wordWrap = true;
        this.setTextFormat(f);
    }

    //梦工厂不能主动释放资源
    #if (!html5)
    @:noCompletion private override function __cleanup() {
        //空实现，不自动释放掉位图
    }
    #end

    /**
     * 计算并生成出精灵表
     * @param value 
     * @return String
     */
    public override function set_text(value:String):String {
        //文本筛选
        _text = value;
        value = deWeighting(value);
        if(text == value)
            return value;
        super.set_text(value);
        this.setTextFormat(f);
        var xml:Xml = Xml.createDocument();
        var atlas:Xml = Xml.createElement("TextureAtlas");
        xml.insertChild(atlas,0);
        #if (haxe_ver < "4.0.0")
        var index:Int = 0;
        #end
        value = text;
        #if !cpp
        var req = ~/[\ud04e-\ue50e]+/;
        #end
        var emoj:String = "";
        var isEmoj:Bool = false;
        for(i in 0...value.length)
        {
            var data = value.charAt(i);
            #if !cpp
            if(req.match(data)){
                emoj += data;
                if(emoj.length == 2)
                {
                    isEmoj = true;
                    data = emoj;
                    emoj = "";
                }
                else
                    continue;
            }
            #end
            var rect:Rectangle = this.getCharBoundaries(i#if (html5 && !no_html5_cache_render) , isEmoj #end);
            isEmoj = false;
            if(data == " ")
            {
                continue;
            }
            if(rect == null)
            {
                continue;
            }

            var rectXml:Xml = Xml.createElement("SubTexture");
            rectXml.set("name",data);
            rectXml.set("x",Std.string(rect.x + 1));
            rectXml.set("width",Std.string(rect.width - 2));
            if(this.cacheAutoWrap)
            {
                rectXml.set("y",Std.string(rect.y-2));
                rectXml.set("height",Std.string(rect.height+4));
            }
            else
            {
                #if bili
                rectXml.set("y",Std.string(rect.y+2));
                rectXml.set("height",Std.string(rect.height-4));
                #else
                rectXml.set("y",Std.string(rect.y+1));
                rectXml.set("height",Std.string(rect.height-2));
                #end
            }
            atlas.insertChild(rectXml,0);
        }
        #if !(html5 && !no_html5_cache_render)
        #if (openfl897 && openfl < "8.9.7")
        var renderer:OpenGLRenderer = cast @:privateAccess openfl.Lib.current.stage.__renderer;
        @:privateAccess this.__renderGL(renderer);
        #else
        // 8.9.2（online）渲染兼容
        @:privateAccess __graphics.__softwareDirty = true;
        var renderer = @:privateAccess openfl.Lib.current.stage.__renderer;
        Context3DTextField.render(this,cast renderer);
        #end
        #end
        var bdata:BitmapData =#if (html5 && !no_html5_cache_render) this.bitmapData #else @:privateAccess __graphics.__bitmap #end;
        if(_atlas != null)
            _atlas.updateAtlas(bdata,xml);
        else
            _atlas = new TextTextureAtlas(bdata,xml,_color);
        _atlas.isTextAtlas = true;
        return value;
    }

    #if (!(html5 && !no_html5_cache_render) && openfl897 && openfl < "8.9.7")
    @:noCompletion private override function __renderGL (renderer:OpenGLRenderer):Void {
        
        if(renderer == @:privateAccess openfl.Lib.current.stage.__renderer)
            @:privateAccess super.__renderGL(renderer);
    }
    #end
    /**
     * 获取文本渲染精灵表
     * @return TextureAtlas
     */
    public function getAtlas():TextureAtlas {
        return _atlas;
    }

    /**
     * 去重处理
     * @param value 
     * @return String
     */
    private function deWeighting(value:String):String
    {
        var emoj:String = "";
        #if !cpp
        var req = ~/[\ud04e-\ue50e]+/;
        #end
        var array:Array<String> = [];
        var newvalue:String = "";
        for (i in 0...value.length) {
            var str:String = value.charAt(i);
            if(str == " ")
                continue;
            if(str.charCodeAt(0) > 800 && str.charCodeAt(0) < 900)
            {
                continue;
            }
            #if !cpp
            //HTML5兼容emoj表情
            if(req.match(str))
                emoj += str;
            #end
            else if(array.indexOf(str) == -1){
                array.push(str);
            }
        }
        array.sort(function(a:String,b:String):Int{
            return a.charCodeAt(0)>b.charCodeAt(0)?1:-1;
        });
        for (i in 0...array.length) {
            var space:String = " ";
            #if qqquick 
            if(untyped window.platform == "android")
                space = " "; //安卓支持
            else
                space = ""; //IOS不支持空格运算
            #elseif cpp
            space = "";
            #end
            newvalue += array[i] + space;
            if(cacheAutoWrap && i % _lineCount == 0){
                newvalue += "\n\n";
            }
        }
        value = newvalue#if !un_emoj + "\n\n" + emoj #end;
        //特殊空格符号
        value = StringTools.replace(value," ️","");
        return value;
    }

    /**
     * 释放缓存文本占用的纹理
     */
    #if (html5 && !no_html5_cache_render) override #end public function dispose():Void
    {
        _xml = null;
        _atlas.dispose();
        _atlas = null;
        #if (html5 && !no_html5_cache_render)
        super.dispose();
        #end
    }

    /**
     * 设置字体大小
     * @param size 
     */
    public function setFontSize(size:Int):Void{
        f.size = size;
        this.text = _text;
    }

    /**
     * 更新字体颜色
     * @param color 
     */
    public function setFontColor(color:Int):Void{
        f.color = color;
        this.text = _text;
    }

}