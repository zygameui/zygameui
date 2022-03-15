package zygame.feathersui;

import feathers.skins.RectangleSkin;
import zygame.components.base.ZConfig;
import feathers.text.TextFormat;
import feathers.layout.VerticalLayout;
import feathers.controls.ListView;
import feathers.controls.dataRenderers.ItemRenderer;
import feathers.themes.ClassVariantTheme;

/**
 * 游戏使用使用的轻量feathersui的UI主题
 */
class FUITheme extends ClassVariantTheme {
	public function new() {
		super();
		styleProvider.setStyleFunction(ListView, null, setFListView);
		styleProvider.setStyleFunction(ItemRenderer, null, setFItemRendererView);
	}

	public function setFListView(listView:ListView):Void {
		listView.layout = new VerticalLayout();
		listView.showScrollBars = false;
	}

	public function setFItemRendererView(item:ItemRenderer):Void {
		item.backgroundSkin = null;
		item.textFormat = new TextFormat(ZConfig.fontName, 28);
	}
}
