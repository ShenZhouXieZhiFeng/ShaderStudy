Shader "Custom/01" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_DrawTexture("Draw Texture",2D) = "white"{}
		_DrawHeight ("DrawHeight",Range(0,0.5)) = 0
		_MainHeight ("MainHeight",Range(0,1)) = 0
		_MainColor ("Main Color", Color) = (1,1,1,1)
	}
	SubShader {
	Tags { "Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
	//Pass
	//	{
	//		Tags { "LightMode"="ForwardBase" }

	//		//Cull Off
	//		//ZWrite Off
	//		Blend SrcAlpha OneMinusSrcAlpha

	//		CGPROGRAM
	//		#pragma vertex vert
	//		#pragma fragment frag
			
	//		#include "UnityCG.cginc"

	//		sampler2D _MainTex;
	//		float4 _MainTex_ST;
	//		sampler2D _DrawTexture;
	//		float _DrawHeight;
	//		float4 _MainColor;
	//		float _MainHeight;

	//		struct a2v {
	//			float4 vertex : POSITION;
	//			float2 uv : TEXCOORD0;
	//		};
			
	//		struct v2f {
	//			float4 pos : SV_POSITION;
	//			fixed2 uv : TEXCOORD;
	//		};
			
	//		v2f vert (a2v v)
	//		{
	//			v2f o;
	//			o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
	//			o.uv = TRANSFORM_TEX(v.uv, _MainTex);
	//			return o;
	//		}
			
	//		fixed4 frag (v2f i) : SV_Target
	//		{
	//			fixed4 c = tex2D(_MainTex,i.uv);
	//			if(i.uv.y < _MainHeight){
	//				c.a = 0;
	//			}
	//			return c;
	//		}
	//		ENDCG
	//	}
	Pass
		{
			Tags { "LightMode"="ForwardBase" }

			Cull Off
            ZWrite Off
            Blend One One

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _DrawTexture_ST;
			sampler2D _DrawTexture;
			float _DrawHeight;
			float4 _MainColor;
			float _MainHeight;

			struct a2v {
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				fixed2 uv : TEXCOORD;
				fixed2 uv2 : TEXCOORD1;
			};
			
			v2f vert (a2v v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _DrawTexture);
				o.uv2 = TRANSFORM_TEX(v.uv, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 c = tex2D(_DrawTexture,i.uv) * _MainColor;
				//使用了blend one one就不能控制alpha
				//c.a = 1.0;
				//if(c.r + c.g + c.b <= 0){
				//	c.a = 0;
				//} 
				//if(i.uv.y <  _DrawHeight || i.uv.y > 1 - _DrawHeight){
				//	c.a = 0;
				//}
				//无效//c.a = 0;
				//直接控制整体颜色值
				return  c;// * saturate((i.uv.y - _DrawHeight));
				//float4 c2 = tex2D(_MainTex,i.uv2);
				//if(i.uv.y < _MainHeight){
				//	c.a = 0;
				//}

				//return c+c2;
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
