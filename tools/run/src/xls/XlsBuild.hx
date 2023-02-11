package xls;

import haxe.Exception;
import sys.io.File;
import python.XlsData;
import sys.FileSystem;

class XlsBuild {
	public static function build(path:String, saveDir:String):Void {
		trace("XLS:",path,saveDir,FileSystem.isDirectory(path));
		if (FileSystem.isDirectory(path)) {
			var array = FileSystem.readDirectory(path);
			for (str in array) {
				build(path + "/" + str, saveDir);
			}
		} else if (StringTools.endsWith(path, "xlsx") || StringTools.endsWith(path, "xls")) {
			if (path.indexOf("/.") != -1)
				return;
			trace("parsing file:" + path);
			try {
				var xlsData:XlsData = XlsData.open(path);
				var names:Array<String> = xlsData.getSheetsNames();
				for (name in names) {
					var data:Dynamic = {data: []};
					trace("do " + name + " parsing...");
					var sheet:XlsSheet = xlsData.getSheet(name);
					// Key值为第二列中
					var keys:Array<String> = sheet.getRowValues(0);
					var newkeys:Array<String> = [];
					var newDockey:Array<{name:String,doc:String}> = [];
					var docKeys:Array<String> = sheet.getRowValues(1);
					for(i in 0...keys.length){
						var s = keys[i];
						var d = docKeys[i];
						if (s != "" && s != null && s != "null"){
							newkeys.push(s);
							newDockey.push({
								name:s,
								doc:d
							});
						}
					}
					keys = newkeys;
					if (newkeys.length == 0)
						continue;
					var saveName = newkeys[0];
					if (saveName.indexOf(".") != -1)
						saveName = saveName.substr(0, saveName.lastIndexOf("."));
					else
						continue;
					trace("keys:" + keys);
					for (i in 2...sheet.nrows) {
						var values:Array<String> = sheet.getRowValues(i);
						var obj:Dynamic = {
							id:(i - 1)
						};
						for (i2 in 1...values.length) {
							var key:String = Std.string(keys[i2]);
							if (key != "" && key != null && key != "null") {
								Reflect.setProperty(obj, key, Std.string(values[i2]));
							}
						}
						data.data.push(obj);
					}
					data.doc = {};
					for (index => value in newDockey) {
						Reflect.setProperty(data.doc,value.name,value.doc);
					}
					if (!FileSystem.exists(saveDir)) {
						FileSystem.createDirectory(saveDir);
					}
					File.saveContent(saveDir + "/" + saveName + ".json", haxe.Json.stringify(data));
				}
			} catch (err:Exception) {
				throw ("file "+path+" is not xls, skip!" + "\n" + err.message);
			}
		}
	}
}
