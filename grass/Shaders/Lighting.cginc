#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

UnityLight NewLight (FragmentData i) {
  UnityLight light;
  #if defined(POINT) || defined(SPOT) || defined(POINT_COOKIE)
	  light.dir = normalize(_WorldSpaceLightPos0.xyz - i.worldPos);
  #else
	  light.dir = _WorldSpaceLightPos0.xyz;
  #endif
  // UNITY_LIGHT_ATTENUATION(attenuation, i, i.worldPos);
	light.color = _LightColor0.rgb * SHADOW_ATTENUATION(i);
  light.color *= i.uv.y;
	light.ndotl = DotClamped(i.normal, light.dir);
	return light;
}

UnityIndirect NewIndirect (FragmentData i, float3 viewDir, float smoothness) {
  UnityIndirect indirect;
  indirect.diffuse = 0;
  indirect.specular = 0;
  #if defined(VERTEXLIGHT_ON)
		indirect.diffuse = i.vertexLightColor;
  #endif
  #if defined(FORWARD_BASE_PASS)
    indirect.diffuse += max(0, ShadeSH9(float4(i.normal.xyz, 1)));
    Unity_GlossyEnvironmentData envData;
    envData.roughness = 1 - smoothness;
    envData.reflUVW = reflect(-viewDir, i.normal);
		indirect.specular = Unity_GlossyEnvironment(UNITY_PASS_TEXCUBE(unity_SpecCube0), unity_SpecCube0_HDR, envData);
  #endif
  indirect.diffuse *= i.uv.y;
  // indirect.diffuse = 0;
  // indirect.specular = 0;
  return indirect;
}
