﻿Shader "examples/week 4/texture mapping"
{
    Properties
    {
        _tex ("my great texture", 2D) = "white"{} 
        //for normal, default is "bump"
    }

    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"


            sampler2D _tex; float4 _tex_ST;

            struct MeshData
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float4 screenPos : TEXCOORD2;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);
               
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 uv = i.uv;
                
                //for worldpos
                 //have texture stay in same place, like chowder!
                 uv=i.worldPos;
               
              //  uv = i.screenPos; //for screenpos
                float3 color = 0;


            //for worldpos
                color = tex2D(_tex, TRANSFORM_TEX(i.worldPos,_tex));
                //for screenpos
              //  color = tex2D(_tex, TRANSFORM_TEX(i.screenPos,_tex));
                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
