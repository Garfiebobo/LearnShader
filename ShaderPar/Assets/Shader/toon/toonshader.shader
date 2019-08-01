
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
                float4 pos: SV_POSITION; 
                float3 color : Color;
            };

            float4 _Diffuse;

            v2f vert (appdata v)
            {
                v2f o;

                o.pos = UnityObjectToClipPos(v.vertex);

                o.color =_Diffuse; // 绿色
           
            fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

                fixed3 worldNormal = normalize(mul(v.normal,(float3x3)unity_WorldToObject));

                fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

                fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, worldLight));

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
