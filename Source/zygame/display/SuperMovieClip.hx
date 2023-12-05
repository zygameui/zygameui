package zygame.display;

import openfl.display.DisplayObject;
import openfl.display.MovieClip;

/**
 * 超级MovieClip
 * 使用方法：
 * var mc:SuperMovieClicp = oldMc;
 * mc.ball.y = 30;
 */
@:forward
abstract SuperMovieClip(MovieClip) to MovieClip from MovieClip {
	@:op(a.b) public function read(key:String):DisplayObject {
		return this.getChildByName(key);
	}
}
