import 'package:flutter/material.dart';

class CartScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {'image': 'assets/burger.png', 'name': 'Burger', 'price': 5.99},
    {'image': 'assets/pizza.png', 'name': 'Pizza', 'price': 7.99},
    // Add more cart items here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.asset(cartItems[index]['image'], width: 50),
            title: Text(cartItems[index]['name']),
            subtitle: Text('\$${cartItems[index]['price']}'),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Add functionality to remove item from cart
              },
            ),
          );
        },
      ),
    );
  }
}
