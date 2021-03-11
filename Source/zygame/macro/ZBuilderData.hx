package zygame.macro;

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

	public function new(xmlPath:String, project:ZProjectData) {
		this.project = project;
		if (!FileSystem.exists(xmlPath)) {
			throw "Xml file '" + xmlPath + "' is not exists!";
		}
		content = File.getContent(xmlPath);
		var xml:Xml = Xml.parse(content);
		parserXml(xml.firstElement());
	}

	private function parserXml(xml:Xml):Void {
		parserItem(xml);
		for (item in xml.elements()) {
			parserXml(item);
		}
	}

	private function parserItem(item:Xml) {
		if (item.exists("id")) {
			ids.set(item.get("id"), item.nodeName);
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
		// Item可能是一个XML配置，列入查询
		if (assetsLoads.indexOf(item.nodeName) == -1 && project.assetsPath.get(StringUtils.getName(item.nodeName) + ".xml") != null) {
			assetsLoads.push(item.nodeName);
			// 子集查询
			var childcontent = File.getContent(project.assetsPath.get(StringUtils.getName(item.nodeName) + ".xml"));
			// trace("子集查询" + project.assetsPath.get(StringUtils.getName(item.nodeName) + ".xml"));
			var childxml:Xml = Xml.parse(childcontent);
			parserXml(childxml.firstElement());
		}
	}
	#end
}
