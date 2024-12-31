using UnityEngine;
using System.Collections.Generic;
using FlutterUnityIntegration;
using System.Linq;
using System.Runtime.InteropServices;

public class FlutterCommunicator : MonoBehaviour
{
    private string lapTimes = "";


    public void AddLapTime(float time)
    {
        lapTimes += time.ToString() + ",";
        // Log when a lap time is added to the list
        Debug.Log("Added Lap Time: " + time);
    }

    public void SendLapTimesToFlutter()
    {
        // Convert lap times to JSON
        string jsonData = JsonUtility.ToJson(new LapData { times = lapTimes });

        lapTimes = "";


        // Send data to Flutter (platform-specific code)
        UnityMessageManager.Instance.SendMessageToFlutter(jsonData);
    }

    public void QuitToFlutter()
    {
        // Send lap times before quitting
        SendLapTimesToFlutter();
    }

    [System.Serializable]
    private class LapData
    {
        public string times;
    }
}
