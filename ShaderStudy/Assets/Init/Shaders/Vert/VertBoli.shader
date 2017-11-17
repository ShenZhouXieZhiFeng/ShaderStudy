Shader "Stone/Vert/VertBoli"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_BumpTex ("Bump Texture",2D) = "white" {}
		_Magnitude ("Magnitude",Range(0,1)) = 0.05
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque" }

		GrabPass {"_GrabTexture"} 

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float4 uvGrab : TEXCOORD1;
			};

			sampler2D _GrabTexture;
			sampler2D _MainTex;
			sampler2D _BumpTex;
			float _Magnitude;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				o.uvGrab = ComputeGrabScreenPos(v.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 mainColor = tex2D(_GrabTexture,i.uv);

				half4 bump = tex2D(_MainTex,i.uv);
				half2 distor = UnpackNormal(bump).rg;

				i.uvGrab.xy += distor * _Magnitude;

				fixed4 col = tex2Dproj(_GrabTexture,UNITY_PROJ_COORD(i.uvGrab));

				return mainColor;//* col;
			}
			ENDCG
		}
	}
}
