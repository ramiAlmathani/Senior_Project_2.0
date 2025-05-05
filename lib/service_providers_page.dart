import 'package:flutter/material.dart';
import 'package:senior_project/service_model.dart';
import 'package:easy_localization/easy_localization.dart';
import '_CompanyBookingPage.dart';
import '_OrderData.dart';


class ServiceProvidersPage extends StatelessWidget {
  final Service service;

  const ServiceProvidersPage({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    final _ = context.locale;
    final Map<String, List<String>> providerMap = {
      "Cleaning": ["SparkleClean", "Maid in Minutes", "ShinySpaces"],
      "Handyman": ["FixIt All", "HandyPro Services", "DIY Dude"],
      "Plumbing": ["AquaFix", "PipePros", "FlowMaster Plumbing"],
      "Delivery": ["QuickDrop", "LocalRunner", "SwiftShip"],
      "Assembly": ["FurnitureFast", "AssemblyCo", "SetUp Squad"],
      "Moving": ["MoveMate", "Lift & Go", "PackRight Movers"],
      "More": ["General Helper", "Custom Service", "Request a Quote"],
    };

    final providers = providerMap[service.nameKey] ?? [tr("no_providers")];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("providers_title", namedArgs: {"service": service.nameKey.tr()}),
        ),
        backgroundColor: const Color(0xFFB2DFDB),
        foregroundColor: const Color(0xFF007EA7),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];

          return GestureDetector(
            onTap: () async {
              final booking = await Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => CompanyBookingPage(
                    companyName: provider,
                    serviceName: service.nameKey.tr(),
                  ),
                  transitionsBuilder: (_, animation, __, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: const Duration(milliseconds: 400),
                ),
              );

              if (booking != null && context.mounted) {
                try {
                  pendingOrders.add(Order(
                    company: booking['company'],
                    service: booking['service'],
                    date: booking['date'],
                    time: booking['time'],
                    address: booking['address'],
                  ));

                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Booking successful!',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Booking failed. Please try again.',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
            child: Image.asset(
              'assets/images/Screenshot_2025-03-24_213038-removebg-preview.png',
                      height: 160,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.business, color: Color(0xFF007EA7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: const [
                                  Icon(Icons.star,
                                      color: Colors.amber, size: 16),
                                  SizedBox(width: 4),
                                  Text('4.5 (200)',
                                      style: TextStyle(fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Available in your area',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Text(
                          '25–35 mins',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}