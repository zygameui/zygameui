import zygame.utils.CEFloat;
import zygame.local.SaveStringData;
import zygame.local.SaveArrayData;
import haxe.Json;
import zygame.local.SaveDynamicData;
import zygame.local.SaveFloatData;
import zygame.local.SaveObject;

class Main {
	static function main() {
		var obj = new SaveObject<SaveData>("test").make(SaveData);
		obj.async((bool) -> {
			if (obj.data.data.data != null)
				obj.data.data.data += 1;
			else
				obj.data.data.data = 2;
			obj.data.a1 = 1;
			obj.data.a2 = 2;
			obj.data.a3 = 3;
			obj.data.a123 = 1;
			obj.async();
			obj.data.data.data2 = 3;
			obj.data.a1 = 2;
			obj.data.str = obj.data.str;
			if (obj.data.cetest.data == null)
				obj.data.cetest.data = 1;
			else
				obj.data.cetest.data = obj.data.cetest.data + 2;
			obj.async();
			obj.data.array[5] = 400;
			obj.data.array[0]++;
			obj.data.setCetestValue("test", 4);
			trace("测试一下：", obj.data.getCetestValue("test2"));
			obj.async();
			trace(obj.getData());
		});
	}
}

class SaveData extends SaveObjectData {
	public var data:SaveDynamicData<Dynamic> = {
		data3: 3
	}

	public var a1:SaveFloatData = 0;

	public var a2:SaveFloatData = 0;

	public var a3:SaveFloatData = 0;

	public var a123:SaveFloatData = 0;

	public var str:SaveStringData = "";

	public var cetest:SaveDynamicData<CEFloat> = {
		key: 1
	};

	public var array:SaveArrayData<Dynamic> = [1, 2, 3];
}
