//顶点漫反射
Shader "Stone/Simple/DiffuseVertex"
{
	Properties
	{
		_Diffuse("Diffuse",Color) = (1,1,1,1)
	}
	SubShader
	{
		Pass
		{
			//定义该pass在光照流水线中的角色
			Tags { "LightMode"="ForwardBase" }

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//要使用和光照有关的一些变量，如_LightColor0，需要包含这个头文件
			#include "Lighting.cginc"

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR;
			};

			fixed4 _Diffuse;
			
			v2f vert (a2v v)
			{
				v2f o;

				o.pos = mul(UNITY_MATRIX_MVP,v.vertex);

				//获取环境光
				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
				//将模型空间中的法线转换到世界空间中
				fixed3 worldNormal = normalize(mul(v.normal,(float3x3)_World2Object));
				//归一化光源
				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
				//计算漫反射
				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

				o.color = ambient + diffuse;

				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return fixed4(i.color,1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}
