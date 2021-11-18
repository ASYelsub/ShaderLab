using System.Collections;
using System.Collections.Generic;
using UnityEngine;


//This script tells the camera to create a depth buffer and make it available in our shader.
[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public class GenerateDepthTexture : MonoBehaviour
{
    void Awake(){
        GetComponent<Camera>().depthTextureMode = DepthTextureMode.Depth;
    }
}
