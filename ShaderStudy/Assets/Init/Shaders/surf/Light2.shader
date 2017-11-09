//各种光照模型的简单应用
Shader "Stone/Surf/Light2" {
	Properties {
		_MainTint ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RoughnessTex("Roughness texture",2D) = "white" {}
		_Roughness("Roughness",Range(1,0)) = 0.5
		_SpecularColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0,30)) = 2
		_Fresnel("Fresnel Value",Range(0,1.0)) = 0.05
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MySpecular

		#pragma target 3.0

		float4 _MainTint;
		sampler2D _MainTex;
		sampler2D _RoughnessTex;
		float _Roughness;
		float4 _SpecularColor;
		float _SpecPower;
		float _Fresnel;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingMySpecular(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			//半角向量
			float3 halfVector = normalize(lightDir + viewDir);
			//
			float NdotL = saturate(dot(s.Normal,normalize(lightDir)));
			float NdotH_raw = dot(s.Normal,halfVector);
			float NdotH = saturate(dot(s.Normal,halfVector));
			float NdotV = saturate(dot(s.Normal,normalize(viewDir)));
			float VdotH = saturate(dot(halfVector,normalize(viewDir)));

			float geoEnum = 2.0 * NdotH;
			float3 G1 = (geoEnum * NdotV)/NdotH;
			float3 G2 = (geoEnum * NdotL)/NdotH;
			float3 G = min(1.0f,min(G1,G2));

			float roughness = tex2D(_RoughnessTex,float2(NdotH_raw * 0.5 + 0.5,_Roughness)).r;

			float fresnel = pow(1.0 - VdotH,5.0);
			fresnel *= (1.0 - _Fresnel);
			fresnel += _Fresnel;
			 
			float3 spec = float3(fresnel * G * roughness * roughness) * _SpecPower;

			float4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NdotL) + (spec * _SpecularColor.rgb) * (atten * 2.0f);
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
