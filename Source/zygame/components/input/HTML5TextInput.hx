package zygame.components.input;

import zygame.utils.Lib;
import openfl.geom.Point;
import js.html.TextAreaElement;
import js.Browser;

/**
 * HTML5输入组件支持，可解决openfl原本不支持中文输入的问题。
 */
class HTML5TextInput {

    /**
     * 输入框组件
     */
    public static var textureArea:TextAreaElement;

    /**
     * 当前焦点输入组件
     */
    public static var zinput:ZLabel;

    /**
     * 打开输入
     */
    public static function openInput(input:ZLabel):Void
    {
        zinput = input;
        var point = input.localToGlobal(new Point(0,0));
        if(textureArea == null){
            textureArea = Browser.document.createTextAreaElement();
            textureArea.style.position = "absolute";
            textureArea.style.bottom = "0px";
            textureArea.style.left = "0px";
            textureArea.style.width = "100%";
            textureArea.style.height = "36px";
            textureArea.style.fontSize = "24px";
            if(Lib.isPc())
                textureArea.style.zIndex = "-1";
            textureArea.oninput = onInput;
            Browser.document.getElementsByTagName("html")[0].appendChild(textureArea);
            //侦听窗口变化
            Browser.document.onresize = onResize;
        }
        textureArea.value = zinput.dataProvider;
        textureArea.style.visibility = "visible";
        textureArea.focus();
    }

    /**
     * 窗口发生变化时，兼容Android的输入框会被挡的问题。
     */
    public static function onResize():Void
    {
        if (Browser.navigator.userAgent.indexOf("Android") != -1) {
            Browser.window.addEventListener('resize', function () {
                if (Browser.document.activeElement.tagName == 'INPUT' || Browser.document.activeElement.tagName == 'TEXTAREA') {
                    Browser.window.setTimeout(function () {
                        untyped Browser.document.activeElement.scrollIntoViewIfNeeded();
                    }, 0);
                }
            });
        }
    }

    /**
     * 侦听输入
     */
    public static function onInput():Void
    {
        if(zinput == null)
            return;
        zinput.dataProvider = textureArea.value.substr(0,zinput.getDisplay().maxChars == 0?99999:zinput.getDisplay().maxChars);
    }

    /**
     * 停止输入
     */
    public static function closeInput():Void
    {
        zinput = null;
        if(textureArea != null)
            textureArea.style.visibility = "hidden";
    }

}