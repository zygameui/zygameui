package zygame.components.style;

/**
 * 样式
 */
class XmlStyle {
	/**
	 * 样式
	 */
	private var __styles:Map<String, Array<{key:String, value:String}>> = [];

	/**
	 * 储存已缓存的样式
	 */
	private var __cacheStyle:Map<String, Bool> = [];

	/**
	 * 获取使用的样式列表
	 * @return Array<String>
	 */
	public function getStyles():Array<String> {
		var k = [];
		for (key => value in __cacheStyle) {
			k.push(key);
		}
		return k;
	}

	/**
	 * 构造一个xml样式支持
	 */
	public function new() {}

	/**
	 * 应用样式
	 * @param xml 
	 */
	public function apply(xml:Xml):Void {
		var styleid = xml.get("style");
		if (styleid == null) {
			return;
		}
		var styleids = styleid.split(":");
		#if !macro
		if (!__cacheStyle.exists(styleids[0])) {
			addXml(styleids[0], ZBuilder.getBaseXml(styleids[0]));
		}
		#end
		var list:Array<{key:String, value:String}> = __styles.get(styleid);
		if (list == null) {
			return;
		}
		for (item in list) {
			if (!xml.exists(item.key)) {
				xml.set(item.key, item.value);
			}
		}
	}

	/**
	 * 添加样式
	 * @param xml 
	 */
	public function addXmlItem(name:String, xml:Xml):Void {
		var list:Array<{key:String, value:String}> = [];
		for (key in xml.attributes()) {
			list.push({
				key: key,
				value: xml.get(key)
			});
		}
		__styles.set(name + ":" + xml.get("id"), list);
	}

	/**
	 * 添加一个完整的xml样式
	 * @param xml 
	 */
	public function addXml(name:String, xml:Xml):Void {
		if (__cacheStyle.exists(name)) {
			return;
		}
		for (item in xml.firstElement().elements()) {
			addXmlItem(name, item);
		}
		__cacheStyle.set(name, true);
	}
}
