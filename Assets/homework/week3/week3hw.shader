Shader "examples/week 3/homework"
{
    Properties 
    {
        _hour ("hour", Float) = 0
        _minute ("minute", Float) = 0
        _second ("second", Float) = 0
        _secondColor("second color", Color) = (0,0,0,0)
        _minuteColor("minute color", Color) = (0,0,0,0)
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

            float _hour;
            float _minute;
            float _second;


            float4 _minuteColor;
            float4 _secondColor;

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
            
            float circle (float2 uv, float size) {
                return smoothstep(0.0, 0.005, 1 - length(uv) / size);
            }

            float rectangle (float2 uv, float2 scale) {
                float2 s = scale * 0.5;
                float2 shaper = float2(step(-s.x, uv.x), step(-s.y, uv.y));
                shaper *= float2(1-step(s.x, uv.x), 1-step(s.y, uv.y));
                return shaper.x * shaper.y;
            }
            
            float2x2 rotate2D (float angle) {
                return float2x2 (
                    cos(angle), -sin(angle),
                    sin(angle),  cos(angle)
                );
            }

            float3 secondHandShape(float2 newUV){
                float2 secondShape = 0;
              
              float secondRad = 100 * (_second/120);
              secondRad = ceil(secondRad);
              secondRad = secondRad/100;
              secondRad = sin(secondRad);
              secondShape = circle(newUV,secondRad);
              float3 secondResult = secondShape.rrr;
              return secondResult;
            }

            float3 minuteHandShape(float2 newUV){
                float2 minuteShape = 0;
                
                float2 polarUV1 = (atan2(newUV.y, newUV.x) / TAU) + 0.25;
                float2 polarUV2 = (atan2(newUV.y, newUV.x) / TAU) + 0.5;
                float2 polarUV3 = (atan2(newUV.y, newUV.x) / TAU) + .75;	        	
                float2 polarUV4 = (atan2(newUV.y, newUV.x) / TAU) + 1;
                

                float polarUV = polarUV1 + polarUV2 + polarUV3 + polarUV4;
                
                polarUV = frac(polarUV + (_minute / 60) + 0.25);
                float3 result = (polarUV * 0.233);
                result = rectangle(result * 0.333,.01);
               // result = result-secondHandShape(newUV);
                result = floor(result);
                
                return result;
           }
           
            float4 frag (Interpolators i) : SV_Target
            {
                float2 uv = i.uv * 2 - 1;
                //subtracting the circle shape and making the lines teal
                float3 result =  saturate(minuteHandShape(uv)-secondHandShape(uv))*_minuteColor; 
                //it SHOULD be adding the circle shape with its color but???
                result = result + saturate(secondHandShape(uv))*_secondColor;
                return float4(result.rgb, 1.0);
            }
            ENDCG
        }
    }
}
