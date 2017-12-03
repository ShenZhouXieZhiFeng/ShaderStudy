Shader "Stone/Vert/VertSnow" {
	Properties {
		_Color ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Bump("Bump",2D) = "white" {}
		_Snow ("Level of Snow",Range(1,-1)) = 1
		_SnowColor ("Snow Color",Color) = (1,1,1,1)
		_SnowDirection ("Snow Direction",Vector) = (0,1,0)
		_SnowDepth ("Snow Depth",Range(0,1)) = 0
		_NoiseTex ("Noise Texture",2D) = "white" {}
		_Period ("Period",Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Test vertex:vert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		struct Input {
			float2 uv_MainTex;
			float2 uv_Bump;
			float2 uv_NoiseTex;
			float3 worldNormal;
			INTERNAL_DATA
		};

		sampler2D _NoiseTex;
		sampler2D _MainTex;
		sampler2D _Bump;
		float _Period;
		float _Snow;
		float4 _SnowColor;
		float4 _SnowDirection;
		float _SnowDepth;
		fixed4 _Color;

		void vert(inout appdata_full v, out Input o){
			UNITY_INITIALIZE_OUTPUT(Input,o);  
			//float4 sn = mul(UNITY_MATRIX_IT_MV,_SnowDirection);
			//if(dot(v.normal,sn.xyz) >= _Snow)
			//	v.vertex.xyz += (sn.xyz + v.normal) * _SnowDepth * _Snow;

			float disp = tex2Dlod(_NoiseTex,float4(v.texcoord.xy,0,0));
			//float disp = tex2Dlod(_NoiseTex, float4(o.uv_NoiseTex,0,0));
			float time = cos(_Time[3] * _Period * disp.r * 10);
			v.vertex.xyz += v.normal * disp.r * time;
		}

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Normal = UnpackNormal(tex2D(_Bump,IN.uv_Bump));

			if(dot(WorldNormalVector(IN,o.Normal),_SnowDirection) >= _Snow)
				o.Albedo = _SnowColor.rgb;
			else
				o.Albedo = c.rgb * _Color;

			o.Alpha = 1;
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
