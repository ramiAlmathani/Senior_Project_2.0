import 'package:flutter/material.dart';
import 'package:senior_project/services/firebase_Services.dart';

class BookingScreen extends StatefulWidget {
  final List<Map<String, dynamic>> services;
  final String providerName;
  final double totalCost;

  const BookingScreen({
    super.key,
    required this.services,
    required this.providerName,
    required this.totalCost,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late TextEditingController _dateController;
  late TextEditingController _timeController;
  final TextEditingController _addressController = TextEditingController();

  final FirebaseService firebaseService = FirebaseService();

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController();
    _timeController = TextEditingController();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitBooking() async {
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    final address = _addressController.text.trim();

    if (date.isEmpty || time.isEmpty || address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields.')),
      );
      return;
    }

    try {
      await firebaseService.createBookingRequest(
        service: widget.services.map((e) => e['name']).join(', '),
        date: date,
        time: time,
        address: address,
      );

      final confirmationMessage =
          "✅ Booking for ${widget.providerName} confirmed!\n"
          "Services: ${widget.services.map((e) => e['name']).join(', ')}\n"
          "Date: $date\nTime: $time";

      if (context.mounted) {
        Navigator.pop(context, confirmationMessage);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Booking failed: $e')),
      );
    }
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF007EA7)),
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildServiceSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Selected Services", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...widget.services.map((s) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(s['name']),
            Text("${s['price']} SAR"),
          ],
        )),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
            Text("${widget.totalCost.toStringAsFixed(2)} SAR", style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Book a Service'),
        backgroundColor: const Color(0xFF007EA7),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildServiceSummary(),
              const SizedBox(height: 24),
              _buildTextField("Date", _dateController),
              const SizedBox(height: 18),
              _buildTextField("Time", _timeController),
              const SizedBox(height: 18),
              _buildTextField("Address", _addressController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitBooking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007EA7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 3,
                  ),
                  child: const Text(
                    "Confirm Booking",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

