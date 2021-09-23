Shader "examples/week 2/homework"
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
            #define TAU 6.2831853

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
                
                float2 uv = i.uv * 2 - 1;
                float time = 0;
                time = 0 + _Time.x;
                int circleCount = 150;
                float spacer = .05;
                float circles = 0;
                float radius = .01;
                for(int i = 1; i < circleCount; i++) {
                    float2 newUV = uv;
                    newUV.x += sin(time + sqrt(i)*3) * 0.2 * i * spacer;
                    newUV.y += cos(time + sqrt(i)*3) * 0.2 * i * spacer;
                    circles += step(1-radius * sqrt(i)/5, 1-length(newUV));
                 }
                for(int i = 1; i < circleCount; i++) {
                    float2 newUV = uv;
                    newUV.x -= sin(time + sqrt(i)*3) * 0.2 * i * spacer;
                    newUV.y -= cos(time + sqrt(i)*3) * 0.2 * i * spacer;
                    circles += step(1-radius * sqrt(i)/2 * cos(_Time.y + sqrt(i))*2, 1-length(newUV));
                }
               
                return float4(circles.r,.2,.5, 1);
            }
            ENDCG
        }
    }
}
