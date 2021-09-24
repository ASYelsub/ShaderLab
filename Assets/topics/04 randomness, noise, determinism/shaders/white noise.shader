Shader "examples/week 4/white noise"
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
                float2 uv = i.uv;
                //uv = floor(uv*200); //do this to pixelize stuff
                uv = floor(uv*600); //find the number for like it to not flicker
                float wn = 0;
                float samp = dot(uv,float2(128.239,-78.382));
                
                wn = frac(sin(samp)*90321);

                //dot product:
                //takes two vectors as input and returns single float
                //between -1 and 1 as output
                //usually take normalized vectors
                //the result is like "how similar are these vectors"
                //the more similar, the closer to 1, the less the closer to -1
                //normalized vector: origin of 0 with length of 1               

                return float4(wn.rrr, 1.0);
            }
            ENDCG
        }
    }
}
