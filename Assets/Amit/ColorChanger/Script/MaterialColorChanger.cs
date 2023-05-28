using UnityEngine;
using UnityEngine.UI;

public class MaterialColorChanger : MonoBehaviour
{
    public GameObject targetObject;
    public Slider redSlider;
    public Slider greenSlider;
    public Slider blueSlider;

    private Material defaultMaterial;
    private Material currentMaterial;

    private void Start()
    {
        // Store the default material of the target object
        defaultMaterial = targetObject.GetComponent<Renderer>().material;
        currentMaterial = new Material(defaultMaterial);

        // Set the initial color of the sliders based on the default material
        Color defaultColor = defaultMaterial.color;
        redSlider.value = defaultColor.r;
        greenSlider.value = defaultColor.g;
        blueSlider.value = defaultColor.b;

        // Add listener to the sliders to update the material color
        redSlider.onValueChanged.AddListener(UpdateMaterialColor);
        greenSlider.onValueChanged.AddListener(UpdateMaterialColor);
        blueSlider.onValueChanged.AddListener(UpdateMaterialColor);

        // Apply the default material to the target object
        targetObject.GetComponent<Renderer>().material = currentMaterial;
    }

    private void UpdateMaterialColor(float value)
    {
        // Update the material color based on the sliders' values
        Color currentColor = currentMaterial.color;
        currentColor.r = redSlider.value;
        currentColor.g = greenSlider.value;
        currentColor.b = blueSlider.value;
        currentMaterial.color = currentColor;

        // Apply the updated material to the target object
        targetObject.GetComponent<Renderer>().material = currentMaterial;
    }
}
