import 'package:flutter/foundation.dart';

/// Shipping address
///
class Address {
  late String contactName;
  late String addressLine1;
  late String addressLine2;
  late String city;
  late String region;
  late String country;
  late String postalCode;
}

/// Shippers you can choose from
///
enum ShippingOptions { ups, fedex, purulator, amazon }

/// Order entity
///
class Order {
  late ShippingOptions _shippingMethod;
  late Address _destination;
  late Address _origin;

  Order(ShippingOptions shippingMethod, Address destination, Address origin) {
    _shippingMethod = shippingMethod;
    _destination = destination;
    _origin = origin;
  }

  ShippingOptions get shippingMethod {
    return _shippingMethod;
  }

  Address get origin {
    return _origin;
  }

  Address get destination {
    return _destination;
  }
}

abstract class ShipmentService {
  double calculateShippingCost(Order order);
}

class ShipmentProviderFactory {
  static ShipmentService create(ShippingOptions shippingMethod) {
    switch (shippingMethod) {
      case ShippingOptions.ups:
        return UPSShipmentProvider();
      case ShippingOptions.fedex:
        return FedExShipmentProvider();
      case ShippingOptions.purulator:
        return PurulatorShipmentProvider();
      case ShippingOptions.amazon:
        return AmazonShipmentProvider();
      default:
        throw ArgumentError('Invalid shipping method');
    }
  }
}

class AmazonShipmentProvider implements ShipmentService {
  @override
  double calculateShippingCost(Order order) {
    return 20;
  }
}

class FedExShipmentProvider implements ShipmentService {
  @override
  double calculateShippingCost(Order order) {
    return 10;
  }
}

class UPSShipmentProvider implements ShipmentService {
  @override
  double calculateShippingCost(Order order) {
    return 15;
  }
}

class PurulatorShipmentProvider implements ShipmentService {
  @override
  double calculateShippingCost(Order order) {
    return 5;
  }
}
