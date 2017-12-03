using UnityEngine;
using System.Collections;

public class CreateCubeMap : MonoBehaviour {

    public Cubemap CubeMapTex;

    [ContextMenu("RenderCubeMap")]
    public void RenderCubeMap() {
        Camera.main.RenderToCubemap(CubeMapTex);
    }
}
