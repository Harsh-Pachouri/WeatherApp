import 'package:flutter/material.dart';

class additional_info_card extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const additional_info_card({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: const EdgeInsets.all(10),
        width: 143,
        child: Column(
          children: [
            Icon(icon, size: 32),
            const SizedBox(height: 16),
            Text(label),
            const SizedBox(height: 16),
            Text(value),
          ],
        ),
      ),
    );
  }
}
