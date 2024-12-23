using UnityEngine;
using UnityEngine.UI;
using System.Collections.Generic;
using TMPro;

public class LapTimer : MonoBehaviour
{
    // UI Elements
    public TMP_Text lapTimerText;
    public TMP_Text bestLapText;
    public Button stopButton;

    // Timing Variables
    private float currentLapTime = 0f;
    private float bestLapTime = Mathf.Infinity;
    private bool isTiming = false;

    // Lap times list
    private List<float> lapTimes = new List<float>();

    // Flutter communicator reference
    private FlutterCommunicator flutterCommunicator;

    void Start()
    {
        // Initialize the FlutterCommunicator
        flutterCommunicator = FindObjectOfType<FlutterCommunicator>();
        stopButton.onClick.AddListener(OnStopButtonPressed);

        // Display best lap at the start (in case there's a best lap time stored)
        UpdateBestLapUI();
    }

    void Update()
    {
        // Update lap time while the timer is running
        if (isTiming)
        {
            currentLapTime += Time.deltaTime;
            UpdateLapTimerUI();
        }
    }

    // Start a new lap when the finish line is crossed
    public void StartLap()
    {
        Debug.Log("StartLap called. Current lap time: " + currentLapTime);

        // Null check for lapTimes
        if (lapTimes == null)
        {
            Debug.LogError("lapTimes list is null!");
            return;
        }

        // Check if flutterCommunicator is null
        if (flutterCommunicator == null)
        {
            Debug.LogError("flutterCommunicator is null!");
            return;
        }

        if (currentLapTime > 0)
        {
            // Store lap time and send to Flutter
            lapTimes.Add(currentLapTime);
            flutterCommunicator.AddLapTime(currentLapTime);

            // Update the best lap time if necessary
            if (currentLapTime < bestLapTime)
            {
                bestLapTime = currentLapTime;
                UpdateBestLapUI();
            }
        }

        // Reset for the next lap
        currentLapTime = 0f;
        isTiming = true;
    }


    // Stop the lap timer
    public void StopLap()
    {
        isTiming = false;
    }

    // Update the lap timer UI with the current lap time
    private void UpdateLapTimerUI()
    {
        lapTimerText.text = "Current Lap: " + FormatTime(currentLapTime);
    }

    // Update the best lap UI with the best lap time
    private void UpdateBestLapUI()
    {
        if (bestLapTime == Mathf.Infinity)
        {
            bestLapText.text = "Best Lap: --";
        }
        else
        {
            bestLapText.text = "Best Lap: " + FormatTime(bestLapTime);
        }
    }

    // Format the time to display in minutes:seconds.milliseconds format
    private string FormatTime(float time)
    {
        int minutes = Mathf.FloorToInt(time / 60F);
        int seconds = Mathf.FloorToInt(time % 60F);
        int milliseconds = Mathf.FloorToInt((time * 100F) % 100F);
        return string.Format("{0:00}:{1:00}.{2:00}", minutes, seconds, milliseconds);
    }

    // Stop button handler (quit and send lap times to Flutter)
    private void OnStopButtonPressed()
    {
        flutterCommunicator.QuitToFlutter();
    }
}

