
void sendPoint (inout TriangleStream<FragmentData> ts, FragmentData i, float3 pos, float2 uv) {
  i.worldPos = mul(unity_ObjectToWorld, pos);
  i.pos = UnityObjectToClipPos(pos);
  i.normal = i.normal;
  i.uvPatch = i.uvPatch;
  i.tint = i.tint;
  i.uv = uv;
#ifndef SHADOW_CASTER_PASS
  TRANSFER_VERTEX_TO_FRAGMENT(i);
#endif
  ts.Append(i);
}

void sendQuad (inout TriangleStream<FragmentData> ts, in FragmentData i,
               float3 p1, float3 p2, float3 p3, float3 p4) {
  sendPoint(ts, i, p1, float2(1, 0));
  sendPoint(ts, i, p2, float2(1, 1));
  sendPoint(ts, i, p3, float2(0, 0));
  sendPoint(ts, i, p4, float2(0, 1));
  ts.RestartStrip();
}

float3 rotate (float3 v, float a) {
  return float3(v.x * cos(a) - v.z * sin(a),
                v.y,
                v.z * cos(a) + v.x * sin(a));
}

void sendQuad (inout TriangleStream<FragmentData> ts, in FragmentData i, float3 v0, float3 v1, float3 side) {
  float3 up = i.normal * _GrassHeight;
  side *= _GrassWidth * 0.5;
  // float3 bend = float3(pow(i.bend, 2), 0);
  float crush = tex2Dlod(_CrushMap, float4(i.uvPatch, 0, 0)).g;
  v1 *= lerp(1, 0.25, crush);
  v1 *= 0.75 + lerp(0, 0.25, i.bend.y);
  v1 = normalize(v1 + float3(1, 0, 0) * pow(i.bend.x, 2)) * length(v1);
  v1 += v0;
  sendQuad(ts, i,
           v0 + side,
           v1 + side,
           v0 - side,
           v1 - side
           );
  ts.RestartStrip();
}

void sendGrass (inout TriangleStream<FragmentData> ts, in FragmentData i) {
  float3 lightPosition = _WorldSpaceLightPos0;
  float3 v0 = i.pos.xyz - float3(0.0, 0.1f, 0);
  float3 v1 = i.normal * _GrassHeight;
  i.normal = cross(float3(0, 0, 1), i.normal);
  float3 wind = float3(
    sin(_Time.x * _WindSpeed + v0.x) + sin(_Time.x * _WindSpeed + v0.z * 2) + sin(_Time.x * _WindSpeed * 0.1 + v0.x),
    0,
    cos(_Time.x * _WindSpeed + v0.x * 2) + cos(_Time.x * _WindSpeed + v0.z)
  );
  v1 += wind * _WindStength;
  float sin30 = 0.5;
  float sin60 = 0.866f;
  float cos30 = sin60;
  float cos60 = sin30;
  sendQuad(ts, i, v0, v1, rotate(float3(1, 0, 0), i.tint.a));
  sendQuad(ts, i, v0, v1, rotate(float3(1, 0, 0), i.tint.a + 1.0472));
  sendQuad(ts, i, v0, v1, rotate(float3(1, 0, 0), i.tint.a + 2.0944));
}

[maxvertexcount(24)]
#if defined(SHADER_API_GLCORE) || defined(SHADER_API_VULKAN)
void geom(triangle FragmentData IN[3], inout TriangleStream<FragmentData> ts) {
  sendGrass(ts, IN[0]);
  sendGrass(ts, IN[1]);
  sendGrass(ts, IN[2]);
}
#else
void geom(point FragmentData IN[1], inout TriangleStream<FragmentData> ts) {
  sendGrass(ts, IN[0]);
}
#endif
