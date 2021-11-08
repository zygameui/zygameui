package zygame.components.base;

import openfl.display.Shader;
import zygame.components.base.Component;
import zygame.components.ZImage;
import zygame.components.ZBox;
import zygame.components.skin.BaseSkin;
import openfl.events.TouchEvent;
import openfl.events.Event;

/**
 *  Event.SELECT 点击选择事件
 */
class ToggleButton extends Component
{

    /**
     *  按下
     */
    public static inline var DOWN:String = "down";

    /**
     *  松开
     */
    public static inline var UP:String = "up";

    /**
     *  移入
     */
    public static inline var OVER:String = "over";

    /**
     *  移出
     */
    public static inline var OUT:String = "out";

    /**
     *  图片组件
     */
    public static inline var COMPONENT_IMAGE:String = "image";

    private var _currentTouchID:Int = -1;

    /**
     *  当前按钮的状态
     */
    private var _toggleState:String = UP;
    public var toggleState(get,never):String;
    private function get_toggleState():String
    {
        return _toggleState;
    }

    /**
     *  按钮容器
     */
    public var box:ZBox;

    public function new()
    {
        super();
        box = new ZBox();
        this.addChild(box);
        this.mouseChildren = false;
        // this.mouseEvent = true;
        this.setTouchEvent(true);
        var img:ZImage = new ZImage();
        this.addComponent(img,COMPONENT_IMAGE);
        this.setChildIndex(img,0);
    }

    override public function initComponents():Void
    {
        this.updateComponents();
    }

    override public function updateComponents():Void
    {
        var img:ZImage = cast this.findComponent(COMPONENT_IMAGE);
        if(img == null)
            return;
        var skin:ButtonSkin = cast skin;
        if(skin != null){
            var skinData:Dynamic = null;
            switch(_toggleState)
            {
                case UP:
                    skinData = skin.upSkin;
                case OVER:
                    skinData = skin.overSkin;
                case OUT:
                    skinData = skin.outSkin;
                case DOWN:
                    skinData = skin.downSkin;
            }
            img.dataProvider = skinData == null?skin.defalutSkin:skinData;
        }
    }

    /**
     * 获取按钮显示对象
     * @return ZImage
     */
    public function getDisplay():ZImage {
		var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
		return img;
	}

    /**
     *  发送选择状态
     *  @param state - 通过ToggleButton的静态常量状态处理
     */
    public function sendToggleState(state:String):Void
    {
        _toggleState = state;
        this.updateComponents();
    }

    override public function onTouchBegin(touch:TouchEvent):Void
    {
        if(_currentTouchID != -1)
            return;
        _currentTouchID = touch.touchPointID;
        sendToggleState(DOWN);
    }

    override public function onTouchEnd(touch:TouchEvent):Void
    {
        if(touch.touchPointID == _currentTouchID)
        {
            var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
            var wz:Float = img.width;
            var hz:Float = img.height;
            if(img.scaleX < 1)
                wz /= img.scaleX;
            if(img.scaleY < 1)
                hz /= img.scaleY;
            sendToggleState(UP);
            if(0 < this.mouseX && 0 < this.mouseY && this.mouseX < wz && this.mouseY < hz)
            {
                this.dispatchEvent(new Event(Event.SELECT,true,false));
            }
            _currentTouchID = -1;
        }

    }

    /**
     * 设置按钮上下文内容
     * @param data 
     */
    public function setContent(data:Dynamic):Void
    {
        var curimg:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
        var img:ZImage = new ZImage();
        img.dataProvider = data;
        box.removeChildren();
        box.addComponent(img,"content");
        img.x = curimg.width / 2 - img.width / 2;
        img.y = curimg.height / 2 - img.height / 2;
    }

    override function set_shader(value:Shader):Shader {
        var img:ZImage = cast this.findComponent(ToggleButton.COMPONENT_IMAGE);
        if(img != null)
            img.shader = value;
        return value;
    }

}