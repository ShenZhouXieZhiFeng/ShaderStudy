Shader "Stone/Surf/Terrain" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Center("Center",vector) = (0,0,0,0)
		_Radius("Radius",Float) = 0.5
		_RadiusColor("Radius Color",Color) = (1,1,1,1)
		_RadiusWidth("Radius Width",Float) = 2
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

		struct Input {
			float2 uv_MainTex;
			float3 worldPos;
		};

		float3 _Center;
		float _Radius;
		fixed4 _RadiusColor;
		float _RadiusWidth;

		void surf (Input IN, inout SurfaceOutputStandard o) {
			float d = distance(_Center,IN.worldPos);
			if(d > _Radius && d < _Radius + _RadiusWidth){
				o.Albedo = _RadiusColor;
			}else{
				o.Albedo = tex2D(_MainTex,IN.uv_MainTex).rgb;
			}
		}
		ENDCG
	}
	FallBack "Diffuse"
}
