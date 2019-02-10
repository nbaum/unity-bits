#include "UnityCG.cginc"
#include "AutoLight.cginc"

half _Glossiness;
half _Metallic;
fixed4 _TopColor;
fixed4 _BottomColor;
half _GrassHeight;
half _GrassWidth;
half _Cutoff;
half _WindStength;
half _WindSpeed;

UNITY_INSTANCING_BUFFER_START(Props)
UNITY_INSTANCING_BUFFER_END(Props)

sampler2D _MainTex;
sampler2D _CrushMap;

struct FragmentData {
  float4 pos : SV_POSITION;
  float3 normal : NORMAL;
  float2 uv : TEXCOORD0;
  float4 tint : TEXCOORD1;
  float4 worldPos : TEXCOORD2;
// #if defined(VERTEXLIGHT_ON)
//   float3 vertexLightColor : TEXCOORD3;
// #endif
#if defined(SHADOWS_SCREEN)
  SHADOW_COORDS(4)
#endif
  float flatness : TEXCOORD5;
  float2 uvPatch : TEXCOORD6;
  float2 bend : TEXCOORD7;
};
