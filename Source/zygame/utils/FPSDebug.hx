package zygame.utils;

import zygame.components.ZBox;
import zygame.components.ZQuad;
import zygame.core.Start;
import haxe.Timer;
import openfl.events.Event;
import openfl.system.System;
import zygame.components.ZBitmapLabel;
import openfl.display.Sprite;
import openfl.Assets;
import openfl.display.BitmapData;
import zygame.utils.load.FntLoader;
import zygame.utils.AssetsUtils;
#if gl_stats
#if (openfl < '9.0.0')
import openfl._internal.renderer.context3D.stats.Context3DStats;
import openfl._internal.renderer.context3D.stats.DrawCallContext;
#else
import openfl.display._internal.stats.Context3DStats;
import openfl.display._internal.stats.DrawCallContext;
#end
#end
class FPSDebug extends ZBox {
	public static var fnt:FntData;

	public static var debugMsg:Dynamic = null;

	private var times:Array<Float>;
	private var memPeak:Float = 0;
	private var _text:ZBitmapLabel;
	private var _qqfps:Int = 0;
	private var _curDrawCall:Int = 0;

	public function new(inX:Float = 0.0, inY:Float = 0.0, inCol:Int = 0xffffff) {
		super();

		times = [];

		BitmapData.loadFromBase64(FPSAssets.assets, "image/png").onComplete(function(bitmapData:BitmapData):Void {
			fnt = new FntData(bitmapData, Xml.parse(FPSAssets.fnt), null);
			_text = new ZBitmapLabel(fnt);
			_text.x = inX;
			this.y = inY;
			_text.width = 120;
			_text.height = 150;
			_text.vAlign = "top";
			var bg = new ZQuad();
			this.addChild(bg);
			bg.width = _text.width;
			bg.height = _text.height;
			bg.alpha = 0.85;
			this.addChild(_text);

			this.mouseChildren = true;
			this.mouseEnabled = false;
			bg.mouseEnabled = false;
			_text.mouseEnabled = false;

			addEventListener(Event.ENTER_FRAME, onEnter);
		}).onError(function(err:Dynamic):Void {});

		this.y = 150;

		this.scaleX = Start.current.HDHeight / 640;
		this.scaleY = this.scaleX;
	}

	private function onEnter(_) {
		_qqfps--;

		var now = Timer.stamp();
		times.push(now);
		while (times[0] < now - 1)
			times.shift();

		var mem:Float = Math.round(System.totalMemory / 1024 / 1024 * 100) / 100;
		if (mem > memPeak)
			memPeak = mem;
		#if (gl_stats)
		if (Context3DStats.totalDrawCalls() != 0)
			_curDrawCall = Context3DStats.totalDrawCalls();
		#end
		if (visible) {
			if (debugMsg != null)
				_text.dataProvider = debugMsg;
			else {
				// #if html5 + "\nTexture:" + zygame.core.Start.TEXTURE_COUNT #end 无意义，释放会由GC处理
				var msg = "MODE:" + Lib.getRenderMode() + "\nMEM:" + mem + "MB\nMaxMEN:" + memPeak + "MB\nUPDATES:"
					+ zygame.core.Start.current.getUpdateLength() + "\nSUPDATES:" + SpineManager.count() + "\nS_RUNING:" + SpineManager.playingCount
					+ "\nFPS:" + getFps() + "\nDrawCalls:" + (_curDrawCall - 2) + "\nScale:" + Start.currentScale + "\nRETAIN:" +
					GC.getRetainCounts() #if wechat + "\nContext:" + untyped window.contextCount + "\nImage:" + untyped window.imageCount #end;
				_text.dataProvider = msg;
			}
		}
	}

	public function getDrawCall():Int {
		#if (gl_stats)
		if (this.visible && this.parent != null)
			return _curDrawCall - 2;
		return _curDrawCall;
		#else
		return 0;
		#end
	}

	public function getFps():Int {
		return times.length - 1;
	}
}

class FPSAssets {
	public static var assets:String = "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";

