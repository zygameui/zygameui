package platforms;

import python.FileUtils;

class Facebook extends BuildSuper {
    
    public function new(args:Array<String>, dir:String) {
		super(args, dir);
        FileUtils.copyDic(Sys.getCwd() + "Export/html5/bin", dir);
	}

}