using UnityEngine;
using UnityEngine.UI; // To access the Button component

public class CartColorChange : MonoBehaviour
{
    public Renderer cartRenderer; // Assign the renderer for your cart
    public Color[] material1Colors; // Colors for the first material
    public Color[] material2Colors; // Colors for the second material

    // Reference to the buttons
    public Button[] colorButtons; // Array of buttons to highlight
    public GameObject[] buttonBorders; // Array to hold the borders (the Image components on each button)

    private int currentButtonIndex = -1; // Index of the currently selected button

    void Start()
    {
        // Check if the arrays are properly set up
        if (cartRenderer == null || material1Colors.Length < 5 || material2Colors.Length < 5 || colorButtons.Length < 5 || buttonBorders.Length < 5)
        {
            Debug.LogError("Please assign the Renderer, set up at least 5 colors for both materials, and assign the buttons and borders!");
        }

        SelectButton(0);

        // Optionally, set initial button state (if needed)
        UpdateButtonHighlight();
    }

    public void ChangeCartColor(int buttonIndex)
    {
        if (cartRenderer != null && buttonIndex >= 0 && buttonIndex < material1Colors.Length)
        {
            // Access the cart's materials
            Material[] materials = cartRenderer.materials;

            // Change colors for both materials
            materials[0].color = material1Colors[buttonIndex];
            materials[1].color = material2Colors[buttonIndex];

            // Assign the updated materials back
            cartRenderer.materials = materials;

            // Save the selected indices to the CartCustomizationManager
            CartCustomizationManager.Instance.SelectedMaterial1ColorIndex = buttonIndex;
            CartCustomizationManager.Instance.SelectedMaterial2ColorIndex = buttonIndex;

            // Update the highlighted button
            currentButtonIndex = buttonIndex;
            UpdateButtonHighlight();
        }
    }


    // Method to update button highlights (show/hide borders)
    private void UpdateButtonHighlight()
    {
        for (int i = 0; i < colorButtons.Length; i++)
        {
            Button button = colorButtons[i];

            if (i == currentButtonIndex)
            {
                // Show the border around the selected button
                buttonBorders[i].SetActive(true);  // Enable the border
            }
            else
            {
                // Hide the border for unselected buttons
                buttonBorders[i].SetActive(false);  // Disable the border
            }
        }
    }

    private void SelectButton(int buttonIndex)
    {
        ChangeCartColor(buttonIndex);  // Change the cart's color
        currentButtonIndex = buttonIndex;  // Set the selected button index
        UpdateButtonHighlight();  // Update the checkmark or highlight
    }
}
