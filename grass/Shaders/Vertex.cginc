#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

void vert(appdata_full i, out FragmentData o) {
  UNITY_INITIALIZE_OUTPUT(FragmentData, o);
  o.pos = i.vertex;
  o.normal = i.normal;
  o.uv = i.texcoord.xy;
  o.bend = i.texcoord.zw;
  o.uvPatch = i.texcoord.xy;
  o.tint = i.color;
  // o.tint = tex2Dlod(_MainTex, i.texcoord);
#ifndef SHADOW_CASTER_PASS
  TRANSFER_VERTEX_TO_FRAGMENT(o);
#endif
}
