package zygame.components;

import zygame.utils.Lib;
import zygame.core.Start;
import openfl.geom.Rectangle;
import openfl.display.BitmapData;

/**
 * 模态层，呈圆角渲染
 */
class ZModel extends ZImage {

    public static var fontSize:Int = 32;

    private static var currentModel:ZModel;
    private static var currentLabel:ZLabel;

    private static var currentCallTime:Int = -1;

    /**
     * 展示文本模态层，一般呈现在中心上方
     * @param txt 弹出文案
     * @param showTime 弹出持续显示时间
     */
    public static function showTextModel(txt:String,showTime:Int = 2000):Void
    {
        if(currentModel != null)
        {
            currentLabel.width = Lib.int(Start.current.getStageWidth() * 0.8);
            currentLabel.dataProvider = txt;
            currentLabel.width = currentLabel.getTextWidth() + 32;
            currentModel.width = Lib.int(currentLabel.width);
            currentLabel.height = currentLabel.getTextHeight();
            currentModel.height = Lib.int(currentLabel.height + 5);
            Lib.clearTimeout(currentCallTime);
            currentCallTime = Lib.setTimeout(clearTextModel,showTime);
            currentModel.x = (Start.current.getStageWidth() - currentModel.width)/2;
            currentModel.y = Start.current.getStageHeight() * 0.2;
            return;
        }
        var label:ZLabel = new ZLabel();
        label.width = Lib.int(Start.current.getStageWidth() * 0.8);
        label.hAlign = "center";
        label.dataProvider = txt;
        label.setFontColor(0xffffff);
        label.setFontSize(fontSize);
        label.width = label.getTextWidth() + 32;
        label.height = label.getTextHeight() + 32;
        var model = new ZModel(Lib.int(label.width),Lib.int(label.height + 5));
        Start.current.getTopView().addChild(model);
        model.x = (Start.current.getStageWidth() - model.width)/2;
        model.y = Start.current.getStageHeight() * 0.2;
        model.addChild(label);
        currentCallTime = Lib.setTimeout(clearTextModel,showTime);
        currentLabel = label;
        currentModel = model;
        model.display.alpha = 0.8;
    }

    /**
     * 清理文本模态层
     */
    public static function clearTextModel():Void
    {
        Lib.clearTimeout(currentCallTime);
        currentModel.parent.removeChild(currentModel); 
        currentLabel.destroy();
        currentLabel = null;
        currentModel = null;
        currentCallTime = -1;
    }

	/**
	 * Base64
	 */
	private static var _modelBase64:String = "iVBORw0KGgoAAAANSUhEUgAAABsAAAAVCAYAAAC33pUlAAAAmUlEQVR42mNgwA70gbgeiPcj4fdA/B8Lfo+mrh6qnyCwB+L7OAwlFd+HmocVxFPJEnQcj26RP40sgmF/mEX8eOKDWvg91B6aBR/W4FxPJ8tA9tA8CJGDki4WwfCoZUPQsv10sghkD8N8Olk2nx7lIkb5eJ/GFt0fkFIfBvJpZFE+vgr0PRXLwnhCTQN+qGvOk2nJeah+fnSDAXa48kWy1Qi2AAAALXRFWHRTb2Z0d2FyZQBieS5ibG9vZGR5LmNyeXB0by5pbWFnZS5QTkcyNEVuY29kZXKoBn/uAAAAAElFTkSuQmCC";

	/**
	 * 模态层位图数据
	 */
    private static var _modelBitmapData:BitmapData;
    
    private static var _ccs:Rectangle;

	public function new(width:Int, height:Int) {
		super();
		this.width = width;
        this.height = height;
    }
    
    override function onInit() {
        super.onInit();
        if (_modelBitmapData == null) {
			BitmapData.loadFromBase64(_modelBase64, "image/png").onComplete(function(data) {
                _modelBitmapData = data;
                _ccs = zygame.utils.Lib.cssRectangle(_modelBitmapData,"8 12 9 11");
                this.dataProvider = data;
                this.setScale9Grid(_ccs);
			});
		} else {
            this.dataProvider = _modelBitmapData;
            this.setScale9Grid(_ccs);
		}
    }
}
