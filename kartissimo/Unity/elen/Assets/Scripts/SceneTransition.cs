using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneTransition : MonoBehaviour
{
    public void LoadScene(string scene)
    {
        if (!string.IsNullOrEmpty(scene))
        {
            SceneManager.LoadScene(scene); // Load the scene by its name
        }
        else
        {
            Debug.LogError("Scene name is empty. Please assign a scene name in the Inspector.");
        }
    }

    public void SetPlayerName(string name) {
        StaticData.playerName = name;
    }

    public void SetPlayerRecord(string amount) {
        StaticData.record = double.Parse(amount);
    }
}
