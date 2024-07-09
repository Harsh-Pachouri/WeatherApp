import 'package:flutter/material.dart';

class HourlyForecastItem extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;

  const HourlyForecastItem(
      {super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: 100,
        child: Column(
          children: [
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 8),
            Icon(
              icon,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              temp,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
