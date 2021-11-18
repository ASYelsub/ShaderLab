Shader "Custom/ZoomPostProcess"
{
    Properties
    {
        _circleX("cirlce X pos", float) = 0
        _circleY("cirlce Y pos", float) = 0
        _MainTex ("render texture", 2D) = "white"{}
        _scale("UV Zoom", Range(0,1)) = 1
        _sphereSize("sphere size", Range(0,1)) = .2
    }

    SubShader
    {
        Cull Off
        ZWrite Off
        ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex; float4 _MainTex_TexelSize;
            float _circleX;
            float _circleY;
            float _scale;
            float _sphereSize;

            float circle(float radius, float2 uv){
                return step(1-radius, 1-length(uv));
            }
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
                float3 color = 0;
                float2 uv = i.uv;
                
                uv -= 0.5;
                float2 uv2 = uv;
                float2 uv3 = uv;
                uv2 -= float2(_circleX,_circleY);
                uv2*=_sphereSize;
                uv2 = float2(uv2.x*16,uv2.y*9);
                uv2 = circle(.5,uv2);
                               
                float radius = pow(length(uv),2);

                uv = uv*(1-_scale);
                uv = float2(uv.x+_circleX*_scale,uv.y+_circleY*_scale);
                uv+= 0.5;
                uv3 = uv3 + 0.5;
                color = tex2D(_MainTex, uv3);
                float3 zoomColor = tex2D(_MainTex,uv);

                float3 circle = uv2.rrr*zoomColor;
                float3 notCircle = (1-uv2.rrr)*color;

                float3 final = circle+notCircle;
                return float4(final, 1.0);
            }
            ENDCG
        }
    }
}
