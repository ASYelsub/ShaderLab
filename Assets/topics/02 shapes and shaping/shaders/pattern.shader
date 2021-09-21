Shader "examples/week 2/pattern"
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

            float circle(float radius, float2 uv){
                return step(1-radius, 1-length(uv));
            }
            float oscillateCircle(float2 uv){
                return step(sin(_Time.y)*0.5+0.5,1-length(uv));
            }

            float rotateAroundCenter(float2 uv){
                uv.x+=sin(_Time.y) * 0.5;
                uv.y+=cos(_Time.y) * 0.5;
                float output = step(0.5,1-length(uv));
                return output;
            }
            float rotateAroundCenterUVOffset(float2 uv, float2 gridUV){
                float index = floor(uv.x) + floor(uv.y); //variation between each cell, will correspond to the cell position
                gridUV.x+=sin(_Time.y + index/3) * 0.5;
                gridUV.y+=cos(_Time.y + index/3) * 0.5;
                float output = step(0.5,1-length(gridUV));
                return output;
            }
            float4 frag (Interpolators i) : SV_Target
            {
                float output = 0;
                float gridSize = 40;
                float2 uv = i.uv;

                uv = uv * gridSize; //to scale the uv space multiply it by gridSize;
                float2 gridUV = frac(uv) * 2 - 1; //remapping uv inside of each cell now
            

                output = rotateAroundCenterUVOffset(uv,gridUV);
                //output = oscillateCircle(gridUV);
                //return float4(gridUV.x,0,gridUV.y,1);
                return float4(output.rrr, 1.0);
            }
            ENDCG
        }
    }
}
