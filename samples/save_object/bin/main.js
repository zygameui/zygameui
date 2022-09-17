(function ($global) { "use strict";
function $extend(from, fields) {
	var proto = Object.create(from);
	for (var name in fields) proto[name] = fields[name];
	if( fields.toString !== Object.prototype.toString ) proto.toString = fields.toString;
	return proto;
}
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var obj = new zygame_local_SaveObject("test").make_zygame_local_SaveObjectData(SaveData);
	obj.async(function(bool) {
		if(zygame_local_SaveDynamicData.fieldRead(obj.data.data,"data") != null) {
			zygame_local_SaveDynamicData.fieldWrite(obj.data.data,"data",zygame_local_SaveDynamicData.fieldRead(obj.data.data,"data") + 1);
		} else {
			zygame_local_SaveDynamicData.fieldWrite(obj.data.data,"data",2);
		}
		obj.data.a1 = zygame_local_SaveFloatData.fromFloat(1);
		obj.data.a2 = zygame_local_SaveFloatData.fromFloat(2);
		obj.data.a3 = zygame_local_SaveFloatData.fromFloat(3);
		obj.data.a123 = zygame_local_SaveFloatData.fromFloat(1);
		obj.async();
		zygame_local_SaveDynamicData.fieldWrite(obj.data.data,"data2",3);
		obj.data.a1 = zygame_local_SaveFloatData.fromFloat(2);
		obj.data.str = obj.data.str;
		if(zygame_local_SaveDynamicData.fieldRead(obj.data.cetest,"data") == null) {
			zygame_local_SaveDynamicData.fieldWrite(obj.data.cetest,"data",zygame_utils_CEFloat.fromFloat(1));
		} else {
			zygame_local_SaveDynamicData.fieldWrite(obj.data.cetest,"data",zygame_utils_CEFloat.fromFloat(zygame_utils_CEFloat.add(zygame_local_SaveDynamicData.fieldRead(obj.data.cetest,"data"),2)));
		}
		obj.async();
		obj.data.array.setValue(5,400);
		var tmp = 0;
		var v = obj.data.array.getValue(tmp) + 1;
		obj.data.array.setValue(tmp,v);
		obj.data.setCetestValue("test",zygame_utils_CEFloat.fromFloat(4));
		var tmp = haxe_Log.trace;
		var tmp1 = obj.data.getCetestValue("test2");
		tmp("测试一下：",{ fileName : "Main.hx", lineNumber : 33, className : "Main", methodName : "main", customParams : [tmp1 == null ? "null" : zygame_utils_CEFloat.toString(tmp1)]});
		obj.async();
		haxe_Log.trace(obj.getData(),{ fileName : "Main.hx", lineNumber : 35, className : "Main", methodName : "main"});
	});
};
var zygame_local_SaveObjectData = function() {
	this.ce = new haxe_ds_StringMap();
	this.lastUploadTime = zygame_local_SaveFloatData.fromFloat(0.);
	this.version = zygame_local_SaveFloatData.fromFloat(0.);
};
zygame_local_SaveObjectData.__name__ = true;
zygame_local_SaveObjectData.prototype = {
	flush: function(data) {
		var keys = Reflect.fields(this);
		var _g_current = 0;
		var _g_array = keys;
		while(_g_current < _g_array.length) {
			var _g1_value = _g_array[_g_current];
			var _g1_key = _g_current++;
			var index = _g1_key;
			var value = _g1_value;
			var content = Reflect.getProperty(this,value);
			if(((content) instanceof zygame_local_SaveDynamicDataBaseContent)) {
				(js_Boot.__cast(content , zygame_local_SaveDynamicDataBaseContent)).flush(value,data);
			}
		}
		if(Reflect.fields(data).length > 0) {
			this.version = zygame_local_SaveFloatData.fromFloat(zygame_local_SaveFloatData.toFloat(this.version) + 1);
			this.lastUploadTime = zygame_local_SaveFloatData.fromFloat(new Date().getTime() / 1000 | 0);
			Reflect.setProperty(data,"version",zygame_local_SaveFloatData.toFloat(this.version));
			Reflect.setProperty(data,"lastUploadTime",zygame_local_SaveFloatData.toFloat(this.lastUploadTime));
		}
	}
	,getData: function(data) {
		var keys = Reflect.fields(this);
		var _g_current = 0;
		var _g_array = keys;
		while(_g_current < _g_array.length) {
			var _g1_value = _g_array[_g_current];
			var _g1_key = _g_current++;
			var index = _g1_key;
			var value = _g1_value;
			var content = Reflect.getProperty(this,value);
			if(((content) instanceof zygame_local_SaveDynamicDataBaseContent)) {
				(js_Boot.__cast(content , zygame_local_SaveDynamicDataBaseContent)).getData(value,data);
			}
		}
	}
	,__class__: zygame_local_SaveObjectData
};
var SaveData = function() {
	this.array = zygame_local_SaveArrayData.fromDynamic([1,2,3]);
	this.cetest = zygame_local_SaveDynamicData.fromDynamic({ key : 1});
	this.str = zygame_local_SaveStringData.fromString("");
	this.a123 = zygame_local_SaveFloatData.fromFloat(0);
	this.a3 = zygame_local_SaveFloatData.fromFloat(0);
	this.a2 = zygame_local_SaveFloatData.fromFloat(0);
	this.a1 = zygame_local_SaveFloatData.fromFloat(0);
	this.data = zygame_local_SaveDynamicData.fromDynamic({ data3 : 3});
	zygame_local_SaveObjectData.call(this);
	var _g = new haxe_ds_StringMap();
	_g.h["cetest"] = true;
	this.ce = _g;
};
SaveData.__name__ = true;
SaveData.__super__ = zygame_local_SaveObjectData;
SaveData.prototype = $extend(zygame_local_SaveObjectData.prototype,{
	setDataValue: function(key,value) {
		zygame_local_SaveDynamicData.fieldWrite(this.data,key,value);
	}
	,getDataValue: function(key,defaultValue) {
		var value = zygame_local_SaveDynamicData.fieldRead(this.data,key);
		if(value == null) {
			return defaultValue;
		} else {
			return value;
		}
	}
	,setCetestValue: function(key,value) {
		zygame_local_SaveDynamicData.fieldWrite(this.cetest,key,value);
	}
	,getCetestValue: function(key,defaultValue) {
		var value = zygame_local_SaveDynamicData.fieldRead(this.cetest,key);
		if(value == null) {
			return defaultValue;
		} else {
			return value;
		}
	}
	,__class__: SaveData
});
Math.__name__ = true;
var Reflect = function() { };
Reflect.__name__ = true;
Reflect.getProperty = function(o,field) {
	var tmp;
	if(o == null) {
		return null;
	} else {
		var tmp1;
		if(o.__properties__) {
			tmp = o.__properties__["get_" + field];
			tmp1 = tmp;
		} else {
			tmp1 = false;
		}
		if(tmp1) {
			return o[tmp]();
		} else {
			return o[field];
		}
	}
};
Reflect.setProperty = function(o,field,value) {
	var tmp;
	var tmp1;
	if(o.__properties__) {
		tmp = o.__properties__["set_" + field];
		tmp1 = tmp;
	} else {
		tmp1 = false;
	}
	if(tmp1) {
		o[tmp](value);
	} else {
		o[field] = value;
	}
};
Reflect.fields = function(o) {
	var a = [];
	if(o != null) {
		var hasOwnProperty = Object.prototype.hasOwnProperty;
		for( var f in o ) {
		if(f != "__id__" && f != "hx__closures__" && hasOwnProperty.call(o,f)) {
			a.push(f);
		}
		}
	}
	return a;
};
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
Std.parseInt = function(x) {
	if(x != null) {
		var _g = 0;
		var _g1 = x.length;
		while(_g < _g1) {
			var i = _g++;
			var c = x.charCodeAt(i);
			if(c <= 8 || c >= 14 && c != 32 && c != 45) {
				var nc = x.charCodeAt(i + 1);
				var v = parseInt(x,nc == 120 || nc == 88 ? 16 : 10);
				if(isNaN(v)) {
					return null;
				} else {
					return v;
				}
			}
		}
	}
	return null;
};
var Type = function() { };
Type.__name__ = true;
Type.createInstance = function(cl,args) {
	var ctor = Function.prototype.bind.apply(cl,[null].concat(args));
	return new (ctor);
};
var haxe_IMap = function() { };
haxe_IMap.__name__ = true;
haxe_IMap.__isInterface__ = true;
haxe_IMap.prototype = {
	__class__: haxe_IMap
};
var haxe_Exception = function(message,previous,native) {
	Error.call(this,message);
	this.message = message;
	this.__previousException = previous;
	this.__nativeException = native != null ? native : this;
};
haxe_Exception.__name__ = true;
haxe_Exception.thrown = function(value) {
	if(((value) instanceof haxe_Exception)) {
		return value.get_native();
	} else if(((value) instanceof Error)) {
		return value;
	} else {
		var e = new haxe_ValueException(value);
		return e;
	}
};
haxe_Exception.__super__ = Error;
haxe_Exception.prototype = $extend(Error.prototype,{
	get_native: function() {
		return this.__nativeException;
	}
	,__class__: haxe_Exception
	,__properties__: {get_native:"get_native"}
});
var haxe_Log = function() { };
haxe_Log.__name__ = true;
haxe_Log.formatOutput = function(v,infos) {
	var str = Std.string(v);
	if(infos == null) {
		return str;
	}
	var pstr = infos.fileName + ":" + infos.lineNumber;
	if(infos.customParams != null) {
		var _g = 0;
		var _g1 = infos.customParams;
		while(_g < _g1.length) {
			var v = _g1[_g];
			++_g;
			str += ", " + Std.string(v);
		}
	}
	return pstr + ": " + str;
};
haxe_Log.trace = function(v,infos) {
	var str = haxe_Log.formatOutput(v,infos);
	if(typeof(console) != "undefined" && console.log != null) {
		console.log(str);
	}
};
var haxe_ValueException = function(value,previous,native) {
	haxe_Exception.call(this,String(value),previous,native);
	this.value = value;
};
haxe_ValueException.__name__ = true;
haxe_ValueException.__super__ = haxe_Exception;
haxe_ValueException.prototype = $extend(haxe_Exception.prototype,{
	__class__: haxe_ValueException
});
var haxe_ds_IntMap = function() {
	this.h = { };
};
haxe_ds_IntMap.__name__ = true;
haxe_ds_IntMap.__interfaces__ = [haxe_IMap];
haxe_ds_IntMap.prototype = {
	get: function(key) {
		return this.h[key];
	}
	,exists: function(key) {
		return this.h.hasOwnProperty(key);
	}
	,keys: function() {
		var a = [];
		for( var key in this.h ) if(this.h.hasOwnProperty(key)) a.push(+key);
		return new haxe_iterators_ArrayIterator(a);
	}
	,__class__: haxe_ds_IntMap
};
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
haxe_ds_StringMap.__interfaces__ = [haxe_IMap];
haxe_ds_StringMap.prototype = {
	exists: function(key) {
		return Object.prototype.hasOwnProperty.call(this.h,key);
	}
	,get: function(key) {
		return this.h[key];
	}
	,keys: function() {
		return new haxe_ds__$StringMap_StringMapKeyIterator(this.h);
	}
	,__class__: haxe_ds_StringMap
};
var haxe_ds__$StringMap_StringMapKeyIterator = function(h) {
	this.h = h;
	this.keys = Object.keys(h);
	this.length = this.keys.length;
	this.current = 0;
};
haxe_ds__$StringMap_StringMapKeyIterator.__name__ = true;
haxe_ds__$StringMap_StringMapKeyIterator.prototype = {
	hasNext: function() {
		return this.current < this.length;
	}
	,next: function() {
		return this.keys[this.current++];
	}
	,__class__: haxe_ds__$StringMap_StringMapKeyIterator
};
var haxe_iterators_ArrayIterator = function(array) {
	this.current = 0;
	this.array = array;
};
haxe_iterators_ArrayIterator.__name__ = true;
haxe_iterators_ArrayIterator.prototype = {
	hasNext: function() {
		return this.current < this.array.length;
	}
	,next: function() {
		return this.array[this.current++];
	}
	,__class__: haxe_iterators_ArrayIterator
};
var js_Boot = function() { };
js_Boot.__name__ = true;
js_Boot.getClass = function(o) {
	if(o == null) {
		return null;
	} else if(((o) instanceof Array)) {
		return Array;
	} else {
		var cl = o.__class__;
		if(cl != null) {
			return cl;
		}
		var name = js_Boot.__nativeClassName(o);
		if(name != null) {
			return js_Boot.__resolveNativeClass(name);
		}
		return null;
	}
};
js_Boot.__string_rec = function(o,s) {
	if(o == null) {
		return "null";
	}
	if(s.length >= 5) {
		return "<...>";
	}
	var t = typeof(o);
	if(t == "function" && (o.__name__ || o.__ename__)) {
		t = "object";
	}
	switch(t) {
	case "function":
		return "<function>";
	case "object":
		if(((o) instanceof Array)) {
			var str = "[";
			s += "\t";
			var _g = 0;
			var _g1 = o.length;
			while(_g < _g1) {
				var i = _g++;
				str += (i > 0 ? "," : "") + js_Boot.__string_rec(o[i],s);
			}
			str += "]";
			return str;
		}
		var tostr;
		try {
			tostr = o.toString;
		} catch( _g ) {
			return "???";
		}
		if(tostr != null && tostr != Object.toString && typeof(tostr) == "function") {
			var s2 = o.toString();
			if(s2 != "[object Object]") {
				return s2;
			}
		}
		var str = "{\n";
		s += "\t";
		var hasp = o.hasOwnProperty != null;
		var k = null;
		for( k in o ) {
		if(hasp && !o.hasOwnProperty(k)) {
			continue;
		}
		if(k == "prototype" || k == "__class__" || k == "__super__" || k == "__interfaces__" || k == "__properties__") {
			continue;
		}
		if(str.length != 2) {
			str += ", \n";
		}
		str += s + k + " : " + js_Boot.__string_rec(o[k],s);
		}
		s = s.substring(1);
		str += "\n" + s + "}";
		return str;
	case "string":
		return o;
	default:
		return String(o);
	}
};
js_Boot.__interfLoop = function(cc,cl) {
	if(cc == null) {
		return false;
	}
	if(cc == cl) {
		return true;
	}
	var intf = cc.__interfaces__;
	if(intf != null) {
		var _g = 0;
		var _g1 = intf.length;
		while(_g < _g1) {
			var i = _g++;
			var i1 = intf[i];
			if(i1 == cl || js_Boot.__interfLoop(i1,cl)) {
				return true;
			}
		}
	}
	return js_Boot.__interfLoop(cc.__super__,cl);
};
js_Boot.__instanceof = function(o,cl) {
	if(cl == null) {
		return false;
	}
	switch(cl) {
	case Array:
		return ((o) instanceof Array);
	case Bool:
		return typeof(o) == "boolean";
	case Dynamic:
		return o != null;
	case Float:
		return typeof(o) == "number";
	case Int:
		if(typeof(o) == "number") {
			return ((o | 0) === o);
		} else {
			return false;
		}
		break;
	case String:
		return typeof(o) == "string";
	default:
		if(o != null) {
			if(typeof(cl) == "function") {
				if(js_Boot.__downcastCheck(o,cl)) {
					return true;
				}
			} else if(typeof(cl) == "object" && js_Boot.__isNativeObj(cl)) {
				if(((o) instanceof cl)) {
					return true;
				}
			}
		} else {
			return false;
		}
		if(cl == Class ? o.__name__ != null : false) {
			return true;
		}
		if(cl == Enum ? o.__ename__ != null : false) {
			return true;
		}
		return false;
	}
};
js_Boot.__downcastCheck = function(o,cl) {
	if(!((o) instanceof cl)) {
		if(cl.__isInterface__) {
			return js_Boot.__interfLoop(js_Boot.getClass(o),cl);
		} else {
			return false;
		}
	} else {
		return true;
	}
};
js_Boot.__cast = function(o,t) {
	if(o == null || js_Boot.__instanceof(o,t)) {
		return o;
	} else {
		throw haxe_Exception.thrown("Cannot cast " + Std.string(o) + " to " + Std.string(t));
	}
};
js_Boot.__nativeClassName = function(o) {
	var name = js_Boot.__toStr.call(o).slice(8,-1);
	if(name == "Object" || name == "Function" || name == "Math" || name == "JSON") {
		return null;
	}
	return name;
};
js_Boot.__isNativeObj = function(o) {
	return js_Boot.__nativeClassName(o) != null;
};
js_Boot.__resolveNativeClass = function(name) {
	return $global[name];
};
var js_Browser = function() { };
js_Browser.__name__ = true;
js_Browser.getLocalStorage = function() {
	try {
		var s = window.localStorage;
		s.getItem("");
		if(s.length == 0) {
			var key = "_hx_" + Math.random();
			s.setItem(key,key);
			s.removeItem(key);
		}
		return s;
	} catch( _g ) {
		return null;
	}
};
var zygame_local_ISave = function() { };
zygame_local_ISave.__name__ = true;
zygame_local_ISave.__isInterface__ = true;
zygame_local_ISave.prototype = {
	__class__: zygame_local_ISave
};
var zygame_local_SaveArrayData = {};
zygame_local_SaveArrayData._new = function(data) {
	var this1 = new zygame_local_SaveArrayDataContent();
	var _g_current = 0;
	var _g_array = data;
	while(_g_current < _g_array.length) {
		var _g1_value = _g_array[_g_current];
		var _g1_key = _g_current++;
		var index = _g1_key;
		var value = _g1_value;
		this1.setValue(index,value);
	}
	return this1;
};
zygame_local_SaveArrayData.get = function(this1,key) {
	return this1.getValue(key);
};
zygame_local_SaveArrayData.arrayWrite = function(this1,k,v) {
	this1.setValue(k,v);
	return v;
};
zygame_local_SaveArrayData.toString = function(this1) {
	return Std.string(this1.data);
};
zygame_local_SaveArrayData.toDynamic = function(this1) {
	return this1.data;
};
zygame_local_SaveArrayData.fromDynamic = function(data) {
	var data1 = zygame_local_SaveArrayData._new(data);
	return data1;
};
var zygame_local_SaveDynamicDataBaseContent = function() {
	this.changed = true;
};
zygame_local_SaveDynamicDataBaseContent.__name__ = true;
zygame_local_SaveDynamicDataBaseContent.prototype = {
	flush: function(key,changeData) {
	}
	,getData: function(key,data) {
	}
	,__class__: zygame_local_SaveDynamicDataBaseContent
};
var zygame_local_SaveArrayDataContent = function() {
	this.data = [];
	this.changedValues = new haxe_ds_IntMap();
	zygame_local_SaveDynamicDataBaseContent.call(this);
};
zygame_local_SaveArrayDataContent.__name__ = true;
zygame_local_SaveArrayDataContent.__super__ = zygame_local_SaveDynamicDataBaseContent;
zygame_local_SaveArrayDataContent.prototype = $extend(zygame_local_SaveDynamicDataBaseContent.prototype,{
	getValue: function(key) {
		return this.data[key];
	}
	,setValue: function(key,value) {
		this.changed = true;
		this.changedValues.h[key] = value;
		this.data[key] = value;
		return value;
	}
	,flush: function(key,changeData) {
		zygame_local_SaveDynamicDataBaseContent.prototype.flush.call(this,key,changeData);
		if(this.changed) {
			this.changed = false;
			var newdata = { };
			var map = this.changedValues;
			var _g_map = map;
			var _g_keys = map.keys();
			while(_g_keys.hasNext()) {
				var key1 = _g_keys.next();
				var _g1_value = _g_map.get(key1);
				var _g1_key = key1;
				var key2 = _g1_key;
				var value = _g1_value;
				if(((value) instanceof zygame_utils_CEData)) {
					Reflect.setProperty(newdata,key2 == null ? "null" : "" + key2,(js_Boot.__cast(value , zygame_utils_CEData)).get_value());
				} else {
					Reflect.setProperty(newdata,key2 == null ? "null" : "" + key2,value);
				}
			}
			Reflect.setProperty(changeData,key,newdata);
			this.changedValues = new haxe_ds_IntMap();
		}
	}
	,getData: function(key,backdata) {
		var newdata = [];
		var _g_current = 0;
		var _g_array = this.data;
		while(_g_current < _g_array.length) {
			var _g1_value = _g_array[_g_current];
			var _g1_key = _g_current++;
			var index = _g1_key;
			var value = _g1_value;
			newdata[index] = value;
		}
		Reflect.setProperty(backdata,key,newdata);
	}
	,__class__: zygame_local_SaveArrayDataContent
});
var zygame_local_SaveDynamicData = {};
zygame_local_SaveDynamicData._new = function(data) {
	var this1 = new zygame_local_SaveDynamicDataContent();
	if(data != null) {
		var keys = Reflect.fields(data);
		var _g = 0;
		while(_g < keys.length) {
			var key = keys[_g];
			++_g;
			this1.setValue(key,Reflect.getProperty(data,key));
		}
	}
	return this1;
};
zygame_local_SaveDynamicData.fieldRead = function(this1,name) {
	return this1.getValue(name);
};
zygame_local_SaveDynamicData.fieldWrite = function(this1,name,value) {
	return this1.setValue(name,value);
};
zygame_local_SaveDynamicData.get = function(this1,key) {
	return this1.getValue(key == null ? "null" : "" + key);
};
zygame_local_SaveDynamicData.arrayWrite = function(this1,k,v) {
	this1.setValue(k == null ? "null" : "" + k,v);
	return v;
};
zygame_local_SaveDynamicData.toString = function(this1) {
	return Std.string(this1.data);
};
zygame_local_SaveDynamicData.toDynamic = function(this1) {
	return this1.data;
};
zygame_local_SaveDynamicData.fromDynamic = function(data) {
	var data1 = zygame_local_SaveDynamicData._new(data);
	return data1;
};
var zygame_local_SaveDynamicDataContent = function() {
	this.data = { };
	this.changedValues = new haxe_ds_StringMap();
	zygame_local_SaveDynamicDataBaseContent.call(this);
};
zygame_local_SaveDynamicDataContent.__name__ = true;
zygame_local_SaveDynamicDataContent.__super__ = zygame_local_SaveDynamicDataBaseContent;
zygame_local_SaveDynamicDataContent.prototype = $extend(zygame_local_SaveDynamicDataBaseContent.prototype,{
	getValue: function(key) {
		return Reflect.getProperty(this.data,key);
	}
	,setValue: function(key,value) {
		this.changed = true;
		this.changedValues.h[key] = value;
		Reflect.setProperty(this.data,key,value);
		return value;
	}
	,flush: function(key,changeData) {
		zygame_local_SaveDynamicDataBaseContent.prototype.flush.call(this,key,changeData);
		if(this.changed) {
			this.changed = false;
			var newdata = { };
			var h = this.changedValues.h;
			var _g_h = h;
			var _g_keys = Object.keys(h);
			var _g_length = _g_keys.length;
			var _g_current = 0;
			while(_g_current < _g_length) {
				var key1 = _g_keys[_g_current++];
				var _g1_key = key1;
				var _g1_value = _g_h[key1];
				var key2 = _g1_key;
				var value = _g1_value;
				if(((value) instanceof zygame_utils_CEData)) {
					Reflect.setProperty(newdata,key2,(js_Boot.__cast(value , zygame_utils_CEData)).get_value());
				} else {
					Reflect.setProperty(newdata,key2,value);
				}
			}
			Reflect.setProperty(changeData,key,newdata);
			this.changedValues = new haxe_ds_StringMap();
		}
	}
	,getData: function(key,backdata) {
		var newdata = { };
		var keys = Reflect.fields(this.data);
		var _g = 0;
		while(_g < keys.length) {
			var key1 = keys[_g];
			++_g;
			Reflect.setProperty(newdata,key1,Reflect.getProperty(this.data,key1));
		}
		Reflect.setProperty(backdata,key,newdata);
	}
	,__class__: zygame_local_SaveDynamicDataContent
});
var zygame_local_SaveFloatData = {};
zygame_local_SaveFloatData._new = function(value) {
	if(value == null) {
		value = 0;
	}
	var this1 = new zygame_local_SaveFloatDataContent();
	this1.changed = true;
	this1.data = zygame_utils_CEFloat.fromFloat(value);
	return this1;
};
zygame_local_SaveFloatData.fromFloat = function(f) {
	var newValue = zygame_local_SaveFloatData._new(f);
	return newValue;
};
zygame_local_SaveFloatData.toFloat = function(this1) {
	return zygame_utils_CEFloat.toFloat(this1.data);
};
zygame_local_SaveFloatData.toDynamic = function(this1) {
	return this1.data;
};
zygame_local_SaveFloatData.add = function(this1,value) {
	return zygame_utils_CEFloat.add(this1.data,value);
};
zygame_local_SaveFloatData.jian = function(this1,value) {
	return zygame_utils_CEFloat.jian(this1.data,value);
};
zygame_local_SaveFloatData.jian2 = function(this1,value) {
	return zygame_utils_CEFloat.jian2(this1.data,value);
};
zygame_local_SaveFloatData.mul = function(this1,value) {
	return zygame_utils_CEFloat.mul(this1.data,value);
};
zygame_local_SaveFloatData.div = function(this1,value) {
	return zygame_utils_CEFloat.div(this1.data,value);
};
zygame_local_SaveFloatData.div2 = function(this1,value) {
	return zygame_utils_CEFloat.div2(this1.data,value);
};
zygame_local_SaveFloatData.pre = function(this1) {
	return zygame_utils_CEFloat.post(this1.data);
};
zygame_local_SaveFloatData.post = function(this1) {
	return zygame_utils_CEFloat.post(this1.data);
};
zygame_local_SaveFloatData.pre2 = function(this1) {
	return zygame_utils_CEFloat.post2(this1.data);
};
zygame_local_SaveFloatData.post2 = function(this1) {
	return zygame_utils_CEFloat.post2(this1.data);
};
zygame_local_SaveFloatData.dy = function(a,b) {
	return zygame_local_SaveFloatData.toFloat(a) > zygame_local_SaveFloatData.toFloat(b);
};
zygame_local_SaveFloatData.xy = function(a,b) {
	return zygame_local_SaveFloatData.toFloat(a) < zygame_local_SaveFloatData.toFloat(b);
};
zygame_local_SaveFloatData.dydy = function(a,b) {
	return zygame_local_SaveFloatData.toFloat(a) >= zygame_local_SaveFloatData.toFloat(b);
};
zygame_local_SaveFloatData.xydy = function(a,b) {
	return zygame_local_SaveFloatData.toFloat(a) <= zygame_local_SaveFloatData.toFloat(b);
};
zygame_local_SaveFloatData.xd = function(a,b) {
	return zygame_local_SaveFloatData.toFloat(a) == zygame_local_SaveFloatData.toFloat(b);
};
var zygame_local_SaveFloatDataContent = function() {
	this.data = zygame_utils_CEFloat.fromFloat(0);
	zygame_local_SaveDynamicDataBaseContent.call(this);
};
zygame_local_SaveFloatDataContent.__name__ = true;
zygame_local_SaveFloatDataContent.__super__ = zygame_local_SaveDynamicDataBaseContent;
zygame_local_SaveFloatDataContent.prototype = $extend(zygame_local_SaveDynamicDataBaseContent.prototype,{
	flush: function(key,changeData) {
		zygame_local_SaveDynamicDataBaseContent.prototype.flush.call(this,key,changeData);
		if(this.changed) {
			Reflect.setProperty(changeData,key,zygame_utils_CEFloat.toFloat(this.data));
			this.changed = false;
		}
	}
	,getData: function(key,data) {
		Reflect.setProperty(data,key,zygame_utils_CEFloat.toFloat(this.data));
	}
	,__class__: zygame_local_SaveFloatDataContent
});
var zygame_local_SaveObject = function(id) {
	this.data = null;
	this._isReadData = false;
	this._changedData = { };
	this._localSaveData = { };
	this._id = id;
};
zygame_local_SaveObject.__name__ = true;
zygame_local_SaveObject.prototype = {
	make_zygame_local_SaveObjectData: function(c) {
		this.data = Type.createInstance(c,[]);
		var storage = js_Browser.getLocalStorage();
		if(storage != null) {
			var keys = Reflect.fields(this.data);
			var _g = 0;
			while(_g < keys.length) {
				var k = keys[_g];
				++_g;
				var id = this._id + "." + k;
				var value = storage.getItem(id);
				if(value != null) {
					var current = Reflect.getProperty(this.data,k);
					if(((current) instanceof zygame_local_SaveArrayDataContent)) {
						var obj = JSON.parse(value);
						var keys1 = Reflect.fields(obj);
						var _g1 = 0;
						while(_g1 < keys1.length) {
							var k2 = keys1[_g1];
							++_g1;
							var v = Reflect.getProperty(obj,k2);
							if(this.data.ce.exists(k)) {
								var setValue = v;
								var cedata = current;
								cedata.setValue(Std.parseInt(k2),zygame_utils_CEFloat.fromFloat(setValue));
							} else {
								(js_Boot.__cast(current , zygame_local_SaveArrayDataContent)).setValue(Std.parseInt(k2),v);
							}
						}
					} else if(((current) instanceof zygame_local_SaveFloatDataContent)) {
						(js_Boot.__cast(current , zygame_local_SaveFloatDataContent)).data = zygame_utils_CEFloat.fromFloat(parseFloat(value));
					} else if(((current) instanceof zygame_local_SaveStringDataContent)) {
						haxe_Log.trace("value=",{ fileName : "zygame/local/SaveObject.hx", lineNumber : 72, className : "zygame.local.SaveObject", methodName : "make", customParams : [value]});
						(js_Boot.__cast(current , zygame_local_SaveStringDataContent)).data = value;
					} else if(((current) instanceof zygame_local_SaveDynamicDataContent)) {
						var obj1 = JSON.parse(value);
						var keys2 = Reflect.fields(obj1);
						var _g2 = 0;
						while(_g2 < keys2.length) {
							var k21 = keys2[_g2];
							++_g2;
							var v1 = Reflect.getProperty(obj1,k21);
							if(this.data.ce.exists(k)) {
								var setValue1 = v1;
								var cedata1 = current;
								cedata1.setValue(k21,zygame_utils_CEFloat.fromFloat(setValue1));
							} else {
								(js_Boot.__cast(current , zygame_local_SaveDynamicDataContent)).setValue(k21,v1);
							}
						}
					}
				}
			}
		}
		return this;
	}
	,async: function(cb) {
		this._cb = cb;
		this.flush();
		if(!this._isReadData) {
			if(this.saveAgent != null) {
				this.saveAgent.readData(function(data,err) {
					if(err == null) {
						haxe_Log.trace("用户数据读取成功：",{ fileName : "zygame/local/SaveObject.hx", lineNumber : 108, className : "zygame.local.SaveObject", methodName : "async", customParams : [data]});
					}
				});
			} else {
				this._cbFunc(true);
			}
		} else if(this.saveAgent != null) {
			this.saveAgent.saveData(this._changedData,$bind(this,this._onSaveData));
		} else {
			this._cbFunc(true);
		}
	}
	,_cbFunc: function(bool) {
		if(this._cb != null) {
			this._cb(bool);
			this._cb = null;
		}
	}
	,_onSaveData: function(data) {
		this._cbFunc(data != null);
	}
	,flush: function() {
		var changed = { };
		this.data.flush(changed);
		this._flush(changed,this._id);
		haxe_Log.trace("最后更改的数据：",{ fileName : "zygame/local/SaveObject.hx", lineNumber : 144, className : "zygame.local.SaveObject", methodName : "flush", customParams : [changed]});
	}
	,_flush: function(data,key) {
		var keys = Reflect.fields(data);
		if(keys.length == 0) {
			return;
		}
		var _g_current = 0;
		var _g_array = keys;
		while(_g_current < _g_array.length) {
			var _g1_value = _g_array[_g_current];
			var _g1_key = _g_current++;
			var index = _g1_key;
			var value = _g1_value;
			var v = Reflect.getProperty(data,value);
			this._setLocal(value,v);
		}
		haxe_Log.trace("应该上报到网络服务器的数据：",{ fileName : "zygame/local/SaveObject.hx", lineNumber : 160, className : "zygame.local.SaveObject", methodName : "_flush", customParams : [this._changedData]});
	}
	,_setLocal: function(key,value) {
		if(!(typeof(value) == "number" || typeof(value) == "string")) {
			var keys = Reflect.fields(value);
			var data = Reflect.getProperty(this._localSaveData,key);
			if(data == null) {
				data = { };
			}
			var changedData = Reflect.getProperty(this._changedData,key);
			if(changedData == null) {
				changedData = { };
			}
			var _g = 0;
			while(_g < keys.length) {
				var k = keys[_g];
				++_g;
				var v = Reflect.getProperty(value,k);
				Reflect.setProperty(data,k,v);
				Reflect.setProperty(changedData,k,v);
			}
			Reflect.setProperty(this._localSaveData,key,data);
			Reflect.setProperty(this._changedData,key,changedData);
		} else {
			Reflect.setProperty(this._localSaveData,key,value);
			Reflect.setProperty(this._changedData,key,value);
		}
		haxe_Log.trace("保存数据",{ fileName : "zygame/local/SaveObject.hx", lineNumber : 185, className : "zygame.local.SaveObject", methodName : "_setLocal", customParams : [key,value]});
		var storage = js_Browser.getLocalStorage();
		if(storage != null) {
			var saveid = this._id + "." + key;
			var v = Reflect.getProperty(this._localSaveData,key);
			if(typeof(v) == "number" || typeof(v) == "string") {
				storage.setItem(saveid,v);
			} else {
				storage.setItem(saveid,JSON.stringify(v));
			}
		}
	}
	,getData: function(data) {
		if(data == null) {
			data = { };
		}
		this.data.getData(data);
		return data;
	}
	,__class__: zygame_local_SaveObject
};
var zygame_local_SaveStringData = {};
zygame_local_SaveStringData._new = function(value) {
	var this1 = new zygame_local_SaveStringDataContent();
	this1.changed = true;
	this1.data = value;
	return this1;
};
zygame_local_SaveStringData.fromString = function(f) {
	var newValue = zygame_local_SaveStringData._new(f);
	return newValue;
};
zygame_local_SaveStringData.toString = function(this1) {
	return this1.data;
};
zygame_local_SaveStringData.toDynamic = function(this1) {
	return this1.data;
};
var zygame_local_SaveStringDataContent = function() {
	this.data = "";
	zygame_local_SaveDynamicDataBaseContent.call(this);
};
zygame_local_SaveStringDataContent.__name__ = true;
zygame_local_SaveStringDataContent.__super__ = zygame_local_SaveDynamicDataBaseContent;
zygame_local_SaveStringDataContent.prototype = $extend(zygame_local_SaveDynamicDataBaseContent.prototype,{
	flush: function(key,changeData) {
		zygame_local_SaveDynamicDataBaseContent.prototype.flush.call(this,key,changeData);
		if(this.changed) {
			Reflect.setProperty(changeData,key,this.data);
			this.changed = false;
		}
	}
	,getData: function(key,data) {
		Reflect.setProperty(data,key,this.data);
	}
	,__class__: zygame_local_SaveStringDataContent
});
var zygame_utils_CEFloat = {};
zygame_utils_CEFloat._new = function(value) {
	var this1 = new zygame_utils_CEData(value);
	return this1;
};
zygame_utils_CEFloat.fromFloat = function(s) {
	var this1 = new zygame_utils_CEData(s);
	return this1;
};
zygame_utils_CEFloat.fromString = function(s) {
	var this1 = new zygame_utils_CEData(parseFloat(s));
	return this1;
};
zygame_utils_CEFloat.toFloat = function(this1) {
	return this1.get_value();
};
zygame_utils_CEFloat.toInt = function(this1) {
	return this1.get_value() | 0;
};
zygame_utils_CEFloat.toString = function(this1) {
	return this1.toString();
};
zygame_utils_CEFloat.add = function(this1,value) {
	return this1.get_value() + value;
};
zygame_utils_CEFloat.jian = function(this1,value) {
	return this1.get_value() - value;
};
zygame_utils_CEFloat.jian2 = function(this1,value) {
	return value - this1.get_value();
};
zygame_utils_CEFloat.mul = function(this1,value) {
	return this1.get_value() * value;
};
zygame_utils_CEFloat.div = function(this1,value) {
	return this1.get_value() / value;
};
zygame_utils_CEFloat.div2 = function(this1,value) {
	return value / this1.get_value();
};
zygame_utils_CEFloat.pre = function(this1) {
	var lhs = this1.get_value();
	this1.set_value(lhs + 1);
	return lhs;
};
zygame_utils_CEFloat.post = function(this1) {
	var lhs = this1.get_value();
	this1.set_value(lhs + 1);
	return lhs;
};
zygame_utils_CEFloat.pre2 = function(this1) {
	var lhs = this1.get_value();
	this1.set_value(lhs - 1);
	return lhs;
};
zygame_utils_CEFloat.post2 = function(this1) {
	var lhs = this1.get_value();
	this1.set_value(lhs - 1);
	return lhs;
};
zygame_utils_CEFloat.dy = function(a,b) {
	return zygame_utils_CEFloat.toFloat(a) > zygame_utils_CEFloat.toFloat(b);
};
zygame_utils_CEFloat.xy = function(a,b) {
	return zygame_utils_CEFloat.toFloat(a) < zygame_utils_CEFloat.toFloat(b);
};
zygame_utils_CEFloat.dydy = function(a,b) {
	return zygame_utils_CEFloat.toFloat(a) >= zygame_utils_CEFloat.toFloat(b);
};
zygame_utils_CEFloat.xydy = function(a,b) {
	return zygame_utils_CEFloat.toFloat(a) <= zygame_utils_CEFloat.toFloat(b);
};
zygame_utils_CEFloat.xd = function(a,b) {
	return zygame_utils_CEFloat.toFloat(a) == zygame_utils_CEFloat.toFloat(b);
};
var zygame_utils_CEData = function(value) {
	this.values = [];
	this.sign = null;
	this.set_value(value);
};
zygame_utils_CEData.__name__ = true;
zygame_utils_CEData.prototype = {
	toString: function() {
		return Std.string(this.get_value());
	}
	,get_value: function() {
		if(this.sign != this.values.join("")) {
			throw haxe_Exception.thrown("游戏内存被修改");
		}
		return parseFloat(this.sign);
	}
	,set_value: function(value) {
		this.sign = value == null ? "null" : "" + value;
		this.values = this.sign.split("");
		return value;
	}
	,__class__: zygame_utils_CEData
	,__properties__: {set_value:"set_value",get_value:"get_value"}
};
var $_;
function $bind(o,m) { if( m == null ) return null; if( m.__id__ == null ) m.__id__ = $global.$haxeUID++; var f; if( o.hx__closures__ == null ) o.hx__closures__ = {}; else f = o.hx__closures__[m.__id__]; if( f == null ) { f = m.bind(o); o.hx__closures__[m.__id__] = f; } return f; }
$global.$haxeUID |= 0;
String.prototype.__class__ = String;
String.__name__ = true;
Array.__name__ = true;
Date.prototype.__class__ = Date;
Date.__name__ = "Date";
var Int = { };
var Dynamic = { };
var Float = Number;
var Bool = Boolean;
var Class = { };
var Enum = { };
js_Boot.__toStr = ({ }).toString;
Main.main();
})(typeof window != "undefined" ? window : typeof global != "undefined" ? global : typeof self != "undefined" ? self : this);
