import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'services/firebase_services.dart'; // ✅ Ensure correct path
import 'TabBarWidget.dart';

class OrdersScreen extends StatefulWidget {
  final VoidCallback onBackToServices;

  const OrdersScreen({super.key, required this.onBackToServices});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;

  final FirebaseService firebaseService = FirebaseService();
  List<Map<String, dynamic>> bookings = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();

    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      final result = await firebaseService.getMyBookings();
      setState(() {
        bookings = result;
        loading = false;
      });
    } catch (e) {
      print('Failed to load bookings: $e');
      setState(() => loading = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildEmptyOrders(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutBack,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  height: 160,
                  width: 160,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFB2DFDB),
                  ),
                  child: Icon(icon, size: 80, color: const Color(0xFF007EA7)),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF007EA7)),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onBackToServices,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007EA7),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            icon: const Icon(Icons.explore, color: Colors.white),
            label: Text(
              "start_exploring".tr(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    return FadeTransition(
      opacity: _fadeIn,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Text(
              "my_orders".tr(),
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF007EA7)),
            ),
            const SizedBox(height: 10),
            const TabBarWidget(),
            const SizedBox(height: 10),
            Expanded(
              child: TabBarView(
                children: [
                  // ✅ Pending Tab - show real bookings
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : bookings.isEmpty
                      ? _buildEmptyOrders(
                    "no_pending_orders".tr(),
                    "no_pending_sub".tr(),
                    Icons.hourglass_empty,
                  )
                      : ListView.builder(
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: const Icon(Icons.assignment, color: Color(0xFF007EA7)),
                          title: Text(booking['service']),
                          subtitle: Text(
                            "📅 ${booking['date']}  ⏰ ${booking['time']}\n📍 ${booking['address']}",
                          ),
                          isThreeLine: true,
                          trailing: Text(
                            booking['status'] ?? 'Pending',
                            style: const TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // ❌ History Tab — placeholder for now
                  _buildEmptyOrders(
                    "no_order_history".tr(),
                    "no_history_sub".tr(),
                    Icons.assignment_turned_in_outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
