package pkg;

import haxe.crypto.Md5;
import python.FileUtils;
import sys.io.File;

class ZProjectData {
	private var _xml:Xml;

	private var _changeXml:Array<String> = [];

	public var includes:Array<ZProjectData> = [];

	/**
	 * 资源绑定
	 */
	public var assetsBind:Array<{path:String, copyTo:String}> = [];

	/**
	 * 代码绑定
	 */
	public var sourceBind:Array<{path:String}> = [];

	/**
	 * 模板绑定
	 */
	public var templateBind:Array<{path:String, copyTo:String}> = [];

	/**
	 * 包绑定
	 */
	public var pkgBind:Array<{path:String, copyTo:String}> = [];

	public function new(path:String, xmlData:String = null) {
		var rootPath = path.substr(0, path.lastIndexOf("/"));
		_xml = Xml.parse(xmlData != null ? xmlData : File.getContent(path));
		for (item in _xml.firstElement().iterator()) {
			if (item.nodeType == Element) {
				trace(item.nodeType, item.nodeName, item);
				switch (item.nodeName) {
					case "section":
						// 子对象
						var sectionData = new ZProjectData(path, item.toString());
						var attributes = [];
						for (itemkey in item.attributes()) {
							attributes.push(itemkey + '="' + item.get(itemkey) + '"');
						}
						_changeXml.push("<section " + attributes.join(" ") + ">" + sectionData.getData() + "</section>");
					case "template":
						// 模板拷贝
						var obj = {
							path: rootPath + "/" + item.get("path"),
							copyTo: "template/" + Md5.encode(rootPath + "/" + item.get("path"))
						};
						templateBind.push(obj);
						item.set("path", obj.copyTo);
						_changeXml.push(item.toString());
					case "source":
						// 代码拷贝
						var obj = {
							path: rootPath + "/" + item.get("path")
						};
						sourceBind.push(obj);
					case "pkg":
						// -pkg时会自动拷贝
						var to = item.exists("rename") ? item.get("rename") : (item.get("path"));
						var obj = {
							path: rootPath + "/" + item.get("path"),
							copyTo: to
						};
						pkgBind.push(obj);
					case "assets":
						// 资源拷贝
						var obj = {
							path: rootPath + "/" + item.get("path"),
							copyTo: "assets/" + Md5.encode(rootPath + "/" + item.get("path"))
						};
						assetsBind.push(obj);
						if (!item.exists("rename"))
							item.set("rename", item.get("path"));
						item.set("path", obj.copyTo);
						_changeXml.push(item.toString());
					case "include":
						// include标签需要变更为setion标签
						var includeData = new ZProjectData(rootPath + "/" + item.get("path"));
						var attributes = [];
						for (itemkey in item.attributes()) {
							if (itemkey == "path")
								continue;
							attributes.push(itemkey + '="' + item.get(itemkey) + '"');
						}
						_changeXml.push("<section " + attributes.join(" ") + ">" + includeData.getData() + "</section>");
						includes.push(includeData);
					default:
						// 默认处理
						_changeXml.push(item.toString());
				}
			}
		}
		if (sourceBind.length > 0)
			_changeXml.push('<source path="source"/>');
		trace("ChangeXml:\n\n" + _changeXml.join("\n"));
	}

	public function getData():String {
		return _changeXml.join("\n");
	}
}
