Shader "Stone/Vert/VertImage"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_VignetteTex("Vignette Texture",2D) = "white" {}
		_ScratchesTex ("Scratches Texture",2D) = "white"{}
		_DustTex ("Dust Texture",2D) = "white"{}
		_SepiaColor("Sepia Color",Color) = (1,1,1,1)
		_EffectAmount ("Efftct Amount",Range(0,1)) = 1.0
		_VignetteAmount("Vignette Amount",Range(0,1)) = 1.0
		_ScratchesYSpeed("Scratch Y Speed",Float) = 10
		_ScratchesXSpeed ("Scrathc X Speed",Float) = 10
		_dustYSpeed ("Dust Y Speed",Float) = 10
		_dustXSpeed ("Dust X Speed",Float) = 10
		_RandomValue ("Random Value",Float) = 1.0
		_Contrast ("Contrast",Float) = 3.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma fragmentoption APB_percision_hint_fastest
			
			#include "UnityCG.cginc"

			float4 _MainTex_ST;
			uniform sampler2D _MainTex;
			uniform sampler2D _VignetteTex;
			uniform sampler2D _ScratchesTex;
			uniform sampler2D _DustTex;
			fixed4 _SepiaColor;
			fixed _VignetteAmount;
			fixed _ScratchesYSpeed;
			fixed _ScratchesXSpeed;
			fixed _dustYSpeed;
			fixed _dustXSpeed;
			fixed _EffectAmount;
			fixed _RandomValue;
			fixed _Contrast;

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				float4 vertex : SV_POSITION;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				//half2 disUV = half2(i.uv.x,i.uv.y + (_RandomValue * _SinTime.z * 0.005));

				fixed4 renderTex  = tex2D(_MainTex,i.uv);

				fixed4 vignTex = tex2D(_VignetteTex,i.uv);

				half2 scraUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed),
				i.uv.y + _SinTime.z * _ScratchesYSpeed);
				fixed4 scraTex = tex2D(_ScratchesTex,scraUV);

				half2 dustUV = half2(i.uv.x + (_RandomValue * (_SinTime.z * _dustXSpeed)),
				i.uv.y + (_RandomValue * (_SinTime.z * _dustYSpeed)));
				fixed4 dustTex = tex2D(_DustTex,dustUV);
				
				//原始颜色处理成黑白
				fixed lum = dot(fixed3(0.299,0.587,0.114),renderTex.rgb);

				fixed4 finalColor = fixed4(lum,lum,lum,lum);
				//加上画面闪动，_RandomValue（-1，1）
				//finalColor = lum + lerp(_SepiaColor,_SepiaColor + fixed4(0.1f,0.1f,0.1f,1.0f),_RandomValue);
				//finalColor = pow(finalColor,_Contrast);

				//叠加旧照片边框效果
				fixed3 constanWhite = fixed3(1,1,1);
			 //   finalColor.rgb = lerp(finalColor,finalColor * vignTex,_VignetteAmount);
				//叠加不断变化的信号纹理
				//finalColor.rgb *= lerp(scraTex,constanWhite,_RandomValue);
				//finalColor.rgb *= lerp(dustTex.rgb,constanWhite,_RandomValue * _SinTime.z);

				return finalColor;
			}
			ENDCG
		}
	}
}
