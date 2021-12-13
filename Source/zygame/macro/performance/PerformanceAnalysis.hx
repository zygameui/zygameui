package zygame.macro.performance;

import haxe.Timer;

/**
 * 性能分析器
 */
@:expose
class PerformanceAnalysis {
	/**
	 * 耗时数据
	 */
	public static var data:Map<String, Map<String, AnalysisData>> = [];

	/**
	 * 时间分析器
	 */
	private static var analysisTimes:Map<String, Float> = [];

	/**
	 * 是否已经初始化完毕
	 */
	private static var inited:Bool = false;

	/**
	 * 输出分析数据
	 */
	public static function echo(pkg:String):Void {
		var maps = data.get(pkg);
		if (maps == null) {
			trace('没有${pkg}的分析数据');
			return;
		}
		var array:Array<{
			name:String,
			data:AnalysisData
		}> = [];
		for (key => value in maps) {
			array.push({
				name: key,
				data: value
			});
		}
		array.sort(function(a, b) {
			return a.data.totalTime > b.data.totalTime ? -1 : 1;
		});
		trace("关于" + pkg + "的分析数据:\n" + array);
	}

	/**
	 * 统计开始
	 * @param name 
	 */
	public static function analysisStart(name:String):Void {
		#if js
		if (inited == false) {
			inited = true;
			untyped window.PerformanceAnalysis = PerformanceAnalysis;
		}
		#end
		analysisTimes.set(name, Timer.stamp());
	}

	/**
	 * 统计耗时
	 * @param name 
	 * @param timeConsuming 
	 */
	public static function analysisEnd(name:String):Void {
		var now = Timer.stamp();
		var timeConsuming = now - analysisTimes.get(name);
		var className = name.substr(0, name.lastIndexOf("."));
		var funcName = name.substr(name.lastIndexOf(".") + 1);
		if (!data.exists(className)) {
			data.set(className, []);
		}
		var classed = data.get(className);
		var maps = classed.get(funcName);
		if (maps == null) {
			classed.set(funcName, {
				times: 1,
				totalTime: timeConsuming,
				average: timeConsuming
			});
		} else {
			maps.times++;
			maps.totalTime += timeConsuming;
			maps.average = (maps.totalTime / maps.times);
		}
	}
}

/**
 * 耗时数据
 */
typedef AnalysisData = {
	times:Int,
	totalTime:Float,
	average:Float
}
