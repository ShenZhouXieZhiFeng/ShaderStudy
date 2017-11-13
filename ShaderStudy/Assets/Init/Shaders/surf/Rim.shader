Shader "Stone/Surf/Rim" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_RimEffect("Rim Effect",Range(-1,1)) = 0
	}
	SubShader {
		Tags {  "RenderType" = "Transparent" 
				"IgnoreProjector" = "True"
				"RenderType" = "Transparent" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Lambert alpha:fade nolighting

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
			float3 worldNormal;
			float3 viewDir;
		};

		half _RimEffect;
		fixed4 _Color;

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;// + NdotV * _Color;


			float NdotV = 1 - abs(dot(IN.worldNormal,IN.viewDir));
			float alpha = NdotV * (1 - _RimEffect) + _RimEffect;

			o.Alpha = c.a * alpha;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
