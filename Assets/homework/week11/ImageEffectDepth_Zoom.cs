using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode] [ImageEffectAllowedInSceneView]
[RequireComponent(typeof(Camera))]
public class ImageEffectDepth_Zoom : MonoBehaviour
{
    public Material effectMaterial;
    public Material stencilObjMat;

    void Awake(){
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination){
        Graphics.Blit(source,destination,effectMaterial);
    }

    float zoomTimer = 1;

    //Will make cube visible when fully zoomed in//
    /*void Update(){
        if(Input.GetMouseButton(1)){
            effectMaterial.SetFloat("_scale",1-zoomTimer);
            if (zoomTimer > .5f)
            {
                zoomTimer -= Time.fixedDeltaTime;
                stencilObjMat.SetInt("_stencilRef", 2);
            }else{
                zoomTimer = .5f;
                stencilObjMat.SetInt("_stencilRef", 1);
            }
        }else{
            effectMaterial.SetFloat("_scale", 1-zoomTimer);
            if (zoomTimer < 1f)
            {
                zoomTimer += Time.fixedDeltaTime;
            }
            stencilObjMat.SetInt("_stencilRef", 2);
        }
    }*/

    //Will make cube visible while zooming in//
    void Update(){
        if(Input.GetMouseButton(1)){
            effectMaterial.SetFloat("_scale",1-zoomTimer);
            stencilObjMat.SetInt("_stencilRef", 1);
            if (zoomTimer > .7f)
            {
                zoomTimer -= Time.fixedDeltaTime;
            }else{
                zoomTimer = .7f;
            }
        }else{
            effectMaterial.SetFloat("_scale", 1-zoomTimer);
            if (zoomTimer < 1f)
            {
                zoomTimer += Time.fixedDeltaTime;
            }
            stencilObjMat.SetInt("_stencilRef", 2);
        }
    }
}
