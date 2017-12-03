using UnityEngine;
using System.Collections;

public class ShowNormal : MonoBehaviour {

    Mesh mesh;
    Vector3[] normals;
    Vector3[] vertices;
    void Start () {
        mesh = GetComponent<MeshFilter>().sharedMesh;
        //for (int i = 0; i < vertices.Length; i ++) {
        //    Vector3 ve = vertices[i];
        //    Debug.DrawLine(ve, ve + Vector3.Normalize(normals[i]));
        //}
    }
	
	void Update () {
        normals = mesh.normals;
        vertices = mesh.vertices;
        for (int i = 0; i < vertices.Length; i++)
        {
            Vector3 ve = vertices[i];
            Debug.DrawLine(ve, ve + Vector3.Normalize(normals[i]));
        }
    }
}
