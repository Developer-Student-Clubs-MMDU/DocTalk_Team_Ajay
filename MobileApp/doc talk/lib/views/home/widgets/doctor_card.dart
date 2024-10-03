import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Theme.of(context).cardColor, // Adapts to light/dark mode
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Browse Doctors',
              style: Theme.of(context).textTheme.titleLarge, // Adaptable
            ),
            const SizedBox(height: 8.0),
            Text(
              'Find and book appointments with top doctors.',
              style: Theme.of(context).textTheme.bodyLarge, // Adaptable
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Navigate to Doctor List Page
              },
              child: const Text('Find Doctors'),
            ),
          ],
        ),
      ),
    );
  }
}
