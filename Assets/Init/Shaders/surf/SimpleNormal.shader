//一个简单的设置法线的shader
Shader "Stone/Surf/SimpleNormal" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_BumpTex ("Normal Texture", 2D) = "white" {}
		_NormalScale ("Normal Scale", Range(0,2)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpTex;
		fixed _NormalScale;

		struct Input {
			float2 uv_MainTex;
		};

		
		void surf (Input IN, inout SurfaceOutputStandard o) {
			//针对法线贴图采样，改变原输出的法线
			fixed3 normal = UnpackNormal(tex2D (_BumpTex, IN.uv_MainTex));
			//使用一个值去控制法线凹凸的程度
			normal = fixed3(normal.x * _NormalScale,normal.y * _NormalScale,normal.z);
			o.Normal = normal;
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
