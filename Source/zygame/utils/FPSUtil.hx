package zygame.utils;


/**
 * 当某个enterframe事件 需要用特定的帧率 而不是stage的帧率可以使用这个工具跳帧
 * 特殊处理过，可用于帧同步计算
 * @author zmliu
 * 
 */
class FPSUtil
{
    public var fps(get, set) : Int;

    
    private var _fps : Int;
    private var _fpsTime : Float;
    private var _currentTime : Float;
    private var _lastFrameTimestamp : Float;
    
    private var _pause : Bool = false;
    
    public function new(fps : Int)
    {
        this.fps = fps;
    }
    
    private function get_fps() : Int
    {
        return _fps;
    }
    
    private function set_fps(value : Int) : Int
    {
        _fps = value;
        _fpsTime = 1000 / _fps * 0.001;
        _currentTime = 0;
        _lastFrameTimestamp = Math.round(haxe.Timer.stamp() * 1000) / 1000;
        return value;
    }
    
    public function update() : Bool
    {
        if (_pause)
        {
            return false;
        }
        
        var now : Float = Math.round(haxe.Timer.stamp() * 1000) / 1000.0;
        var passedTime : Float = now - _lastFrameTimestamp;
        _lastFrameTimestamp = now;
        
        _currentTime += passedTime;
        if (_currentTime >= _fpsTime)
        {
            // _currentTime -= _fpsTime;
            // if (_currentTime > _fpsTime)
            // {
            //     _currentTime = 0;
            // }
            _currentTime %= _fpsTime;
            return true;
        }
        return false;
    }
    
    public function pause() : Void
    {
        _pause = true;
    }
    
    public function resume() : Void
    {
        _pause = false;
    }
}
