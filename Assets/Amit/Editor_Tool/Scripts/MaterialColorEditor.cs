using UnityEngine;
using UnityEditor;

public class MaterialColorEditor : EditorWindow
{
    public static GameObject selectedGameObject;
    private Vector2 scrollPosition;

    [MenuItem("Tools/Material Color Tool")]
    public static void OpenMaterialColorTool()
    {
        MaterialColorEditor window = GetWindow<MaterialColorEditor>();
        window.titleContent = new GUIContent("Material Color Tool");
    }

    private void OnGUI()
    {
        GUILayout.Label("Select GameObject", EditorStyles.boldLabel);
        selectedGameObject = EditorGUILayout.ObjectField("GameObject", selectedGameObject, typeof(GameObject), true) as GameObject;

        if (selectedGameObject != null)
        {
            EditorGUILayout.Space();

            scrollPosition = EditorGUILayout.BeginScrollView(scrollPosition);

            Renderer[] renderers = selectedGameObject.GetComponentsInChildren<Renderer>();

            foreach (Renderer renderer in renderers)
            {
                foreach (Material material in renderer.sharedMaterials)
                {
                    EditorGUILayout.BeginHorizontal();
                    EditorGUILayout.PrefixLabel(material.name);

                    Color oldColor = material.GetColor("_Color");
                    Color newColor = EditorGUILayout.ColorField(oldColor);

                    if (newColor != oldColor)
                    {
                        material.SetColor("_Color", newColor);
                    }

                    EditorGUILayout.EndHorizontal();
                }
            }

            EditorGUILayout.EndScrollView();
        }
    }
}
