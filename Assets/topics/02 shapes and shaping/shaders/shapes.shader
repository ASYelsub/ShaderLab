Shader "examples/week 2/shapes"
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

            float rectangle(float width, float height, float2 uv){
                //shape = step(-size.x,uv.x); //create a boundary on the x, one edge of the box
                float2 size = float2(width/10,height/10); //divide it just because i want it to be bigger numbers

                 float4 shaper = float4(step(-size.x,uv.x),step(-size.y,uv.y),1 - step(size.x,uv.x),1-step(size.y,uv.y));
                float2 shape = shaper.x * shaper.y * shaper.z * shaper.w;
                return shape;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float2 uv = i.uv * 2 - 1;
                float2 shape = 0;


                float2 size = float2(0.5,0.7);
                float4 shaper = float4(step(-size.x,uv.x),step(-size.y,uv.y),1 - step(size.x,uv.x),1-step(size.y,uv.y));
                 

                shape = rectangle(5,6,uv);

                //shape = oscillateCircle(uv);
               // shape = circle(0.2,uv);
               //return float4(uv.x,0,uv.y,0);
                return float4(shape.rrr, 1.0);
            }
            ENDCG
        }
    }
}
