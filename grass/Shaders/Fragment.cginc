float4 _MainTex_ST;

half4 frag (FragmentData i) : COLOR {
  float4 diffuse = tex2D(_MainTex, TRANSFORM_TEX(i.uv, _MainTex));
  clip(diffuse.a - _Cutoff);
#if defined(SHADOW_CASTER_PASS)
  return 0;
#else
  float metallic = _Metallic;
  float smoothness = _Glossiness;
  float3 normal = i.normal;
  float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
  if (dot(i.normal, viewDir) < 0)
    i.normal = -i.normal;
  float oneMinusReflectivity;
  float3 specular;
  diffuse.rgb = DiffuseAndSpecularFromMetallic(diffuse.rgb, metallic, specular, oneMinusReflectivity);
  UnityLight light = NewLight(i);
  float4 color = UNITY_BRDF_PBS(
    diffuse.rgb,
    specular,
    oneMinusReflectivity,
    smoothness,
    i.normal,
    viewDir,
    light,
    NewIndirect(i, viewDir, smoothness)
  );
  return color;
#endif
}
