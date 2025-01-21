
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderHistoryScreen extends StatelessWidget {
  final String userId;

  OrderHistoryScreen({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];
          if (data.isEmpty) {
            return Center(child: Text('You have no past orders.'));
          }

          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              final order = data[index].data() as Map<String, dynamic>;
              final items = order['items'] as List<dynamic>;

              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 5,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Order #${data[index].id}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('Status: ${order['status']}'),
                      SizedBox(height: 8.0),
                      Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
                      ...items.map((item) {
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(vertical: 4.0),
                          leading: Image.network(item['imageUrl']),
                          title: Text(item['name']),
                          subtitle: Text('\$${item['price']}'),
                        );
                      }).toList(),
                      SizedBox(height: 8.0),
                      Text('Order placed on: ${order['timestamp'].toDate()}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
