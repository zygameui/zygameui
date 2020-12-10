package dialog;

import zygame.macro.JSONData;
import zygame.components.ZButton;
import zygame.core.Start;
import zygame.components.ZModel;

class Main extends Start {
    
    override function onInit() {
        super.onInit();
        this.addChild(new ZModel(300,64));

        ZModel.showTextModel("我是测试文案，怎么了！？");

        stage.addEventListener("click",function(e){
            ZModel.showTextModel("我是"+Std.random(999)+"，怎么了！？");
        });

        var button = ZButton.createModelButton("测试按钮");
        this.addChild(button);
        button.y = 300;

        var json = zygame.macro.JSONData.create("data/test.json",null,["type"]);
        trace(json.getDataArrayByType(2));

        this.addChild(new Scene());
    }

}