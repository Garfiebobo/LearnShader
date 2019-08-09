
Shader "boboshader/Toon"
{
       Properties
    {
        _Diffuse("Diffuse",Color) = (1,1,1,1)
    }
    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "ForwardBase"}
            Cull Front
            CGPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal:NORMAL;
            };

            struct v2f
            {
                float3 worldNormal:TEXCOORD0;
                float4 pos: SV_POSITION; 
            };

            float4 _Diffuse; 

            v2f vert (appdata v)
            {    
                v2f o;

                // 获取法线
                float3 normal = v.normal;

                // 顶点加 0.0.2 倍的法线
                v.vertex.xyz += normal * 0.02;

                // 转换坐标到裁剪坐标
                o.pos = UnityObjectToClipPos(v.vertex);

                return o;
            }

            float4 frag (v2f i) : SV_Target
            {    
                return fixed4(0,0,0,1);
            }
            ENDCG
        }
         Pass
        {
        
        }

    }
}
