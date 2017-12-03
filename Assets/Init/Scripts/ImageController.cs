using UnityEngine;
using System.Collections;
using UnityEngine.UI;
/// <summary>
/// 直接操作图片像素
/// </summary>
[ExecuteInEditMode]
public class ImageController : MonoBehaviour {

    public RawImage Image;
    public Texture2D _tex;
	void Start () {
        Image.texture = _tex;
    }
	
	void Update () {
	    
	}

    void blur() {

    }

    void setPixture() {
        _tex = new Texture2D(100, 100, TextureFormat.ARGB4444, false);
        int height = 100;
        int width = 100;
        for (int i = 0; i < width; i++)
        {
            for (int j = 0; j < height; j++)
            {
                _tex.SetPixel(i, j, new Color(i / 100f, j / 100f, 0, 1));
            }
        }
        _tex.Apply(false);
        Image.texture = _tex;
    }
}
