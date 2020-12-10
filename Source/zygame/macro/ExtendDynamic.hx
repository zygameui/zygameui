package zygame.macro;

#if macro
import haxe.Json;
import haxe.macro.Context;
import haxe.macro.Expr;
#end

/**
 * 扩展Dynamic的set/get能力，可快捷建立反射设置关系
 */
class ExtendDynamic {
	#if macro
	macro public static function build():Array<Field> {
		var array:Array<Field> = Context.getBuildFields();
		for (item in array) {
			var path = item.kind.getParameters()[0];
			if (path != null && item.access.indexOf(AStatic) == -1) {
				if (Std.is(path, ComplexType)) {
					var cname:ComplexType = path;
					if (cname != null && cname.getParameters() != null) {
						var className = cname.getParameters()[0];
						if (className != null && className.name == "Dynamic") {
							// 动态类型
                            var attrName = item.name;
                            // 追加set/get方法
                            var setValue = {
								name: "set" + item.name.charAt(0).toUpperCase() + item.name.substr(1) + "Value",
								meta: [],
								access: [APublic],
								kind: FFun({
									args: [{name: "name", type: macro:String},{name:"value", type:macro:Dynamic}],
									ret: macro:Void,
									expr: macro {
										Reflect.setProperty(this.$attrName,name,value);
									}
								}),
								pos: Context.currentPos()
                            };
                            
                            var getValue = {
								name: "get" + item.name.charAt(0).toUpperCase() + item.name.substr(1) + "Value",
								meta: [],
								access: [APublic],
								kind: FFun({
									args: [{name: "name", type: macro:String},{name:"defalutValue",opt:true, type:macro:Dynamic}],
									ret: macro:Dynamic,
									expr: macro {
                                        var data = Reflect.getProperty(this.$attrName,name);
                                        if(data == null)
                                            return defalutValue;
                                        return data;
									}
								}),
								pos: Context.currentPos()
                            };
                            array.push(setValue);
                            array.push(getValue);
						}
					}
				}
			}
		}
		return array;
	}
	#end
}
