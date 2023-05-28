Shader "AmitSingh/CellShader"
{
Properties
{
_MainColor ("Main Color", Color) = (1,1,1,1)
_VertexColor ("Vertex Color", Color) = (1,1,1,1)
_CellSize ("Cell Size", float) = 0.1
_EdgeWidth ("Edge Width", float) = 0.01
_EdgeColor ("Edge Color", Color) = (1,0,0,1)
}
SubShader
{
Tags { "RenderType"="Opaque" }
LOD 200
CGPROGRAM
#pragma surface surf Standard fullforwardshadows vertex:vert
#pragma target 3.0

sampler2D _MainTex;
fixed4 _MainColor;
fixed4 _VertexColor;
float _CellSize;
float _EdgeWidth;
fixed4 _EdgeColor;

struct Input
{
float2 uv_MainTex;
float3 viewDir;
};

void vert (inout appdata_full v)
{
v.vertex = UnityObjectToClipPos(v.vertex);
v.normal *= sign(dot(v.normal, v.viewDir));
}

void surf (Input IN, inout SurfaceOutputStandard o)
{
fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _MainColor;

// Cell shading
float2 uv = IN.uv_MainTex;
uv *= _CellSize;
uv = floor(uv);
uv /= _CellSize;

// Edge detection
float edge = 1.0 - saturate(abs(uv - 0.5));

// Edge coloring
c *= lerp(_EdgeColor, 1.0, edge);

o.Albedo = c.rgb;
o.Metallic = 0.0;
o.Smoothness = 1.0;
o.Alpha = c.a;

}
ENDCG
}
FallBack "Diffuse"
}
