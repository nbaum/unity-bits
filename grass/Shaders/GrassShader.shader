Shader "Plenary/Old Grass" {

	Properties {
		[HDR] _TopColor("Top Color", Color) = (1,0,0,1)
		[HDR] _BottomColor("Bottom Color", Color) = (0,0,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Cutoff("Cutoff", Range(0,1)) = 0.1
		_GrassHeight("Grass Height", Float) = 0.25
		_GrassWidth("Grass Width", Float) = 0.25
		_WindSpeed("Wind Speed", Float) = 100
		_WindStength("Wind Strength", Float) = 0.05
		_CrushMap("Crush Map", 2D) = "black" {}
	}

	SubShader {
		Cull Off
		Pass {
			Tags {
				"LightMode" = "ForwardBase"
			}
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma geometry geom
				#pragma multi_compile_fwdbase
				#pragma target 5.0
				#define FORWARD_BASE_PASS
				#include "Properties.cginc"
				#include "Lighting.cginc"
				#include "Geometry.cginc"
				#include "Vertex.cginc"
				#include "Fragment.cginc"
			ENDCG
		}
		// Pass {
		// 	Tags {
		// 		"LightMode" = "ForwardAdd"
		// 	}
		// 	CGPROGRAM
		// 		#pragma vertex vert
		// 		#pragma fragment frag
		// 		#pragma geometry geom
		// 		#pragma multi_compile DIRECTIONAL DIRECTIONAL_COOKIE POINT POINT_COOKIE SPOT
		// 		#pragma multi_compile_fwdadd_fullshadows
		// 		#pragma target 5.0
		// 		#define FORWARD_ADD_PASS
		// 		#include "Properties.cginc"
		// 		#include "Lighting.cginc"
		// 		#include "Geometry.cginc"
		// 		#include "Vertex.cginc"
		// 		#include "Fragment.cginc"
		// 	ENDCG
		// }
		Pass {
			Tags {
				"LightMode" = "ShadowCaster"
			}
			CGPROGRAM
				#pragma vertex vert
				#pragma fragment frag
				#pragma geometry geom
				#pragma target 4.0
				#pragma multi_compile_shadowcaster
				#define SHADOW_CASTER_PASS
				#include "Properties.cginc"
				// #include "Lighting.cginc"
				#include "Geometry.cginc"
				#include "Vertex.cginc"
				#include "Fragment.cginc"
			ENDCG
		}
	}
}
