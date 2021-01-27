package zygame.components;

import zygame.components.ZBox;
import zygame.components.ZScene;
import zygame.utils.ZSceneManager;

/**
 *  场景，用于管理不同的场景使用
 */
class ZScene extends ZBox
{

    public function new(){
        super();
    }

    /**
     *  当场景被创建后，重新createScene或者替换场景时，会进行调用场景重设，这时应该在这里进行重置数据。
     */
    public function onSceneReset():Void
    {
        
    }

    /**
     *  当场景释放时，请在这里精准释放所有额外内容。
     */
    public function onSceneRelease():Void
    {
        setFrameEvent(false);
        setTouchEvent(false);
    }

    /**
     *  创建场景
     *  @param cName - 
     *  @return ZScene
     */
    public function createScene(cName:Class<ZScene>):ZScene
    {
        return ZSceneManager.current.createScene(cName);
    }

    /**
     *  替换场景
     *  @param cName - 
     *  @return ZScene
     */
    public function replaceScene(cName:Class<ZScene>,isReleaseScene:Bool = false):ZScene
    {
        return ZSceneManager.current.replaceScene(cName,isReleaseScene);
    }

    #if flash
    override public function get_width():Float
    {
        return getStageWidth();
    }
    override public function get_height():Float
    {
        return getStageHeight();
    }
    #else
    override private function get_width():Float
    {
        return getStageWidth();
    }

    override private function get_height():Float
    {
        return getStageHeight();
    }
    #end

}