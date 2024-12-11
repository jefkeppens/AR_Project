using UnityEngine;

public class ApplyCartCustomization : MonoBehaviour
{
    public Renderer cartRenderer; // Assign the renderer for your cart
    public Color[] material1Colors; // Colors for the first material
    public Color[] material2Colors; // Colors for the second material

    private void Start()
    {
        // Check if cartRenderer is assigned
        if (cartRenderer == null)
        {
            Debug.LogError("Cart Renderer is not assigned!");
            return;
        }

        // Get the selected indices from the CartCustomizationManager
        int material1Index = CartCustomizationManager.Instance.SelectedMaterial1ColorIndex;
        int material2Index = CartCustomizationManager.Instance.SelectedMaterial2ColorIndex;

        // Check if the indices are valid
        if (material1Index >= material1Colors.Length || material2Index >= material2Colors.Length)
        {
            Debug.LogError("Color indices are out of bounds!");
            return;
        }

        // Apply the colors to the cart
        Material[] materials = cartRenderer.materials;

        Debug.Log("Number of materials detected: " + materials.Length);

        if (materials.Length >= 2)
        {
            Debug.Log("Applying colors...");

            // Create new materials to avoid shared material issues
            materials[0] = new Material(materials[0]); // Duplicate the material
            materials[1] = new Material(materials[1]); // Duplicate the material

            // Set the colors
            materials[0].color = material1Colors[material1Index];
            materials[1].color = material2Colors[material2Index];

            // Reassign the updated materials to the cart renderer
            cartRenderer.materials = materials;

            Debug.Log("Colors applied: " + materials[0].color + ", " + materials[1].color);
        }
        else
        {
            Debug.LogError("Cart Renderer does not have enough material slots.");
        }
    }
}
