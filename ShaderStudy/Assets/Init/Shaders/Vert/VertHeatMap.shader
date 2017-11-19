Shader "Stone/Vert/VertHeatMap"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" }
		blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;

			uniform int _Points_Length = 0;
			uniform float3 _Points[20];
			uniform float2 _Properties[20];

			struct appdata
			{
				float4 pos : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 posWorld : TEXCOORD2;
			};

			v2f vert (appdata v)
			{
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.pos);
				o.posWorld = mul(_Object2World,v.pos).xyz;
				return o;
			}

			fixed4 frag (v2f i) : SV_Target
			{
				half h = 0;

				for(int x = 0;x < _Points_Length; x ++){

					float di = distance(i.posWorld,_Points[x].xyz);

					half ri = _Properties[x].x;

					half hi = 1 - saturate(di/ri);

					h += hi * _Properties[x].y;
				}

				h = saturate(h);
				fixed4 c = tex2D(_MainTex,fixed2(h,0.5));
				return c;
				//return fixed4(h,h,h,h);
			}
			ENDCG
		}
	}
}
