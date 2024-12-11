using System.Collections;
using System;
using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;
public class ConfirmCustomization : MonoBehaviour
{
    public Button confirmButton; // Reference to your button
    private CartColorChange cartColorChange;

    void Start()
    {
        cartColorChange = FindObjectOfType<CartColorChange>();
        // Ensure the button is set up to call the method when clicked
        confirmButton.onClick.AddListener(SendPostRequest);
    }
    void SendPostRequest()
    {
        //Coroutines: perform this operation over time instead of instantly
        StartCoroutine(PostDataCoroutine());
    }
    private string PostDataCoroutine()
    {
        UnityMessageManager.Instance.SendMessageToFlutter(JsonUtility.ToJson(new CheckinMessageFlutter() { key = "" + cartColorChange.currentButtonIndex, success = true }));
        return "success";
    }

    [System.Serializable]
    public class CheckinMessageFlutter
    {
        public string key;
        public bool success;
    }
}