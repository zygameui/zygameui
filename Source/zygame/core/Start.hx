package zygame.core;

import zygame.utils.CullingRenderUtils;
import lime.graphics.RenderContext;
import haxe.Timer;
import openfl.display.OpenGLRenderer;
import openfl.events.RenderEvent;
import openfl.events.UncaughtErrorEvent;
#if cmnt
import zygame.cmnt.GameUtils;
#end
import zygame.display.Image;
import zygame.utils.FPSUtil;
import zygame.media.SoundChannelManager;
import zygame.utils.Lib;
import haxe.Json;
import zygame.utils.SpineManager;
import openfl.display.DisplayObject;
import openfl.display.BitmapData;
import zygame.display.DisplayObjectContainer;
import zygame.utils.FPSDebug;
import openfl.Vector;
import openfl.events.Event;
import zygame.components.ZScene;
import zygame.utils.Log;
import zygame.utils.SoundUtils;
import zygame.components.ZQuad;
import zygame.components.ZBuilder;
import zygame.macro.ZMacroUtils;
import openfl.events.MouseEvent;
import zygame.components.ZLabel;
#if (builddoc || vscode)
import zygame.core.ImportAll;
#end

/**
 * 引擎核心类，请继承这个作为启动类
 */
@:access(lime.ui.Window)
#if !disable_res
@:build(zygame.macro.Res.init())
#end
class Start extends ZScene {
	#if vscode
	public static function main() {};
	#end

	/**
	 * 动态FPS，如果开启动态FPS，在CPU超过负荷的情况下，会自动调为低频渲染，但主帧逻辑仍然使用60FPS运行，默认为true
	 */
	public var dynamicFps:Bool = #if disable_dynamic_fps false #else true #end;

	/**
	 * 焦点对象
	 */
	public static var focus:DisplayObject;

	/**
	 * 应用是否处于活动状态，当离开页面时，该属性会返回false。
	 */
	public static var isActivate:Bool = true;

	/**
	 * 纹理数量
	 */
	public static var TEXTURE_COUNT:Int = 0;

	/**
	 * 当前Start启动器的引用
	 */
	public static var current:Start;

	/**
	 * 设定的舞台的宽度
	 */
	public static var stageWidth:Int = 0;

	/**
	 * 设定的舞台的高度
	 */
	public static var stageHeight:Int = 0;

	/**
	 * 当前舞台与实际设备尺寸的像素比例
	 */
	public static var currentScale:Float;

	/**
	 * 指定的适配高度
	 */
	public var HDHeight:Int = 0;

	/**
	 * 指定的适配宽度
	 */
	public var HDWidth:Int = 0;

	/**
	 * 是否为Debug模式
	 */
	public var isDebug:Bool = false;

	/**
	 * 更新列表，每次onFrame被调用时，都会进行调用
	 */
	private var updates:Vector<Refresher>;

	/**
	 * FPS60锁着计算
	 */
	private var fps60:FPSUtil = new FPSUtil(61);

	/**
	 * FPS以及内存显示器，请在super(0,0,true)第三个参数设置为true时设置为生效，否则fps将会为null。
	 */
	public var fps:FPSDebug;

	/**
	 * 层级渲染对象，默认会有1个topView的层级渲染对象
	 */
	public var screens:Array<Screen> = [new Screen()];

	/**
	 * 最顶层显示，该窗口会根据缩放比例进行适配，能够与实际游戏内容的坐标匹配。
	 */
	public var topView(get, never):Screen;

	private function get_topView():Screen {
		return screens[0];
	}

	/**
	 * 添加一层顶层显示
	 * @param screen 
	 */
	public function addScreen(screen:Screen):Void {
		screens.push(screen);
		this.updateScreens();
	}

	#if ios_render_fix
	/**
	 * IOS渲染器修复
	 */
	public var iosRender:ZQuad;
	#end
	/**
	 * 更新状态队列
	 */
	private var updateStatsList:Array<UpdateStats> = [];

	private var isFrameing:Bool = false;

	/**
	 * 是否锁定横版，如果是竖版显示时，也会锁定横版
	 */
	private var _lockLandscape:Bool = false;

	/**
	 * 测试性功能，使缩放永远为0.5作为间隔缩放。
	 */
	private var scalePower:Bool = false;

	/**
	 * 时间戳
	 */
	private var _lastTime:Float = 0;
	private var _dt:Float = 0;
	private var _cpuDt:Float = 0;

