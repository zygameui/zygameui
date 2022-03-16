package zygame.components;

import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.events.MouseEvent;
import zygame.components.base.DataProviderBox;
import zygame.components.data.ListData;

/**
 * 创建一个Stack菜单，样式是横向并排选择样式：|1|2|3|4|5|
**/
class ZStackMenu extends DataProviderBox {
	/**
	 * 默认未选中状态
	**/
	public var defaultBgImage:Dynamic;

	/**
	 * 默认选中状态
	**/
	public var selectedBgImage:Dynamic;

	/**
	 * 线条渲染
	**/
	public var lineImage:Dynamic;

	/**
	 * 当前选中渲染
	**/
	private var _selectedItem:ZImage;

	private var _bg:ZImage;

	/**
	 * 当前选中的菜单
	**/
	public var selectIndex:Int = 0;

	/**
	 * 获取当前选中的数据
	**/
	public var selectItem(get, never):Dynamic;

	private function get_selectItem():Dynamic {
		var list:ZStackMenuListData = cast dataProvider;
		if (list != null) {
			return list.getItem(selectIndex);
		}
		return null;
	}

	private var lines:Array<ZImage>;

	private var icons:Array<ZImage>;

	/**
	 * 创建一个Stack菜单，注意需要为`defaultBgImage`和`selectedBgImage`提供默认未选中的图片以及选中图片数据
	 * @param defaultBgImage 默认背景图片
	 * @param selectedBgImage 选中背景图片
	 * @param lineImage 选项之间的渲染条图片
	 */
	public function new(defaultBgImage:Dynamic, selectedBgImage:Dynamic, lineImage:Dynamic = null) {
		super();
		this.defaultBgImage = defaultBgImage;
		this.selectedBgImage = selectedBgImage;
		this.lineImage = lineImage;
		_selectedItem = new ZImage();
		_bg = new ZImage();
		_bg.dataProvider = defaultBgImage;
		_selectedItem.dataProvider = selectedBgImage;
		this.addEventListener(MouseEvent.CLICK, onClick);
	}

	private function onClick(e:MouseEvent):Void {
		var list:ZStackMenuListData = cast dataProvider;
		if (list != null) {
			for (i in 0...list.length) {
				var leftLine = lines[i];
				var rightLine = lines[i + 1];
				if (leftLine.x < this.mouseX && rightLine.x > this.mouseX) {
					changeSelectIndex(i);
					break;
				}
			}
		}
	}

	override function initComponents() {
		this.setFrameEvent(true);
	}

	override function onFrame() {
		super.onFrame();
		var list:ZStackMenuListData = cast dataProvider;
		if (list != null && list.length > 0) {
			var leftLine = lines[selectIndex];
			var rightLine = lines[selectIndex + 1];
			for (image in lines) {
				if (image != leftLine || image != rightLine) {
					image.x -= (image.x - image.customData) * 0.2;
				}
			}
			for (index => icon in icons) {
				var curscale = icon.scaleX;
				curscale -= (curscale - (index == selectIndex ? 1 : 0.8)) * 0.2;
				icon.scale(curscale);
			}
			var itemWidth = width / list.length;
			leftLine.x -= (leftLine.x - (leftLine.customData - itemWidth * 0.2)) * 0.2;
			rightLine.x -= (rightLine.x - (rightLine.customData + itemWidth * 0.2)) * 0.2;
			_selectedItem.x = leftLine.x;
			_selectedItem.width = rightLine.x - leftLine.x;

			
		}
	}

	override function updateComponents() {
		super.updateComponents();
	}

	/**
	 * 切换当前选中的索引
	 * @param i 索引
	 */
	public function changeSelectIndex(i:Int):Void {
		selectIndex = i;
		var leftLine = lines[i];
		var rightLine = lines[i + 1];
		_selectedItem.x = leftLine.x;
		_selectedItem.width = rightLine.x - leftLine.x;
		this.dispatchEvent(new Event(Event.CHANGE));
	}

	/**
	 * 获取ICON显示对象
	 * @param index 索引
	**/
	public function getIconAt(index:Int):ZImage {
		return icons[index];
	}

	/**
	 * 使用ZStackMenuListData来绑定数据
	 * @param data `ZStackMenuListData`数据类型
	**/
	override function set_dataProvider(data:Dynamic):Dynamic {
		if (data != null && Std.isOfType(data, ListData)) {
			this.removeChildren();
			// 开始创建选项
			var list:ZStackMenuListData = cast data;
			var itemWidth = this.width / list.length;
			var itemHeight = this.height;
			lines = [];
			icons = [];
			// 最左边的线
			if (defaultBgImage == null) {
				var quad = new ZQuad();
				quad.alpha = 0;
				quad.width = this.width;
				quad.height = this.height;
				this.addChild(quad);
			}
			this.addChild(_bg);
			_bg.width = this.width;
			_bg.height = this.height;
			this.addChild(_selectedItem);
			_selectedItem.height = this.height;
			var line = new ZImage();
			line.dataProvider = lineImage;
			lines.push(line);
			this.addChild(line);
			for (i in 0...list.length) {
				var img = new ZImage();
				img.dataProvider = ZBuilder.getBaseBitmapData(list.getItem(i).icon);
				img.x = itemWidth * i + (itemWidth) / 2;
				img.y = (itemHeight) / 2;
				img.alignPivot("center", "center");
				img.scale(0.8);
				this.addChild(img);
				icons.push(img);
				// 边界线
				var line = new ZImage();
				line.dataProvider = lineImage;
				line.x = Math.round(itemWidth * (i + 1) - line.width / 2);
				line.height = this.height;
				this.addChild(line);
				lines.push(line);
			}
			for (image in lines) {
				image.customData = image.x;
			}
			this.changeSelectIndex(selectIndex);
		}
		return super.set_dataProvider(data);
	}
}

/**
 * 适用于ZStackMenu的列表数据
**/
class ZStackMenuListData extends ListData {
	/**
	 * 构造一个适用于ZStack渲染数据
	 * @param arr 
	 */
	public function new(arr:Array<ZStackMenuListDataItem> = null) {
		super(arr);
	}
}

/**
 * ZStack单独使用的渲染数据
 */
typedef ZStackMenuListDataItem = {
	/**
	 * 图标图片名称
	 */
	icon:String,

	/**
	 * 扩展数据
	 */
	?data:Dynamic
}
