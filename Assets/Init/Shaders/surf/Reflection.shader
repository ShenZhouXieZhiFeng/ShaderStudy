//反射，遮罩，改变法线
Shader "Stone/Surf/Reflection" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "white" {}
		_CubeMapTex ("Cube Map Texture", CUBE) = ""{}
		_ReflAmount ("Reflection Amount",Range(0.01,1)) = 0.5
		_ReflMask ("Reflection Mask", 2D) = "white" {}
	}
	SubShader {
		Tags { "Queue"="Transparent" "RenderType"="Opaque" }
		LOD 200
		
		//Cull Off 
		//ZWrite Off 
		//Blend One One

		CGPROGRAM

		#pragma surface surf Standard fullforwardshadows

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _NormalMap;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float2 uv_NormalMap;
			//要访问修改后的法线值，需要加下面这一句
			INTERNAL_DATA
		};

		fixed4 _Color;
		samplerCUBE _CubeMapTex;
		float _ReflAmount;
		sampler2D _ReflMask;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			//fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
			//采样法线贴图
			float3 normals = UnpackNormal(tex2D(_NormalMap,IN.uv_NormalMap)).rgb;
			//设置法线
			o.Normal = normals;

			//使用以下函数计算逐像素法线，在应用法线贴图之后
			float3 wrv = WorldReflectionVector(IN,o.Normal);
			//使用个像素的法线重新采样cubemap，将结果赋给自发光
			o.Emission = texCUBE(_CubeMapTex,wrv).rgb * _ReflAmount;

			float4 reflMask = tex2D(_ReflMask,IN.uv_MainTex);

			//o.Albedo = c.rgb;
			o.Alpha = 1;
			//直接与遮罩贴图的r值相乘
			o.Emission = o.Emission * reflMask.g;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
