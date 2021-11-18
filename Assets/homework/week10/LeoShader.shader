Shader "examples/week 10/LeoShader"
{
    Properties 
    {
        _MainTex ("render texture", 2D) = "white"{}
        _AbsRedThreshold ("red threshold", Range(0,1)) = 0.4
        _RelativeRedThreshold ("red threshold", Range(0,2)) = 1

    }
    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTex;
            float _AbsRedThreshold;
            float _RelativeRedThreshold;

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
                float3 color = 0;
                float2 uv = i.uv;
                
                
                color = tex2D(_MainTex, uv);

                float IsRed = step(_AbsRedThreshold,color.r) * step(_RelativeRedThreshold , color.r/(color.g + color.b));

                float3 redparts = IsRed * color * float3(1, 0.3, 0.3);

                float3 grayscaleReference = float3(0.299, 0.587, 0.114);

                float grayscale = dot(color, grayscaleReference);

                return float4(redparts * IsRed + grayscale * (1 - IsRed), 1.0);
            }
            ENDCG
        }
    }
}
