using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode] [ImageEffectAllowedInSceneView]
[RequireComponent(typeof(Camera))]
public class ImageEffectDepth : MonoBehaviour
{
    public Material effectMaterial;

    void Awake(){
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination){
        Graphics.Blit(source,destination,effectMaterial);
    }

    
}
