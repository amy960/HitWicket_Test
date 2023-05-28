using UnityEngine;
using UnityEngine.UI;

public class ColorChanger : MonoBehaviour
{

    public Slider redSlider;
    public Slider greenSlider;
    public Slider blueSlider;

    // Use this for initialization
    void Start()
    {
        
        
    }

    // Update is called once per frame
    void Update()
    {

        // Get the current values of the sliders
        float redValue = redSlider.value;
        float greenValue = greenSlider.value;
        float blueValue = blueSlider.value;

        // Create a new color from the slider values
        Color color = new Color(redValue, greenValue, blueValue);

        // Get the renderer component of the selected game object
        Renderer renderer = GetComponent<Renderer>();

        // Set the material property color of the renderer
        renderer.material.color = color;
    }
}
