// the ElectricLightSweep shader is modified for UI masking so that it is maskable in ui Mask.

Shader "AmitSingh/UI/ElectricLightSweep"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_MainColor("Color", Color) = (0.3,0.4,0.9,1)
		_XFactor("X Factor", Range(-50, 50)) = 1
		_YFactor("Y Factor", Range(-50, 50)) = 1
		_LightSpeed("Light Speed", Range(-100.0, 100.0)) = 10.0
		_RunCounter("Run Counter", Range(0,1000)) = 0
		_DFactor("D Factor", Range(0.01,10)) = 1
		_MFactor("M Factor", Range(0.01,10)) = 3
		_SFactor("S Factor", Range(0.01,10)) = 2.8
		_BrightnessFactor("Brightness Factor", Range(-50.0, 500.0)) = 40
		_BarWidth("Bar Width", Range(0.0, 5000.0)) = 20
		_ClipFactor("Clip Factor", Range(0.0,1.0)) = 0.0
		_Inverse("Clip Inverse", Range(0.0,1.0)) = 0.0
			// Added Stencil Properties for adding per pixel Mask																					
		[HideInInspector] _StencilComp("Stencil Comparison", Float) = 8
        [HideInInspector] _Stencil("Stencil ID", Float) = 0
        [HideInInspector] _StencilOp("Stencil Operation", Float) = 0
        [HideInInspector] _StencilWriteMask("Stencil Write Mask", Float) = 255
        [HideInInspector] _StencilReadMask("Stencil Read Mask", Float) = 255
        [HideInInspector] _ColorMask("Color Mask", Float) = 15

        [Toggle(UNITY_UI_ALPHACLIP)] _UseUIAlphaClip ("Use Alpha Clip", Float) = 0
																								
    }
    SubShader
    {
        Tags {
		"RenderType" = "Transparent"
		"Queue" = "Transparent"
		"IgnoreProjector"="True"													//
		"PreviewType"="Plane"														// 
		"CanUseSpriteAtlas"="True" }												//
															//
		 Stencil
        {
            Ref [_Stencil]
            Comp [_StencilComp]
            Pass [_StencilOp]
            ReadMask [_StencilReadMask]
            WriteMask [_StencilWriteMask]
        }
															//
															//
		Cull Off
        Lighting Off
        ZTest [unity_GUIZTestMode]
        ColorMask [_ColorMask]
															//
	
        Pass
        {
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
			#pragma target 2.0							//

            #include "UnityCG.cginc"
			#include "UnityUI.cginc"					//

			#pragma multi_compile_local _ UNITY_UI_CLIP_RECT			//
            #pragma multi_compile_local _ UNITY_UI_ALPHACLIP			//

			struct VertexInput
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
				float4 tangent : TANGENT;
				float3 normal : NORMAL;
			};


			struct VertexOutput
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float4 color    : COLOR;			//
				float4 worldPosition : TEXCOORD1;	//
				 UNITY_VERTEX_INPUT_INSTANCE_ID		//
			};
														//
			fixed4 _TextureSampleAdd;
			float4 _ClipRect;
			float4 _MainTex_ST;
													//
            sampler2D _MainTex;
            float4 _MainColor;
			float  _XFactor, _YFactor, _LightSpeed, _RunCounter, _BrightnessFactor, _DFactor, _MFactor, _SFactor, _BarWidth, _ClipFactor;
			float _ColBrightness, _MainReduction, _Inverse;

			VertexOutput vert(VertexInput v)
			{
				VertexOutput o;
				UNITY_SETUP_INSTANCE_ID(v);					//
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(OUT);	//
				o.worldPosition = v.vertex;					//
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX (v.uv , _MainTex);		//
			//	o.uv = v.uv;
				o.color = _MainColor;						//
				return o;
			}

																				

			float4 frag(VertexOutput i) : SV_Target
			{
				// Main texture that will be used to render everything on 
		//		float4 col = tex2D(_MainTex, i.uv);
				float4 col = (tex2D(_MainTex, i.uv) + _TextureSampleAdd) * i.color;			//
																						//
				 #ifdef UNITY_UI_CLIP_RECT
                _MainColor.a *= UnityGet2DClipping(i.worldPosition.xy, _ClipRect);
                #endif

				#ifdef UNITY_UI_ALPHACLIP
                clip (_MainColor.a - 0.001);
                #endif
																						//

				float time = fmod(_Time.y,1000) * _LightSpeed;

				time = _RunCounter + (abs(sign(_RunCounter) - 1) * time);
			
				float2 uv = i.uv;
				float sbXYval = (uv.y * _YFactor) + (uv.x * _XFactor) - (time * 0.1);
				float sc = ((sin(sbXYval / _DFactor) * _MFactor) - _SFactor) * (1/_BarWidth) * 0.1;
				sc = abs(sc);

				float3 col3 = (_MainColor.rgb * 0.00001) / sc ;
				col3 *= (_BrightnessFactor);

				if ((col.r + col.g + col.b) > _ClipFactor)
				{
					col.rgb += col3;
					if (_Inverse > 0.5)
					{
						col.rgb *= col3;
					}
					else
					{
						col.rgb += col3;
					}
				}

				return col;

            }
            ENDCG
        }
    }
}
