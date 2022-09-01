import haxe.Json;
import zygame.local.SaveDynamicData;
import zygame.local.SaveFloatData;
import zygame.local.SaveObject;

class Main {
	static function main() {
		var obj = new SaveObject<SaveData>("test").make(SaveData);
		obj.data.data.data = 2;
		obj.data.a1 = 1;
		obj.data.a2 = 2;
		obj.data.a3 = 3;
		obj.data.a123 = 1;
		obj.flush();
		obj.data.data.data = 3;
		obj.data.a1 = 2;
		obj.flush();
		trace(obj.getData());
	}
}

class SaveData extends SaveObjectData {
	public var data:SaveDynamicData = new SaveDynamicData();

	public var a1:SaveFloatData;

	public var a2:SaveFloatData;

	public var a3:SaveFloatData;

	public var a123:SaveFloatData;
}
