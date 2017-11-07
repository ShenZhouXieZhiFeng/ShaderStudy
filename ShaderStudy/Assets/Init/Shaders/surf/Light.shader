Shader "Stone/Surf/Light" {
	Properties {
		_MainTint ("Color", Color) = (1,1,1,1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Specular ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0,30)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MySpecular

		#pragma target 3.0

		float4 _MainTint;
		sampler2D _MainTex;
		float4 _Specular;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainTint;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		//自定义高光模型
		inline fixed4 LightingMySpecular(SurfaceOutput s,fixed3 lightDir,half3 viewDir,fixed atten){
			//点乘法线和光照方向，正对着光源的位置值最大
			float diff = dot(s.Normal,lightDir);
			//计算出光线的反射方向：2*dot(s.normal,lightDir)*s.normal - lightDir
			//float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);
			float3 reflectionVector = reflect(-lightDir,s.Normal);
			//计算高光值，反射方向×观察方向，再与强度做ｐｏｗ操作
			float spec = pow(max(0,dot(reflectionVector,viewDir)),_SpecPower);
			//加上高光颜色
			float3 finalSpec = _Specular.rgb * spec;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = 1.0;
			return c;

			//float diff = dot(s.Normal,lightDir);
			//float3 reflectionVector = normalize(2.0 * s.Normal * diff - lightDir);

			//fixed4 c;
			//c.rgb = _LightColor0.rgb * _Specular *
			// pow(dot(reflectionVector,viewDir),_SpecPower);
			//c.a = 1.0;
			//return c;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
