import 'package:flutter/material.dart';

class SimpleImageTest extends StatelessWidget {
  const SimpleImageTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Image Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Testing Regular Images:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Test with a regular image
            const Text('Regular Image Test:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                'assets/images/test_simple.svg',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading regular image: $error');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Error Loading Image'),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Test with a placeholder
            const Text('Placeholder Test:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[300],
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 40, color: Colors.grey),
                    SizedBox(height: 8),
                    Text('Placeholder'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
