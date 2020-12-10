package zygame.loader.parser;

#if zygame3d
import away3d.loaders.parsers.ParticleGroupParser;
import away3d.loaders.AssetLoader;
import away3d.events.Asset3DEvent;
import away3d.events.LoaderEvent;
import away3d.entities.ParticleGroup;
import away3d.library.assets.Asset3DType;
import openfl.net.URLRequest;
import away3d.loaders.misc.SingleFileLoader;
import away3d.cameras.lenses.OrthographicLens;
import away3d.controllers.HoverController;
import away3d.cameras.Camera3D;
#end

@:keep class SparticleParser extends ParserBase {
	public static function supportType(data:Dynamic):Bool {
		var bool = StringTools.endsWith(data, ".awp");
		if (bool) {
			#if !zygame3d
			throw "需要解析awp模块，需要使用zygameui-3d库";
			#else
			return true;
			#end
		}
		return false;
	}

	override function process() {
		#if zygame3d
		SingleFileLoader.enableParser(ParticleGroupParser);
		var loader:AssetLoader = new AssetLoader();
		loader.addEventListener(Asset3DEvent.ASSET_COMPLETE, onAnimation);
		loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onComplete);
		loader.addEventListener(LoaderEvent.LOAD_ERROR, (event) -> {
			sendError("无法加载" + getData() + " event:" + event);
		});
		loader.load(new URLRequest(getData()));
		#end
	}

	#if zygame3d
	private var particleGroup:Dynamic;

	private function onComplete(e):Void {
		this.finalAssets(SPARTICLE, particleGroup, 1);
	}

	private function onAnimation(e:Asset3DEvent):Void {
		if (e.asset.assetType == Asset3DType.CONTAINER && Std.is(e.asset, ParticleGroup)) {
			particleGroup = cast(e.asset, ParticleGroup);
		}
	}
	#end
}

#if zygame3d

/**
 * 用于兼容4399平台的prefab3D粒子文件解析
 */
 class Away3DSprticleParser extends away3d.loaders.parsers.ParticleGroupParser {
	public static var extName:String = "awp";
	public static function supportsType(extension:String):Bool {
		extension = extension.toLowerCase();
		return extension == extName;
	}
}

#end