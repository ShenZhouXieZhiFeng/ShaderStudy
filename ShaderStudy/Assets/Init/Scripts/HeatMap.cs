using UnityEngine;
using System.Collections;

public class HeatMap : MonoBehaviour {

    public Vector3[] positions;
    public float[] radiuses;
    public float[] intensities;

    public Material mate;

    private void Update()
    {
        if (mate == null)
        {
            mate = GetComponent<MeshRenderer>().material;
        }
        mate.SetInt("_Points_Length", positions.Length);
        for (int i = 0; i < positions.Length; i++)
        {
            mate.SetVector("_Points" + i.ToString(), positions[i]);

            Vector2 properties = new Vector2(radiuses[i], intensities[i]);
            mate.SetVector("_Properties" + i.ToString(), properties);
        }
    }
}
