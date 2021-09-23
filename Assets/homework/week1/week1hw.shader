Shader "examples/week 1/homework template"
{
    Properties
    {
        [NoScaleOffset] _base ("base", 2D) = "white" {}
        [NoScaleOffset] _blend ("blend", 2D) = "white" {}
        [NoScaleOffset] _mask ("mask", 2D) = "white" {}
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
            uniform sampler2D _base;
            uniform sampler2D _blend;
            uniform sampler2D _mask;
            
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
                // sample the color data from each of the three textures and store them in float3 variables
                float3 base = tex2D(_base, uv).rgb;
                float3 blend = tex2D(_blend, uv).rgb;
                float3 mask = tex2D(_mask, uv).rgb;
                float3 color = 0;
                // add your code here


                color = saturate(normalize(round(base))) * (mask+mask) + (frac(blend+blend)*(1-mask));

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}