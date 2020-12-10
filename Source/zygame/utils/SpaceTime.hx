package zygame.utils;

/**
 * 间隔时间操作
 */
class SpaceTime  {

    private var _time:Float;

    private var _now:Float = 0;

    /**
     * 新建一个间隔时间器
     * @param time 间隔多长时间可执行，单位毫秒
     */
    public function new(time:Float) {
        _time = time;
    }

    /**
     * 触发yes的时候，则意味着间隔时间已足够
     * @return Bool
     */
    public function yes():Bool{
        var nowtime = Date.now().getTime();
        if(nowtime - _now > _time)
        {
            _now = nowtime;
            return true;
        }
        return false;
    }

}