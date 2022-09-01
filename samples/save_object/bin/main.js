(function ($global) { "use strict";
var Main = function() { };
Main.__name__ = true;
Main.main = function() {
	var obj = zygame_local_SaveObject.getLocal("test");
	zygame_local_SaveDynamicData.fieldWrite(obj.data,"data",0);
};
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
var Std = function() { };
Std.__name__ = true;
Std.string = function(s) {
	return js_Boot.__string_rec(s,"");
};
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
var haxe_ds_StringMap = function() {
	this.h = Object.create(null);
};
haxe_ds_StringMap.__name__ = true;
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
};
var js_Boot = function() { };
js_Boot.__name__ = true;
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
var zygame_local_SaveDynamicData = {};
zygame_local_SaveDynamicData._new = function() {
	var this1 = zygame_local_SaveDynamicData._new();
	return this1;
};
zygame_local_SaveDynamicData.fieldRead = function(this1,name) {
	return this1.getValue(name);
};
zygame_local_SaveDynamicData.fieldWrite = function(this1,name,value) {
	return this1.setValue(name,value);
};
var zygame_local_SaveDynamicDataContent = function() {
	this.data = { };
	this.changed = true;
};
zygame_local_SaveDynamicDataContent.__name__ = true;
zygame_local_SaveDynamicDataContent.prototype = {
	getValue: function(key) {
		return Reflect.getProperty(this.data,key);
	}
	,setValue: function(key,value) {
		haxe_Log.trace("设置",{ fileName : "zygame/local/SaveDynamicData.hx", lineNumber : 39, className : "zygame.local.SaveDynamicDataContent", methodName : "setValue", customParams : [key,value]});
		this.changed = true;
		Reflect.setProperty(this.data,key,value);
		return value;
	}
};
var zygame_local_SaveObject = function(id) {
	this.data = { };
	this._id = id;
};
zygame_local_SaveObject.__name__ = true;
zygame_local_SaveObject.getLocal = function(id) {
	if(!Object.prototype.hasOwnProperty.call(zygame_local_SaveObject.__saveObjects.h,id)) {
		var this1 = zygame_local_SaveObject.__saveObjects;
		var value = new zygame_local_SaveObject(id);
		this1.h[id] = value;
	}
	return zygame_local_SaveObject.__saveObjects.h[id];
};
String.__name__ = true;
Array.__name__ = true;
js_Boot.__toStr = ({ }).toString;
zygame_local_SaveObject.__saveObjects = new haxe_ds_StringMap();
Main.main();
})({});
