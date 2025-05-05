import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '_BookingScreenState.dart'; // or the correct path to BookingScreen

class ProviderServicesPage extends StatefulWidget {
  final String providerId;
  final String providerName;

  const ProviderServicesPage({
    super.key,
    required this.providerId,
    required this.providerName,
  });

  @override
  State<ProviderServicesPage> createState() => _ProviderServicesPageState();
}

class _ProviderServicesPageState extends State<ProviderServicesPage> {
  List<Map<String, dynamic>> services = [];
  List<Map<String, dynamic>> cart = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProviderServices();
  }

  Future<void> fetchProviderServices() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('providers')
          .doc(widget.providerId)
          .get();

      final data = doc.data();
      if (data != null && data['services'] != null) {
        services = List<Map<String, dynamic>>.from(data['services']);
      }
    } catch (e) {
      print("Error fetching services: $e");
    }

    setState(() {
      loading = false;
    });
  }

  void addToCart(Map<String, dynamic> service) {
    setState(() {
      cart.add(service);
    });
  }

  void removeFromCart(Map<String, dynamic> service) {
    setState(() {
      cart.remove(service);
    });
  }

  void goToBookingPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingScreen(
          services: cart,
          providerName: widget.providerName,
          totalCost: cart.fold(0.0, (sum, item) => sum + (item['price'] ?? 0)),
        ),
      ),
    );
  }

  bool isInCart(Map<String, dynamic> service) {
    return cart.contains(service);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.providerName)),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : services.isEmpty
          ? const Center(child: Text("No services available."))
          : ListView.builder(
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          final inCart = isInCart(service);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              title: Text(service['name']),
              subtitle: Text("Price: ${service['price']} SAR"),
              trailing: IconButton(
                icon: Icon(
                  inCart ? Icons.remove_circle : Icons.add_circle,
                  color: inCart ? Colors.red : Colors.green,
                ),
                onPressed: () {
                  inCart ? removeFromCart(service) : addToCart(service);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: cart.isNotEmpty
          ? FloatingActionButton.extended(
        onPressed: goToBookingPage,
        icon: const Icon(Icons.shopping_cart_checkout),
        label: Text("Book (${cart.length}) • ${cart.fold(0.0, (sum, item) => sum + (item['price'] ?? 0))} SAR"),

      )
          : null,
    );
  }
}
