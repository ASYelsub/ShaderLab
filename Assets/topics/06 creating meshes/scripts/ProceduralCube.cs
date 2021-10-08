using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof (MeshFilter))]
[RequireComponent(typeof (MeshRenderer))]
public class ProceduralCube : MonoBehaviour
{
    Mesh mesh;

    void Start()
    {
        MakeCube();
    }

    void MakeCube() {
        //points are according to cube Burgess sent in slack
        Vector3[] vertices = {
            new Vector3(0,0,0),
            new Vector3(1,0,0), //x axis
            new Vector3(1,1,0),
            new Vector3(0,1,0),
            new Vector3(0,1,1),
            new Vector3(1,1,1),
            new Vector3(1,0,1),
            new Vector3(0,0,1),
        };

        //unity has a clockwise winding order... form the triangle by going in a clockwise direction
        int[] triangles = {
            //Front/south face
            0,3,2,
            0,2,1,

            //Top face
            3,4,5,
            3,5,2,

            //East face
            1,2,5,
            1,5,6,

            //West face
            7,4,3,
            7,3,0,

            //Back/north face
            6,5,7,
            5,4,7,

            //Botom face
            1,6,0,
            0,6,7
        };
        mesh = GetComponent<MeshFilter>().mesh;
        mesh.Clear();
        mesh.vertices = vertices;
        mesh.triangles = triangles;
    }

    void OnDestroy(){
        Destroy(mesh);
    }
}
