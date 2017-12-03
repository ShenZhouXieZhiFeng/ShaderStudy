Shader "Stone/Vert/VertAnimation" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_TintAmount ("Tint Amount",Range(0,1)) = 0.5
		_ColorA ("Color A", Color) = (1,1,1,1)
		_ColorB ("Color B", Color) = (1,1,1,1)
		_Speed ("Speed",Float) = 5
		_Frequency ("Wave Frequency", Range(0,5)) = 2
		_Amplitude ("Wave Amplitude",Range(1,-1)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		#pragma target 3.0

		sampler2D _MainTex;
		float _TintAmount;
		fixed4 _ColorA;
		fixed4 _ColorB;
		float _Speed;
		float _Frequency;
		float _Amplitude;

		struct Input {
			float2 uv_MainTex;
			float3 vertColor;
		};

		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input,o);  
			float time = _Time * _Speed;
			float waveValueA = sin(time + v.vertex.x * _Frequency) * _Amplitude;
			v.vertex.xyz = float3(v.vertex.x,v.vertex.y + waveValueA,v.vertex.z);
			v.normal = normalize(float3(v.normal.x + waveValueA,v.vertex.y,v.vertex.z));
			o.vertColor = float3(waveValueA,waveValueA,waveValueA);
		}

		void surf (Input IN, inout SurfaceOutput o) {
			// Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			float tintColor = lerp(_ColorA,_ColorB,IN.vertColor).rgb;

			o.Albedo = c.rgb * (tintColor * _TintAmount);
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