	public static var fnt:String = '<?xml version="1.0" encoding="UTF-8"?>
<!--Created using Glyph Designer - http://71squared.com/glyphdesigner-->
<font>
    <info face="Adobe Heiti Std" size="12" bold="0" italic="0" charset="" unicode="0" stretchH="100" smooth="1" aa="1" padding="0,0,0,0" spacing="2,2"/>
    <common lineHeight="15" base="23" scaleW="85" scaleH="140" pages="1" packed="0"/>
    <pages>
        <page id="0" file="zygameui-font.png"/>
    </pages>
    <chars count="95">
        <char id="32" x="52" y="130" width="0" height="0" xoffset="0" yoffset="14" xadvance="3" page="0" chnl="0" letter="space"/>
        <char id="33" x="9" y="97" width="3" height="11" xoffset="1" yoffset="3" xadvance="3" page="0" chnl="0" letter="!"/>
        <char id="34" x="76" y="120" width="5" height="5" xoffset="1" yoffset="3" xadvance="5" page="0" chnl="0" letter="&quot;"/>
        <char id="35" x="22" y="58" width="7" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="#"/>
        <char id="36" x="14" y="2" width="7" height="13" xoffset="1" yoffset="2" xadvance="7" page="0" chnl="0" letter="$"/>
        <char id="37" x="16" y="19" width="11" height="11" xoffset="0" yoffset="3" xadvance="11" page="0" chnl="0" letter="%"/>
        <char id="38" x="54" y="19" width="9" height="11" xoffset="0" yoffset="3" xadvance="8" page="0" chnl="0" letter="&amp;"/>
        <char id="39" x="2" y="130" width="4" height="5" xoffset="0" yoffset="3" xadvance="3" page="0" chnl="0" letter="\'"/>
        <char id="40" x="23" y="2" width="4" height="13" xoffset="1" yoffset="3" xadvance="4" page="0" chnl="0" letter="("/>
        <char id="41" x="29" y="2" width="4" height="13" xoffset="0" yoffset="3" xadvance="4" page="0" chnl="0" letter=")"/>
        <char id="42" x="57" y="120" width="6" height="6" xoffset="0" yoffset="4" xadvance="6" page="0" chnl="0" letter="*"/>
        <char id="43" x="42" y="97" width="9" height="9" xoffset="1" yoffset="5" xadvance="8" page="0" chnl="0" letter="+"/>
        <char id="44" x="8" y="130" width="4" height="5" xoffset="0" yoffset="11" xadvance="3" page="0" chnl="0" letter=","/>
        <char id="45" x="30" y="130" width="5" height="3" xoffset="0" yoffset="8" xadvance="4" page="0" chnl="0" letter="-"/>
        <char id="46" x="37" y="130" width="3" height="3" xoffset="1" yoffset="11" xadvance="3" page="0" chnl="0" letter="."/>
        <char id="47" x="29" y="84" width="6" height="11" xoffset="0" yoffset="4" xadvance="4" page="0" chnl="0" letter="/"/>
        <char id="48" x="31" y="58" width="7" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="0"/>
        <char id="49" x="77" y="84" width="5" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="1"/>
        <char id="50" x="40" y="58" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="2"/>
        <char id="51" x="49" y="58" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="3"/>
        <char id="52" x="46" y="32" width="8" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="4"/>
        <char id="53" x="58" y="58" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="5"/>
        <char id="54" x="67" y="58" width="7" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="6"/>
        <char id="55" x="76" y="58" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="7"/>
        <char id="56" x="2" y="71" width="7" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="8"/>
        <char id="57" x="11" y="71" width="7" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="9"/>
        <char id="58" x="52" y="120" width="3" height="8" xoffset="1" yoffset="6" xadvance="3" page="0" chnl="0" letter=":"/>
        <char id="59" x="36" y="97" width="4" height="10" xoffset="0" yoffset="6" xadvance="3" page="0" chnl="0" letter=";"/>
        <char id="60" x="53" y="97" width="8" height="9" xoffset="1" yoffset="5" xadvance="8" page="0" chnl="0" letter="&lt;"/>
        <char id="61" x="65" y="120" width="9" height="5" xoffset="1" yoffset="7" xadvance="8" page="0" chnl="0" letter="="/>
        <char id="62" x="63" y="97" width="8" height="9" xoffset="1" yoffset="5" xadvance="8" page="0" chnl="0" letter="&gt;"/>
        <char id="63" x="37" y="84" width="6" height="11" xoffset="1" yoffset="3" xadvance="5" page="0" chnl="0" letter="?"/>
        <char id="64" x="42" y="19" width="10" height="11" xoffset="1" yoffset="4" xadvance="10" page="0" chnl="0" letter="@"/>
        <char id="65" x="65" y="19" width="9" height="11" xoffset="0" yoffset="3" xadvance="8" page="0" chnl="0" letter="A"/>
        <char id="66" x="20" y="71" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="B"/>
        <char id="67" x="56" y="32" width="8" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="C"/>
        <char id="68" x="2" y="32" width="9" height="11" xoffset="1" yoffset="3" xadvance="8" page="0" chnl="0" letter="D"/>
        <char id="69" x="29" y="71" width="7" height="11" xoffset="1" yoffset="3" xadvance="6" page="0" chnl="0" letter="E"/>
        <char id="70" x="45" y="84" width="6" height="11" xoffset="1" yoffset="3" xadvance="6" page="0" chnl="0" letter="F"/>
        <char id="71" x="13" y="32" width="9" height="11" xoffset="0" yoffset="3" xadvance="8" page="0" chnl="0" letter="G"/>
        <char id="72" x="66" y="32" width="8" height="11" xoffset="1" yoffset="3" xadvance="8" page="0" chnl="0" letter="H"/>
        <char id="73" x="14" y="97" width="3" height="11" xoffset="1" yoffset="3" xadvance="3" page="0" chnl="0" letter="I"/>
        <char id="74" x="2" y="97" width="5" height="11" xoffset="0" yoffset="3" xadvance="5" page="0" chnl="0" letter="J"/>
        <char id="75" x="2" y="45" width="8" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="K"/>
        <char id="76" x="53" y="84" width="6" height="11" xoffset="1" yoffset="3" xadvance="6" page="0" chnl="0" letter="L"/>
        <char id="77" x="29" y="19" width="11" height="11" xoffset="1" yoffset="3" xadvance="10" page="0" chnl="0" letter="M"/>
        <char id="78" x="12" y="45" width="8" height="11" xoffset="1" yoffset="3" xadvance="8" page="0" chnl="0" letter="N"/>
        <char id="79" x="24" y="32" width="9" height="11" xoffset="0" yoffset="3" xadvance="9" page="0" chnl="0" letter="O"/>
        <char id="80" x="38" y="71" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="P"/>
        <char id="81" x="35" y="2" width="9" height="12" xoffset="0" yoffset="3" xadvance="9" page="0" chnl="0" letter="Q"/>
        <char id="82" x="47" y="71" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="R"/>
        <char id="83" x="56" y="71" width="7" height="11" xoffset="1" yoffset="3" xadvance="6" page="0" chnl="0" letter="S"/>
        <char id="84" x="22" y="45" width="8" height="11" xoffset="0" yoffset="3" xadvance="6" page="0" chnl="0" letter="T"/>
        <char id="85" x="32" y="45" width="8" height="11" xoffset="1" yoffset="3" xadvance="8" page="0" chnl="0" letter="U"/>
        <char id="86" x="35" y="32" width="9" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="V"/>
        <char id="87" x="2" y="19" width="12" height="11" xoffset="0" yoffset="3" xadvance="11" page="0" chnl="0" letter="W"/>
        <char id="88" x="42" y="45" width="8" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="X"/>
        <char id="89" x="52" y="45" width="8" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="Y"/>
        <char id="90" x="62" y="45" width="8" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="Z"/>
        <char id="91" x="60" y="2" width="4" height="12" xoffset="1" yoffset="4" xadvance="4" page="0" chnl="0" letter="["/>
        <char id="92" x="61" y="84" width="6" height="11" xoffset="0" yoffset="4" xadvance="4" page="0" chnl="0" letter="\"/>
        <char id="93" x="66" y="2" width="4" height="12" xoffset="0" yoffset="4" xadvance="4" page="0" chnl="0" letter="]"/>
        <char id="94" x="28" y="110" width="8" height="8" xoffset="1" yoffset="3" xadvance="8" page="0" chnl="0" letter="^"/>
        <char id="95" x="42" y="130" width="8" height="2" xoffset="0" yoffset="14" xadvance="7" page="0" chnl="0" letter="_"/>
        <char id="96" x="14" y="130" width="4" height="5" xoffset="0" yoffset="3" xadvance="3" page="0" chnl="0" letter="`"/>
        <char id="97" x="58" y="110" width="7" height="8" xoffset="0" yoffset="6" xadvance="6" page="0" chnl="0" letter="a"/>
        <char id="98" x="72" y="45" width="8" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="b"/>
        <char id="99" x="29" y="120" width="6" height="8" xoffset="0" yoffset="6" xadvance="6" page="0" chnl="0" letter="c"/>
        <char id="100" x="65" y="71" width="7" height="11" xoffset="0" yoffset="3" xadvance="7" page="0" chnl="0" letter="d"/>
        <char id="101" x="67" y="110" width="7" height="8" xoffset="0" yoffset="6" xadvance="7" page="0" chnl="0" letter="e"/>
        <char id="102" x="69" y="84" width="6" height="11" xoffset="0" yoffset="3" xadvance="4" page="0" chnl="0" letter="f"/>
        <char id="103" x="74" y="71" width="7" height="11" xoffset="0" yoffset="6" xadvance="7" page="0" chnl="0" letter="g"/>
        <char id="104" x="2" y="84" width="7" height="11" xoffset="1" yoffset="3" xadvance="7" page="0" chnl="0" letter="h"/>
        <char id="105" x="19" y="97" width="3" height="11" xoffset="1" yoffset="3" xadvance="3" page="0" chnl="0" letter="i"/>
        <char id="106" x="7" y="2" width="5" height="14" xoffset="-1" yoffset="3" xadvance="3" page="0" chnl="0" letter="j"/>
        <char id="107" x="11" y="84" width="7" height="11" xoffset="1" yoffset="3" xadvance="6" page="0" chnl="0" letter="k"/>
        <char id="108" x="24" y="97" width="3" height="11" xoffset="1" yoffset="3" xadvance="3" page="0" chnl="0" letter="l"/>
        <char id="109" x="2" y="110" width="11" height="8" xoffset="1" yoffset="6" xadvance="11" page="0" chnl="0" letter="m"/>
        <char id="110" x="76" y="110" width="7" height="8" xoffset="1" yoffset="6" xadvance="7" page="0" chnl="0" letter="n"/>
        <char id="111" x="38" y="110" width="8" height="8" xoffset="0" yoffset="6" xadvance="7" page="0" chnl="0" letter="o"/>
        <char id="112" x="2" y="58" width="8" height="11" xoffset="1" yoffset="6" xadvance="7" page="0" chnl="0" letter="p"/>
        <char id="113" x="20" y="84" width="7" height="11" xoffset="0" yoffset="6" xadvance="7" page="0" chnl="0" letter="q"/>
        <char id="114" x="45" y="120" width="5" height="8" xoffset="1" yoffset="6" xadvance="4" page="0" chnl="0" letter="r"/>
        <char id="115" x="37" y="120" width="6" height="8" xoffset="0" yoffset="6" xadvance="5" page="0" chnl="0" letter="s"/>
        <char id="116" x="29" y="97" width="5" height="10" xoffset="0" yoffset="4" xadvance="4" page="0" chnl="0" letter="t"/>
        <char id="117" x="2" y="120" width="7" height="8" xoffset="1" yoffset="6" xadvance="7" page="0" chnl="0" letter="u"/>
        <char id="118" x="48" y="110" width="8" height="8" xoffset="0" yoffset="6" xadvance="6" page="0" chnl="0" letter="v"/>
        <char id="119" x="15" y="110" width="11" height="8" xoffset="0" yoffset="6" xadvance="10" page="0" chnl="0" letter="w"/>
        <char id="120" x="11" y="120" width="7" height="8" xoffset="0" yoffset="6" xadvance="6" page="0" chnl="0" letter="x"/>
        <char id="121" x="12" y="58" width="8" height="11" xoffset="0" yoffset="6" xadvance="6" page="0" chnl="0" letter="y"/>
        <char id="122" x="20" y="120" width="7" height="8" xoffset="0" yoffset="6" xadvance="6" page="0" chnl="0" letter="z"/>
        <char id="123" x="46" y="2" width="5" height="12" xoffset="0" yoffset="4" xadvance="4" page="0" chnl="0" letter="{"/>
        <char id="124" x="2" y="2" width="3" height="15" xoffset="1" yoffset="2" xadvance="3" page="0" chnl="0" letter="|"/>
        <char id="125" x="53" y="2" width="5" height="12" xoffset="0" yoffset="4" xadvance="4" page="0" chnl="0" letter="}"/>
        <char id="126" x="20" y="130" width="8" height="4" xoffset="1" yoffset="7" xadvance="8" page="0" chnl="0" letter="~"/>
    </chars>
    <kernings count="0"/>
</font>';
}
