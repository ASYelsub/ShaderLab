Shader "examples/week 4/homework"
{
    Properties
    {
        _bandSize ("BandWidth", range(0,1)) = .5
        _bandIntensity("BandIntensity",range(0,1)) = .5
        _lineColor("LineColor",Color)=(0,0,0,0)
        _spaceColor("SpaceColor",Color)=(0,0,0,0)
        _lineLerpColor("LineLerpColor",Color)=(0,0,0,0)
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

            #define TAU 6.28318530718
            float _bandSize;
            float _bandIntensity;
            fixed4 _lineColor;
            fixed4 _spaceColor;
            fixed4 _lineLerpColor;

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
            

            float white_noise (float2 value) {
                return frac(sin(dot(value, float2(128.239, -78.381))) * 90321);
            }
            
            float oscillateCircle(float2 uv){
                return step(sin(_Time.y)*0.5+0.5,1-length(uv));
            }
            
            float rotateAroundCenterUVOffset(float2 uv, float2 gridUV){
                gridUV = white_noise(uv);
                float index = floor(uv.x) + floor(uv.y);
                _bandSize = 1-_bandSize;
                _bandIntensity = 1-_bandIntensity;
                gridUV.x+=sin(_Time.y + index/3) * _bandSize;
                gridUV.y+=cos(_Time.y + index/3) * _bandSize;
                float output = step(_bandIntensity,1-length(gridUV));
                return output;
            }
            float4 frag (Interpolators i) : SV_Target
            {
                float gridSize = 20;
                float2 uv = i.uv;

                uv = uv * gridSize; 
                float2 gridUV = frac(uv) * 2 - 1;

                float t = cos(2*_Time.y);
                t = t/2;
                t = t + .5;
                float t2 = sin(_Time.z);
                float3 result = saturate(rotateAroundCenterUVOffset(uv,gridUV)-rotateAroundCenterUVOffset(uv,gridUV))+_spaceColor;
                result = result + saturate(rotateAroundCenterUVOffset(uv,gridUV))*lerp(_lineColor,_lineLerpColor,t2);
                
                return float4(result.rgb, 1.0);
            }
            ENDCG
        }
    }
}
