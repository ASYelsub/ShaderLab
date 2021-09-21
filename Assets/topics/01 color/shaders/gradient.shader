Shader "examples/week 1/gradient"
{
    SubShader
    {
        //Do you HAVE to tag a shader?
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

            struct Interpolators //define in here the data that is outputted from the vert function
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
                float2 uv = i.uv; //getting UV data from the vertex shader and from the mesh
                float3 color = float3(uv.x, 0.0, uv.y);
                
                color = uv.yyy; //"swizzeling"

                float3 colorX = float3(0.1,0.1,0.3);
                float3 colorY = float3(0.3,0.1,0.1);

                float3 gradientX = lerp(colorX,colorY,uv.x);
                float3 gradientY = lerp(colorX,colorY,uv.y);
              //  color = (uv.xxx + uv.yyy)*.5; //black and white diagonal gradient

               // color = smoothstep(0,1,uv.xxx+uv.yyy);
                color = (gradientX + gradientY);
                //color = color * float3(2,1,0); //can multiply each component separately

                color = color/2;

                return float4(color, 1);
            }
            ENDCG
        }
    }
}
