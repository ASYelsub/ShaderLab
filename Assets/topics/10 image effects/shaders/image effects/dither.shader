Shader "examples/week 10/dither"
{
    Properties
    {
        _MainTex ("render texture", 2D) = "white" {}
        _ditherPattern ("dither pattern", 2D) = "gray" {}
        _threshold("dither midpoint", Range(-0.5,0.5)) = 0
        _color1 ("color1", Color) = (0,0,0,0)
        _color2 ("color2", Color) = (0,0,0,0)
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

            sampler2D _MainTex; float4 _MainTex_TexelSize; //texel = pixel in the texture, helps distinction between pixel on screen and pixel in texture 
            sampler2D _ditherPattern; float4 _ditherPattern_TexelSize; // z & w are height and width of texels in texure //x & y are 1/z and 1/w
            float _threshold;
            float3 _color1;
            float3 _color2;

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
                

                //if you divide this by 2 it gets more like obra dinn
                float2 ditherUV = (uv / _ditherPattern_TexelSize.zw)*_MainTex_TexelSize.zw; //makes uv's 0/256 and 1/256 aka .0039 //uv space is now size of one texel, multiplying by maintex_texelsize.zw scales up to screen resolution, which is 1080, the result is 4.218something, texture is going to tile 4.2 times in the x direction, which makes it so every texel perfectly matches a pixel across the screen
                float ditherPattern = tex2D(_ditherPattern,ditherUV).r;

                float3 grayScaleLuminence = float3(0.299,0.587,0.144);
                color = dot(tex2D(_MainTex,uv),grayScaleLuminence);

                //this is the actual dithering part//
                float threshold = dot(ditherPattern,grayScaleLuminence);

                float3 c1 =saturate(step(threshold, color + _threshold)*_color1);
                float3 c2 = saturate((1-step(threshold, color + _threshold))*_color2);
                color = c1+c2;

                return float4(color, 1.0);
            }
            ENDCG
        }
    }
}
