package differ;

import differ.shapes.Ray;
import differ.shapes.Circle;
import zygame.components.ZLabel;
import zygame.utils.Lib;
import zygame.differ.DebugDraw;
import zygame.differ.Shapes;
import differ.shapes.Polygon;
import zygame.core.Start;

class Main extends Start {
	private var self:Polygon;

	private var debug:DebugDraw;

	private var shapes:Shapes;

	private var label:ZLabel;

	public function new() {
		super(800, 480, true);
	}

	override function onInit() {
		super.onInit();

		this.stage.color = 0x0;

		debug = new DebugDraw();
		shapes = new Shapes();

		// 图形空间
		var box = Polygon.rectangle(0, 0, 100, 100);
		box.x = 300;
		box.y = 300;
        box.rotation = 45;
        shapes.add(box);
        
        var c:Circle = new Circle(100,100,30);
        shapes.add(c);

		self = Polygon.rectangle(0, 0, 100, 100);
		shapes.add(self);

		// 调试面板
		this.addChild(debug.display);

		label = new ZLabel();
		this.addChild(label);
		label.width = 300;
        label.height = 32;
        label.setFontColor(0xffffff);
        label.setFontSize(24);
        label.y = 200;

		this.setFrameEvent(true);
	}

	override function onFrame() {
		super.onFrame();
		self.x = this.mouseX;
        self.y = this.mouseY;
        self.scaleX = this.mouseX / 500;
        self.scaleY = self.scaleX;
		self.rotation++;
		debug.clear();
		debug.drawShapes(shapes);

        var ret = shapes.test(self);
		if (ret != null && ret.length > 0) {
			label.dataProvider = "true";
		} else {
			label.dataProvider = "false";
        }
	}
}
