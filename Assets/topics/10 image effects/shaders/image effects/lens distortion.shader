Shader "examples/week 10/lens distortion"
{
    Properties
    {
        _MainTex ("render texture", 2D) = "white"{}
        _distortion("UV Distortion", Range(-1,1)) = -0.5
        _scale("UV Zoom", Range(0,3)) = 1
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
            float _distortion;
            float _scale;

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

                uv -= 0.5; //makes range between -.5 and .5 with 0 in the center

                float radius = pow(length(uv),2);

                float distort = 1 + radius * _distortion;
                uv = uv*distort*_scale + 0.5; //adding 0.5 brings it back into 0-1 scale

                color = tex2D(_MainTex, uv);

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
