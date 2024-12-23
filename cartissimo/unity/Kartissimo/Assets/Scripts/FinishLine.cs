using UnityEngine;

public class FinishLine : MonoBehaviour
{
    private void OnTriggerEnter(Collider other)
    {
        // Check if the object entering the trigger is tagged as "Player"
        if (other.CompareTag("Player"))
        {
            // Log that the player has crossed the line
            Debug.Log("Player crossed the finish line!");

            // Try to find the LapTimer component
            LapTimer lapTimer = FindObjectOfType<LapTimer>();

            // Check if lapTimer is found
            if (lapTimer != null)
            {
                Debug.Log("LapTimer found! Calling StartLap.");
                // Start a new lap
                lapTimer.StartLap();
            }
            else
            {
                Debug.LogError("LapTimer component not found! It might be disabled or destroyed.");
            }
        }
    }
}
