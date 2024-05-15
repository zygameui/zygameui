package zygame.media.base;

import openfl.events.IEventDispatcher;
#if extsound
interface SoundChannel extends IEventDispatcher {
	public function stop():Void;

	/**
		The SoundTransform object assigned to the sound channel. A SoundTransform
		object includes properties for setting volume, panning, left speaker
		assignment, and right speaker assignment.
	**/
	public var soundTransform(get, set):openfl.media.SoundTransform;
}
#else
typedef SoundChannel = openfl.media.SoundChannel;
#end
