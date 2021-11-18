Shader "examples/week 11/depth intersection"
{
    Properties {
        _size ("intersection size", Range(0.1,1)) = 0.2
    }

    SubShader
    {
        Tags{"Queue" = "Transparent"}
        Blend One One
        Cull Off //if we view this plane from either direction itll render
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            // declare depth texture
            sampler2D _CameraDepthTexture;
            float _size;

            struct MeshData
            {
                float4 vertex : POSITION;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float4 screenPos : TEXCOORD0;
                float surfZ : TEXCOODRD1;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.screenPos = ComputeScreenPos(o.vertex);

                o.surfZ = (-UnityObjectToViewPos(v.vertex) * _ProjectionParams.w).z; //in vew position the values are relative to the far plane of the camera, multiplying the v.vertex stuff in view pos by projectionparams puts it between 0 and 1 because this is the range of the depth buffer, _ProjectionParams.w = 1/farplane
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float3 color = 0;

                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                float depth = Linear01Depth(tex2D(_CameraDepthTexture, screenUV)); //depth is what's already rendered in the scene on the depth texture
                float difference = abs(depth - i.surfZ);
                
                color = smoothstep(0, _ProjectionParams.w * _size, difference).rrr;
                color = 1-color;

                return float4(color, 1);
            }
            ENDCG
        }
    }
}
