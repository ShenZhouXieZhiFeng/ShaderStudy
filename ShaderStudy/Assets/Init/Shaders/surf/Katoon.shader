Shader "Stone/Surf/Katoon" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_RamTex ("Ram Texture",2D) = "white"{}
		_RamValue ("Ram Value",Float) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Katoon

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RamTex;

		struct Input {
			float2 uv_MainTex;
		};

		fixed4 _Color;
		float _RamValue;

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		fixed4 LightingKatoon(SurfaceOutput s,fixed3 lightDir,fixed3 viewDir,fixed atten){
			//法线光照点乘
			half NdotL = dot(s.Normal,lightDir);
			//将兰伯特反射的光强值通过坡度图映射成一个新的值
			//NdotL = tex2D(_RamTex,fixed2(NdotL,0.5));
			//另一种方式
			NdotL = floor(NdotL * _RamValue)/(_RamValue - 0.5);

			//half NdotV = dot(s.Normal,viewDir);
			//fixed4 rimColor = NdotV * _Color;

			fixed4 c;
			//根据采样结果输出颜色值
			c.rgb = s.Albedo * _LightColor0.rgb * NdotL * atten ;//* rimColor;
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
