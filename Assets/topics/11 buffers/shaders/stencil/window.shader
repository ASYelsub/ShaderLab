Shader "examples/week 11/window"
{
    Properties {
        _stencilRef("stencil reference number", Int) = 1
    }

    SubShader
    {

        Tags {"Queue" = "Geometry-1"}//have to make sure this renders first so it can write to the stencil buffer and then the teapot reads the stencil buffer
        ZWrite Off //makes it so it wont write to the depth buffer
        ColorMask 0 //tells unity to not output any colors for the pixel

        Stencil{
            //Ref is short of reference, think of it as a variable declaration?
            //Might use ref to write to the stencil buffer or might use it to check to the stencil buffer.
            Ref [_stencilRef] //
//          Comp Greater //will pass if value is greater than value in stencil buffer
            Comp Greater //want the window to always render to the stencil buffer
            Pass Replace //pass = additional operation preformed if comp passes //replace = replace value in stencil buffer with reference vlaue
        }

        // nothing new below
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
            };

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                return 0;
            }
            ENDCG
        }
    }
}
