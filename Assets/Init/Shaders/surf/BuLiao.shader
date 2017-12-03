Shader "Stone/Surf/BuLiao" {
	Properties {
		_MainTint ("Color", Color) = (1,1,1,1)
		_BumpMap ("Normal NormalMap",2D) = "bump"{}
		_DetailBump ("Detail NormalMap",2D) = "bump"{}
		_DetailTex ("Detail Texture",2D) = "White" {}
		_FresnelColor ("Fresnel Color",Color) = (1,1,1,1)
		_FresnelPower ("Frenel Power",Range(0,12)) = 3
		_RimPower ("Rim Falloff",Range(0,12)) = 3
		_SpecIntesity ("Specular Intensility",Range(0,1)) = 0.2
		_SpecWidth ("Specula Width",Range(0,1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Velvet

		#pragma target 3.0

		sampler2D _BumpMap;
		sampler2D _DetailBump;
		sampler2D _DetailTex;
		float4 _MainTint;
		float4 _FresnelColor;
		float _FresnelPower;
		float _RimPower;
		float _SpecIntesity;
		float _SpecWidth;

		struct Input 
		{
			float2 uv_BumpMap;
			float2 uv_DetailBump;
			float2 uv_DetailTex;
		};

		inline fixed4 LightingVelvet(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			half3 halfVec = normalize(lightDir + viewDir);
			fixed NdotL = max(0,dot(s.Normal,lightDir));

			//Spec
			float NdotH = saturate(dot(s.Normal,halfVec));
			float spec = pow(NdotH,_SpecWidth*128.0) * s.Gloss;

			//Fresnel
			//float HdotV = pow(1-max(0,dot(halfVec,viewDir)),_FresnelPower);
			//float HdotE = pow(1-max(0,dot(s.Normal,viewDir)),_RimPower);
			//float finalSpecMask = HdotV * HdotE;
			float finalSpecMask = 1;

			//final
			fixed4 c;
			c.rgb  = (s.Albedo * NdotL * _LightColor0.rgb ) + (spec * (finalSpecMask * _FresnelColor.rgb)) * (atten * 2);
			return c;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D(_DetailTex,IN.uv_DetailTex);
			fixed3 normals = UnpackNormal(tex2D(_BumpMap,IN.uv_BumpMap)).rgb;
			float3 detailNormal = UnpackNormal(tex2D(_DetailBump,IN.uv_DetailBump)).rgb;
			float3 finalNormal = float3(normals.x + detailNormal.x,normals.y + detailNormal.y,normals.z + detailNormal.z);

			o.Normal = normalize(finalNormal);
			//o.Specular = _SpecWidth;
			o.Gloss = _SpecIntesity;
			o.Albedo = c.rgb * _MainTint;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
