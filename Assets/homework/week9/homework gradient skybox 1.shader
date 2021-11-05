Shader "examples/week 9/homework gradient skybox"
{
    Properties 
    {
        _colorHigh ("color high", Color) = (1, 1, 1, 1)
        _colorMid ("color mid", Color) = (0, 0, 0, 1)
        _colorLow ("color low", Color) = (0, 0, 0, 1)
        _offset ("offset", Range(0, 1)) = 0
        _contrast ("contrast", Range(1,50)) = 10
        _noisePattern("noise pattern", Range(1,500)) = 10
        _steps("steps", Int) = 4
    }

    SubShader
    {
        Tags { "Queue" = "Background" "RenderType" = "Background" "PreviewType" = "Skybox" }
        Cull off
        Zwrite off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float3 _colorHigh;
            float3 _colorMid;
            float3 _colorLow;
            float _offset;
            float _contrast;
            float _noisePattern;
            int _steps;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 uv : TEXCOORD0;
            };


            float white_noise (float2 value) {
                return frac(sin(dot(value, float2(128.239, -78.381))) * 90321);
            }

             float rand (float2 uv) {
                return frac(sin(dot(uv.xy, float2(12.9898, 78.233))) * 43758.5453123);
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float3 colorL = _colorLow;
                float3 colorM = _colorMid;
                float3 colorH = _colorHigh;
                float3 uv = normalize(i.uv)*0.5+0.5;

                colorH = white_noise(i.vertex/_noisePattern) * colorH;
                colorH = colorH + (1-white_noise(i.vertex/_noisePattern))*colorM;

                float l = smoothstep(0,1,pow(saturate(uv.y + _offset), _contrast));

                float lSteps = max(2,_steps);

                l = floor(l * lSteps)/lSteps;

                float3 color = lerp(colorL,colorM,l);
                 color = lerp(color,colorH, smoothstep(0,1,uv.y));
                
                
                return float4(color,1);
            }
            ENDCG
        }
    }
}
