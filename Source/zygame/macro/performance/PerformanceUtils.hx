package zygame.macro.performance;

import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.Expr.ExprDef;
#if macro
import sys.io.File;
import zygame.utils.StringUtils;
import haxe.macro.Context;
import haxe.macro.Expr;
#end

/**
 * 性能分析工具
 */
#if performance_analysis
class PerformanceUtils {
	#if macro
	/**
	 * 分析性能，使用build方法可以对当前类的每个方法进行耗时平均统计
	 */
	macro public static function build():Array<Field> {
		var array = Context.getBuildFields();

		for (index => value in array) {
			switch (value.kind.getName()) {
				case "FFun":
					// 排除set / get / new
					if (value.name.indexOf("get_") != -1 || value.name.indexOf("set_") != -1)
						continue;
					var analysisName = Context.getLocalClass().toString() + "." + value.name;
					// 分析方法的性能
					var expr:Dynamic = value.kind.getParameters()[0];
					// trace("这是什么方法？", expr.ret);
					var exprDef:Dynamic = expr.expr;
					var block:Expr = exprDef;
					// 往第一行添加
					var array:Array<Dynamic> = block.expr.getParameters()[0];
					array.insert(0, macro zygame.macro.performance.PerformanceAnalysis.analysisStart($v{analysisName}));
					// 往有return的地方追加，如果没有return的情况下，在最后一行添加
					var isReturn = pushReturnAnalysis(analysisName, array, false, block.expr);
					// 结尾追加分析最终结果，如果没有返回值，默认追加统计
					if (!isReturn || expr.ret == null)
						array.push(macro zygame.macro.performance.PerformanceAnalysis.analysisEnd($v{analysisName}));
			}
		}
		return array;
	}

	public static function pushReturnAnalysis(analysisName:String, array:Array<Dynamic>, lastReturn:Bool, parentExpr:ExprDef):Bool {
		var isReturn = lastReturn;
		var maxLen = array.length;
		while (maxLen > 0) {
			maxLen--;
			var line:Dynamic = array[maxLen];
			if (Std.isOfType(line, Array)) {
				// 自身是个Array
				isReturn = pushReturnAnalysis(analysisName, line, isReturn, parentExpr);
				continue;
			}
			var lineExpr:ExprDef = line.expr;
			if (lineExpr == null)
				continue;
			if (line.expr.expr != null)
				lineExpr = line.expr.expr;
			switch (lineExpr.getName()) {
				case "EReturn":
					isReturn = true;
					switch (parentExpr.getName()) {
						case "EIf":
							// 如果上一级是EIf，则需要使用EBlock包含
							var block = EBlock([
								macro zygame.macro.performance.PerformanceAnalysis.analysisEnd($v{analysisName}),
								line
							]);
							var lineIndex = array.indexOf(line);
							array[lineIndex] = {
								pos: Context.currentPos(),
								expr: block
							};
							continue;
					}
					array.insert(maxLen, macro zygame.macro.performance.PerformanceAnalysis.analysisEnd($v{analysisName}));
				default:
					isReturn = pushReturnAnalysis(analysisName, lineExpr.getParameters(), isReturn, lineExpr);
			}
		}
		return isReturn;
	}
	#end
}
#end
