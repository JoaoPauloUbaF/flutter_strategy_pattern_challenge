import 'package:flutter/material.dart';

import 'shipping.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shipping Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ShippingCalculator(),
    );
  }
}

class ShippingCalculator extends StatefulWidget {
  @override
  _ShippingCalculatorState createState() => _ShippingCalculatorState();
}

class _ShippingCalculatorState extends State<ShippingCalculator> {
  final _formKey = GlobalKey<FormState>();
  final Address origin = Address();
  final Address destination = Address();
  ShipmentService? _shipmentService;
  ShippingOptions? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shipping Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Origin Address:'),
              _buildAddressFields(origin),
              const SizedBox(height: 20),
              const Text('Destination Address:'),
              _buildAddressFields(destination),
              const SizedBox(height: 20),
              DropdownButton<ShippingOptions>(
                value: _selectedOption,
                items: ShippingOptions.values.map((option) {
                  return DropdownMenuItem(
                    value: option,
                    child: Text(option.toString().split('.').last),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedOption = value;
                  });
                },
                hint: const Text('Select Shipping Option'),
              ),
              ElevatedButton(
                onPressed: _calculateShippingCost,
                child: const Text('Calculate Shipping Cost'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressFields(Address address) {
    return Column(
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: 'Contact Name'),
          onSaved: (value) => address.contactName = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Address Line 1'),
          onSaved: (value) => address.addressLine1 = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Address Line 2'),
          onSaved: (value) => address.addressLine2 = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'City'),
          onSaved: (value) => address.city = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Region'),
          onSaved: (value) => address.region = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Country'),
          onSaved: (value) => address.country = value!,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: 'Postal Code'),
          onSaved: (value) => address.postalCode = value!,
        ),
      ],
    );
  }

  void _calculateShippingCost() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedOption == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a shipping option.')),
        );
        return;
      }

      final order = Order(_selectedOption!, destination, origin);
      _shipmentService = ShipmentProviderFactory.create(order.shippingMethod);
      final cost = _shipmentService?.calculateShippingCost(order);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Shipping Cost: \$${cost?.toStringAsFixed(2)}')),
      );
    }
  }
}

// Your existing classes and enums go here...
