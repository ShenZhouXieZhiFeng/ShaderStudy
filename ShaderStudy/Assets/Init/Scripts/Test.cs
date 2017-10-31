using UnityEngine;
using System.Collections;

public class Test : MonoBehaviour {

    public Vector3 Vec;

    [ContextMenu("VecT")]
    public void VecT() {
        Debug.Log(Vec.normalized);
    }
}
