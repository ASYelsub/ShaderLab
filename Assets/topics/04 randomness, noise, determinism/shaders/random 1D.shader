﻿Shader "examples/week 4/random 1D"
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

 //   float samp = dot(uv,float2(128.239,-78.382));
                //very pretty
                 float samp = uv.x + uv.y;
                 samp = frac(sin(samp)*90321);
                return float4(samp.rrr, 1.0);
            }
            ENDCG
        }
    }
}
