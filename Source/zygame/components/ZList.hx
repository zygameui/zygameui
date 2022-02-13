package zygame.components;

import zygame.components.ZScroll;
import openfl.display.DisplayObject;
import zygame.components.base.ItemRender;
import zygame.components.base.DefalutItemRender;
import zygame.components.layout.ListLayout;
import zygame.components.data.ListData;
import openfl.events.TouchEvent;

/**
 * 经过优化的列表
 * 每个item组件高度或者宽度都是固定的，但是你可以存放100000+的数据也不会感觉到卡顿。
 * 使用该组件，你需要配合ItemRender得到自定义渲染结构。然后将你的渲染对象赋值到itemRenderType中，使全局都使用该渲染对象。
 * 可以修改ListLayout布局的方向实现，得到横向的List；默认允许XML中使用。
 * ```xml
 * <ZList id="list" width="300" height="300"/>
 * ```
 * 然后需要通过访问对象进行数据传输：
 * ```haxe
 * list.dataProvider = new ListData([1,2,3]);
 * ```
 */
class ZList extends ZScroll {
	/**
	 * 间隔
	 */
	public var gap:Int = 0;

	/**
	 *  渲染池
	 */
	private var _itemRenders:Array<ItemRender>;

	/**
	 *  指定渲染组件
	 */
	public var itemRenderType:Class<ItemRender>;

	/**
	 * 当前选择渲染的组件
	 */
	public var currentSelectItem:Dynamic;

	/**
	 * 是否做缓存处理，这种比较适合用于文字更改频繁的页面。
	 */
	public var cache:Bool = false;

	/**
	 * 构造一个列表渲染对象
	 */
	public function new() {
		super();
		var layout2:ListLayout = new ListLayout();
		this.hscrollState = "off";
		view.layout = layout2;
		_itemRenders = [];
	}

	override public function initComponents():Void {
		super.initComponents();
		this.updateComponents();
	}

	override public function onTouchEnd(touch:TouchEvent):Void {
		super.onTouchEnd(touch);
		if (Std.isOfType(touch.target, itemRenderType)
			&& getIsMoveing() == false
			&& currentSelectItem != cast(touch.target, ItemRender).data) {
			selectIndex = @:privateAccess cast(this.dataProvider, ListData)._data.indexOf(cast(touch.target, ItemRender).data);
		}
	}

	/**
	 * 是否开启Item自动适配高宽
	 */
	public var autoSize(get, set):Bool;

	private var _selectIndex:Int = -1;

	/**
	 * 当前选择的Item索引
	 */
	public var selectIndex(get, set):Int;

	private function get_selectIndex():Int {
		return _selectIndex;
	}

	private function set_selectIndex(index:Int):Int {
		_selectIndex = index;
		currentSelectItem = @:privateAccess cast(this.dataProvider, ListData)._data[_selectIndex];
		this.updateAll();
		this.dispatchEvent(new openfl.events.Event(openfl.events.Event.CHANGE));
		return index;
	}

	override private function set_dataProvider(data:Dynamic):Dynamic {
		if (!Std.isOfType(data, ListData) && data != null)
			throw "ZList对象只允许使用ListData数据，请使用ListData数据进行设置。";
		super.dataProvider = data;
		updateAll();
		return data;
	}

	/**
	 * 重新刷新所有数据
	 */
	public function updateAll():Void {
		if (layout == null || this.dataProvider == null)
			return;
		if (!cache) {
			while (view.childs.length > 0) {
				removeItemRender(cast view.childs[0], true);
			}
		} else {
			for (c in view.childs) {
				cast(c, ItemRender).data = null;
			}
		}
		if (autoSize) {
			cast(this.layout, ListLayout).updateSize(this);
		}
		this.updateComponents();
	}

	override public function updateComponents():Void {
		// 刷新容器布局，ZList布局只可以使用ListLayout布局对象
		if (view != null) {
			if (Std.isOfType(view.layout, ListLayout))
				view.updateComponents();
			else
				throw "ZList只可以使用ListLayout布局对象，ZList在被创建出来那一刻默认就是ListLayout布局。";
		}
	}

	/**
	 *  ZList中禁用addChild方法
	 *  @param display - 
	 *  @return DisplayObject
	 */
	override public function addChild(display:DisplayObject):DisplayObject {
		return this.addChildAt(display, 0);
	}

	/**
	 *  ZList中禁用addChild方法
	 *  @param display - 
	 *  @param index - 
	 *  @return DisplayObject
	 */
	override public function addChildAt(display:DisplayObject, index:Int):DisplayObject {
		throw "ZList是一个列表组件，无法直接添加对象，请使用dataProvider进行管理列表";
		return null;
	}

	/**
	 *  创建ItemRender对象，这里会做垃圾池循环利用
	 *  @param value 创建的对象
	 *  @return ItemRender
	 */
	public function createItemRender(value:Dynamic):ItemRender {
		if (_itemRenders.length > 0) {
			for (render in _itemRenders) {
				if (render.data == value) {
					_itemRenders.remove(render);
					return render;
				}
			}
			return _itemRenders.shift();
		}
		var item:ItemRender = null;
		if (itemRenderType != null)
			item = Type.createInstance(itemRenderType, []);
		else
			item = new DefalutItemRender();
		if (cast(this.layout, ListLayout).direction == ListLayout.VERTICAL)
			item.width = this.width;
		else
			item.height = this.height;
		return item;
	}

	/**
	 * 安全移除ItemRender并放入垃圾池
	 * @param item 渲染对象
	 * @param clearData 是否清楚data数据
	 */
	public function removeItemRender(item:ItemRender, clearData:Bool = false):Void {
		if (item != null && item.parent != null) {
			if (!cache) {
				_itemRenders.push(item);
				view.removeChildSuper(item);
				if (item.tileDisplayObject != null) {
					// 批渲染对象不为空时，请清理
					batch.getBatchs().removeTile(item.tileDisplayObject);
				}
			}
			if (clearData)
				item.data = null;
		}
	}

	override public function onFrame():Void {
		super.onFrame();
		if ((_vMoveing || _hMoveing) && _moveMath > 0)
			view.updateComponents();
	}

	/**
	 * 底层调用添加对象方法
	 * @param item 渲染对象
	 */
	public function addChildSuper(item:ItemRender):Void {
		super.addChild(item);
		if (item.tileDisplayObject != null) {
			// 批渲染对象不为空时，请清理
			batch.getBatchs().addChild(item.tileDisplayObject);
		}
	}

	function get_autoSize():Bool {
		return cast(this.layout, ListLayout).autoSize;
	}

	function set_autoSize(value:Bool):Bool {
		cast(this.layout, ListLayout).autoSize = value;
		return value;
	}

	override function destroy() {
		super.destroy();
		for (index => value in _itemRenders) {
			value.destroy();
		}
	}
}
