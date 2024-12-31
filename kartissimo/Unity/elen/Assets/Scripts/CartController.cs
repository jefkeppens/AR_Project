using UnityEngine;

public class CartController : MonoBehaviour
{
    public float moveSpeed = 10f;
    public float turnSpeed = 100f;

    private Rigidbody rb;
    private FloatingJoystick joystick; // Reference to the joystick

    void Start()
    {
        rb = GetComponent<Rigidbody>();
        joystick = FindObjectOfType<FloatingJoystick>(); // Assuming there's only one Dynamic Joystick in the scene
    }

    void FixedUpdate()
    {
        // Get joystick input
        float moveInput = joystick.Vertical;  // Forward/Backward (Y-axis)
        float turnInput = joystick.Horizontal;  // Left/Right (X-axis)

        // Apply movement (forward/backward)
        Vector3 moveDirection = transform.forward * moveInput * moveSpeed * Time.deltaTime;
        rb.MovePosition(rb.position + moveDirection);

        // Apply rotation (left/right)
        float turnAmount = turnInput * turnSpeed * Time.deltaTime;
        Quaternion turnRotation = Quaternion.Euler(0f, turnAmount, 0f);
        rb.MoveRotation(rb.rotation * turnRotation);
    }
}
