import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final Function(int) removeFromCart;
  final Function clearCart;

  CartPage({required this.cartItems, required this.removeFromCart, required this.clearCart});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  Future<void> checkout(BuildContext context) async {
    if (widget.cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Your cart is empty!")),
      );
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('orderedItems').add({
        'items': widget.cartItems,
        'totalPrice': widget.cartItems.fold(0.0, (sum, item) {
          final price = item['price'];
          if (price is num) {
            return sum + price;
          } else {
            return sum;
          }
        }),
        'timestamp': FieldValue.serverTimestamp(),
      });

      widget.clearCart();
      setState(() {

      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Order placed successfully!")),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to place order: $error")),
      );
    }
  }

  Future<void> showOrderHistoryDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Order History"),
          content: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance.collection('orderedItems').orderBy('timestamp', descending: true).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              }

              final orders = snapshot.data!.docs;

              return orders.isEmpty
                  ? Center(child: Text("No orders yet."))
                  : ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text("Order placed on: ${order['timestamp'].toDate()}"),
                      subtitle: Text("Total: \$${order['totalPrice']}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          await FirebaseFirestore.instance.collection('orderedItems').doc(order.id).delete();
                          setState(() {
                            Navigator.of(context).pop();
                            showOrderHistoryDialog(context);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Order deleted!")),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              child: Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = widget.cartItems.fold(0, (sum, item) => sum + (item['price'] as num));

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart Items',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
        centerTitle: true,
        backgroundColor: Colors.red,

      ),
      body: widget.cartItems.isEmpty
          ? Center(child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),

                ),
                child: TextButton(onPressed: () => showOrderHistoryDialog(context),
                    child: Text("View Order",style: TextStyle(color: Colors.white),)),
              ),
              Text('Your cart is empty.', style: TextStyle(fontSize: 18)),
            ],
          ))
          : Column(
        children: [

          Container(
            margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),

              ),
              child: TextButton(onPressed: () => showOrderHistoryDialog(context),
                  child: Text("View Order",style: TextStyle(color: Colors.white),)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.cartItems.length,
              itemBuilder: (context, index) {
                final item = widget.cartItems[index];
                return Card(
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 3,
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item['imageUrl'],
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.broken_image, size: 40, color: Colors.red),
                      ),
                    ),
                    title: Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    subtitle: Text('\$${item['price']}', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        widget.removeFromCart(index);
                        setState(() {

                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("${item['name']} removed from cart!")),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Total : \$${totalPrice.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  onPressed: () => checkout(context),
                  child: Text("Checkout",style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
