
Shader "boboshader/Toon"
{
       Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
    }
    SubShader
    {
        //Cull Off ZWrite Off ZTest Always
        Pass
        {
            Tags { "LightMode" = "ForwardBase"}

            CGPROGRAM

            #pragma vertex vert 
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                // SV_POSITION:描述的变量存储物体顶点在屏幕坐标上的位置
                // SV_POSITION:描述裁剪空间中的顶点坐标
                float4 pos: SV_POSITION; 
                float3 color : Color;     // COLOR 告诉 Shader，color存储的是顶点颜色
            };

            float4 _Diffuse;

            v2f vert (appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.color =_Diffuse; // 绿色
                  // 环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                // 表面法线   
                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));
                // 顶点到光源方向  
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                float NdotL = saturate(dot(worldNormal, worldLight));

                if (NdotL > 0.9)
                {
                    NdotL = 1;
                } 
                else if (NdotL > 0.5)
                {
                    NdotL = 0.6;
                } 
                else 
                {
                    NdotL = 0;
                }

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * NdotL;

                o.color = ambient + diffuse;
           
                return o;
           
            }

            float4 frag (v2f i) : SV_Target
            {
                  return fixed4(i.color,1.0);
            }
            ENDCG

        }
    }
}
