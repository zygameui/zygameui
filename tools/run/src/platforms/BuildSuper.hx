package platforms;

class BuildSuper {

    public var dir:String;

    public var args:Array<String>;

    public var root:String = null;

    public function new(args:Array<String>,dir:String) {
        this.dir = dir;
        this.args = args;
    }
    
    public function run(cName:String):Void
    {

    }

    /**
     * Build命令执行完成的最后
     */
    public function buildAfter():Void
    {

    }

}