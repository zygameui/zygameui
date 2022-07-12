package zygame.utils.load;

#if castle
import haxe.crypto.Base64;
import cdb.Data;
import cdb.Parser;

/**
 * CDB数据格式加载
 */
class CDBLoader {
	public var path:String;

	private var _onLoaded:String->CDBData->Void;

	private var _onError:String->Void;

	public function new(path:String) {
		this.path = path;
	}

	public function load(onLoaded:String->CDBData->Void, onError:String->Void):Void {
		_onLoaded = onLoaded;
		_onError = onError;
		AssetsUtils.loadText(this.path).onComplete(function(data) {
			_onLoaded(this.path, new CDBData(data));
		}).onError(_onError);
	}
}

/**
 * CDB数据源支持
 */
class CDBData {
	public var data:Data;

	public function new(data:String) {
		if (data.indexOf("{") == -1) {
			// 可能被base64编码处理
			data = Base64.decode(data).toString();
		}
		this.data = Parser.parse(data, false);
	}

	/**
	 * 根据表格名字获取表格数据
	 * @param name
	 * @return SheetData
	 */
	public function getSheetByName(name:String):SheetData {
		for (item in data.sheets) {
			if (item.name == name)
				return item;
		}
		return null;
	}

	/**
	 * 在表格中查找对象
	 * @param sheetData 查找的表格
	 * @param key 确认键值
	 * @param ifvalue 判断值
	 * @return Dynamic
	 */
	public function findData(sheetData:SheetData, key:String, ifvalue:Dynamic):Dynamic {
		for (item in sheetData.lines) {
			var value = Reflect.getProperty(item, key);
			if (value == ifvalue)
				return item;
		}
		return null;
	}

	/**
	 * 在表格中查找对象
	 * @param name 查找的表
	 * @param key 确认键值
	 * @param ifvalue 判断值
	 * @return Dynamic
	 */
	public function findDataByName(name:String, key:String, ifvalue:Dynamic):Dynamic {
		return findData(getSheetByName(name), key, ifvalue);
	}
}
#end
