Shader "examples/week 5/homework"
{
    Properties
    {
        _color ("color", Color) = (0, 0, 0.8, 1)
        _color2 ("color2", Color) = (0, 0, 0.8, 1)
        _scale ("noise scale", Range(2, 100)) = 15.5
        _displacement ("displacement", Range(0, 0.3)) = 0.05
        _speed("undulate speed", Range(0,4)) = 1
        _vec("a lerp number",Range(0,1))=0
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

            float3 _color;
            float3 _color2;
            float _scale;
            float _displacement;
            float _speed;

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float3 color : COLOR;
                float2 uv : TEXCOORD1;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
                float wave : TEXCOORD0;
                float2 uv : TEXCOORD1;
            };


            float easeInQuart(float x){
            return x * x * x * x;
            }   

            float easeOutCubic(float x) {
            return 1 - pow(1 - x, 3);
            }
           

            
            float wave (float2 uv) {
                
                
                float scale = _scale;
                scale = scale * sin(_Time.z*_speed);
     
              
                
                //float neutral = easeInQuart(1-abs(uv.x+uv.y))*5 + abs(scale)/7;
                //float neutral2 = easeInQuart(1-abs(uv.x-uv.y))*5 + abs(scale)/7;
                float spike = (1-abs((uv.x+uv.y) * scale)) + abs(scale)/7;
                float spike2 = (1-abs((uv.x-uv.y)*scale))+abs(scale)/7;
                
                return (spike*spike2) / 3;
            }

            Interpolators vert (MeshData v)
            {
                Interpolators o;

                float3 worldPos = mul(unity_ObjectToWorld,v.vertex);

                float2 worldUV = worldPos.xz * 0.02;
                
                float displacement = wave(worldUV) * _displacement;
                
                
                o.wave = displacement * v.color;
                
                float val1 = (o.wave);
                float val2 = (1-o.wave);
                v.vertex.y += lerp(val1,val2,sin(_Time.z*_speed)*.5+.5);

                o.vertex = UnityObjectToClipPos(v.vertex);

                return o;
            }

            float4 frag (Interpolators i) : SV_Target
            {
                float3 color = 0;
                float3 color2 = _color2;
                color = saturate((i.wave)*_color);
                color2 = saturate(1-(i.wave+1-color2));
               
                //color = color+color2;
                return float4(color+color2, 1.0);
            }
            ENDCG
        }
    }
}
