//各种光照模型的简单应用
Shader "Stone/Surf/Light" {
	Properties {
		_MainTint ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_SpecularLightColor ("Specular Color", Color) = (1,1,1,1)
		_SpecularMask("Specular Mask", 2D) = "white" {}
		_SpecPower ("Specular Power", Range(0,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MyCustomSpecular

		#pragma target 3.0

		float4 _MainTint;
		sampler2D _MainTex;
		sampler2D _SpecularMask;
		float4 _SpecularLightColor;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SpecularMask;
		};

		struct SurfaceCustomOutput{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};

		void surf (Input IN, inout SurfaceCustomOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			float4 specMask = tex2D(_SpecularMask,IN.uv_SpecularMask) * _SpecularLightColor;

			o.Albedo = c.rgb;
			o.Specular = specMask.r;
			o.SpecularColor = specMask.rgb;
			o.Alpha = c.a;
		}

		//Phong自定义高光模型
		inline fixed4 LightingMySpecular(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			//点乘法线和光照方向，正对着光源的位置值最大
			float diff = dot(s.Normal,lightDir);
			//计算出光线的反射方向：2*dot(s.normal,lightDir)*s.normal - lightDir
			//float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
			float3 reflectionVector = reflect(-lightDir,s.Normal);
			//计算高光值，反射方向×观察方向，再与强度做ｐｏｗ操作
			float spec = pow(max(0,dot(reflectionVector,viewDir)),_SpecPower);
			//加上高光颜色
			float3 finalSpec = _SpecularLightColor.rgb * spec;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = 1.0;
			return c;
		}

		//Blinn_Phong自定义高光模型
		inline fixed4 LightingMyBlinnSpecular(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			//计算blinn引入的新参数H，通过光照方向和观察方向获得，半角
			float3 halfVec = normalize(lightDir + viewDir);
			//通过法线与半角向量点乘，其他操作与phong模型一致
			float nh = max(0,dot(s.Normal,halfVec));
			float spec = pow(nh,_SpecPower) * _SpecularLightColor;

			float diff = max(0,dot(s.Normal,lightDir));

			fixed4 c;
			//c.rgb = (_LightColor0.rgb * _Specular.rgb * spec);
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * _SpecularLightColor.rgb * spec) * (atten * 2);
			c.a = 1.0;
			return c;
		}

		//使用高光遮罩,能够让高光部分随着纹理遮罩的纹路发生变化
		inline fixed4 LightingMyCustomSpecular(SurfaceCustomOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			//计算blinn引入的新参数H，通过光照方向和观察方向获得，半角
			float3 halfVec = normalize(lightDir + viewDir);
			//通过法线与半角向量点乘，其他操作与phong模型一致
			float nh = max(0,dot(s.Normal,halfVec));
			float spec = pow(nh,_SpecPower) * s.Specular;
			float3 finalSpec = s.SpecularColor * spec * _SpecularLightColor.rgb;

			float diff = max(0,dot(s.Normal,lightDir));

			fixed4 c;
			//c.rgb = (_LightColor0.rgb * _Specular.rgb * spec);
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = 1.0;
			return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
