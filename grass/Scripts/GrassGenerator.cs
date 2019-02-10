using System.Collections;
using System.Collections.Generic;
using System.Linq;

using UnityEngine;

[ExecuteInEditMode]
[RequireComponent(typeof(MeshFilter))]
[RequireComponent(typeof(MeshRenderer))]
public class GrassGenerator : MonoBehaviour {

  public int seed;
  public Vector2 size;

  [Range(1, 60000)]
  public int grassNumber;

  public float startHeight = 1000;
  public float grassOffset = 0.0f;

  private Vector3 lastPosition;

  void OnValidate() {
    lastPosition = Vector3.zero;
  }

  void Update() {
    var grassNumber = this.grassNumber - this.grassNumber % 3;
    if (lastPosition != this.transform.position) {
      Random.InitState(seed);
      List<Vector3> positions = new List<Vector3>(grassNumber);
      List<int> indices = new List<int>(grassNumber);
      List<Color> colors = new List<Color>(grassNumber);
      List<Vector3> normals = new List<Vector3>(grassNumber);
      List<Vector4> uvs = new List<Vector4>(grassNumber);
      for (int i = 0; i < grassNumber; ++i) {
        Vector3 origin = transform.position;
        origin.y = startHeight;
        origin.x += size.x * Random.Range(-0.5f, 0.5f);
        origin.z += size.y * Random.Range(-0.5f, 0.5f);
        Ray ray = new Ray(origin, Vector3.down);
        RaycastHit hit;
        if (Physics.Raycast(ray, out hit, 10000)) {
          if (Vector3.Angle(hit.normal, Vector3.up) > 45)
            continue;
          origin = hit.point;
          origin.y += grassOffset;
          indices.Add(indices.Count);
          positions.Add(transform.InverseTransformPoint(origin));
          Vector2 uv = new Vector2(origin.x, origin.z) / size + new Vector2(0.5f, 0.5f);
          uvs.Add(new Vector4(uv.x, uv.y, Random.Range(-1.0f, 1.0f), Random.Range(-1.0f, 1.0f)));
          colors.Add(new Color(Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), Random.Range(0.0f, 1.0f), Random.Range(-180f, 180f)));
          normals.Add((hit.normal + new Vector3(Random.Range(-1f, 1f), 1, Random.Range(-1f, 1f))).normalized);
          // normals.Add((Vector3.up + hit.normal).normalized);
        }
      }
      var mesh = new Mesh();
      mesh.SetVertices(positions);
      mesh.SetIndices(indices.Take(indices.Count - indices.Count % 3).ToArray(), MeshTopology.Triangles, 0);
      mesh.SetColors(colors);
      mesh.SetNormals(normals);
      mesh.SetUVs(0, uvs);
      GetComponent<MeshFilter>().mesh = mesh;
      lastPosition = this.transform.position;
    }
  }

}
