Shader "AmitSingh /ToonShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color",COLOR)= (1,1,1,1)
        _NormalTex ("Normal Tex", 2D) = "white" {}                          // Normal texture not in used
        _Brightness ("Brightness",Range(0,1))=0.5
        _Strength ("Strength",Range(0,1))=0.5
        _Detail("Detail" ,Range(0,1))=0.3
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
      

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal : NORMAL;
            };

            sampler2D _MainTex;
            sampler2D _NormalTex;                           // normal texture not in used
            float4 _MainTex_ST;
            float4 _Color;
            float _Brightness;
            float _Strength;
            float _Detail;


            float Toon(float3 normal, float3 lightDir)
            {
                float NdotL = max(0.0,dot(normalize(normal), normalize(lightDir)));
              
                return floor(NdotL/ _Detail);

            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

              // o.normal = v.norma;                                                             // for adding normal map, normal strength
               
                o.worldNormal = UnityObjectToWorldNormal(v.normal);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                float3 tangentNormal = tex2D(_NormalTex, i.uv) * 2 - 1;                         // for normal texture function
                
              
                col *= Toon(i.worldNormal, _WorldSpaceLightPos0.xyz)* _Strength* _Color + _Brightness;
                return col;
            }
            ENDCG
        }
    }
}
