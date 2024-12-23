using UnityEngine;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;

public class FlutterCommunicator : MonoBehaviour
{
    private List<float> lapTimes = new List<float>();

    // For iOS communication
    [DllImport("__Internal")]
    private static extern void SendMessageToFlutter(string message);

    public void AddLapTime(float time)
    {
        lapTimes.Add(time);
        // Log when a lap time is added to the list
        Debug.Log("Added Lap Time: " + time);
        Debug.Log("Current Lap Times: " + string.Join(", ", lapTimes.Select(time => time.ToString("F2"))));
    }

    public void SendLapTimesToFlutter()
    {
        // Convert lap times to JSON
        string jsonData = JsonUtility.ToJson(new LapData { times = lapTimes });

        // Log the JSON data being sent to Flutter
        Debug.Log("Sending Lap Times to Flutter: " + jsonData);

        // Send data to Flutter (platform-specific code)
#if UNITY_IOS && !UNITY_EDITOR
        SendMessageToFlutter(jsonData);
#elif UNITY_ANDROID
        using (AndroidJavaClass unityPlayer = new AndroidJavaClass("com.unity3d.player.UnityPlayer"))
        {
            using (AndroidJavaObject currentActivity = unityPlayer.GetStatic<AndroidJavaObject>("currentActivity"))
            {
                currentActivity.Call("onUnityMessage", jsonData);
            }
        }
#endif
    }

    public void QuitToFlutter()
    {
        // Send lap times before quitting
        SendLapTimesToFlutter();
        Application.Quit();
    }

    [System.Serializable]
    private class LapData
    {
        public List<float> times;
    }
}
