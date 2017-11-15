Shader "Stone/Vert/VertJiYa" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_ExtrusionTex("ExtrusionTex",2D) = "white" {}
		_Amount ("Amount",Range(-1,1)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Test vertex:vert

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _ExtrusionTex;
		float _Amount;

		struct Input {
			float2 uv_MainTex;
			float3 vertColor;
		};

		
		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input,o);  
			float4 tex = tex2Dlod(_ExtrusionTex,float4(v.vertex.xy,0,0));
			float extru = tex.r * 2 - 1;
			v.vertex.xyz += v.normal * _Amount * extru;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		fixed4 LightingTest(SurfaceOutput s,fixed3 lightDir,fixed atten){
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = 1;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
