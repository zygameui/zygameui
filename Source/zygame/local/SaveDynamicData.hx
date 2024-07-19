package zygame.local;

import haxe.Json;
import zygame.utils.CEFloat.CEData;

/**
 * 动态类型抽象类
 */
@:runtimeValue abstract SaveDynamicData<T>(SaveDynamicDataContent<T>) to SaveDynamicDataContent<T> from SaveDynamicDataContent<T> {
	public function new(data:Dynamic = null) {
		this = new SaveDynamicDataContent();
		if (data != null) {
			var keys = Reflect.fields(data);
			for (key in keys) {
				this.setValue(key, Reflect.getProperty(data, key));
			}
		}
	}

	@:op(a.b) public function fieldRead(name:String):T {
		return this.getValue(name);
	}

	@:op(a.b) public function fieldWrite(name:String, value:T):T {
		return this.setValue(name, value);
	}

	@:arrayAccess
	public inline function get(key:Int):T {
		return this.getValue(Std.string(key));
	}

	@:arrayAccess
	public inline function arrayWrite(k:Int, v:T):T {
		this.setValue(Std.string(k), v);
		return v;
	}

	@:arrayAccess
	public inline function getString(key:String):T {
		return this.getValue(key);
	}

	@:arrayAccess
	public inline function arrayStringWrite(k:String, v:T):T {
		this.setValue(k, v);
		return v;
	}

	/**
	 * 转为String
	 * @return String
	 */
	public function toData():Dynamic {
		return this.data;
	}

	/**
	 * 是否已经存在更改数据
	 * @return Bool
	 */
	public function isChanged():Bool {
		return this.changed;
	}

	/**
	 * 启动验算逻辑，它会产生一个签名数值
	 * @param cb 
	 */
	public function vaildateFunc(cb:T->String):Void {
		this.vaildateFunc = cb;
	}

	/**
	 * 验算数据是否存在异常
	 * @param id 
	 * @return Bool
	 */
	public function vaildate(id:String):Bool {
		return this.vaildate(id);
	}

	@:from public static function fromDynamic<T>(data:Dynamic<T>):SaveDynamicData<T> {
		var data = new SaveDynamicData(data);
		return data;
	}
}

class SaveDynamicDataContent<T> extends SaveDynamicDataBaseContent {
	/**
	 * 发生变化的值
	 */
	public var changedValues:Map<String, T> = [];

	/**
	 * 数据储存
	 */
	public var data:Dynamic<T> = {};

	public function getValue(key:String):T {
		return Reflect.getProperty(this.data, key);
	}

	/**
	 * 签名验算方法定义
	 */
	public var vaildateFunc:T->String;

	/**
	 * 签名验算使用的签名
	 */
	private var __vaildateSign:Map<String, String> = [];

	/**
	 * 验算数据
	 * @param key 
	 * @return T
	 */
	public function vaildate(key:String):Bool {
		if (vaildateFunc == null) {
			return true;
		}
		if (__vaildateSign.exists(key)) {
			var v = this.getValue(key);
			if (v == null) {
				return true;
			}
			return __vaildateSign.get(key) == vaildateFunc(v);
		}
		return true;
	}

	public function setValue(key:String, value:T):T {
		this.changed = true;
		this.changedValues.set(key, value);
		Reflect.setProperty(this.data, key, value);
		// 更新签名
		if (vaildateFunc != null) {
			if (value == null) {
				__vaildateSign.remove(key);
			} else {
				__vaildateSign.set(key, vaildateFunc(value));
			}
		}
		return value;
	}

	override function flush(key:String, changeData:Dynamic) {
		super.flush(key, changeData);
		if (changed) {
			changed = false;
			var newdata = {};
			for (key => value in changedValues) {
				// 需要进行签名验证
				if (this.vaildate(key)) {
					if (value is CEData) {
						Reflect.setProperty(newdata, key, cast(value, CEData).value);
					} else
						Reflect.setProperty(newdata, key, value);
				} else {
					throw "SaveDynamicData数据验证错误:" + key + ":" + Json.stringify(value);
				}
			}
			Reflect.setProperty(changeData, key, newdata);
			changedValues = [];
		}
	}

	override function getData(key:String, backdata:Dynamic):Void {
		var newdata = {};
		var keys = Reflect.fields(data);
		for (key in keys) {
			var v = Reflect.getProperty(data, key);
			if (v is CEData) {
				Reflect.setProperty(newdata, key, cast(v, CEData).value);
			} else {
				Reflect.setProperty(newdata, key, Reflect.getProperty(data, key));
			}
		}
		Reflect.setProperty(backdata, key, newdata);
	}
}
