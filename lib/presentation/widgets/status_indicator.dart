import 'package:flutter/material.dart';
import '../../domain/entities/delivery_status.dart';

class StatusIndicator extends StatelessWidget {
  final DeliveryStatus status;

  const StatusIndicator({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatusStep(
          icon: Icons.shopping_bag,
          label: 'Picked',
          isActive: _isStepActive(DeliveryStatus.picked),
          isCompleted: _isStepCompleted(DeliveryStatus.picked),
        ),
        _StatusLine(
          isCompleted: _isStepCompleted(DeliveryStatus.picked),
        ),
        _StatusStep(
          icon: Icons.local_shipping,
          label: 'En Route',
          isActive: _isStepActive(DeliveryStatus.enRoute),
          isCompleted: _isStepCompleted(DeliveryStatus.enRoute),
        ),
        _StatusLine(
          isCompleted: _isStepCompleted(DeliveryStatus.enRoute),
        ),
        _StatusStep(
          icon: Icons.near_me,
          label: 'Arriving',
          isActive: _isStepActive(DeliveryStatus.arriving),
          isCompleted: _isStepCompleted(DeliveryStatus.arriving),
        ),
        _StatusLine(
          isCompleted: _isStepCompleted(DeliveryStatus.arriving),
        ),
        _StatusStep(
          icon: Icons.check_circle,
          label: 'Delivered',
          isActive: _isStepActive(DeliveryStatus.delivered),
          isCompleted: _isStepCompleted(DeliveryStatus.delivered),
        ),
      ],
    );
  }

  bool _isStepActive(DeliveryStatus stepStatus) {
    return status == stepStatus;
  }

  bool _isStepCompleted(DeliveryStatus stepStatus) {
    final statusOrder = [
      DeliveryStatus.picked,
      DeliveryStatus.enRoute,
      DeliveryStatus.arriving,
      DeliveryStatus.delivered,
    ];

    final currentIndex = statusOrder.indexOf(status);
    final stepIndex = statusOrder.indexOf(stepStatus);

    return stepIndex < currentIndex;
  }
}

class _StatusStep extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isCompleted;

  const _StatusStep({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    if (isCompleted) {
      color = const Color(0xFF10B981);
    } else if (isActive) {
      color = const Color(0xFF4F46E5);
    } else {
      color = Colors.grey[300]!;
    }

    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: isActive || isCompleted ? color : Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isActive || isCompleted ? Colors.white : color,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive || isCompleted ? color : Colors.grey[500],
          ),
        ),
      ],
    );
  }
}

class _StatusLine extends StatelessWidget {
  final bool isCompleted;

  const _StatusLine({
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 20),
        color: isCompleted ? const Color(0xFF10B981) : Colors.grey[300],
      ),
    );
  }
}