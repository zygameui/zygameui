## 灰度

使用灰度着色器，可以使显示对象呈灰色显示：

```haxe
display.shader = GeryShader.shader; //可直接使用单例着色器片段
```

## 着色器分析

```glsl
		#pragma header
				
		void main(void) {
			#pragma body
			float mColor = 0.0;
      // 将所有颜色合计
			mColor += gl_FragColor.r + gl_FragColor.g + gl_FragColor.b;
      // 然后将颜色平均化
			mColor = mColor/3.0;
      // 设置灰度颜色
			gl_FragColor.r = mColor;
			gl_FragColor.g = mColor;
			gl_FragColor.b = mColor;
      // 输出最终透明度
			gl_FragColor *= openfl_Alphav;
		}
```

