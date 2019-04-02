Shader "Custom/Specular_Frag"
{
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1,1,1,1)
		_Gloss("Gloss", Range(8.0, 256)) = 20
	}

		SubShader{
			Pass{
				Tags {"LightMode" = "ForwardBase"}
				CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#include "Lighting.cginc"

				fixed4 _Diffuse;
				fixed4 _Specular;
				float  _Gloss;

				struct a2v {
					float4 vertex : POSITION;
					float3 normal : NORMAL;
				};

				struct v2f {
					float4 pos : SV_POSITION;
					float3 worldNormal : TEXCOORD0;
					float3 worldPos : TEXCOORD1;
				};

				void vert(in a2v i, out v2f o) {
					o.pos = UnityObjectToClipPos(i.vertex); 

					//以下三种计算世界坐标系内法线的方法结果都一样
					//o.worldNormal = normalize(mul(i.normal, (float3x3)unity_WorldToObject));
					//o.worldNormal = normalize(mul((float3x3)unity_ObjectToWorld, i.normal));
					o.worldNormal = UnityObjectToWorldNormal(i.normal);

					o.worldPos = mul(unity_ObjectToWorld, i.vertex).xyz;
				}
				fixed4 frag(v2f i) : SV_TARGET{
					fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

					fixed3 worldNormal = normalize(i.worldNormal);

					fixed3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);

					fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLightDir));

					fixed3 reflectDir = normalize(reflect(-worldLightDir, worldNormal));

					fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);

					fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, viewDir)), _Gloss);
					return fixed4(ambient + diffuse + specular, 1.0);
				}
				ENDCG
			}
	}
		FallBack "Diffuse"
}