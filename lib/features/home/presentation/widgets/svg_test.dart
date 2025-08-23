import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgTest extends StatelessWidget {
  const SvgTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SVG Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Testing SVG Images:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Test with simple SVG
            const Text('Simple SVG Test:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/images/test_simple.svg',
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading simple SVG: $error');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Error Loading Simple SVG'),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // Test with complex SVG
            const Text('Complex SVG Test:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SvgPicture.asset(
                'assets/images/product1.svg',
                fit: BoxFit.cover,
                placeholderBuilder: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading complex SVG: $error');
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 40, color: Colors.red),
                        SizedBox(height: 8),
                        Text('Error Loading Complex SVG'),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
