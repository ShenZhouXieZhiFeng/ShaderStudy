using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class VertImage : MonoBehaviour {

    #region
    public Shader imageShader;

    public float oldFilmEffectAmount = 1.0f;

    public Color sepiaColor = Color.white;
    public Texture2D vignetteTexture;
    public float vignetteAmount = 1.0f;

    public Texture2D scratchesTeture;
    public float scratchesYSpeed = 10;
    public float scratchesXSpeed = 10;

    public Texture2D dustTexture;
    public float dustYSpeed = 1;
    public float dustXSpeed = 1;

    public float Contrast = 1;

    private Material curMaterial;
    private float randomValue;
    #endregion

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (imageShader != null)
        {
            if (curMaterial == null)
            {
                curMaterial = new Material(imageShader);
                curMaterial.hideFlags = HideFlags.HideAndDontSave;
            }
            curMaterial.SetColor("_SepiaColor", sepiaColor);
            curMaterial.SetFloat("_Contrast", Contrast);
            curMaterial.SetFloat("_VignetteAmount", vignetteAmount);
            curMaterial.SetFloat("_EffectAmount", oldFilmEffectAmount);

            if (vignetteTexture)
            {
                curMaterial.SetTexture("_VignetteTex", vignetteTexture);
            }
            if (scratchesTeture)
            {
                curMaterial.SetTexture("_ScratchesTex", scratchesTeture);
                curMaterial.SetFloat("_ScratchesYSpeed", scratchesYSpeed);
                curMaterial.SetFloat("_ScratchesXSpeed", scratchesXSpeed);
            }
            if (dustTexture)
            {
                curMaterial.SetTexture("_DustTex", dustTexture);
                curMaterial.SetFloat("_dustYSpeed", dustYSpeed);
                curMaterial.SetFloat("_dustXSpeed", dustXSpeed);
                curMaterial.SetFloat("_RandomValue", randomValue);
            }

            Graphics.Blit(source, destination, curMaterial);
        }
        else {
            Graphics.Blit(source, destination);
        }
    }
    private void Update()
    {
        vignetteAmount = Mathf.Clamp01(vignetteAmount);
        oldFilmEffectAmount = Mathf.Clamp(oldFilmEffectAmount, 0f, 1.5f);
        randomValue = Random.Range(-1f, 1f);
    }
}
