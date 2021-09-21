Shader "examples/week 1/gradient exercise"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 uv = i.uv;
                float3 color = 0;

                // add your code here
                float3 c1 = float3(0.1,0.1,0.6);
                float3 c2 = float3(0.6,0.1,0.1);
                float3 c3 = float3(0.1,0.6,0.1);
                float3 c4 = float3(0.4,0.4,0.7);


                float3 cA = lerp(c1,c2,uv.x);
                float3 cB = lerp(c2,c3,uv.y);
                color = (cA + cB);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
