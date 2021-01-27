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
	/**
	 * 扩展Dynamic的set/get能力，可快捷建立反射设置关系
	 * @param ce 是否启动对Int/Float进行保护，如果设置为true，将会对数据进行保护。
	 * @return Array<Field>
	 */
	macro public static function build():Array<Field> {
		var array:Array<Field> = Context.getBuildFields();
		for (item in array) {
			var path = item.kind.getParameters()[0];
			if (path != null && item.access.indexOf(AStatic) == -1) {
				if (Std.is(path, ComplexType)) {
					var cname:ComplexType = path;
					if (cname != null && cname.getParameters() != null) {
						var className = cname.getParameters()[0];
						if (className != null) {
							if (className.name == "Dynamic") {
								// 动态类型
								var attrName = item.name;
								// 追加set/get方法
								var setValue = {
									name: "set" + item.name.charAt(0).toUpperCase() + item.name.substr(1) + "Value",
									meta: [],
									access: [APublic],
									kind: FFun({
										args: [{name: "name", type: macro:String}, {name: "value", type: macro:Dynamic}],
										ret: macro:Void,
										expr: macro {
											Reflect.setProperty(this.$attrName, name, value);
										}
									}),
									pos: Context.currentPos()
								};

								var getValue = {
									name: "get" + item.name.charAt(0).toUpperCase() + item.name.substr(1) + "Value",
									meta: [],
									access: [APublic],
									kind: FFun({
										args: [
											{name: "name", type: macro:String},
											{name: "defalutValue", opt: true, type: macro:Dynamic}
										],
										ret: macro:Dynamic,
										expr: macro {
											var data = Reflect.getProperty(this.$attrName, name);
											if (data == null)
												return defalutValue;
											return data;
										}
									}),
									pos: Context.currentPos()
								};
								array.push(setValue);
								array.push(getValue);
							} else {
								switch (className.name) {
									case "Int":
										// 针对Int做CE保护
										var m = Lambda.find(item.meta, m -> m.name == ":ce");
										if (m != null) {
											var myFunc:Function = {
												expr: macro return 1, // actual value
												ret: (macro:Int), // ret = return type
												args: [] // no arguments here
											};
											// 创建私有变量
											var privateValue = {
												name: "_" + item.name,
												meta: [],
												access: [APublic],
												kind: FieldType.FVar(macro:Dynamic),
												pos: Context.currentPos()
											}
											array.push(privateValue);
											// 将item更改为get/set
											item.kind = FieldType.FProp("get", "set", macro:Int);
											var attrName = privateValue.name;
											var getfunc = {
												name: "get_" + item.name,
												meta: [],
												access: [APrivate],
												kind: FFun({
													args: [],
													ret: macro:Int,
													expr: macro {
														return Std.int(zygame.utils.Lib.ceDecode(this.$attrName));
													}
												}),
												pos: Context.currentPos()
											};
											var setfunc = {
												name: "set_" + item.name,
												meta: [],
												access: [APrivate],
												kind: FFun({
													args: [{name: "value", type: macro:Int}],
													ret: macro:Int,
													expr: macro {
														this.$attrName = zygame.utils.Lib.ceEncode(value);
														return value;
													}
												}),
												pos: Context.currentPos()
											};
											array.push(getfunc);
											array.push(setfunc);
										}
								}
							}
						}
					}
				}
			}
		}
		return array;
	}
	#end
}
