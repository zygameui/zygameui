package zygame.macro;

import zygame.components.style.XmlStyle;
import zygame.utils.StringUtils;
#if macro
import sys.FileSystem;
import sys.io.File;
#end

class ZBuilderData {
	#if macro
	public var assetsLoads:Array<String> = [];

	public var ids:Map<String, String> = [];

	public var content:String;

	public var project:ZProjectData;

	public var xmlStyle:XmlStyle = new XmlStyle();

	public function new(xmlPath:String, project:ZProjectData) {
		this.project = project;
		if (!FileSystem.exists(xmlPath)) {
			throw "Xml file '" + xmlPath + "' is not exists!";
		}
		content = File.getContent(xmlPath);
		var xml:Xml = Xml.parse(content);
		parserXml(xml.firstElement());
	}

	private function parserXml(xml:Xml, parentId:String = null, isClassed:Bool = false, noParseId:Bool = false):Void {
		if (xml.get("load") == "true") {
			// 预加载模块，不解析id
			noParseId = true;
		}
		parserItem(xml, parentId, isClassed, noParseId);
		for (item in xml.elements()) {
			parserXml(item, parentId, isClassed, noParseId);
		}
	}

	private function parserItem(item:Xml, parentId:String = null, isClassed:Bool = false, noParseId:Bool = false) {
		// 样式查询
		if (item.exists("style")) {
			var styleid = item.get("style");
			// 需要切割成两个：xml配置:样式id
			var styleids = styleid.split(":");
			var childcontent = File.getContent(project.assetsPath.get(styleids[0] + ".xml"));
			var childxml:Xml = Xml.parse(childcontent);
			xmlStyle.addXml(styleids[0], childxml);
			if (assetsLoads.indexOf(styleids[0]) == -1)
				assetsLoads.push(styleids[0]);
		}
		xmlStyle.apply(item);
		var idname = null;
		if (item.exists("id")) {
			idname = (parentId != null ? parentId + "_" : "") + item.get("id");
			if (!item.exists("classed") && !isClassed && !noParseId) {
				ids.set(idname, item.nodeName);
			}
		}
		// 可能内置音效功能
		if (item.exists("sound")) {
			var src = item.get("sound");
			if (assetsLoads.indexOf(src) == -1) {
				assetsLoads.push(src);
			}
		}
		// 可能内置tween动画
		if (item.exists("tween")) {
			var src = item.get("tween");
			if (assetsLoads.indexOf(src) == -1) {
				assetsLoads.push(src);
			}
		}
		if (item.exists("src")) {
			var src = item.get("src");
			if (src.indexOf(":") != -1) {
				src = src.substr(0, src.lastIndexOf(":"));
			} else {
				src = StringUtils.getName(src);
			}
			if (assetsLoads.indexOf(src) == -1) {
				assetsLoads.push(src);
			}
		}
		// Item可能是一个XML配置，列入查询，如果classed为true时，则意味着这个组件可能已经被类型注册，则不再解析
		if (project.assetsPath.get(StringUtils.getName(item.nodeName) + ".xml") != null) {
			if (assetsLoads.indexOf(item.nodeName) == -1)
				assetsLoads.push(item.nodeName);
			// 子集查询
			var childcontent = File.getContent(project.assetsPath.get(StringUtils.getName(item.nodeName) + ".xml"));
			var childxml:Xml = Xml.parse(childcontent);
			if (childxml.firstElement().exists("classed")) {
				item.set("classed", childxml.firstElement().get("classed"));
				if (idname == null)
					throw item.nodeName + "XML配置中使用了" + item.get("classed") + "，需要定义id。";
				if (!noParseId)
					ids.set(idname, item.get("classed"));
				parserXml(childxml.firstElement(), item.get("id"), true, noParseId);
			} else {
				parserXml(childxml.firstElement(), item.get("id"), false, noParseId);
			}
		}
	}
	#end
}