	/**
	 * 启动一个启动器，用于启动进入游戏入口。
	 *  @param HDWidth - 以宽适配时使用的宽度像素
	 *  @param HDHeight - 以高适配时使用的高度像素
	 *  @param isDebug - 是否显示debug数据，当该值为true时，FPSDebug对象将会建立，一般在发布正式版时，该值应该被设置为false。
	 *  @param scalePower - 测试性功能，使缩放永远为0.5作为间隔缩放。
	 */
	public function new(HDWidth:Int = 800, HDHeight:Int = 480, isDebug:Bool = false, scalePower:Bool = false) {
		super();
		this.scalePower = scalePower;
		// RES资源绑定
		zygame.net.UDP.init();
		ZBuilder.init();
		Log.clear();
		this.HDHeight = HDHeight;
		this.HDWidth = HDWidth;
		this.isDebug = isDebug;
		updates = new Vector<Refresher>();
		Start.current = this;
		log("[zygameui] build time:", ZMacroUtils.buildDateTime());
		log("[zygameui] channel=" + Lib.getChannel() + " render=" + Lib.getRenderMode());

		#if cmnt
		// 默认优先初始化用户数据信息
		zygame.cmnt.Cmnt.initUserData();
		#end

		#if minigame
		// 小游戏的文本输入初始化入口
		zygame.core.KeyboardManager.init();
		#end

		// ZBuilder定义宏自动处理
		var defines:Dynamic = Json.parse(ZMacroUtils.getDefines());
		log(defines);
		var keys:Array<String> = Reflect.fields(defines);
		for (key in keys) {
			ZBuilder.defineValue(key, Reflect.getProperty(defines, key));
		}

		// GL纹理计算
		#if html5
		if (this.stage.application.window.context.webgl != null) {
			var createTextureCall:Dynamic = this.stage.application.window.context.webgl.createTexture;
			untyped this.stage.application.window.context.webgl.createTexture = function():Dynamic {
				TEXTURE_COUNT++;
				return createTextureCall();
			}
			var deleteTextureCall:Dynamic = this.stage.application.window.context.webgl.deleteTexture;
			untyped this.stage.application.window.context.webgl.deleteTexture = function(texture:Dynamic):Void {
				TEXTURE_COUNT--;
				deleteTextureCall(texture);
			}
		}
		untyped window.URL2 = untyped window.URL;
		untyped window.Blob2 = untyped window.Blob;
		if (untyped window.URL == null) {
			untyped window.URL = {
				createObjectURL: function(file:Dynamic):String {
					return null;
				}
			};
		} else {
			untyped window.URL.createObjectURL = function(file:Dynamic):String {
				return null;
			};
		}
		untyped window.Blob = function() {};
		// 优化储存可能会丢失的问题
		if (untyped window.localStorage != null)
			untyped window.localStorage.removeItem = function() {};
		#end
		this.updateScreens();
		this.onStageSizeChange();
	}

	/**
	 * 更新屏幕列表
	 */
	private function updateScreens():Void {
		for (screen in screens) {
			stage.addChild(screen);
		}
	}

	/**
	 * 锁定横版模式
	 */
	public function lockLandscape():Void {
		this._lockLandscape = true;
	}

	private function superInitEvent(e:Event):Void {
		super.onInitEvent(e);
		trace("[zygameui stage size]", "width:", this.getStageWidth(), "height:", this.getStageHeight());
	}

	/**
	 * 渲染事件
	 * @param e
	 */
	public function onRender(e:RenderEvent):Void {
		Lib.onRender();
	}

	/**
	 * 初始化时机控制，确保ZQuad可用
	 * @param e
	 */
	override public function onInitEvent(e:Event):Void {
		#if !api
		if (ZQuad.quadBitmapData == null) {
			#if (mgc || base64quad)
			var px1base64:String = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAMAAAAoyzS7AAAAA1BMVEUAAACnej3aAAAACklEQVQYlWNgAAAAAgABNesWWgAAAABJRU5ErkJggg==";
			BitmapData.loadFromBase64(px1base64, "image/png").onComplete((bitmapData:BitmapData) -> {
				ZQuad.quadBitmapData = bitmapData;
				superInitEvent(e);
			});
			#elseif qqquick
			ZQuad.quadBitmapData = new BitmapData(1, 1, false, 0xffffff);
			superInitEvent(e);
			#else
			ZQuad.quadBitmapData = new BitmapData(1, 1, false, 0xffffff);
			superInitEvent(e);
			#end
		} else {
			superInitEvent(e);
		}
		#end
		#if ios_render_fix
		iosRender = new ZQuad();
		#end
	}

	/**
	 * 3D渲染对象，它永远会比我们的2D画面要置低。
	 */
	public var view3d:#if zygame3d away3d.containers.View3D #else Dynamic #end;

	/**
	 * 启动3D引擎渲染
	 */
	public function super3d(pclass:Class<Dynamic>):Void {
		#if zygame3d
		view3d = new away3d.containers.View3D();
		var start:Start3D = cast Type.createInstance(pclass, [view3d]);
		this.addChildAt(view3d, 0);
		view3d.scene = start;
		start.onInit();
		#else
		throw "请引入zygameui-3d库，才能使用super3d方法。";
		#end
	}

