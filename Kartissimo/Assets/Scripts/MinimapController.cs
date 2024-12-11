using UnityEngine;
using UnityEngine.UI;

public class MiniMap : MonoBehaviour
{
    public RectTransform mapImage; // UI RectTransform for the map image
    public RectTransform cartIcon; // UI RectTransform for the cart icon
    public Transform cart; // The cart's Transform in the scene

    public Vector2 mapSize; // Size of the map image in Unity units
    public Vector2 worldSize; // Size of the world in Unity units (actual dimensions of the playable area)

    // Manually set initial cart icon position on the minimap
    public Vector2 initialPosition; // You can set this in the Inspector for custom positioning

    void Start()
    {
        // Set the initial position of the cart icon manually (relative to the map)
        cartIcon.anchoredPosition = initialPosition - (mapSize / 2);
    }

    void Update()
    {
        // Calculate the cart's position as a percentage of the world size
        Vector2 cartWorldPos = new Vector2(cart.position.x, cart.position.z); // Use X and Z for 3D world

        // Normalize the world position (mapping from world space to minimap space)
        Vector2 normalizedPos = new Vector2(
            Mathf.InverseLerp(-worldSize.x / 2, worldSize.x / 2, cartWorldPos.x),
            Mathf.InverseLerp(-worldSize.y / 2, worldSize.y / 2, cartWorldPos.y) // Normalized Y
        );

        // Map the normalized position to the map image size (in minimap coordinates)
        Vector2 mapPos = new Vector2(
            normalizedPos.x * mapSize.x,
            normalizedPos.y * mapSize.y
        );

        // Update the cart icon's position relative to the map
        cartIcon.anchoredPosition = mapPos - (mapSize / 2); // Adjust for map's pivot (centered)
    }
}
