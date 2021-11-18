Shader "examples/week 11/depth"
{
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _CameraDepthTexture;
            struct MeshData
            {
                float4 vertex : POSITION;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD0;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float3 color = 0;
                float2 screenUV = i.screenPos.xy / i.screenPos.w; //do this when using a perspective camera (it distorts the screen position), fixes it, computescreenpos creates it
                float depth = tex2D(_CameraDepthTexture,screenUV);
                depth = Linear01Depth(depth); //making it so the change moving through depth is linear because unity automatically makes stuff less detailed farther away
                color = depth.rrr + float3(.3,.1,.2);


                return float4(color, 1.0);
            }
            ENDCG
        }
    }
    FallBack "Diffuse" //has shadowcaster pass built in 
}