	private var _update:Int = 0;

	private function onGameRender(context:RenderContext):Void {
		var newTime = Timer.stamp();
		_dt = Std.int((newTime - _lastTime) * 1000);
		_lastTime = newTime;

		#if !disable_dynamic_fps
		if (!dynamicFps || _dt < 20 || _update >= 2) {
		#else
		if (true) {
		#end
			_update = 0;
			// 剔除
			// CullingRenderUtils.culling(stage);
			@:privateAccess stage.__onLimeRender(context);
		} else {
			_update++;
			@:privateAccess stage.__broadcastEvent(new Event(Event.ENTER_FRAME));
			@:privateAccess stage.__broadcastEvent(new Event(Event.FRAME_CONSTRUCTED));
			@:privateAccess stage.__broadcastEvent(new Event(Event.EXIT_FRAME));
		}

		var cpu = Timer.stamp();
		_cpuDt = Std.int((cpu - newTime) * 1000);
	}

	override public function onInit():Void {
		stage.window.onRender.remove(@:privateAccess stage.__onLimeRender);
		stage.window.onRender.add(onGameRender);

		stage.frameRate = 60;
		SpineManager.init(stage);

		fps = new FPSDebug();
		topView.addChild(fps);
		fps.visible = this.isDebug;

		// 默认最高质量
		stage.quality = openfl.display.StageQuality.HIGH;

		// 唯一帧刷新事件
		_lastTime = Timer.stamp();
		this.addEventListener(Event.ENTER_FRAME, onFrameEvent);
		stage.addEventListener(Event.RESIZE, onResize);
		stage.addEventListener(MouseEvent.CLICK, onStageMouseClick);
		stage.addEventListener(RenderEvent.RENDER_CAIRO, onRender);
		stage.addEventListener(RenderEvent.RENDER_OPENGL, onRender);
		stage.addEventListener(RenderEvent.RENDER_CANVAS, onRender);
		#if html5
		// bate测试
		// OPPO侦听无法正常使用onBlur以及onFocue
		if (untyped document.addEventListener != null) {
			untyped document.addEventListener('visibilitychange', function() {
				var isHidden = untyped document.hidden;
				if (isHidden) {
					onDeActivate(null);
				} else {
					onActivate(null);
				}
			});
		}
		#end
		stage.addEventListener(Event.ACTIVATE, onActivate);
		stage.addEventListener(Event.DEACTIVATE, onDeActivate);

		// 异常错误过滤
		// openfl.Lib.current.loaderInfo.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,function(event){
		// 	event.preventDefault();
		// 	trace("发生异常错误：",event.toString());
		// });
	}

	public function onStageMouseClick(e:MouseEvent):Void {
		var oldfocus = focus;
		focus = cast e.target;
		if (oldfocus == focus)
			return;
		if (Std.isOfType(oldfocus, ZLabel)) {
			var oldlabel = cast(oldfocus, ZLabel);
			// 隐藏光标
			@:privateAccess oldlabel.setSelectQuadVisible(false);
		}
	}

	public function onDeActivate(e:Event):Void {
		isActivate = false;
		trace("返回至后台");
		SoundChannelManager.current.stopAllEffectAndMusic(true);
	}

	public function onActivate(e:Event):Void {
		isActivate = true;
		trace("返回至前台");
		zygame.utils.Lib.onResume();
		#if qqquick
		#else
		SoundChannelManager.current.resumeMusic();
		#end
	}

	public function onStageSizeChange():Void {
		if (HDWidth == 0 && HDHeight == 0) {
			Start.stageWidth = Std.int(stage.stageWidth / this.scaleX) + 1;
			Start.stageHeight = Std.int(stage.stageHeight / this.scaleY) + 1;
			topView.x = stage.stageWidth;
			onSceneSizeChange();
			return;
		}
		var wscale:Float = 1;
		var hscale:Float = 1;
		if (_lockLandscape && stage.stageWidth < stage.stageHeight) {
			hscale = Math.round(stage.stageWidth / this.HDHeight * 1000000) / 1000000;
			wscale = Math.round(stage.stageHeight / this.HDWidth * 1000000) / 1000000;
		} else {
			wscale = Math.round(stage.stageWidth / this.HDWidth * 1000000) / 1000000;
			hscale = Math.round(stage.stageHeight / this.HDHeight * 1000000) / 1000000;
		}

		if (wscale < hscale) {
			currentScale = wscale;
		} else {
			currentScale = hscale;
		}

		if (scalePower) {
			var currentScale3 = Std.int(currentScale);
			if (currentScale != currentScale3) {
				currentScale = currentScale3 + 1;
			}
			if (currentScale < 1) {
				currentScale = 1;
			}
		}

		this.scaleX = currentScale;
		this.scaleY = currentScale;

		// topView比例同步
		topView.scaleX = this.scaleX;
		topView.scaleY = this.scaleY;

		#if html5
		js.Syntax.code("window.currentScale=zygame_core_Start.currentScale");
		#end

		log("适配结果：", wscale, hscale);

		Start.stageWidth = Std.int(stage.stageWidth / this.scaleX) + 1;
		Start.stageHeight = Std.int(stage.stageHeight / this.scaleY) + 1;
		this.rotation = 0;
		topView.rotation = 0;
		this.x = 0;
		this.topView.x = 0;
		if (_lockLandscape && Start.stageWidth < Start.stageHeight) {
			// 锁定横版
			Start.stageWidth = Std.int(stage.stageHeight / this.scaleY) + 1;
			Start.stageHeight = Std.int(stage.stageWidth / this.scaleX) + 1;
			this.rotation = 90;
			this.x = stage.stageWidth;
			topView.rotation = 90;
			topView.x = stage.stageWidth;
		}
		onSceneSizeChange();
		if (view3d != null) {
			view3d.width = Start.stageWidth;
			view3d.height = Start.stageHeight;
		}

		log("适配" + HDHeight + "x" + HDWidth, stage.stageHeight + "x" + stage.stageWidth, currentScale);
	}

	public function onSceneSizeChange():Void {
		for (i in 0...this.numChildren) {
			if (Std.isOfType(this.getChildAt(i), ZScene)) {
				var scene:ZScene = cast this.getChildAt(i);
				if (scene != null)
					scene.updateComponents();
			}
		}
		for (screen in screens) {
			if (screen != topView && !screen.igoneChange) {
				screen.x = topView.x;
				screen.y = topView.y;
				screen.scaleX = topView.scaleX;
				screen.scaleY = topView.scaleY;
				screen.rotation = topView.rotation;
			}
		}
	}

	private function onResize(e:Event):Void {
		this.onStageSizeChange();
	}

	/**
	 * 获取帧侦听数量
	 * @return Int
	 */
	public function getUpdateLength():Int {
		return updates.length;
	}

	/**
	 * 获取每帧间隔时间
	 * @return Float
	 */
	public function getIntervalTime():Float {
		return _dt;
	}

	/**
	 * 获取CPU运行时间
	 * @return Float
	 */
	public function getCPUTime():Float {
		return _cpuDt;
	}

	/**
	 * 帧事件
	 * @param e
	 */
	private function onFrameEvent(e:Event):Void {
		if (fps.visible)
			topView.addChild(fps);
		#if (ios_render_fix)
		if (iosRender != null) {
			stage.addChild(iosRender);
			iosRender.scale(topView.scaleX);
			iosRender.width = getStageWidth();
			iosRender.height = getStageHeight();
			iosRender.alpha = 0.0001;
			iosRender.mouseEnabled = false;
		}
		#end
		#if (invalidate || hl)
		this.invalidate();
		#end
		if (fps.getFps() < 61 || fps60.update()) {
			this.onFrame();
			isFrameing = true;
			for (i in 0...updates.length) {
				updates[i].onFrame();
			}
			isFrameing = false;
			for (i in 0...updateStatsList.length) {
				if (updateStatsList[i].action == 0)
					addToUpdate(updateStatsList[i].display);
				else
					removeToUpdate(updateStatsList[i].display);
			}
			if (updateStatsList.length > 0)
				updateStatsList = [];
			// GC处理
			zygame.utils.ZGC.onFrame();
			// 计时器处理
			zygame.utils.Lib.onFrame();
			// 3D渲染
			#if zygame3d
			if (zygame.core.Start3D.current != null)
				zygame.core.Start3D.current.onRender();
			#end
		}
	}

	/**
	 *  添加对象到帧事件
	 *  @param display -
	 */
	public function addToUpdate(display:Refresher):Void {
		if (isFrameing)
			this.updateStatsList.push(new UpdateStats(display, 0));
		else if (this.updates.indexOf(display) == -1)
			this.updates.push(display);
	}

	/**
	 *  将对象从帧事件移除
	 *  @param display -
	 */
	public function removeToUpdate(display:Refresher):Void {
		if (isFrameing)
			this.updateStatsList.push(new UpdateStats(display, 1));
		else {
			var index:Int = this.updates.indexOf(display);
			if (index != -1)
				this.updates.removeAt(index);
		}
	}

	/**
	 * 重写onFrame
	 */
	override public function onFrame():Void {}
}
class UpdateStats {
	/**
	 * 处理对象
	 */
	public var display:Refresher;

	/**
	 * 0为添加，1为移除
	 */
	public var action:Int = 0;

	public function new(display:Refresher, action:Int) {
		this.display = display;
		this.action = action;
	}
}
