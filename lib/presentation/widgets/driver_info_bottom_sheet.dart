import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/driver.dart';
import '../../domain/entities/delivery_status.dart';
import 'status_indicator.dart';

class DriverInfoBottomSheet extends StatelessWidget {
  final ScrollController scrollController;
  final Driver? driver;
  final DeliveryStatus status;
  final double distanceKm;
  final Duration eta;
  final DateTime lastUpdated;

  const DriverInfoBottomSheet({
    super.key,
    required this.scrollController,
    required this.driver,
    required this.status,
    required this.distanceKm,
    required this.eta,
    required this.lastUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: StatusIndicator(status: status),
            ),

            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.access_time,
                      label: 'ETA',
                      value: _formatDuration(eta),
                      color: const Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _InfoCard(
                      icon: Icons.place,
                      label: 'Distance',
                      value: '${distanceKm.toStringAsFixed(1)} km',
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),

            if (driver != null) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(driver!.photoUrl),
                      backgroundColor: Colors.grey[200],
                    ),

                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            driver!.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: Color(0xFFFBBF24),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                driver!.rating.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.directions_car,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                driver!.vehicleNumber,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.phone, size: 20),
                      color: const Color(0xFF4F46E5),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
            Padding(
              padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
              child: Text(
                'Last updated: ${DateFormat('hh:mm a').format(lastUpdated)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    if (duration.inMinutes < 1) {
      return 'Arriving now';
    } else if (duration.inMinutes < 60) {
      return '${duration.inMinutes} min';
    } else {
      final hours = duration.inHours;
      final minutes = duration.inMinutes % 60;
      return '${hours}h ${minutes}m';
    }
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
