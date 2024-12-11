using UnityEngine;
using UnityEngine.UI;

public class CameraControl : MonoBehaviour
{
    public Camera cameraToMove;         // Reference to the camera
    public Transform cart;              // Reference to the cart (the object the camera follows)
    public Vector3[] cameraOffsets;    // Offsets for the different camera views relative to the cart
    private int currentViewIndex = 0;   // Current view index

    void Start()
    {
        if (cameraToMove == null)
            cameraToMove = Camera.main;  // Default to the main camera if not assigned

        if (cart == null)
            Debug.LogError("Cart is not assigned!");

        if (cameraOffsets.Length == 0)
            Debug.LogError("Camera offsets are not assigned!");
    }

    // This method will be called when the button is pressed
    public void SwitchCameraView()
    {
        // Cycle through the views
        currentViewIndex++;

        // If we reach the last view, go back to the first one
        if (currentViewIndex >= cameraOffsets.Length)
        {
            currentViewIndex = 0;
        }

        // Set the camera's position relative to the cart's position and offset
        cameraToMove.transform.position = cart.position + cameraOffsets[currentViewIndex];
        cameraToMove.transform.rotation = cart.rotation;  // You could modify this to change rotation if necessary
    }
}
