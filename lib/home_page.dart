import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Home Page'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('foods').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final data = snapshot.data?.docs ?? [];
          return GridView.builder(
            padding: EdgeInsets.all(16.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              final food = data[index].data() as Map<String, dynamic>;
              return Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex:8,
                      child: Image.network(
                        food['imageUrl'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                   Row(
                     children:[
                       Padding(
                         padding: const EdgeInsets.all(1.0),
                         child: Text(
                           food['name'],
                           style: TextStyle(fontWeight: FontWeight.bold),
                         ),
                       ),
                       Padding(
                         padding: const EdgeInsets.all(1.0),
                         child: Text('\$${food['price']}'),
                       ),
                     ]
                   ),
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Add order functionality here
                        },
                        child: Text('Order'),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
