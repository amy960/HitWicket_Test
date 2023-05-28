using UnityEngine;
using UnityEditor;

public class MaterialColorTool : MonoBehaviour
{
    [MenuItem("Tools/Material Color Tool")]
    public static void OpenMaterialColorTool()
    {
        MaterialColorEditor window = EditorWindow.GetWindow<MaterialColorEditor>();
        window.titleContent = new GUIContent("Material Color Tool");
    }
}
