//一个简单的表面着色器
Shader "Stone/Surf/Custom/BasicDiffuse" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_EmissiveColor ("Emissive Color",Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_Slider ("Slider", Range(0,10)) = 1
		_RampTex ("RampTexture (RGB)", 2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		//使用自定义的光照函数
		#pragma surface surf BasicLambertDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _RampTex;
		fixed4 _EmissiveColor;
		fixed4 _AmbientColor;
		float _Slider;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			 //Albedo comes from a texture tinted by color
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
			//fixed4 col;
			//col = pow((_EmissiveColor + _AmbientColor),_Slider);

			//o.Albedo = col.rgb;
			//o.Alpha = col.a;
		}

		//基本漫反射光照模型
		inline float4 LightingBasicDiffuse(SurfaceOutput s,fixed3 lightDir,fixed atten){
			//将物体表面法线和光照方向进行点乘，正对着光源的位置值越大
			//使用max函数将值截取到0以上
			float difLight = max(0,dot(s.Normal,lightDir));
			fixed4 col;
			//计算漫反射光照 = 物体颜色 * 光源颜色 * 偏移值
			col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2);
			col.a = s.Alpha;
			return col;
		}

		//半兰伯特光照模型
		inline float4 LightingBasicLambertDiffuse(SurfaceOutput s,fixed3 lightDir,fixed atten){
			//与传统漫反射光照对于像素偏移值的处理方式不同的地方
			//半兰伯特光照 将点乘的结果重新映射到0和1之间
			float difLight = max(0,dot(s.Normal,lightDir));
			difLight = difLight * 0.5 + 0.5;
			//使用渐变纹理
			float3 ramp = tex2D(_RampTex,float2(difLight,difLight)).rgb;

			fixed4 col;
			//计算漫反射光照 = 物体颜色 * 光源颜色 * 偏移值
			col.rgb = s.Albedo * _LightColor0.rgb * (difLight * atten * 2) * ramp;
			//col.rgb = s.Albedo * _LightColor0.rgb * ramp;
			col.a = s.Alpha;
			return col;
		}

		ENDCG
	}
	FallBack "Diffuse"
}
