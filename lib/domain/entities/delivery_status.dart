enum DeliveryStatus {
  picked,
  enRoute,
  arriving,
  delivered;

  String get displayName {
    switch (this) {
      case DeliveryStatus.picked:
        return 'Picked Up';
      case DeliveryStatus.enRoute:
        return 'En Route';
      case DeliveryStatus.arriving:
        return 'Arriving Soon';
      case DeliveryStatus.delivered:
        return 'Delivered';
    }
  }

  String get value {
    switch (this) {
      case DeliveryStatus.picked:
        return 'picked';
      case DeliveryStatus.enRoute:
        return 'en_route';
      case DeliveryStatus.arriving:
        return 'arriving';
      case DeliveryStatus.delivered:
        return 'delivered';
    }
  }

  static DeliveryStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'picked':
        return DeliveryStatus.picked;
      case 'en_route':
        return DeliveryStatus.enRoute;
      case 'arriving':
        return DeliveryStatus.arriving;
      case 'delivered':
        return DeliveryStatus.delivered;
      default:
        return DeliveryStatus.enRoute;
    }
  }
}
