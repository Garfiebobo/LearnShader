Shader "boboshader/colorshader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        _PropertyA ("PropertyA",int) =1
    }
    SubShader
    {
        // No culling or depth
    Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;

	        float4 frag (v2f i) : SV_Target
			{
			    // 图片上每个像素的颜色值
				float4 color = tex2D(_MainTex, i.uv);
				
				color.r = 0;
				color.g = 2;
                color.b = 2;
                color.a = 1;
				// 返回颜色，表示将改像素的颜色值输出到屏幕上
				return color;
			}
            ENDCG
        }
    }
}
