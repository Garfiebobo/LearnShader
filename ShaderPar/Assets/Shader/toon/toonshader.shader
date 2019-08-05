
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
            
            //定义 v2f 结构体
            struct v2f
            {
                // SV_POSITION:描述的变量存储物体顶点在屏幕坐标上的位置
                // SV_POSITION:描述裁剪空间中的顶点坐标
                float4 pos: SV_POSITION; 
                float3 worldNormal : TEXCOORD0;     // COLOR 告诉 Shader，color存储的是顶点颜色
            };
  
            float4 _Diffuse;
  
            //顶点着色器
            v2f vert (appdata v)
            {
                    v2f o;

                    o.pos = UnityObjectToClipPos(v.vertex);

                    // 表面法线                
                    o.worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                    return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                // 环境光
                fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                // 顶点到光源方向                
                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);
                
                float NdotL = dot(i.worldNormal, worldLight);

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

                // Cdiffuse = (Clight * Mdiffuse)max(0,N^*L^)
                fixed3 diffuse =_LightColor0.rgb * _Diffuse.rgb * NdotL;
                return fixed4(ambient + diffuse,1.0);
            }
            ENDCG

        }
    }
}
