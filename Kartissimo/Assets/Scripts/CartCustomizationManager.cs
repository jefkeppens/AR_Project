using UnityEngine;

public class CartCustomizationManager : MonoBehaviour
{
    public static CartCustomizationManager Instance;

    public int SelectedMaterial1ColorIndex = 0; // Index of the selected color for material 1
    public int SelectedMaterial2ColorIndex = 0; // Index of the selected color for material 2

    private void Awake()
    {
        if (Instance == null)
        {
            Instance = this;
            DontDestroyOnLoad(gameObject); // Ensure it persists across scenes
        }
        else
        {
            Destroy(gameObject); // Prevent duplicates
        }
    }
}
