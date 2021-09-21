Shader "examples/week 2/shaping"
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
                //defining the space
                float2 uv = i.uv;



                //moving the canvas around
                uv = uv * 2 - 1; //substract from range to get [-0.5,0.5] and then multiply by two to get it from [-1,1]
                                        //or uv = (uv-0.5)*2


                uv *= 10;                    
                float x = uv.x;
                float y = uv.y;

              //  float c = sin(x);
               // c = cos(x);
                //c = abs(x);
                //c = ceil(x);
                //c = min(x,y); //when y is greater that space will be white
                //c = sign(x); //returns 0 or 1 if input value is pos or neg
                //c = smoothstep(-0.1,0.1,x); //anything below min is gonna be black, anything above max is gonna be white, in between is gonna be a gradient

                float3 c1 = float3(0.3,0.8,0.2);
                float3 c2 = float3(0.9,0.2,0.4);

                return float4(lerp(c1,c2,sin(x)),1);
                    
            //return float4(uv.x,0.0,uv.y,1); //returns color visuals of the bw gradient
             //   return float4(c.rrr, 1.0);
            }
            ENDCG
        }
    }
}
