using UnityEngine;
using System.Collections;

public class Test : MonoBehaviour {
    private void Start()
    {
        
    }

    private void Update()
    {
        Debug.Log("X: " + Mathf.Floor(Time.time / 4));
        Debug.Log("Y: " + Mathf.Floor(Time.time / 16));
    }

}
