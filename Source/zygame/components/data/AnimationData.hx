package zygame.components.data;

import zygame.utils.FPSUtil;

/**
 *  动画数据，用于ZAnimation提供渲染数据
 */
class AnimationData {

    /**
     *  帧列表
     */
    public var frames:Array<FrameData>;

    /**
     *  帧率计算
     */
    public var fps:FPSUtil;

    private var _frame:Int;

    public function new(curfps:Int){
        frames = [];
        fps = new FPSUtil(curfps);
        _frame = 0;
    }

    /**
     *  检测是否可以更新，如果返回true时，则可以刷新图
     *  @return Bool
     */
    public function update():Bool
    {
        return fps.update();
    }

    /**
     *  获取当前帧数据
     *  @param frame - 
     *  @return FrameData
     */
    public function getFrame(frame:Int):FrameData
    {
        if(frame < frames.length)
            return frames[frame];
        return null;
    }

    /**
     *  添加帧动画
     *  @param bitmapData - 位图
     *  @param delayFrame - 延迟多少帧
     */
    public function addFrame(bitmapData:Dynamic,delayFrame:Int = 0,call:Void->Void = null):Void
    {
        var frameData:FrameData = new FrameData(bitmapData,delayFrame);
        frames.push(frameData);
        if(call != null)
            frameData.call = call;
    }

    /**
     *  批量添加帧动画
     *  @param arr - 
     */
    public function addFrames(arr:Array<Dynamic>):Void
    {
        for(i in 0...arr.length)
            addFrame(arr[i]);
    }

    /**
     *  设置指定帧的间隔时长
     *  @param frame - 
     *  @param delayFrame - 
     */
    public function setFrameDelay(frame:Int,delayFrame:Int):Void
    {
        frames[frame].delayFrame = delayFrame;
    }

    /**
     *  设置回调处理
     *  @param frame - 
     *  @param call - 
     */
    public function setFrameCall(frame:Int,call:Void->Void):Void
    {
        frames[frame].call = call;
    }

}

class FrameData {

    /**
     *  该帧的显示内容
     */
    public var bitmapData:Dynamic;

    /**
     *  延迟帧
     */
    public var delayFrame:Int;

    /**
     *  帧回调事件
     */
    public var call:Void->Void;

    public function new(bitmapData:Dynamic,delayFrame:Int)
    {
        this.bitmapData = bitmapData;
        this.delayFrame = delayFrame;
    }

    /**
     *  尝试回调
     */
    public function tryCall():Void
    {
        if(call != null)
            call();
    }

}