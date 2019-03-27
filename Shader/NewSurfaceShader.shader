// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/NewSurfaceShader" {
	SubShader{
		Pass{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "Lighting.cginc"

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : COLOR0;
			};

			void vert(in a2v v, out v2f o){
				fixed3 camForward = UNITY_MATRIX_V[2].xyz;
				o.pos = UnityObjectToClipPos(v.vertex + _SinTime);
				o.color = (v.normal + camForward) * 0.5 + fixed3(0.5, 0.5, 0.5);
			}
			fixed4 frag(v2f i) : SV_TARGET{
				return fixed4(i.color, 1.0);
			}
			ENDCG
		}
	}
	FallBack "Diffuse"
}