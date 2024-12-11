using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CartInput : MonoBehaviour
{
    private CartColorChange cartColorChange;

    void Start() {
        cartColorChange = FindObjectOfType<CartColorChange>();
    }

    public void SetPlayerCart(int cartIndex) {
        cartColorChange.currentButtonIndex = cartIndex;
    }
}
