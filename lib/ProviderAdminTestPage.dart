import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProviderAdminTestPage extends StatefulWidget {
  const ProviderAdminTestPage({super.key});

  @override
  State<ProviderAdminTestPage> createState() => _ProviderAdminTestPageState();
}

class _ProviderAdminTestPageState extends State<ProviderAdminTestPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<Map<String, TextEditingController>> serviceControllers = [];

  void addServiceField() {
    setState(() {
      serviceControllers.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
  }

  void removeServiceField(int index) {
    setState(() {
      serviceControllers.removeAt(index);
    });
  }

  Future<void> submitProvider() async {
    if (_formKey.currentState?.validate() != true) return;

    final id = _idController.text.trim();
    final name = _nameController.text.trim();
    final category = _categoryController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final location = _locationController.text.trim();

    final services = serviceControllers.map((service) {
      return {
        'name': service['name']!.text.trim(),
        'price': double.tryParse(service['price']!.text.trim()) ?? 0,
      };
    }).toList();

    try {
      await FirebaseFirestore.instance.collection('providers').doc(id).set({
        'name': name,
        'category': category,
        'rating': 4.5,
        'location': location,
        'image': imageUrl,
        'services': services,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Provider added successfully!")),
      );

      _formKey.currentState?.reset();
      setState(() {
        serviceControllers.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _locationController.dispose();
    for (var map in serviceControllers) {
      map['name']?.dispose();
      map['price']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Provider (Admin Test)")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(labelText: "Provider ID (unique)"),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Provider Name"),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Service Category (e.g., cleaning)"),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: "Image URL"),
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "Location"),
              ),
              const SizedBox(height: 16),
              const Text("Services", style: TextStyle(fontWeight: FontWeight.bold)),
              ...serviceControllers.asMap().entries.map((entry) {
                int index = entry.key;
                var controllers = entry.value;
                return Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controllers['name'],
                        decoration: const InputDecoration(labelText: "Service Name"),
                        validator: (val) => val == null || val.isEmpty ? "Required" : null,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controllers['price'],
                        decoration: const InputDecoration(labelText: "Price"),
                        keyboardType: TextInputType.number,
                        validator: (val) => val == null || val.isEmpty ? "Required" : null,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_circle, color: Colors.red),
                      onPressed: () => removeServiceField(index),
                    ),
                  ],
                );
              }),
              TextButton.icon(
                onPressed: addServiceField,
                icon: const Icon(Icons.add),
                label: const Text("Add Service"),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: submitProvider,
                child: const Text("Submit Provider"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
