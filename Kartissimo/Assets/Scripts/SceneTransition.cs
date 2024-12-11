using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransition : MonoBehaviour
{
    // Public field to set the scene name in the Inspector
    public string sceneName; // The scene to load

    // Method to load the scene
    public void LoadScene()
    {
        if (!string.IsNullOrEmpty(sceneName))
        {
            SceneManager.LoadScene(sceneName); // Load the scene by its name
        }
        else
        {
            Debug.LogError("Scene name is empty. Please assign a scene name in the Inspector.");
        }
    }
}
