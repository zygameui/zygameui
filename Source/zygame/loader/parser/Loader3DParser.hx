package zygame.loader.parser;

@:keep class Loader3DParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		return true;
	}

	override function process() {
		#if zygame3d
        var loader = new zygame.utils.load.Loader3DData(getData());
        loader.load(function(data){
            this.finalAssets(OBJ3D,data,1);
        },sendError);
		#else
		throw "使用3D资源需要引入zygameui-3d库";
        #end
	}
}
