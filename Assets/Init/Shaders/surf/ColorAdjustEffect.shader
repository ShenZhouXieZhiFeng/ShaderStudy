//一个调节对比度，亮度，饱和度的shader
Shader "Stone/ColorAdjustEffect"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_Brightness("亮度", Range(0,10)) = 1
		_Saturation("饱和度",Range(0,10)) = 1
		_Constrast("对比度", Range(0,10)) = 1
	}
	SubShader
	{
		Pass
		{
			ZTest Always Cull Off ZWrite Off

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			half _Brightness;
			half _Saturation;
			half _Constrast;

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 pos : SV_POSITION;
			};

			v2f vert (appdata_img v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//采样，得到该点的颜色
				fixed4 renderTex = tex2D(_MainTex,i.uv);
				//亮度
				//将采样的颜色值直接乘以亮度值
				fixed3 finalColor = renderTex * _Brightness;

				//饱和度
				//计算在该颜色下的最低饱和度
				fixed gray = 0.2125 * renderTex.r + 0.7154 * renderTex.g + 0.0721 * renderTex.b;
				fixed3 grayColor = fixed3(gray,gray,gray);
				//与原来的颜色进行插值
				finalColor = lerp(grayColor,finalColor,_Saturation);

				//对比度
				//最低对比度如下
				fixed3 avgColor = fixed3(0.5,0.5,0.5);
				//进行颜色插值
				finalColor = lerp(avgColor,finalColor,_Constrast);

				return fixed4(finalColor,renderTex.a);
			}
			ENDCG
		}
	}
	FallBack Off
}
