Shader "examples/week 6/homework"
{
    Properties
    {
        _color ("color", Color) = (0, 0, 0.8, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" "Queue" = "Transparent" }
        
        Blend SrcAlpha OneMinusSrcAlpha
		ZWrite off
        

        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

           float3 _color;
            

            
            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float4 color : COLOR;
              
            };

        
            

            Interpolators vert (MeshData v)
            {
                Interpolators o;
                o.color = v.color;
                o.vertex = v.vertex;
                    
        
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                o.normal = v.normal;

                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float3 color = i.color;
                float a1 = 1-color.g;
                float a2 = color.g;

                float alph = lerp(a1,a2,sin(_Time.z)*.5 + .5);

                
                
                
                return float4(color, alph);
            }
            ENDCG
        }
    }
}
