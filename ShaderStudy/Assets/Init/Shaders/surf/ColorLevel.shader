//一个简单的调整色阶的shader
Shader "Stone/Surf/ColorLevel" {
	Properties {
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_inBlack ("Input Black", Range(0,255)) = 0
		_inGamma ("Input Gamma", Range(0,2)) = 1.61
		_inWhite ("Input White", Range(0,255)) = 255
		_outWhite ("OutPut White", Range(0,255)) = 255
		_outBlack ("OutPut Black", Range(0,255)) = 0
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

		float _inBlack;
		float _inGamma;
		float _inWhite;
		float _outWhite;
		float _outBlack;



		struct Input {
			float2 uv_MainTex;
		};

		float GetPixelLevel(float pixelColor)  
		{  
			float pixelResult;  
			//tex2D采样的颜色范围是0-1，我们需要重新映射到0，255
			pixelResult = (pixelColor * 255.0);  
			//调整亮度(变暗)
			pixelResult = max(0, pixelResult - _inBlack);  
			//
			//pow操作 _inGamma进行伽马校正，适应人眼和屏幕的一些性质（不是很懂，校正后显示效果提升)
			pixelResult = saturate(pow(pixelResult / (_inWhite - _inBlack), _inGamma));  
			pixelResult = (pixelResult * (_outWhite - _outBlack) + _outBlack)/255.0;      
			return pixelResult;  
		}

		void surf (Input IN, inout SurfaceOutputStandard o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);

			//c.r = GetPixelLevel(c.r);
			//c.g = GetPixelLevel(c.g);
			c.b = GetPixelLevel(c.b);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
