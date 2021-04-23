package zygame.events;

class SoundChannelManagerEvent extends openfl.events.Event {
	/**
	 * 当发生停止背景音乐时
	 */
	public static inline var STOP_MUSIC:String = "pause";

	/**
	 * 当允许恢复背景音乐时
	 */
	public static inline var RESUME_MUSIC:String = "resume";
}
